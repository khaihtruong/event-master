//
//  Comment.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Hanson Wu on 11/27/24.
//

import FirebaseFirestore
import Foundation

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var createdTS: Timestamp
    var user: String
    var text: String
    var likes: [String]

    init(createdTS: Timestamp, user: String, text: String) {
        self.createdTS = createdTS
        self.user = user
        self.text = text
        self.likes = []
    }
}
