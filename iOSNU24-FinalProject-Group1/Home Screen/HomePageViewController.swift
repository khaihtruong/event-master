//
//  HomePageViewController.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Khai Truong on 11/26/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomePageViewController: UIViewController {
    let homeScreen = HomePageView()
    var eventList = [Event]()
    var filteredEvent = [Event]()
    let database = Firestore.firestore()

    override func viewWillAppear(_ animated: Bool) {
        self.homeScreen.tableViewEvent.reloadData()
        self.database.collection("events")
        .addSnapshotListener(
            includeMetadataChanges: false,
            listener: { querySnapshot, error in
                if let documents = querySnapshot?.documents {
                    self.eventList.removeAll()
                    for document in documents {
                        let capacity =
                            document.get("capacity") as! String
                        let name = document.get("name") as! String
                        let date = document.get("dateTime")
                        let location =
                            document.get("location") as! String
                        let tag = document.get("tags") as! [String]

                        let event = Event(dateTime: date as! Timestamp, name: name, location: location, capacity: capacity, tag: tag)
                                            
                        self.eventList.append(event)
                    }
                    self.homeScreen.tableViewEvent.reloadData()
                }
            })
        }
    override func loadView() {
        view = homeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Events"
        
        homeScreen.tableViewEvent.delegate = self
        homeScreen.tableViewEvent.dataSource = self
        
        homeScreen.tableViewEvent.separatorStyle = .none
        
        
        homeScreen.floatingButtonAddContact.addTarget(
                    self, action: #selector(addEventButtonTapped), for: .touchUpInside
                )
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: self,
            action: #selector(onShowProfileTapped)
            )
        
        view.bringSubviewToFront(homeScreen.floatingButtonAddContact)
    }
    
    @objc func onShowProfileTapped() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @objc func addEventButtonTapped(){
        let newEventController = NewEventScreenVC()
        navigationController?.pushViewController(newEventController, animated: true)
    }

}
