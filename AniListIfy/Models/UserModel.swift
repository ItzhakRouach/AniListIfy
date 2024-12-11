//
//  UserModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 02/12/2024.
//  Description: This file contain the user model.

import Foundation


struct User:  Codable {
    let id: String  //Each user have an id
    let username: String    // user user-name.
    let email: String   // user email.
    let joined: TimeInterval // when the user register.
}
