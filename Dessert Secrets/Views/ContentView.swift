//
//  ContentView.swift
//  Desert Secrets
//
//  Created by Darryl Fleurantin on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MealViewModel() // ViewModel to manage meal data and state
    @State private var searchText = "" // State to hold the search text
    @State private var isSearchBarVisible = false // State to control search bar visibility

    var body: some View {
        NavigationView {
            VStack {
                // Header with image, title, search button, and favorites button
                HStack {
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 50)
                        .padding(.leading)
                        .tint(Color.red)

                    Spacer()
                    Spacer()

                    Text("DESSERT SECRETS")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                        .fontDesign(.serif)

                    Spacer()

                    // Button to toggle the search bar visibility
                    Button(action: {
                        isSearchBarVisible.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .frame(width: 24, height: 24)
                            .padding(.trailing)
                            .background(Color.white)
                    }

                    // Navigation link to the favorites view
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                        Image(systemName: "heart.fill")
                            .frame(width: 24, height: 24)
                            .padding(.trailing)
                            .foregroundColor(Color.blue)
                    }
                }
                .background(Color.white)

                // Display the search bar if isSearchBarVisible is true
                if isSearchBarVisible {
                    SearchBar(text: $searchText, isSearchBarVisible: $isSearchBarVisible)
                        .padding([.horizontal, .bottom])
                }

                // Display a loading indicator if meals are being loaded
                if viewModel.isLoading {
                    ProgressView("Loading meals...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                // Display an error message if there was an error fetching meals
                else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                // Display the list of meals
                else {
                    List {
                        ForEach(viewModel.filteredMeals(searchText: searchText)) { meal in
                            HStack {
                                // Navigation link to meal detail view
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
                                .buttonStyle(BorderlessButtonStyle()) // Allow the button to work inside a list
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchDessertMeals() // Fetch meals when the view appears
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}

#Preview {
    ContentView()
}
