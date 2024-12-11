//
//  RegisterView.swift
//  AniListIfy
//
//  Created by צחי רואש on 02/12/2024.
//  Description : this file handle the regerstion screen with a form to handle user Sign up .

import SwiftUI

// The main View of Regisertion.
struct RegisterView: View {
    
    //viewModel to handle user register logic.
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        ZStack{
            //a subview that handle the register cover image
            BackgroundView(imageName: "register")
            
            //Subview that handle the form background template
            FormTampleView(cornerRadius: 10, width: 350, height: 388, opacity: 0.6, shadowRadius: 10)
            
            VStack(spacing:10){
                Spacer()
                Text("AnilistIfy")
                    .font(.custom("Paul Jackson", size: 40))
                    .kerning(10)
                    .foregroundStyle(.black)
                
                
                //Check if there is error then show the user the error
                if !viewModel.errorMessage.isEmpty{
                    Text(viewModel.errorMessage)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                
                //store the user 'username' to viewModel.username
                TextField("", text: $viewModel.username,
                          prompt: Text("  User Name")
                    .foregroundColor(.black.opacity(0.4)))
                .frame(width:300 , height:40)
                .background(Color.white)
                .foregroundStyle(.black)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                //store the user 'password' to viewModel.password
                SecureField("", text: $viewModel.password,
                          prompt: Text("  Password")
                    .foregroundColor(.black.opacity(0.4)))
                .frame(width:300 , height:40)
                .background(Color.white)
                .foregroundStyle(.black)
                .cornerRadius(10)
                .shadow(radius: 10)
                //store the user 'password' to viewModel.confrimPassword use to check if the passwords are the same.
                SecureField("", text: $viewModel.confirmPassword,
                          prompt: Text("  Password Confirm")
                    .foregroundColor(.black.opacity(0.4)))
                .frame(width:300 , height:40)
                .background(Color.white)
                .foregroundStyle(.black)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                //Store the user 'Email' to viewModel.email.
                TextField("", text: $viewModel.username,
                          prompt: Text("  Email")
                    .foregroundColor(.black.opacity(0.4)))
                .frame(width:300 , height:40)
                .background(Color.white)
                .foregroundStyle(.black)
                .cornerRadius(10)
                .shadow(radius: 10)
                
                
                //Trigger the sign up Function.
                Button{
                    viewModel.SignUp()
                }label: {
                    //UI design for sign up button
                    Text("SIGN UP")
                        .font(.title2)
                        .padding()
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                //Use to push all to the center
                Spacer()

            }
        }
    }
}

#Preview {
    RegisterView()
}
