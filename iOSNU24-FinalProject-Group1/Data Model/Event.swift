//
//  Event.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import FirebaseFirestore
import Foundation

struct Event: Codable, Identifiable {
    @DocumentID var id: String?
    var dateTime: Timestamp
    var name: String
    var location: String
    var capacity: String
    var tag: [String]

    init(dateTime: Timestamp, name: String, location: String, capacity:String, tag: [String]) {
        self.dateTime = dateTime
        self.name = name
        self.location = location
        self.capacity = capacity
        self.tag = tag
    }
}
