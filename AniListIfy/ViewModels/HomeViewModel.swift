//
//  HomeViewModel.swift
//  AniListIfy
//
//  Created by צחי רואש on 09/12/2024.
//  Descriptiom: thisn file contain the logic for the home view , connection to Jikan API and fetching data from it

import Foundation
import Combine

// class name homeViewMoedel of observableObject to be used in home view
class HomeViewModel:ObservableObject {
    @Published var animeList:[Anime]=[] // initilize list of type Anime (model : AnimeModel )
    @Published var searchText:String="" // hold the anime the user search for
    @Published var errorMessage:String="" // hold any error that may occure during the search and fetching result
    @Published var isError:Bool = false
    
    
    init(){}
    
    private var cancellables = Set<AnyCancellable>()
    
    //Function to fetch from Jikan API the anime the user search for.
    func searchAnime(){
        //make sure the query handle correctly.
        guard let query = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  ,
        //store the API url inside var call 'url' to use throgh the call.
        let url = URL(string: "https://api.jikan.moe/v4/anime?q=\(query)") else {
            errorMessage = "Invalid Search Querey"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for:url)
            .map(\.data)
            .handleEvents(receiveOutput : {data in
                print("Response:  \(String(data: data, encoding: .utf8) ?? "No Data")")
            })
            //decode the data recived intop model of JikanRepone we created in folder 'Models'
            .decode(type: JikanRespone.self , decoder: JSONDecoder())
            .map { response in
                response.data.map{ anime in
                    //set each data from 'anime' into his correct variable
                    Anime(
                          name: anime.title,
                          description: anime.synopsis ?? "No Description Available",
                          rating: anime.score ?? 0.0,
                          imageURL: anime.images.jpg.image_url ?? "",
                          isAdded: false)
                }
            }
            .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        //check if failure the let the user know and print the error to console for debugg(to see why).
                        if case .failure(let error) = completion {
                            self?.errorMessage = "Failed To Fetch Anime"
                            print(error.localizedDescription)
                            self?.showError()
                        }
                    }, receiveValue: { [weak self] animeList in
                        //first check if the recive value we got(we call it 'animeList') is empty
                        //if it empty then handle it and let the user know and if not store in animeList.
                        if animeList.isEmpty {
                            self?.errorMessage = "No results found for '\(self?.searchText ?? "")'"
                            self?.showError()
                        } else {
                            self?.animeList = animeList
                        }
                    })
                    .store(in: &cancellables)
            }
    
    //func to handle error , let us to after showing the user the error to reset the error message .
    func showError(){
        if !errorMessage.isEmpty{
            isError = true
            DispatchQueue.main.asyncAfter(deadline: .now()+3){[weak self] in
                self?.isError = false
                self?.errorMessage = ""
                
            }
        }
        
    }
}
