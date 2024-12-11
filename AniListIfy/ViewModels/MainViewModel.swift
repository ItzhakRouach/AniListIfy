//
//  MainViewModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 03/12/2024.
//  Description: this file handle main view logic

import Foundation
import FirebaseAuth


class MainViewModel: ObservableObject {
    @Published var currentUserId: String = "" //hold the user id.
    private var handler: AuthStateDidChangeListenerHandle? // handler to check if the user state change (log in or log out)
    
    init() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                print("Auth state changed: \(self?.currentUserId ?? "No user")")
            }
        }
    }
    
    
    //Check if user sign in
    func isSignedIn() -> Bool {
        let signedIn = Auth.auth().currentUser != nil
        print("Signed in: \(signedIn)")
        return signedIn
    }
}
