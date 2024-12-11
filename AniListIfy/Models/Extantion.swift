//
//  Extantion.swift
//  AniListIfy
//
//  Created by צחי רואש on 03/12/2024.
//  Description: this file contain an extantion that will be handy in seting the user data to our FirsStore Firebase.

import Foundation

//let as convorte the User model into a dictionary we can put inside our database.
extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try?JSONEncoder().encode(self) else {
            return [:]
        }
        do{
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        }catch{
            return [:]
        }
                
    }
}
