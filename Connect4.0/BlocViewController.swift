//
//  BlocViewController.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import IGListKit
import SWRevealViewController
import SwiftEventBus

class BlocViewController: BaseViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MAKE : outlet
    @IBOutlet var categoryScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var layoutCategory: UIView!
    @IBOutlet var blocCollectionView: UICollectionView!
    
    //MAKE : Properties
    private var restoreInformation:[String]?
    private var categoryBlocView:[CategoryBlocView]?
    var arrBloc:[ResultCategory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideBar()
        setEventBus()
        initParameter()
        
        blocCollectionView.delegate = self
    }
    
    private func initParameter(){
        restoreInformation = AuthenLogin().restoreLogin() //0 user, 1 token, 2 dynamickey
        if (restoreInformation?.count)! > 0 {
            let key = [UInt8](Data(base64Encoded: (restoreInformation?[2])!)!)
            RequireKey.key = key
        }
        
        setModelUser(restoreInformation!)
    }
    
    private func initCategory(_ category:[ResultCategory]){
        categoryBlocView = createSlideCategory(category)
        setCategoryScrollView()
        
        pageControl.numberOfPages = (categoryBlocView?.count)!
        pageControl.currentPage = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "ResponseApplication"){
            (result) in
            let response:ApplicationResponse = result.object as! ApplicationResponse
            if response.success == "OK" {
                print(response.result.authToken)
                ClientHttp.getInstace().requestUserInfo(response.result.authToken)
                ClientHttp.getInstace().requestUserBloc(response.result.authToken)
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "UserInfoResponse") { (result) in
            let response:UserInfoResponse = result.object as! UserInfoResponse
            ModelCart.getInstance().getUserInfo = response
            
        }
        
        SwiftEventBus.onMainThread(self, name: "UserBlocResponse") { (result) in
            if let responses:[ResultCategory] = result.object as? [ResultCategory] {
                self.arrBloc = responses
                print(responses[0].resultBloc.count)
                
                let str:Bloc = (self.arrBloc?[self.pageControl.currentPage].resultBloc[0])!
                print(str.bloc_icon_path)
                self.initCategory(responses)
                
                self.blocCollectionView.dataSource = self
            }
            
            self.hideLoading()
        }
    }
    
    func createSlideCategory(_ category:[ResultCategory]) -> [CategoryBlocView]{
        var numberCategoryView = [CategoryBlocView]()
        for i in 0 ..< category.count {
            let categoryView:CategoryBlocView = Bundle.main.loadNibNamed("CategoryBloc", owner: self, options: nil)?.first as! CategoryBlocView
            
            let url = URL(string: category[i].resultCategory.bloc_category_image_path)!
            categoryView.categoryIMG.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
            
            numberCategoryView.append(categoryView)
        }
        
        return numberCategoryView
    }
    
    func setCategoryScrollView() {
        categoryScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        categoryScrollView.contentSize = CGSize(width: view.frame.width * CGFloat((categoryBlocView?.count)!), height: layoutCategory.frame.height)
        
        for i in 0 ..< (categoryBlocView?.count)! {
            categoryBlocView?[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: -65, width: view.frame.width, height: view.frame.height)
            categoryScrollView.addSubview((categoryBlocView?[i])!)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        switch pageControl.currentPage {
        case 0:
            blocCollectionView.reloadData()
            break
        case 1:
            blocCollectionView.reloadData()
            break
        default:
            break
        }
    }
    
    
    //Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrBloc?[pageControl.currentPage].resultBloc.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = Bundle.main.loadNibNamed("blocCell", owner: self, options: nil)?.first as! BlocCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlocCell", for: indexPath) as! BlocCollectionViewCell
        
        let bloc:Bloc = (self.arrBloc?[self.pageControl.currentPage].resultBloc[indexPath.row])!
        let url = URL(string: bloc.bloc_icon_path)!
        
        cell.blocIMG.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
        
        cell.blocLabel.text = bloc.bloc_name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 2) - 2
        
        return CGSize(width: width, height: width - 10)
    }
    
}

extension BlocViewController {
    func setModelUser(_ information:[String]){
        var application = [String: String]()
        application[ApplicationKey.clientID] = "abcdef"
        application[ApplicationKey.secret] = "123456"
        
        print(application)
        
        var user = [String:String]()
        user[ApplicationKey.token] = information[1]
        print(user)
        
        var request = [String:Any]()
        request[ApplicationKey.application] = application
        request[ApplicationKey.user] = user
        
        var requestUser = [String:String]()
        requestUser["username"] = information[0]
        
        self.showLoading()
        ClientHttp.getInstace().requestAuthToken(FormatterRequest(RequireKey.key).application(request, requestUser))
    }
}
