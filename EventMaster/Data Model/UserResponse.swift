//
//  UserResponse.swift
//  iOSNU24-FinalProject-Group1
//
//  Created by Scott Carvalho on 11/26/24.
//

import Foundation

struct UserResponse: Codable {
    let name: String   // User's name
    let email: String  // User's email address
    let bio: String
    let location: String
    let profileImage: String
}
