//
//  SearchBar.swift
//  Desert Secrets
//
//  Created by Darryl Fleurantin on 7/9/24.
//

import SwiftUI

// A custom SwiftUI view that wraps a UISearchBar
struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    @Binding var isSearchBarVisible: Bool

    // Coordinator to handle UISearchBar delegate methods
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isSearchBarVisible: Bool

        init(text: Binding<String>, isSearchBarVisible: Binding<Bool>) {
            _text = text
            _isSearchBarVisible = isSearchBarVisible
        }

        // Update the binding text when the search text changes
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        // Show the cancel button when editing begins
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
        }

        // Hide the cancel button when editing ends
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
        }

        // Handle the cancel button click - clear text, resign first responder, and hide the search bar
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            searchBar.resignFirstResponder()
            isSearchBarVisible = false // Hide the search bar
        }

        // Handle the search button click - resign first responder
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    // Create a coordinator to manage the UISearchBar
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isSearchBarVisible: $isSearchBarVisible)
    }

    // Create and configure the UISearchBar
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    // Update the UISearchBar when SwiftUI state changes
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
