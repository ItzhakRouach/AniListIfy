//
//  MainView.swift
//  AniListIfy
//
//  Created by צחי רואש on 03/12/2024.
// Description: This file is to check if the user sign in then show him the app pages if not then he need first to sign in

import SwiftUI


struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var selectedTab: Int = 0 // use to shift between the tabs
   
    
    var body: some View {
        //First check if the user is sign in if it is then show him the tabs
        if viewModel.isSignedIn(), !viewModel.currentUserId.isEmpty {
            TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                        .tabItem{
                            Image(systemName: "house")
                            Text("House")
                            
                        }
                    ListView()
                        .tag(1)
                        .tabItem{
                            Image(systemName: "tray.circle")
                            Text("My List")
                        }
                    ProfileView()
                        .tag(2)
                        .tabItem{
                            Image(systemName: "person")
                            Text("Profile")
                        }
            }
            //Use Animations and transtions for more clean look.
            .transition(.move(edge: .leading))
            .animation(.easeInOut(duration:0.4), value:selectedTab)
        }else{
            LoginView()
                .transition(.slide.animation(.easeInOut(duration: 0.3)))
                
        }
    }
}

#Preview {
    MainView()
        .environmentObject(MyListViewModel())
}


