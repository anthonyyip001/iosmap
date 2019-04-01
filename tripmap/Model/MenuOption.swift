//
//  MenuOption.swift
//  SideMenu
//
//  Created by Anthony Yip on 3/6/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import Foundation
import UIKit

class MenuOption: UITableViewCell {
    var name : String!
    var index : Int!
    
    
    func setName(city : String) {
        name = city
        
    }
    func getName() -> String{
        return name
    }
    func setIndex(index : Int) {
        self.index = index
    }
    func getIndex() -> Int {
        return index
    }
    
    
    
}

