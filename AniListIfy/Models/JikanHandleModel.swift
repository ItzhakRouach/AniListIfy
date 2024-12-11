//
//  JikanHandleModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 09/12/2024.
//  Description : this file handle the Respone we will get from Jikan API

import Foundation

struct JikanRespone: Decodable{
    let data: [JikanAnime] // data will be a list of type JikanAnime
}

struct JikanAnime: Decodable{
    let title: String //Title of the anime
    let synopsis: String? // Synopsis/description of the anime
    let score: Double? // Score/Rating of the anime
    let images: ImageURLs //Image of the anime
}

    // Set imageUrl  struct
struct ImageURLs: Decodable{
    let jpg : JPG
}

 // Set JPG as image url of type string
struct JPG: Decodable{
    let image_url: String?
}
