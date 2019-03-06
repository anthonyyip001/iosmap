//
//  ViewController.swift
//  tripmap
//
//  Created by Anthony Yip on 3/6/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeController: UIViewController {
    var delegate: HomeControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey("AIzaSyCvTaM5VaLOf-D1ZFx11dR_66IwIiPnQ30")
        let camera = GMSCameraPosition.camera(withLatitude: 37.632, longitude: -122.378, zoom: 8)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        configureNavigationBar()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func handleMenuToggle() {
        print("Toggle menu..")
        delegate?.handlMenuToggle(forMenuOption: nil)
    }
    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Side Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

