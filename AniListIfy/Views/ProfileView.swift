//
//  ProfileView.swift
//  AniListIfy
//
//  Created by צחי רואש on 03/12/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel =  ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                if let user = viewModel.user {
                    VStack{
                        Text("AniListify")
                            .font(.custom("Paul Jackson", size: 60))
                            .foregroundStyle(.black)
                            .kerning(5)
                            .padding()
                            .padding(.top,20)
                        VStack(spacing:5){
                            Spacer()
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Text(user.username)
                                .font(.custom("Paul Jackson", size: 42))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Email: \(user.email)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Since: \(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated ,time:.shortened))")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Button{
                                viewModel.logout()
                            }label: {
                                Text("Sign Out")
                                    .font(.headline)
                                    .padding()
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .background(Color.red)
                                    .cornerRadius(22)
                            }
                            .padding()
                            Spacer()
                        }
                    }
                }else{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .controlSize(.extraLarge)
                    
                }
            
            }
        }
        .onAppear(){
            viewModel.fetchUser()
        }
        
    }
}

#Preview{
    ProfileView()
}
