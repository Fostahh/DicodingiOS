//
//  Injection.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 01/08/23.
//

import RealmSwift

final class Injection {
    
    private func provideRepository() -> GameRepositoryProtocol {
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        
        let realm = try? Realm()
        let local: LocalDataSource = LocalDataSource.sharedInstance(realm)
        
        return GameRepository.sharedInstance(remote, local)
    }
    
    func provideHome() -> HomeUseCase {
        let repository = provideRepository()
        return HomeInteractor(repository: repository)
    }
    
    func provideDetail() -> DetailUseCase {
        let repository = provideRepository()
        return DetailInteractor(repository: repository)
    }
    
    func provideFavorite() -> FavoriteUseCase {
        let repo = provideRepository()
        return FavoriteInteractor(repository: repo)
    }
    
}
