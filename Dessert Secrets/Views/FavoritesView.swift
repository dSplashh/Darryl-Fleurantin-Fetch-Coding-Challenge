//
//  FavoritesView.swift
//  Dessert Secrets
//
//  Created by Darryl Fleurantin on 7/11/24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: MealViewModel // ViewModel to manage meal data and state

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                // Display the title  in the center of the top bar
                Text("Favorites")
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.serif)
        
                Spacer()
            }
            
            // Display the list of favorited meals
            List {
                // Sort favorited meals alphabetically by name and display each meal
                ForEach(viewModel.favoritedMeals.values.sorted { $0.name < $1.name }) { meal in
                    HStack {
                        // Navigation link to navigate to the MealDetailView when a meal is selected
                        NavigationLink(destination: MealDetailView(viewModel: viewModel, mealId: meal.id)) {
                            HStack {
                                // Asynchronously load and display the meal image
                                AsyncImage(url: URL(string: meal.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(50)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 50, height: 50)
                                }
                                
                                // Display the meal name
                                Text(meal.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .fontWeight(.light)
                                    .fontDesign(.serif)
                                    .padding(.leading, 10)
                            }
                        }
                        
                        Spacer()
                        
                        // Button to toggle the meal as a favorite
                        Button(action: {
                            viewModel.toggleFavorite(meal: meal)
                        }) {
                            Image(systemName: viewModel.favoritedMeals[meal.id] != nil ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.favoritedMeals[meal.id] != nil ? .red : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: MealViewModel())
}
