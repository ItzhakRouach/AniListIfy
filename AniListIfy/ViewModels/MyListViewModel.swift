//
//  MyListViewModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 09/12/2024.
//  Description: This file contain all the logic that will be used in our List View

import Foundation
import Firebase     //Import in order to connect to user db
import FirebaseAuth // import in order to make sure if user is conected or not



class MyListViewModel: ObservableObject {
    @Published var userAnimeList:[Anime] = [] //Make a list called userAnimeList of type Anime .
    private var db = Firestore.firestore()  //Make var called db that connect into our firestore firebase.
    
    
    //FUNCTION:
    
    //func that handle of adding animes into our list and updata the user database , take anime of type Anime as args.
    func addAnime(anime:Anime){
        //First create 'userId' var and check if current user is logged in if not then return form the function
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in")
            return
        }
        //check if the anime is already in the list and if not then added to the list and to the database
        if !userAnimeList.contains(where: {$0.name == anime.name}){
            userAnimeList.append(anime)
            let docRef = db.collection("users") //set docRef to connect into user Database animelist collection
                .document(userId)
                .collection("animeList").document(anime.id)
            
            //Set the anime information the user want to add to his list , to the user database.
            docRef.setData([
                "name":anime.name,
                "description":anime.description,
                "score":anime.rating,
                "image":anime.imageURL,
                "status":anime.isAdded
                
                //Handle error that may happend
            ]) {error in
                if let error = error{
                    print("Error adding anime to list \(error.localizedDescription)")//if failed print to the console - use for Debug
                }else{
                    print("Anime added to list") //if success print to the console - use for Debug
                }
            }
        }else{
            print("Anime already in list") //If already exist then print to the consle - use for Debug
            return
        }
    }
        
    
    
        
        
        
    
    //This function handle remove anime from the list and also from the database , make sure the list and the database are in sync
    func removeAnime(at offsets: IndexSet){
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in")
            return
        }
        
        let idtoRemove = offsets.map{ userAnimeList[$0].id}
        print("Attempting to remove IDs: \(idtoRemove)")
        for id in idtoRemove{
            db.collection("users")
                .document(userId)
                .collection("animeList")
                .document(id)
                .delete{[weak self] error in
                    if let error = error{
                        print("Error deleting Anime from firestore \(error.localizedDescription)")
                    }else{
                        print("Successfully deleted Anime with ID: \(id)")
                        DispatchQueue.main.async {
                            if let index = self?.userAnimeList.firstIndex(where: { $0.id == id }) {
                                print("Removing Anime from local list: \(self?.userAnimeList[index].name ?? "Unknown")")
                                self?.userAnimeList.remove(at: index)
                            }
                        }
                    }
                }
        }
    }
    
    
    //func that use in order to fetch the user anime list from the database.
    func fetchAnimeList(){
        //First create 'userId' var and check if current user is logged in if not then return form the function
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            return
        }
        
        //conect to user animelist in database
        let collectionRef = db.collection("users").document(userId).collection("animeList")
        collectionRef.getDocuments{ snapshot , error in
        //Handle error that may occure.
        if let error = error{
                print("Error fetching anime list \(error.localizedDescription)")
            return
        }else{
            guard let document =  snapshot?.documents else{
                print("No anime found")
                return
            }
            
            self.userAnimeList = document.compactMap{ doc -> Anime? in
                let data = doc.data()
                return Anime(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    rating: data["score"] as? Double ?? 0,
                    imageURL: data["image"] as? String ?? "",
                    isAdded: data["isAdded"] as? Bool ?? false
                )
            }
        }
            
        }
    }
    
}
