//
//  MealViewModel.swift
//  Desert Secrets
//
//  Created by Darryl Fleurantin on 7/9/24.
//

import SwiftUI

// ViewModel for handling meal-related data and operations
class MealViewModel: ObservableObject {
    // Published properties to update the UI when their values change
    @Published var meals: [Meal] = []
    @Published var selectedMeal: MealDetail?
    @Published var favoritedMeals: [String: Meal] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // Initializer to load favorited meals from storage when the ViewModel is created
    init() {
        loadFavorites()
    }

    // Fetch dessert meals asynchronously from the API
    func fetchDessertMeals() async {
        isLoading = true // Set loading state to true
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
            DispatchQueue.main.async {
                self.meals = decodedResponse.meals.sorted { $0.name < $1.name } // Sort meals by name
                self.isLoading = false // Set loading state to false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching meals: \(error.localizedDescription)" // Set error message
                self.isLoading = false // Set loading state to false
            }
        }
    }

    // Fetch meal details asynchronously from the API
    func fetchMealDetails(by id: String) async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let mealData = decodedResponse?["meals"] as? [[String: Any]], let mealDetails = MealDetail.from(mealData.first!) {
                DispatchQueue.main.async {
                    self.selectedMeal = mealDetails // Update selected meal
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching meal details: \(error.localizedDescription)" // Set error message
            }
        }
    }

    // Toggle the favorite state of a meal
    func toggleFavorite(meal: Meal) {
        DispatchQueue.main.async {
            if self.favoritedMeals[meal.id] != nil {
                self.favoritedMeals.removeValue(forKey: meal.id) // Remove from favorites if already favorited
            } else {
                self.favoritedMeals[meal.id] = meal // Add to favorites if not already favorited
            }
            self.saveFavorites() // Save updated favorites to storage
        }
    }

    // Save the current list of favorited meals to UserDefaults
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoritedMeals) {
            UserDefaults.standard.set(encoded, forKey: "favoritedMeals")
        }
    }

    // Load the list of favorited meals from UserDefaults
    private func loadFavorites() {
        if let savedMeals = UserDefaults.standard.data(forKey: "favoritedMeals") {
            DispatchQueue.main.async {
                if let decodedMeals = try? JSONDecoder().decode([String: Meal].self, from: savedMeals) {
                    self.favoritedMeals = decodedMeals // Update favorited meals with saved data on the main thread
                }
            }
        }
    }


    // Filter meals based on the search text
    func filteredMeals(searchText: String) -> [Meal] {
        if searchText.isEmpty {
            return meals // Return all meals if search text is empty
        } else {
            return meals.filter { $0.name.lowercased().contains(searchText.lowercased()) } // Return filtered meals
        }
    }
}
