//
//  LoginView.swift
//  AniListIfy
//
//  Created by צחי רואש on 02/12/2024.
//  Description: This file contain the login screen with a form o handle user sign-in.

import SwiftUI


//The Main view for the login screen.
struct LoginView: View {
    
    //ViewModel to handle login logic.
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isSignin{
                    MainView()
                        .transition(.slide.animation(.easeInOut(duration: 4.5)))
                }else{
                    ZStack {
                        // A Subview that handle the login cover image .
                        BackgroundView(imageName: "login")
                        
                        
                        // Semi-transparent Card for the Login Form
                        FormTampleView(cornerRadius: 10, width: 350, height: 350, opacity: 0.8, shadowRadius: 10)
                        
                        //A subview that handles the login form UI and logic.
                        SignInFormView(viewModel: viewModel)
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut(duration: 4.5) , value: viewModel.isSignin)
    }
}






//SUBVIEWS:

// Bckground Image for  loginView.
struct BackgroundView: View {
    var imageName:String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}

//A View for the login form with email,password and sign in button.
struct SignInFormView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    
    var body: some View {
        VStack {
            Spacer()
            
            // Title
            Text("AniListIfy")
                .font(.custom("Paul Jackson", size: 40))
                .kerning(10)
                .fontWeight(.bold)
                .foregroundColor(.black)
                
            
            // Handle in case of error while try to login.
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Email TextField
            TextField("", text: $viewModel.email,
                      prompt: Text("  Email")
                .foregroundColor(.black.opacity(0.4)))
            .frame(width:300 , height:50)
            .background(Color.white)
            .foregroundStyle(.black)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            // Password SecureField
            SecureField("", text: $viewModel.password,
                      prompt: Text("  Password")
                .foregroundColor(.black.opacity(0.4)))
            .frame(width:300 , height:50)
            .background(Color.white)
            .foregroundStyle(.black)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            // Sign-In Button
            Button {
                //Trigger the fuction to sign in if got pressed
                viewModel.signIn()
            
            } label: {
                //UI design for sign in button
                Text("SIGN IN")
                    .font(.title2)
                    .bold()
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.top, 15)
            
            // Navigation Link for create an  acccount which Take the user to RegisterView.
            NavigationLink {
                RegisterView()
            } label: {
                //UI design for text that got pressed on to create an account.
                Text("Create an account")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FormTampleView: View {
    let cornerRadius:CGFloat
    let width:CGFloat
    let height:CGFloat
    let opacity:Double
    let shadowRadius:CGFloat
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.white)
            .frame(width: width, height: height)
            .opacity(opacity)
            .shadow(radius: shadowRadius)
    }
}
