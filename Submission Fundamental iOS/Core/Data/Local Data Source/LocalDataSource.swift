//
//  LocalDataSource.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 11/08/23.
//

import Foundation
import Combine
import RealmSwift

protocol LocalDataSourceProtocol {
    func getVideoGames() -> AnyPublisher<[VideoGameEntity], Error>
    func getVideoGame(by id: Int) -> AnyPublisher<VideoGameEntity?, Error>
    func addVideoGame(from videoGame: VideoGameEntity) -> AnyPublisher<Bool, Error>
    func deleteVideoGame(by id: Int) -> AnyPublisher<Bool, Error>
}

final class LocalDataSource: LocalDataSourceProtocol {
    
    private let realm: Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> LocalDataSource = { realmDatabase in
        return LocalDataSource(realm: realmDatabase)
    }
    
    func getVideoGames() -> AnyPublisher<[VideoGameEntity], Error> {
        return Future<[VideoGameEntity], Error> { completion in
            if let realm = self.realm {
                let videoGame = realm.objects(VideoGameEntity.self).sorted(byKeyPath: "id").toArray(ofType: VideoGameEntity.self)
                completion(.success(videoGame))
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func getVideoGame(by id: Int) -> AnyPublisher<VideoGameEntity?, Error> {
        return Future<VideoGameEntity?, Error> { completion in
            if let realm = self.realm {
                let videoGame = realm.object(ofType: VideoGameEntity.self, forPrimaryKey: id)
                if let videoGame = videoGame {
                    completion(.success(videoGame))
                } else {
                    completion(.success(nil))
                }
                
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func addVideoGame(from videoGame: VideoGameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        realm.add(videoGame, update: .all)
                        completion(.success(true))
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteVideoGame(by id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let realm = self.realm {
                do {
                    try realm.write {
                        if let videoGameCache = realm.object(ofType: VideoGameEntity.self, forPrimaryKey: id) {
                            realm.delete(videoGameCache)
                            completion(.success(true))
                        } else {
                            completion(.success(true))
                        }
                    }
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
}

extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
    
}
