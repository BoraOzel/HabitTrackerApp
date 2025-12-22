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
    let birthDate: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case birthDate = "birth_date"
    }
}
