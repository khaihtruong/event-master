//
//  HomePageView.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Khai Truong on 11/26/24.
//

import UIKit

class HomePageView: UIView {

    var bottomAddView:UIView!
    var homeButton:UIButton!
    var profileButton:UIButton!
    var floatingButtonAddContact: UIButton!
    var tableViewEvent: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupFloatingButtonAddContact()
        setupTableViewEvent()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    func setupTableViewEvent(){
        tableViewEvent = UITableView()
        tableViewEvent.register(EventTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        tableViewEvent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewEvent)
    }
    
    func setupFloatingButtonAddContact(){
        floatingButtonAddContact = UIButton(type: .system)
        floatingButtonAddContact.titleLabel?.font = .boldSystemFont(ofSize: 200)
        floatingButtonAddContact.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        floatingButtonAddContact.frame.size = CGSize(width: 200.0, height: 300.0)
        floatingButtonAddContact.contentHorizontalAlignment = .fill
        floatingButtonAddContact.contentVerticalAlignment = .fill
        floatingButtonAddContact.imageView?.contentMode = .scaleAspectFit
        floatingButtonAddContact.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(floatingButtonAddContact)
    }
    
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            tableViewEvent.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableViewEvent.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewEvent.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewEvent.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            floatingButtonAddContact.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonAddContact.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonAddContact.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButtonAddContact.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
}
