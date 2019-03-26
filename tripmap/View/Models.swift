//
//  Models.swift
//  tripmap
//
//  Created by Anthony Yip on 3/24/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import UIKit
import Firebase

class featUsers : NSObject {
    var bannerCategory: UserCategory?
    var userCategories: [UserCategory]?
    
}

class UserCategory: NSObject {
    var name: String?
    var country: String?
    var users: [User]?
    
    
    static func getFirebase() -> [UserCategory] {
        let feat = UserCategory()
        feat.name = ""
        let youtube = UserCategory()
        youtube.name = "Youtube"
        let insta = UserCategory()
        insta.name = "Instagram"
        let faceb = UserCategory()
        faceb.name = "Facebook"
        let db = Firestore.firestore()
        let docRef = db.collection("featured").document("main")  //should add if country check
        docRef.getDocument(source: .server) { (document, error) in
            if let document = document {
                
                
                var youtubePeople = [User]()
                var instaPeople = [User]()
                var facePeople = [User]()
                var featPeople = [User]()
                for  j in 1...5 {
                    let y = User()
                    let i = User()
                    let f = User()
                    let feat = User()
                    feat.id = document.get("feat\(j)") as? String
                    feat.imageName = document.get("feat\(j)i") as? String
                    featPeople.append(feat)
                    
                        y.id = document.get("y\(j)") as? String
                        y.imageName = document.get("y\(j)i") as? String
                        y.name = document.get("y\(j)n") as? String
                        print("\(y.imageName!)")
                        youtubePeople.append(y)
                        i.id = document.get("i\(j)") as? String
                        i.imageName = document.get("i\(j)i") as? String
                        i.name = document.get("i\(j)n") as? String
                        instaPeople.append(i)
                        f.id = document.get("f\(j)") as? String
                        f.imageName = document.get("f\(j)i") as? String
                        f.name = document.get("f\(j)n") as? String
                        facePeople.append(f)
                }
                youtube.users = youtubePeople
                insta.users = instaPeople
                faceb.users = facePeople
                feat.users = featPeople
                
                
                
                
                
            } else{
                print("Failed to get doc")
            }
            
        }
        return [youtube, insta, faceb, feat]
    }
    
    static func userCategories() -> [UserCategory] {
        
        let Youtube = UserCategory()
        Youtube.name = "Youtube"
        
        var youtubePeople = [User]()
        let box = User()
        box.name = "Tester"
        box.imageName = "firebase-logo"
        box.category = "Youtube"
        box.rating = "0"
        youtubePeople.append(box)
        
        Youtube.users = youtubePeople
        
        
        let Instagram = UserCategory()
        Instagram.name = "Instagram"
        
        var instaPeople = [User]()
        let red = User()
        red.name = "Instag"
        red.imageName = "firebase-logo"
        red.category = "Instagram"
        red.rating = "0"
        instaPeople.append(red)
        
        Instagram.users = instaPeople
        
    
        return [Youtube, Instagram]
        
    }
    
    
}


class User: NSObject {
    var id: String?
    var name: String?
    var category: String?
    var imageName: String?
    var rating: String?
}
