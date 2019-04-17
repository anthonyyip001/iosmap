//
//  MenuController.swift
//  SideMenu
//
//  Created by Anthony Yip on 3/5/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//
import UIKit
import Firebase

class ContainerController: UIViewController{
    
    var menuController : MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    var detailedString: String!
    var cityArrayto = Array<String>()
    var pointArray = Array<Point>()
    var pointNames = Array<String>()
    var docRef : DocumentReference!
    var countRef : CollectionReference!
    var cityRefresh: String!
    var homeController: HomeController!
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCities()
        navigationItem.title = detailedString!
        configureNavigationBar()

        configureHomeController()
        
        
    }
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
//    @objc func handleMenuToggle() {
//        print("Toggle menu..")
//        delegate?.handlMenuToggle(forMenuOption: nil)
//    }
//
//    @objc func handleUserToggle() {
//        print("Toggle user..")
//
//        let vc = UserController(collectionViewLayout: UICollectionViewFlowLayout())
//        vc.country = detailedString!
//        vc.userCategories = userCategories
//        vc.featCategory = featCategory
//
//        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//
//
//    }
    
    func getCities() {
        if uid == ""{
            uid = (Auth.auth().currentUser?.uid)!
        }
        
        let db = Firestore.firestore()
        countRef = db.collection("users/\(uid)/countries/\(detailedString!)/cities")
        print("filepath cities: users/\(uid)/countries/\(detailedString!)/cities")
        countRef.addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            print("in add snapshot")
            let cities = documents.map {
                print("cityarrayto size: \(self.cityArrayto.count)")
                self.cityArrayto.append($0["city"]! as! String )
                print("Current files in cityarray: \(self.cityArrayto.last!)")
                
            }
            if self.cityArrayto.count != 0 {
                print("Reloading")
                print("Current files in cityarray: \(self.cityArrayto.count)")
                
            
            }
        }
        
        
        
    }
    
    func getPoints(cname : String) {
        if uid == ""{
            uid = (Auth.auth().currentUser?.uid)!
        }
        print("in getPoints: \(cname)")
        pointArray.removeAll()
        let db = Firestore.firestore()
        countRef = db.collection("users/\(uid)/countries/\(detailedString!)/cities/\(cname)/points")
        print("users/\(uid)/countries/\(detailedString!)/cities/\(cname)/points")
        countRef.addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            let cities = documents.map {
                print("pointarray size: \(self.pointArray.count)")
                let temp = Point()
                temp.setName(city: $0["name"]! as! String)
                self.pointNames.append($0["name"]! as! String)
                temp.setAddress(city: $0["address"]! as! String )
                temp.setLatitude(latitud: $0["latitude"]! as! String )
                temp.setLongitude(longitud: $0["longitude"]! as! String )
                temp.setIcon(city: $0["avatar"]! as! String)
                self.pointArray.append(temp)
                print("Current files in pointarray: \(self.pointArray.last!.getName())")
                
            }
            if self.cityArrayto.count != 0 {
                print("Reloading")
                
                self.homeController.pointArray = self.pointArray
                self.homeController.cityNameto = cname
                if(!self.homeController.markers.isEmpty){  //to clear map markers from map
                    for (index, _) in self.homeController.markers.enumerated() {
                        self.homeController.markers[index].map = nil
                    }
                }
                
                self.homeController.refreshMap()
            }
        }
        
        
        
    }
    
    func configureHomeController(){
        
        self.homeController = HomeController()
        homeController.delegate = self
        homeController.country = detailedString
        if cityRefresh != nil {
            homeController.cityName = cityRefresh
            
        }
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        print("view count: \(view.subviews.count)")

        addChildViewController(centerController)
        centerController.didMove(toParentViewController: self)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //white status bar style
        return .lightContent
    }
    func configureMenuController(){
        if menuController == nil{
            //render menu controller only once
            menuController = MenuController()
            menuController.cityArray = cityArrayto
            menuController.country = detailedString
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChildViewController(menuController)
            menuController.didMove(toParentViewController:  self)
            print("Did add menu controller..")
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?){
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
                
            }, completion: nil)
        } else{
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
            
        }
    }
    
    func didSelectMenuOption(menuOption: MenuOption){
        let cityname = menuOption.getName()
        
        getPoints(cname: cityname)
        
        
        
    }
    
}

extension ContainerController: HomeControllerDelegate {
    func handlMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
        
    }
}


