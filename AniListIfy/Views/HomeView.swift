//
//  HomeView.swift
//  AniListIfy
//
//  Created by צחי רואש on 09/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel() //viewmodel to use search and fetch anime from api logic
    @EnvironmentObject var myListViewModel: MyListViewModel //mylistviewmodel to integrate with user anime list.
    var body: some View {
        
        ZStack {
            BackgroundView(imageName: "home") //Home background cover image
            //Handle search bar for the animes.
            VStack{
                    TitleView(size: 60, kerning: 5) //App Title Name
                HStack{
                    Spacer()
                    SearchBarTextView(viewModel: viewModel)
                        .padding(.leading,10)
                    SearchButtonView(viewModel: viewModel)
                    Spacer()
                }
                //If there is error message show them
                ShowErrorView(viewModel: viewModel)
                //check if the list of the user is empty and if it is then show the user the following message.
                ShowStartTrackView(viewModel: viewModel)
                //Scroll view to enable the user to look and after all the result that appeard from the user search.
                
                ScrollView{
                    LazyVStack{
                        ForEach(viewModel.animeList.indices , id:\.self) { index in
                            AnimeRowView(anime: $viewModel.animeList[index])
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MyListViewModel())
}


//SUBVIEWS:

struct TitleView: View {
    
    var size: CGFloat
    var kerning: CGFloat
    
    var body: some View {
        Text("AniListify")
            .font(.custom("Paul Jackson", size: size))
            .foregroundStyle(.black)
            .kerning(kerning)
            .fontWeight(.bold)
            .font(.largeTitle)
            .padding()
    }
}

struct SearchBarTextView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        TextField("", text: $viewModel.searchText,
                  prompt: Text("Search For Animes")
            .foregroundColor(.blue.opacity(0.5)))
        .padding(10)
        .frame(width: 300)
        .background(Color.white)
        .foregroundStyle(.black)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct SearchButtonView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        Button{
            //search anime
            viewModel.searchAnime()
        }label: {
            Text("Search")
                .font(.subheadline)
                .padding(.vertical , 10)
                .padding( . horizontal, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}

struct ShowErrorView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        if !viewModel.errorMessage.isEmpty{
            Text(viewModel.errorMessage)
                .foregroundColor(.red)
                .padding()
                .onAppear{
                    viewModel.showError() // clear the error after set time
                }
        }
        
        
    }
}


struct ShowStartTrackView: View{
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        if viewModel.animeList.isEmpty{
            Text("Start Tracking Your Animes")
                .padding()
                .foregroundStyle(.gray)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
        }
    }
}

struct AnimeRowView: View {
    
    @Binding var anime: Anime
    @EnvironmentObject var myListViewModel: MyListViewModel
    
    var body: some View {
        HStack (spacing: 5){
            AsyncImage(url: URL(string: anime.imageURL)){ image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color:.black.opacity(0.2), radius: 5 , x: 0 , y: 3)
            } placeholder:{
                ProgressView()
                    .tint(Color.black)
                    .controlSize(.large)
            }
            .padding()
            
            VStack(alignment: .leading){
                Text(anime.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(1)
                HStack{
                    Text("\(anime.rating , specifier: "%.1f")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    
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
                Text(anime.description)
                    .font(.body)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
            }
            .padding()
            Spacer()
            
            Button{
                if !myListViewModel.userAnimeList.contains(where: { $0.name == anime.name }){
                    myListViewModel.addAnime(anime: anime)
                    anime.isAdded = true
                }
            }label: {
                if anime.isAdded{
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width:30 , height: 30)
                        .padding(.horizontal , 10)
                        .padding(.vertical , 5)
                        .foregroundStyle(.green)
                }else{
                    Text("+")
                        .frame(width:30 , height: 30)
                        .padding(.horizontal , 10)
                        .padding(.vertical , 5)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2) , radius: 5 , x: 0 , y: 3)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth:390)
        .shadow(color: .black.opacity(0.1) , radius: 5 , x: 0 , y: 3)
    }
}
 
