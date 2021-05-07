//
//  FavoriteDAO.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-05.
//

import Foundation
import CoreData

class FavoriteDAO { 
    init() {
        
    }
    let context = DbContext.shared.persistentContainer.viewContext
    func add(email: String, road: Road) {
        var newFavorite: Favorite
        
        if let favorite = getFavoriteByEmail(email: email) {
            newFavorite = favorite
        } else {
            newFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context) as! Favorite
            newFavorite.setValue(email, forKey: "email")
        }
        
        newFavorite.addToRoads(road)
        
        do {
            try context.save()
            print("New Favorite added")
        } catch  {
            print("Error while adding")
        }
    }
    
    func getFavorites() -> [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let Favorites = try context.fetch(request)
            return Favorites as [Favorite]
        } catch {
            print("error while fetching")
        }
        
        print("No data in Favorite entity")
        return []
    }
    
    func getFavoriteByEmail(email: String) -> Favorite? {
        for favorite in getFavorites() {
            if (favorite.email == email) {
                return favorite
            }
        }
        return nil
    }
    
    func getRoadsByEmail(email: String) -> [Road]? {
        return getFavoriteByEmail(email: email)?.roads?.allObjects as? [Road]
    }
    
    func remove(email: String, road: Road) {
        print(road.title!)
        getFavoriteByEmail(email: email)?.removeFromRoads(road)
        do {
            try context.save()
            print("Favorite road removed")
        } catch {
            print("error while deleting")
        }
    }
}
