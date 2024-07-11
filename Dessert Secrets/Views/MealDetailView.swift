//
//  MealDetailView.swift
//  Desert Secrets
//
//  Created by Darryl Fleurantin on 7/9/24.
//

import SwiftUI

struct MealDetailView: View {
    @ObservedObject var viewModel: MealViewModel // ViewModel to manage meal data and state
    let mealId: String // ID of the meal to display details for

    var body: some View {
        VStack(alignment: .leading) {
            // Display meal details if available
            if let meal = viewModel.selectedMeal {
                ScrollView {
                    VStack(alignment: .leading) {
                        // Asynchronously load and display the meal image
                        AsyncImage(url: URL(string: meal.imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        }
                        .padding()

                        HStack {
                            // Display meal name
                            Text(meal.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding([.horizontal, .top])
                                .foregroundColor(.primary)
                                .fontDesign(.serif)
                            
                            Spacer()
                            
                            // Button to toggle the meal as a favorite
                            Button(action: {
                                viewModel.toggleFavorite(meal: Meal(id: meal.id, name: meal.name, imageUrl: meal.imageUrl))
                            }) {
                                Image(systemName: viewModel.favoritedMeals[meal.id] != nil ? "heart.fill" : "heart")
                                    .foregroundColor(viewModel.favoritedMeals[meal.id] != nil ? .red : .gray)
                                    .padding()
                            }
                        }

                        // Display instructions heading
                        Text("Instructions:")
                            .font(.headline)
                            .padding([.top, .horizontal])
                            .fontDesign(.serif)

                        // Display meal instructions
                        Text(meal.instructions.replacingOccurrences(of: "\r\n\r\n", with: "\n\n").replacingOccurrences(of: "\r\n", with: "\n\n"))
                            .padding(.horizontal)
                            .fontDesign(.serif)

                        // Display ingredients heading
                        Text("Ingredients:")
                            .font(.headline)
                            .padding([.top, .horizontal])
                            .fontDesign(.serif)

                        // Display meal ingredients
                        ForEach(meal.ingredients.sorted(by: >), id: \.key) { ingredient, measurement in
                            Text("\(ingredient): \(measurement)")
                                .padding(.horizontal)
                                .fontDesign(.serif)
                        }
                    }
                }
            }
            // Display a loading indicator while fetching meal details
            else {
                ProgressView()
                    .onAppear {
                        Task {
                            await viewModel.fetchMealDetails(by: mealId) // Fetch meal details when the view appears
                        }
                    }
            }
        }
        .padding()
        .onAppear {
            viewModel.selectedMeal = nil // Clear selected meal when the view appears
        }
    }
}

