//
//  UserController.swift
//  tripmap
//
//  Created by Anthony Yip on 3/22/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import Foundation
import UIKit

class UserController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    var userCategories: [UserCategory]?
    var featCategory : UserCategory?
    
    var country : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        navigationItem.title = "Featured"
    
        
        print("passed")
        
        collectionView?.backgroundColor = UIColor.white
        //print("\(country!)")
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        
        cell.userCategory = userCategories?[indexPath.item]
        cell.userController = self
        
        return cell
    }
    
    func loadData(user : User) {
        let nmap = CountryController()
        nmap.uid = user.id!
        navigationController?.pushViewController(nmap, animated: true)
        //navigationController?.navigationBar.backItem?.setLeftBarButton(<#T##item: UIBarButtonItem?##UIBarButtonItem?#>, animated: <#T##Bool#>)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = userCategories?.count {
            return count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: view.frame.width, height: 200)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 0, 600, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize.init(width: view.frame.width, height: 200)
        return size
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        header.userCategory = featCategory
        
        return header
    }
    
}

class Header: CategoryCell {
    let cellId = "featCellId"
    
    override func setupViews() {
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        
        usersCollectionView.register(FeatCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(usersCollectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : usersCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : usersCollectionView]))
        
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(25, 0, 0, 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        
        cell.user = userCategory?.users?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: 225, height: frame.height + 10)
        return size
    }
    
    private class FeatCell: UserCell {
        public override func setupViews() {
            imageView.layer.cornerRadius = 6
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView]))
            
        }
    }
}
