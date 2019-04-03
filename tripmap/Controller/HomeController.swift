//
//  ViewController.swift
//  tripmap
//
//  Created by Anthony Yip on 3/6/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import GooglePlaces

class HomeController: UIViewController {
    var delegate: HomeControllerDelegate?
    var country: String!
    var mapView : GMSMapView!
    var cityName: String!
    var uid: String!
    var provided = false
    var pointArray = Array<Point>()
    var cityNameto: String!
    var markers = [GMSMarker]()
    var userCategories: [UserCategory]?
    var featCategory: UserCategory?
    
    //clustering
    //private var clusterManager : GMUClus
    
    
    let floater: UIButton = {
        let floating = UIButton()
        floating.translatesAutoresizingMaskIntoConstraints = false
        floating.backgroundColor = .red
        floating.setTitle("add", for: .normal)
        return floating
    }()
    
    let floater2: UIButton = {
        let floating = UIButton()
        floating.translatesAutoresizingMaskIntoConstraints = false
        floating.backgroundColor = .red
        floating.setTitle("all", for: .normal)
        return floating
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if provided == false{
            GMSServices.provideAPIKey("AIzaSyCvTaM5VaLOf-D1ZFx11dR_66IwIiPnQ30")
            GMSPlacesClient.provideAPIKey("AIzaSyCvTaM5VaLOf-D1ZFx11dR_66IwIiPnQ30")
            provided = true
        }
        
        if uid == nil {
            loadUserData()
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.632, longitude: -122.378, zoom: 8)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
        view = mapView
        
        //var ref: DocumentReference? = nil
        //ref = db.collection("Users").addDocument(data: <#T##[String : Any]#>)
        
        
        view.addSubview(floater)
        floater.heightAnchor.constraint(equalToConstant: 64).isActive = true
        floater.widthAnchor.constraint(equalToConstant: 64).isActive = true
        floater.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        floater.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -36).isActive = true
        
       floater.addTarget(self, action: #selector(btnAddTapp(sender:)), for: .touchUpInside)
        
        view.addSubview(floater2)
        floater2.heightAnchor.constraint(equalToConstant: 48).isActive = true
        floater2.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        floater2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -370).isActive = true
        floater2.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 115).isActive = true
        
        floater2.addTarget(self, action: #selector(btnListTapp(sender:)), for: .touchUpInside)
        
        configureNavigationBar()
        print("Configured NavBar")
        
        
        userCategories = UserCategory.getFirebase()
        featCategory = userCategories?.popLast()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.configureNavigationBar()
    }
    @objc func btnListTapp(sender: UIButton){
        print("list button tapped")
        let cityView = CityListPopup()

        let datasource = [
            City(name: "Ho Chi Minh",
                 description: "Hello this is Ho Chi Minh City",
                 point: CLLocationCoordinate2D(latitude: 10.769810,
                                               longitude: 106.681363)),
            City(name: "Ha Noi",
                 description: "Welcome to Ha Noi",
                 point: CLLocationCoordinate2D(latitude: 10.780994,
                                               longitude: 106.731364)),
            City(name: "Da Nang",
                 description: "This is the best city",
                 point: CLLocationCoordinate2D(latitude: 10.758435,
                                               longitude: 106.556458)),
            City(name: "Ho Chi Minh",
                 description: "Hello this is Ho Chi Minh City",
                 point: CLLocationCoordinate2D(latitude: 10.769810,
                                               longitude: 106.681363)),
            City(name: "Ha Noi",
                 description: "Welcome to Ha Noi",
                 point: CLLocationCoordinate2D(latitude: 10.780994,
                                               longitude: 106.731364)),
            City(name: "Da Nang",
                 description: "This is the best city",
                 point: CLLocationCoordinate2D(latitude: 10.758435,
                                               longitude: 106.556458)),
            City(name: "Ho Chi Minh",
                 description: "Hello this is Ho Chi Minh City",
                 point: CLLocationCoordinate2D(latitude: 10.769810,
                                               longitude: 106.681363)),
            City(name: "Ha Noi",
                 description: "Welcome to Ha Noi",
                 point: CLLocationCoordinate2D(latitude: 10.780994,
                                               longitude: 106.731364)),
            City(name: "Da Nang",
                 description: "This is the best city",
                 point: CLLocationCoordinate2D(latitude: 10.758435,
                                               longitude: 106.556458)),
            City(name: "Ho Chi Minh",
                 description: "Hello this is Ho Chi Minh City",
                 point: CLLocationCoordinate2D(latitude: 10.769810,
                                               longitude: 106.681363)),
            City(name: "Ha Noi",
                 description: "Welcome to Ha Noi",
                 point: CLLocationCoordinate2D(latitude: 10.780994,
                                               longitude: 106.731364)),
            City(name: "Da Nang",
                 description: "This is the best city",
                 point: CLLocationCoordinate2D(latitude: 10.758435,
                                               longitude: 106.556458)),
        ]
        cityView.setData(data: datasource)

        cityView.selectAction = { [weak self] city in
            self?.dropMarker(city: city)
        }
        cityView.show(in: view)
    }

    func dropMarker(city: City) {
        guard let point = city.point else { return }
        let marker = GMSMarker(position: point)
        marker.icon = UIImage(named: "strictd_marker")
        marker.title = city.name
        marker.snippet = city.description
        marker.map = mapView
        markers.append(marker)
        let camera = GMSCameraPosition.camera(withLatitude: point.latitude,
                                              longitude: point.longitude,
                                              zoom: 20)
        mapView.camera = camera
    }
    
    @objc func btnAddTapp(sender: UIButton){
        print("add button tapped")
        if cityNameto == nil{
            print("no city name")
        }
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter

        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func handleMenuToggle() {
        print("Toggle menu..")
        delegate?.handlMenuToggle(forMenuOption: nil)
    }
    
    @objc func handleUserToggle() {
        print("Toggle user..")
        print("This is country: \(country!)")
        
        let vc = UserController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.country = country!
        vc.userCategories = userCategories
        vc.featCategory = featCategory
        
        navigationController?.pushViewController(vc, animated: true)
        //navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = country
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleUserToggle))
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserData() {
        uid = Auth.auth().currentUser?.uid
    }
    
    func refreshMap() {
        print("Refreshing map with data: \(cityNameto!)")
        print("pointarray size: \(pointArray.count)")
        var lat = pointArray.first?.getLatitude().toDouble()!           //set camera around points in pointArray
        var long = pointArray.first?.getLongitude().toDouble()!
        var index = 1
        
        //Placing into clusters
        showClusters()
        for pont in pointArray {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(pont.getLatitude())!, longitude: Double(pont.getLongitude())!))
            marker.title = pont.getName()
            marker.map = mapView
            if(index != 1){
                lat = lat! + pont.getLatitude().toDouble()!
                long = long! + pont.getLongitude().toDouble()!
                index = index + 1
                
            }
            markers.append(marker)
            print(pont)
            
        }
        
        if(!pointArray.isEmpty){
            lat = lat! / Double(pointArray.count)
            long = long! / Double(pointArray.count)
            let camera = GMSCameraPosition.camera(withLatitude: lat!,
                                                  longitude: long!,
                                                  zoom: 10)
            mapView.camera = camera
        }
    }
    
    func showClusters() {
        ///bllab
    }
    
}
extension HomeController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("Entered into willmove")
        if gesture == false {
            print("mved programatically")
        }
    }
    
}

extension HomeController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated:true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name!)")
        print("Place address: \(place.formattedAddress!)")
        let marker = GMSMarker(position: place.coordinate)
        marker.title = place.name
        marker.map = mapView
        markers.append(marker)
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                              longitude: place.coordinate.longitude,
                                              zoom: 20)
        dismiss(animated:true, completion: nil)
        mapView.camera = camera
        
        let alert = UIAlertController(title: "Add Point?", message: "add \(place.name!)?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let db = Firestore.firestore()
            db.collection("users/\(self.uid!)/countries/\(self.country!)/cities/\(self.cityNameto!)/points").document(place.name!).setData(["name": "\(place.name!)" ,
                "address": "\(place.formattedAddress!)",
                "latitude": "\(place.coordinate.latitude)",
                "longitude": "\(place.coordinate.longitude)"
                ])
            
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
            print("Cancel pressed")
            marker.map = nil
            
        }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
