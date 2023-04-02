//
//  VideoGameProvider.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 02/04/23.
//

import CoreData

class VideoGameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataContainer")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(String(describing: error))")
            }
            
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getIsVideoGameFavorited(id: Int, completion: @escaping (Bool) -> Void) {
        let taskContext = newTaskContext()

        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DetailVideoGameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            do {
                let game = try taskContext.fetch(fetchRequest).first
                completion(game != nil)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteVideoGame(id: Int, completion: @escaping () -> Void) {
        let taskContext = newTaskContext()
        
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DetailVideoGameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
    
    func getListVideoGame(completion: @escaping(_ videoGames: [VideoGame]) -> Void) {
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DetailVideoGameEntity")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var videoGames: [VideoGame] = []
                for result in results {
                    let videoGame = VideoGame(
                        id: result.value(forKeyPath: "id") as! Int,
                        name: result.value(forKeyPath: "name") as! String,
                        released: result.value(forKeyPath: "released") as! String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as! String,
                        rating: result.value(forKeyPath: "rating") as! Double
                    )
                    
                    videoGames.append(videoGame)
                }
                completion(videoGames)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getDetailVideoGame(id: Int, completion: @escaping (DetailVideoGame) -> Void) {
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DetailVideoGameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    
                    let esrbRatingEntity = result.value(forKeyPath: "esrbRating") as! Set<ESRBRatingEntity>
                    
                    var genres = [Genre]()
                    let genresEntity = result.value(forKeyPath: "genres") as! Set<GenreEntity>
                    for genreEntity in genresEntity {
                        genres.append(Genre(id: Int(genreEntity.id), name: genreEntity.name!))
                    }
                    
                    var developers = [Developer]()
                    let developersEntity = result.value(forKeyPath: "developers") as! Set<DeveloperEntity>
                    for developerEntity in developersEntity {
                        developers.append(Developer(id: Int(developerEntity.id), name: developerEntity.name!))
                    }
                    
                    let detailVideoGame = DetailVideoGame(
                        id: result.value(forKeyPath: "id") as! Int,
                        name: result.value(forKeyPath: "name") as! String,
                        description: result.value(forKeyPath: "desc") as! String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as! String,
                        released: result.value(forKeyPath: "released") as! String,
                        backgroundImageAdditional: result.value(forKeyPath: "backgroundImageAdditional") as! String,
                        rating: result.value(forKeyPath: "rating") as! Double,
                        esrbRating: ESRBRating(
                            id: Int(esrbRatingEntity.first!.id),
                            name: esrbRatingEntity.first!.name!
                        ),
                        genres: genres,
                        developers: developers
                    )
                    completion(detailVideoGame)
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addVideoGame(videoGame: DetailVideoGame, completion: @escaping () -> Void) {
        let taskContext = newTaskContext()

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DetailVideoGameEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(videoGame.id)")
        
        let game = try? taskContext.fetch(fetchRequest).first
        
        if game == nil {
            if let entity = NSEntityDescription.entity(forEntityName: "DetailVideoGameEntity", in: taskContext) {
                let detailVideoGameEntity = NSManagedObject(entity: entity, insertInto: taskContext) as! DetailVideoGameEntity
                
                detailVideoGameEntity.setValue(videoGame.id, forKey: "id")
                detailVideoGameEntity.setValue(videoGame.name, forKey: "name")
                detailVideoGameEntity.setValue(videoGame.description, forKey: "desc")
                detailVideoGameEntity.setValue(videoGame.backgroundImage, forKey: "backgroundImage")
                detailVideoGameEntity.setValue(videoGame.released, forKey: "released")
                detailVideoGameEntity.setValue(videoGame.backgroundImageAdditional, forKey: "backgroundImageAdditional")
                detailVideoGameEntity.setValue(videoGame.rating, forKey: "rating")
                
                // Add Genres
                for genre in videoGame.genres {
                    self.createGenre(videoGameEntity: detailVideoGameEntity, genre: genre, context: taskContext)
                }
                
                // Add Developers
                for developer in videoGame.developers {
                    self.createDeveloper(videoGameEntity: detailVideoGameEntity, developer: developer, context: taskContext)
                }
                
                // Add ESRB Rating
                self.createESRBRating(videoGameEntity: detailVideoGameEntity, esrbRating: videoGame.esrbRating, context: taskContext)
                
            }
            
            do {
                try taskContext.save()
                completion()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            completion()
        }
    }
    
    private func createGenre(videoGameEntity: DetailVideoGameEntity, genre: Genre, context: NSManagedObjectContext) {
        let genreEntity = GenreEntity(context: context)
        genreEntity.id = Int32(genre.id)
        genreEntity.name = genre.name
        
        videoGameEntity.addToGenres(genreEntity)
    }
    
    private func createDeveloper(videoGameEntity: DetailVideoGameEntity, developer: Developer, context: NSManagedObjectContext) {
        let developerEntity = DeveloperEntity(context: context)
        developerEntity.id = Int32(developer.id)
        developerEntity.name = developer.name
        
        videoGameEntity.addToDevelopers(developerEntity)
    }
    
    private func createESRBRating(videoGameEntity: DetailVideoGameEntity, esrbRating: ESRBRating, context: NSManagedObjectContext) {
        let esrbRatingEntity = ESRBRatingEntity(context: context)
        esrbRatingEntity.id = Int32(esrbRating.id)
        esrbRatingEntity.name = esrbRating.name
        
        videoGameEntity.addToEsrbRating(esrbRatingEntity)
    }
    
//    func deleteAllVideoGame(completion: @escaping() -> Void) {
//        let taskContext = newTaskContext()
//        taskContext.perform {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DetailVideoGameEntity")
//            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            batchDeleteRequest.resultType = .resultTypeCount
//            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
//                if batchDeleteResult.result != nil {
//                    print("Delete all success")
//                    completion()
//                }
//            }
//        }
//    }
}
