//
//  FavoriteViewModel.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 02/04/23.
//

import Foundation

class FavoriteViewModel {
    
    // MARK: Public Properties
    var loadingObservable: Observer<Bool>?
    var gamesObservable: Observer<[VideoGame]>?
    var errorObservable: Observer<String>?
    
    // MARK: Private Properties
    private lazy var videoGameProvider: VideoGameProvider = { return VideoGameProvider() }()
    private var videoGames: [VideoGame] = []
    
    func retrieveGames() {
        loadingObservable?(true)
        videoGameProvider.getListVideoGame { [weak self] videoGames in
            DispatchQueue.main.async {
                self?.loadingObservable?(false)
                self?.videoGames = videoGames
                if videoGames.isEmpty {
                    self?.errorObservable?("You don't have favorite video games")
                } else {
                    self?.gamesObservable?(videoGames)
                }
            }
        }
    }
    
    func getVideoGamesSize() -> Int {
        videoGames.count
    }
    
    func getVideoGame(indexPath: Int) -> VideoGame {
        videoGames[indexPath]
    }
}
