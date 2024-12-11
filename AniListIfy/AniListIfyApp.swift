//
//  AniListIfyApp.swift
//  AniListIfy
//
//  Created by צחי רואש on 02/12/2024.
//
import Firebase
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("configure firebase")

    return true
  }
}




@main
struct AniListIfyApp: App {
    @StateObject private var myListViewMode = MyListViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
                    .environmentObject(myListViewMode)
            }
        }
    }
}
