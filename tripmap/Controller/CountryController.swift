//
//  HomeController.swift
//  CreateFirebaseUser
//
//  Created by Stephen Dowless on 1/2/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import Firebase


class country {
    var cname: String?
    
    init(name: String){
        self.cname = name
    }
}


class CountryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let countryId = "countryId"
    let numbers = ["1", "2", "3", "4", "5"]
    var countryArray = [String]()
    var docRef : DocumentReference!
    var countRef : CollectionReference!
    var uid = ""
    var myuid : String?
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = true
        return tv
    }()
    
    let floater: UIButton = {
       let floating = UIButton()
        floating.translatesAutoresizingMaskIntoConstraints = false
        floating.backgroundColor = .red
        floating.setTitle("add", for: .normal)
        return floating
    }()
    
    // MARK: - Properties
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if uid == ""{
            myuid = (Auth.auth().currentUser?.uid)!
            uid = myuid!
        }
        
            let db = Firestore.firestore()
        countRef = db.collection("users").document(uid).collection("countries")
            
            countRef.addSnapshotListener { QuerySnapshot, error in
                guard let documents = QuerySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let countries = documents.map {
                    self.countryArray.append($0["country"]! as! String )
                    print("Current files in countries: \(self.countryArray.last!)")
                    
                }
                
                if self.countryArray.count != 0 {
                    print("Reloading")
                    self.tableView.reloadData()
                }
                
                
                //print("Current files in countries: \(self.countryArray.last)")
                
                //add update function here
                
            }
        
        authenticateUserAndConfigureView()
        setupTableView()
        
        
    }
    
    // MARK: - Selectors
    
    @objc func goBack() {
        if let nav = self.navigationController, self != nav.viewControllers.first {
            nav.popViewController(animated: true)
        } else {
            self.handleSignOut()
        }
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(countryCell.self, forCellReuseIdentifier: countryId)
        
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.addSubview(floater)
    
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        floater.heightAnchor.constraint(equalToConstant: 64).isActive = true
        floater.widthAnchor.constraint(equalToConstant: 64).isActive = true
        floater.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        floater.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -36).isActive = true
        
        floater.addTarget(self, action: #selector(btnAddTapp(sender:)), for: .touchUpInside)
        
    }
    
    @objc func btnAddTapp(sender: UIButton){
        print("add button tapped")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let alert = UIAlertController(title: "Add Country?", message: "Enter a Country", preferredStyle: .alert)
        alert.addTextField { (textField) in
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let country = textField?.text else { return }
            let db = Firestore.firestore()
            db.collection("users/\(uid)/countries").document(country).setData(["country": "\(country)"])
            
        }))
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("in num of rows section: \(self.countryArray.count)")
        return self.countryArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countr = countryArray[indexPath.row] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: countryId, for: indexPath) as! countryCell
        
        print("in setting labels: \(countryArray[indexPath.row])")
        
        cell.setTitle(String: countr)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "Countries"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked on \(countryArray[indexPath.row])")
        let vc = ContainerController()
        vc.detailedString = countryArray[indexPath.row]
        if uid != myuid{
            vc.uid = uid
        }
        
        
        navigationController?.pushViewController(vc, animated: true)
        //navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    
    func loadUserData() {
        
    
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            configureViewComponents()
            loadUserData()
        }
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = UIColor.darkGray
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Trips Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.darkGray
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}


class countryCell: UITableViewCell {
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.addShadow()
        
        return view
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 5, dy: 100)
    }
    func setTitle(String: String){
        countryLabel.text = String
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    func setup() {
        addSubview(cellView)
        
        cellView.addSubview(countryLabel)
        
        cellView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 7, paddingBottom: 0, paddingRight: 7, width: 20, height: 50)
        
        
        //setting up label anchor and constraints to appear
        countryLabel.anchor(top: nil, left: cellView.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        countryLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) hasnt been implemented")
    }
}

extension UIView{
    func addShadow(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 1.0,height: 1.0)
        self.layer.cornerRadius = 8
    }
    
}

