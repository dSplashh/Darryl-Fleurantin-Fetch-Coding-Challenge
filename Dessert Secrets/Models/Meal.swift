//
//  Meal.swift
//  Desert Secrets
//
//  Created by Darryl Fleurantin on 7/9/24.
//

import Foundation

struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageUrl = "strMealThumb"
    }
}
