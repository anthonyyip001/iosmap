//
//  MenuController.swift
//  SideMenu
//
//  Created by Anthony Yip on 3/5/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//
import UIKit
import Foundation

class ContainerController: UIViewController{
    
    var menuController : MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    func configureHomeController(){
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
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
        switch menuOption{
        //add code for stuff here
        case .Profile:
            print("Show profile")
        case .Inbox:
            print("Show inbox")
        case .Notifications:
            print("Show notification")
        case .Settings:
            print("Show setting")
            
            
        }
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


