//
//  ListView.swift
//  AniListIfy
//
//  Created by צחי רואש on 09/12/2024.
//  Description: This file contain the UI for User Anime list 

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listviewModel:MyListViewModel
    var body: some View {
        ZStack {
            
            Image("list")
                .resizable()
                .ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
            
            
            
            VStack{
                TitleView(size: 60, kerning: 5)
                
                CountAnimesView()
                
                if listviewModel.userAnimeList.isEmpty {
                    Text("No Anime Added to Your List Yet.")
                        .foregroundColor(.gray)
                        .padding()
                }else{
                    ScrollView {
                        LazyVStack {
                            ForEach(Array(listviewModel.userAnimeList.enumerated()) , id: \.element.id){ index , anime in
                                HStack(spacing:5){

                                    Text("\(index + 1)")
                                        .font(.custom("Paul Jackson", size: 20))
                                        .foregroundStyle(.black)
                                    
                                    
                                    AsyncImage(url: URL(string: anime.imageURL)){ image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .shadow(color: .black.opacity(0.2), radius: 5 , x:0 , y:3)
                                    } placeholder:{
                                        ProgressView()
                                            .tint(.black)
                                            .controlSize(.large)
                                    }
                                    .padding()
                                    
                                    VStack(alignment: .leading){
                                        Text(anime.name)
                                            .font(.headline)
                                            .foregroundStyle(.black)
                                            .lineLimit(1)
                                            .padding(.leading , -5)
                                            .padding(.trailing , 30)
                                        
                                        Text("Rating: \(anime.rating , specifier: "%.1f")")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding(.leading,-5)
                                            .padding(.trailing,30)
                                        HStack{
                                            ForEach(0...Int(anime.rating/2), id:\.self){ _ in
                                                Image(systemName: "star.fill")
                                                    .resizable()
                                                    .frame(width:10 ,height:10)
                                                    .foregroundStyle(.yellow)
                                            }
                                            
                                            if Int(anime.rating)%2 != 0{
                                                Image(systemName: "star.leadinghalf.filled")
                                                    .resizable()
                                                    .frame(width:10 ,height:10)
                                                    .foregroundStyle(.yellow)
                                                
                                            }
                                        }
                                        
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                    Button{
                                        if let index = listviewModel.userAnimeList.firstIndex(where: { $0.id == anime.id }){
                                            let indexSet  = IndexSet(integer: index)
                                            listviewModel.removeAnime(at: indexSet)
                                        }
                                    }label: {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width:20 , height:20)
                                            .foregroundStyle(.red)
                                    }
                                }
                                .padding(.vertical,2)
                                .padding(.horizontal,10)
                                .background(Color.white.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                .frame(maxWidth:.infinity)
                                .shadow(radius: 10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }.onAppear{
                listviewModel.fetchAnimeList()
            }
        }
    }
}

#Preview {
    ListView()
        .environmentObject(MyListViewModel())
    
}

struct CountAnimesView: View {
    @EnvironmentObject var listviewModel: MyListViewModel
    var body: some View {
        Text("Total Anime: \(listviewModel.userAnimeList.count)")
            .font(.custom("Paul Jackson", size: 30))
            .kerning(5)
            .foregroundStyle(.black)
            .padding()
    }
}
