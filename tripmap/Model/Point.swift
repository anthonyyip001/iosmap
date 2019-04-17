//
//  MenuOption.swift
//  SideMenu
//
//  Created by Anthony Yip on 3/6/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import Foundation
import UIKit

class Point  {
    var name : String!
    var address : String!
    var latitude : String!
    var longitude : String!
    var icon : String!
    
    
    func setName(city : String) {
        name = city
        
    }
    func getName() -> String{
        return name
    }
    func setIcon(city : String) {
        icon = city
        
    }
    func getIcon() -> String {
        return icon
    }
    func setAddress(city : String) {
        address = city
        
    }
    func getAddress() -> String{
        return address
    }
    func setLatitude(latitud : String) {
        self.latitude = latitud
        
    }
    func getLatitude() -> String{
        return latitude
    }
    func setLongitude(longitud : String) {
        longitude = longitud
        
    }
    func getLongitude() -> String{
        return longitude
    }
    
    
    
}

