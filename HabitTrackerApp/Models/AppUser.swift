//
//  User.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 27/11/25.
//

import Foundation

struct AppUser: Codable {
    let id: String
    let name: String
    let email: String
    let joinedDate: Date
    let birthDate: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case joinedDate = "joined_date"
        case birthDate = "birth_date"
    }
}
