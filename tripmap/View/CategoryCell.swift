//
//  CategoryCell.swift
//  tripmap
//
//  Created by Anthony Yip on 3/22/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    private let cellId = "userCellId"
    
    var userController: UserController?
    
    var userCategory: UserCategory? {
        didSet {
            if let name = userCategory?.name {
                nameLabel.text = name
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = userCategory?.users?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        
         cell.user = userCategory?.users?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user = userCategory?.users?[indexPath.item]{
            userController?.loadData(user: user)
        }
        print("Selected")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let usersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Youtube"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        //backgroundColor = UIColor.green
     
        addSubview(usersCollectionView)
        addSubview(dividerLine)
        addSubview(nameLabel)
        
        usersCollectionView.dataSource = self
        usersCollectionView.delegate = self
        
        usersCollectionView.register(UserCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLine]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": usersCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(30)][v0][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": usersCollectionView, "v1": dividerLine, "nameLabel": nameLabel]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: 100, height: frame.height - 32)  //adjusts pic height so text not cutoff bottom
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 20)
    }
    
}

class UserCell: UICollectionViewCell{
    
    var user: User? {
        didSet {
            if let name = user?.name {
                nameLabel.text = name
            }
            ratingLabel.text = user?.rating
            
            
            if let imageName = user?.imageName {
                imageView.image = UIImage(named: imageName)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "firebase-logo")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    func setupViews(){
        
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ratingLabel)
        
        let rect = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.width)
        imageView.frame = rect
        let rect1 = CGRect.init(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        nameLabel.frame = rect1
        ratingLabel.frame = CGRect.init(x: 0, y: frame.width + 32, width: frame.width, height: 20)
    }
    
}
