//
//  EventDetailScreenVC.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import UIKit
import CoreLocation // For converting address to coordinates

class EventDetailScreenVC: UIViewController, EventDetailScreenDelegate {
    let eventDetailScreen = EventDetailScreen()
    let database = Firestore.firestore()
//    let testEventKey = "Bob2024-11-27 17:001 test Dr"
    let placeholderCurrUser = "bob@gmail.com"
    let currUserEmail = Auth.auth().currentUser?.email
    var eventKey = ""
    let currUser: String! = Auth.auth().currentUser?.displayName
    var commentTextView: UITextView?

    var allComments = [Comment]()
    var TF = false

    override func loadView() {
        view = eventDetailScreen
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("currUser: \(currUser)")
        
        eventDetailScreen.delegate = self
        
        eventDetailScreen.buttonShowMap.removeTarget(nil, action: nil, for: .allEvents) //Remove existing targets to prevent duplicate map call/screen
        
        eventDetailScreen.buttonShowMap.addTarget(self, action: #selector(onShowMapTapped), for: .touchUpInside) //Add button target
        
        
//        eventKey = currUser + eventKey
        print("eventDetailVC eventKey: |\(eventKey)|")
        commentListener(eventKey: eventKey)
        Task {
            do {
                try await loadEvent()
            } catch {
                print("Failed to fetch messages: \(error)")
            }
        }

        eventDetailScreen.tableViewComments.delegate = self
        eventDetailScreen.tableViewComments.dataSource = self

        eventDetailScreen.buttonAddComment.addTarget(
            self, action: #selector(onReplyButtonTapped), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem()

        //MARK: recognizing the taps on the app screen, not the keyboard...
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)

    }

    func loadEvent() async throws {
        print("loading event details for |\(eventKey)|")
        do {
            let eventRef = try await database.collection("events").document(
                eventKey
            ).getDocument()

            if let event = eventRef.data() {
                print("event loaded \(event)")
                
                guard let uwEventDataName = event["name"] as? String else {
                    print("error unwrapping event name")
                    return
                }
                guard let uwEventDataDateTime = event["dateTime"] as? Timestamp
                else {
                    print("error unwrapping event date time")
                    return
                }
                guard let uwEventDataLocation = event["location"] as? String
                else {
                    print("error unwrapping event location")
                    return
                }
                guard let uwEventDataCapacity = event["capacity"] as? String
                else {
                    print("error unwrapping event capacity")
                    return
                }
                guard let uwEventDataTags = event["tags"] as? [String] else {
                    print("error unwrapping event date time")
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                var loadedEvent = Event(
                    dateTime: uwEventDataDateTime, name: uwEventDataName,
                    location: uwEventDataLocation,
                    capacity: uwEventDataCapacity,
                    tag: uwEventDataTags)
                
                eventDetailScreen.labelEventDetailName.text! += uwEventDataName
                eventDetailScreen.labelEventDetailDateTime.text! +=
                dateFormatter.string(
                    from: uwEventDataDateTime.dateValue())
                eventDetailScreen.labelEventDetailLocation.text! +=
                uwEventDataLocation
                eventDetailScreen.labelEventDetailAttendance.text! +=
                uwEventDataCapacity
                eventDetailScreen.labelEventDetailTags.text! +=
                uwEventDataTags.joined(separator: ", ")
                eventDetailScreen.setEventImage(imageName: uwEventDataTags[0])
                
                convertAddressToCoordinates(address: uwEventDataLocation) { coordinate, error in
                    if let error = error {
                        print("Geocoding error: \(error.localizedDescription)")
                        return
                    }
                    if let coordinate = coordinate {
                        print("Coordinates for \(uwEventDataLocation): \(coordinate.latitude), \(coordinate.longitude)")
                    }
                }
            }
        } catch let error as NSError {
                print("Error fetching event details: \(error.localizedDescription)")
                print("Error code: \(error.code), domain: \(error.domain)")
        }
}
    

    private func convertAddressToCoordinates(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate, nil)
            } else {
                completion(nil, NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to find coordinates for the given address."]))
            }
        }
    }
    
    func commentListener(eventKey: String) {
        print("commentListener: ")
        database.collection("events").document(eventKey).collection(
            "comments"
        )
        .order(by: "createdTS").addSnapshotListener {
            querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            print(snapshot.documents)
            for document in snapshot.documents {
                let commentData = document.data()
                do {
                    let comment = try document.data(as: Comment.self)
                    if !self.allComments.contains(where: {
                        $0.id == comment.id
                    }) {
                        self.allComments.append(comment)
                    }
                } catch {
                    print("error decoding message data: \(error)")
                }
            }

            self.eventDetailScreen.tableViewComments.reloadData()

        }

    }

    @objc func onReplyButtonTapped() {
        print("reply button tapped")
        guard let uwInputText = eventDetailScreen.textViewReply.text,
            !uwInputText.isEmpty
        else {
            print("textView null or empty")
            return
        }
        print(uwInputText + " in textView")

        database.collection("events").document(eventKey).collection("comments")
            .addDocument(data: [
                "text": uwInputText,
                "createdTS": Timestamp(),
                "likes": [String](),
                "user": currUser,
            ]) { error in
                if let error = error {
                    print("error adding message: \(error)")
                } else {
                    print("message added successfully!")
                }
            }
        eventDetailScreen.textViewReply.text = ""
    }

    //MARK: Hide Keyboard...
    @objc func hideKeyboardOnTap() {
        //MARK: removing the keyboard from screen...
        view.endEditing(true)
    }
    
    //MARK: Go to map screen when map button tapped
    @objc func onShowMapTapped() {
        guard let eventLocation = eventDetailScreen.labelEventDetailLocation.text, !eventLocation.isEmpty else {
            print("Event location is missing or empty")
            return
        }
        
        // ConvertZ event location text to coordinates
        convertAddressToCoordinates(address: eventLocation) { [weak self] coordinate, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let coordinate = coordinate {
                print("Coordinates fetched for \(eventLocation): \(coordinate.latitude), \(coordinate.longitude)")
                
                let mapViewController = MapViewController()
                mapViewController.eventLocation = coordinate
                self.navigationController?.pushViewController(mapViewController, animated: true)
            }
        }
    }

    @objc func commentLikeButtonTapped(_ sender: UIButton) {

        let rowIndex = sender.tag
//        let likedCommentID = allComments[rowIndex].id!
//        var likedComment = allComments[rowIndex]

        guard let uwCurrUserEmail = currUserEmail else {
            print("error unwrapping currUserEmail")
            return
        }
        
        print("like button tapped")
        print("starting likes list \(allComments[rowIndex].likes)")

        if !allComments[rowIndex].likes.contains(uwCurrUserEmail) {
            print("curr user is NOT in likes list, adding")

            allComments[rowIndex].likes.append(uwCurrUserEmail)
            print(
                "added \(allComments[rowIndex].id!) \(allComments[rowIndex].user) to \(allComments[rowIndex].likes)"
            )

            let commentRef = database.collection("events").document(
                eventKey
            ).collection("comments").document(allComments[rowIndex].id!)
            commentRef.updateData(["likes": allComments[rowIndex].likes])
            self.TF = true
        } else {

            print("curr user IS in likes list, removing")

            guard
                let currUserIndex = allComments[rowIndex].likes.firstIndex(
                    of: uwCurrUserEmail)
                
                
            else {
                print("currUserIndex not found")
                return
            }
            self.TF = false

            print("currUserIndex \(currUserIndex)")

            allComments[rowIndex].likes.remove(at: currUserIndex)
            let commentRef = database.collection("events").document(
                eventKey
            )
            .collection("comments").document(allComments[rowIndex].id!)
            commentRef.updateData(["likes": allComments[rowIndex].likes])

        }

        print("after appending allcomments \(allComments[rowIndex].likes)")
    }

}

extension EventDetailScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return allComments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"

        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "comments", for: indexPath)
            as! TableViewCommentCell

        
        cell.labelUserName.text = allComments[indexPath.row].user
        cell.labelCommentText.text = allComments[indexPath.row].text
        cell.labelDateTime.text = dateFormatter.string(
            from: allComments[indexPath.row].createdTS.dateValue())

        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.setTitle(
            String(allComments[indexPath.row].likes.count), for: .normal)
        cell.contentView.isUserInteractionEnabled = false
        cell.buttonLike.addTarget(
            self, action: #selector(commentLikeButtonTapped),
            for: .touchUpInside)
        
        if self.TF == true {
            cell.buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.buttonLike.tintColor = .systemRed
        } else {
            cell.buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.buttonLike.tintColor = .systemBlue
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.selectionStyle = .none
    }

}
