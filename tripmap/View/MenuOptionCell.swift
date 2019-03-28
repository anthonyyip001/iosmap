//
//  MenuOptionCell.swift
//  SideMenu
//
//  Created by Anthony Yip on 3/5/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {
    
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Sample Text"
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .darkGray
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false         //creating icon for each cell option menu
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true;
        
       addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false         //creating icon for each cell option menu
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true   //setting the text next to right anchor of icon
       
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

}
