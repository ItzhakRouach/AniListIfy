//
//  RegisterViewModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 03/12/2024.
//  Description: this file hold the logic to create an user and register him to app database by using firebase.

import Foundation
import FirebaseAuth
import FirebaseFirestore


//Create a class name RegisterViewmodel and make it ObservableObject so we can use it in register View
class RegisterViewModel: ObservableObject {
    @Published var username: String = ""   //hold the user username
    @Published var password: String = ""    //hold the user password
    @Published var confirmPassword: String = "" // hold user confrrim password made to check if the user sure about its password
    @Published var email: String = ""   // hold the user email
    @Published var errorMessage = "" // hold any error that may be will try to register into our app.

    
    
    init(){
        
    }
    
    
    //Function to sign up into the app.
    func SignUp() {
        //make sure that the information the user enter are valid if not then dont execute the function.
        guard validate() else { return }
        //USE firebase Auth to create user and pass user email and user passeord
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in // use weak self to prevent memory leak
            guard let self = self,
            let userId = result?.user.uid else { return } //create userId that hold the result that return from the function if register like its should then rhe result should ne user.uid if not then return.
            
            //Handle error that may be and set the error message to the massege the user will get and print the error to the console.
            
            if let error = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    self.errorMessage = "Cannt Register"
                    print(error.localizedDescription)
                }
                return
            }
            //if successe then use InsertUserRecord to put inside firebase database
            self.insertUserRecord(id: userId)
            DispatchQueue.main.async {
                self.errorMessage = ""
            }
        }
    }
    
    //create a model for a user and insert it into the database.
    private func insertUserRecord(id: String){
        //crreate a newUser that hold the user deatailes.
        let newUser = User(id: id,
                           username: username,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        //create db as var that conect into firebase firestore mean into our app database
        let db = Firestore.firestore()
        
        //create a collection name "users" to hold all the users of the app
        db.collection("users")
            //make sure that each  document of user have a id that identify him.
            .document(id)
            // set data with the user data , use extantion 'asDicctionart' to store its like should be.
            .setData(newUser.asDictionary())
    }
    
    
    
    
    //Validate That all fields are fill as required .
    private func validate() -> Bool {
        //Make sure no filed is empty else show the user "Please fill in all fields"
        guard !username.isEmpty || !password.isEmpty || !confirmPassword.isEmpty || !email.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        //Make sure the passwords are the same else show the user "Passwords do not match"
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return false
        }
        
        //Make sure the email is valid else "Invalid email address"
        guard email.contains("@") , email.contains(".") else {
            errorMessage = "Invalid email address"
            return false
        }
        //Make sure there is no spaces inside the password else show "Password cannot contain spaces"
        guard !password.contains(" ") else {
            errorMessage = "Password cannot contain spaces"
            return false
        }
        //Make sure the password is at least 8 character length  else show "Password must be at least 8 characters long"
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters long"
            return false
        }
        
        //Make sure the usename length is at least 4 else show errorMessage = "Username must be at least 4 characters long"
        guard username.count >= 4 else {
            errorMessage = "Username must be at least 4 characters long"
            return false
        }
        return true
    }
}
