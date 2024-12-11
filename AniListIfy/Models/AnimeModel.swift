//
//  AnimeModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 09/12/2024.
//  Description: ANIME MODEL , this file contain the model of anime item.

import Foundation


struct Anime: Identifiable , Codable {
    let id:String //each anime get uid
    let name:String // name of the anime
    let description:String // description of the anime
    let rating:Double // rating of the anime
    let imageURL :String // image of the anime
    var isAdded: Bool = false // bool to check if anime added to the list.
    
    
    init(id:String = UUID().uuidString ,name:String , description:String , rating:Double  , imageURL:String , isAdded:Bool){
        self.id = id
        self.name = name
        self.description = description
        self.rating = rating
        self.imageURL = imageURL
        self.isAdded = isAdded
    }
    
}
