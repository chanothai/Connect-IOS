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

protocol UserInfoDelegate {
    func getUserInfo( userInfo: UserInfo)
}

class BlocViewController: BaseViewController {
    //Make: delegate
    var delegate: UserInfoDelegate?
    
    //MAKE : outlet
    @IBOutlet var categoryScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var layoutCategory: UIView!
    @IBOutlet var blocCollectionView: UICollectionView!
    
    //MAKE : Properties
    private var categoryBlocView:[CategoryBlocView]?
    var arrBloc:[ResultCategory] = [ResultCategory]()
    var token: String?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var destinationController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.createTitleBarImage()

        self.setSideBar()
        blocCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard arrBloc.count == 0 else {
            return
        }
        
        setEventBus()
        initParameter()
        
    }
    
    public func initParameter(){
        var restoreInformation:[String] = AuthenLogin().restoreLogin() //0 user, 1 token, 2 dynamickey
        if (restoreInformation.count) > 0 {
            token = restoreInformation[1]
            let key = [UInt8](Data(base64Encoded: (restoreInformation[2]))!)
            RequireKey.key = key
            
            showLoading()
            ClientHttp.getInstace().requestUserBloc(token!)
        }else{
            pushToLogin()
        }
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
        
        SwiftEventBus.onMainThread(self, name: "UserBlocResponse") { (result) in
            if let responses:DataBloc = result.object as? DataBloc {
                self.arrBloc = responses.resultCategories!
                print(self.arrBloc.count)
                
                if let category:CategoryBloc = self.arrBloc[self.pageControl.currentPage].category {
                    guard let imgCategory = category.imagePath else {
                        print("image's category was null")
                        return
                    }
                    print(imgCategory)
                }
                
                self.initCategory(responses.resultCategories!)
                self.blocCollectionView.dataSource = self
                
                if let point = responses.userInfo?.point {
                    self.navigationItem.rightBarButtonItem = self.createItemRightBase(point)
                }else {
                    self.navigationItem.rightBarButtonItem = self.createItemRightBase(10000)
                }
                
                self.delegate?.getUserInfo(userInfo: responses.userInfo!)
                ModelCart.getInstance().getUserInfo.firstName = (responses.userInfo?.firstNameTH!)!
                ModelCart.getInstance().getUserInfo.lastName = (responses.userInfo?.lastNameTH)!
                
                if let imagePath = responses.userInfo?.image {
                    ModelCart.getInstance().getUserInfo.profile_image_path = imagePath
                }
                
                ClientHttp.getInstace().requestQuiz(self.token!)
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "ResponseQuiz") { (result) in
            if let responses:QuizResult = result.object as? QuizResult {
                if responses.success == "OK" {
                    print((responses.data?.quiz?.url)!)
                    
                    guard let quiz = responses.data?.quiz?.url else {
                        
                        return
                    }
                    
                    let destination = self.storyBoard.instantiateViewController(withIdentifier: "ShowBlocDetail") as! BlocContentViewController
                    destination.urlBloc = quiz
                    destination.titleName = "แบบสอบถาม"
                    
                    self.navigationController?.pushViewController(destination, animated: true)
                }
                
                self.hideLoading()
            }
        }
    }
    
    func createSlideCategory(_ category:[ResultCategory]) -> [CategoryBlocView]{
        var numberCategoryView = [CategoryBlocView]()
        for i in 0 ..< category.count {
            let categoryView:CategoryBlocView = Bundle.main.loadNibNamed("CategoryBloc", owner: self, options: nil)?.first as! CategoryBlocView
            
            let url = URL(string: (category[i].category?.imagePath)!)!
            categoryView.categoryIMG.af_setImage(withURL: url, placeholderImage: nil , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
            
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
    
    func pushToLogin() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
        self.present(loginController, animated: false, completion: nil)
    }
}

extension BlocViewController: UIScrollViewDelegate {
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
}

extension BlocViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 2) - 2
        
        return CGSize(width: width, height: width - 10)
    }
}

extension BlocViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    //Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrBloc[pageControl.currentPage].bloc?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlocCell", for: indexPath) as! BlocCollectionViewCell
        
        let bloc:Bloc = (self.arrBloc[self.pageControl.currentPage].bloc![indexPath.row])
        
        if bloc.imagePath != nil {
            let url = URL(string: bloc.imagePath!)
            cell.blocIMG.af_setImage(withURL: url!, placeholderImage: nil , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
        }
        
        cell.blocLabel.text = bloc.blocNameTH
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 3 {
            let blocInformation:Bloc = (arrBloc[pageControl.currentPage].bloc![indexPath.row])
            let blocContent = storyBoard.instantiateViewController(withIdentifier: "ShowBlocDetail") as! BlocContentViewController
            blocContent.urlBloc = blocInformation.blocURL
            blocContent.titleName = blocInformation.blocNameTH
            
            navigationController?.pushViewController(blocContent, animated: true)
        }
        else if indexPath.row == 1 {
            let backButton = UIBarButtonItem(image: UIImage(named:"back_screen"), style: .plain, target: self, action: #selector(backScreen))
            destinationController = self.storyBoard.instantiateViewController(withIdentifier: "IDCardController") as! IDCardViewController
            destinationController?.navigationItem.leftBarButtonItem = backButton
            destinationController?.navigationItem.titleView = self.createTitleBarImage()
            
            let nav = UINavigationController(rootViewController: destinationController!)
            self.show(nav, sender: nil)
        }
        else if indexPath.row == 2 {
            let backButton = UIBarButtonItem(image: UIImage(named:"back_screen"), style: .plain, target: self, action: #selector(backScreen))
            destinationController = self.storyBoard.instantiateViewController(withIdentifier: "ContactController") as! ContactViewController
            destinationController?.navigationItem.leftBarButtonItem = backButton
            destinationController?.navigationItem.titleView = self.createTitleBarImage()
            destinationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"add-contact") , style: .plain, target: self, action: #selector(selectAddContact))
            
            let nav = UINavigationController(rootViewController: destinationController!)
            self.show(nav, sender: nil)
        }
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    @objc func selectAddContact() {
        print("Add Contact")
        let navAddContactController = self.storyBoard.instantiateViewController(withIdentifier: "NavAddContact") as! NavContactController
        self.destinationController?.show(navAddContactController, sender: nil)
    }
    
    @objc func backScreen() {
        destinationController?.dismiss(animated: true, completion: nil)
    }
}
