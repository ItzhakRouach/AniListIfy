//
//  LoginViewModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 02/12/2024.
// Hold the logic and handle the connection of user into firebase database and auth.

import Foundation
import FirebaseAuth

//Create a class name LoginViewModel to be of type ObservableObject so we can use it inside our Login View.
class LoginViewModel: ObservableObject {
    @Published var email: String = ""   // default set to empty string , hold the user email adresse
    @Published var password: String = "" // default set to empty string , hold the user password
    @Published var errorMessage: String = "" // default set to empty , will hold error message that may be  while try to sign in
    @Published var isSignin: Bool = false
    
    init() {}
    
    
    //Func to Handle Sign in of user.
    func signIn() {
        
        //use guard to make sure that validate is true if not then return.(mean do not processe the sign in function)
        guard validate() else { return }
        
        //Use FireBase Auth fuction to sign in the user with his email and password.
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in // use weak self to prevent memory leak
            // if while try to sign in was an error then show the user that cann't sign in and print to console the reason .
            if let error = error{
                DispatchQueue.main.async {
                    self?.errorMessage = "Cann't Sign In"
                    print("Error signing in: \(error.localizedDescription)")
                }
                return
            }
            // If succsess to sign in then print it into the console else print faild to sign in.
            if let user = Auth.auth().currentUser {
                print("Sign in Successful: \(user.uid)")
                self?.isSignin = true
            }else{
                print("Sign in faild!")
            }
            //After 3 sec reaset the error message variable.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.errorMessage = ""
            }
        }
        
    }
    
    // Func To Validate the information the user enter inside the form fields(email and password).
    func validate() -> Bool {
        //make sure that the email and the password are not empty if it is then set the error message to "Please enter a username and password".
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty ,!password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a username and password"
            return false
        }
        //Make sure tha the password its at least 8 charcter length else tell the user "Password must be at least 8 characters long"
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters long"
            return false
        }
        
        //Make sure the email field is contain @ and . else tell the user "Email Is Not Valid"
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Email Is Not Valid"
            return false
        }
        return true
    }
    
 

    
}
