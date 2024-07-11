//
//  MealDetail.swift
//  Desert Secrets
//
//  Created by Darryl Fleurantin on 7/9/24.
//

import Foundation

struct MealDetail: Identifiable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [String: String]
    let imageUrl: String
    
    // Enum to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case imageUrl = "strMealThumb" 
    }
    
    // Initializer for MealDetail
    init(id: String, name: String, instructions: String, ingredients: [String: String], imageUrl: String) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
        self.imageUrl = imageUrl
    }
    
    // Factory method to create a MealDetail instance from a dictionary
    static func from(_ dictionary: [String: Any]) -> MealDetail? {
        // Safely unwrap and map the dictionary values to the corresponding properties
        guard let id = dictionary["idMeal"] as? String,
              let name = dictionary["strMeal"] as? String,
              let instructions = dictionary["strInstructions"] as? String,
              let imageUrl = dictionary["strMealThumb"] as? String else {
            return nil // Return nil if any required value is missing
        }
        
        var ingredients = [String: String]()
        for index in 1...20 {
            // Safely unwrap and add ingredients and measurements to the dictionary
            if let ingredient = dictionary["strIngredient\(index)"] as? String, !ingredient.isEmpty,
               let measurement = dictionary["strMeasure\(index)"] as? String, !measurement.isEmpty {
                ingredients[ingredient] = measurement
            }
        }
        
        // Return a new MealDetail instance with the parsed values
        return MealDetail(id: id, name: name, instructions: instructions, ingredients: ingredients, imageUrl: imageUrl)
    }
}
