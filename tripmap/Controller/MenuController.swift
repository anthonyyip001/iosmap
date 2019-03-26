//
//  MenuController.swift
//  SideMenu
//
//  Created by Anthony Yip on 3/5/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//
import UIKit
import Firebase

private let reuseIdentifier = "MenuOptionCell"

class MenuController: UIViewController{
    var tableView : UITableView!
    var delegate : HomeControllerDelegate?
    var cityArray = Array<String>()
    var pointsArray = Array<String>()
    var country: String!
    var docRef : DocumentReference!
    var countRef : CollectionReference!
    var menuArray = Array<MenuOption>()
    
    let floater: UIButton = {
        let floating = UIButton()
        floating.translatesAutoresizingMaskIntoConstraints = false
        floating.backgroundColor = .red
        floating.setTitle("add", for: .normal)
        return floating
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .darkGray   //style of tableview options menu
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        print("After adding a tableview: \(view.subviews.count)")
        tableView.addSubview(floater)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        floater.heightAnchor.constraint(equalToConstant: 64).isActive = true
        floater.widthAnchor.constraint(equalToConstant: 64).isActive = true
        floater.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        floater.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -36).isActive = true
        
        floater.addTarget(self, action: #selector(btnAddTapp(sender:)), for: .touchUpInside)
        
    }
    
    @objc func btnAddTapp(sender: UIButton){
        print("add button tapped")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let alert = UIAlertController(title: "Add City?", message: "Enter a City", preferredStyle: .alert)
        alert.addTextField { (textField) in
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let tcity = textField?.text else { return }
            self.cityArray.append(tcity)
            let db = Firestore.firestore()
            db.collection("users/\(uid)/countries/\(self.country!)/cities").document(tcity).setData(["city": "\(tcity)"])
            
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = MenuOption()
        menuOption.setName(city: cityArray[indexPath.row])
        menuOption.setIndex(index: indexPath.row)
        
        if !pointsArray.isEmpty {
            menuOption.setName(city: pointsArray[indexPath.row])
            menuOption.setIndex(index: indexPath.row)
        }
        
        menuArray.append(menuOption)
        cell.descriptionLabel.text = cityArray[indexPath.row]
        if !pointsArray.isEmpty {
            cell.descriptionLabel.text = pointsArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(  _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var menuOption = MenuOption()
        menuOption = menuArray[indexPath.row]
        delegate?.handlMenuToggle(forMenuOption: menuOption)
    }
    
}

