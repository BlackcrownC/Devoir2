//
//  SectorDAO.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-05.
//

import Foundation
import CoreData

class SectorDAO {
    init() {
        if (getSectors().count == 0) {
            add(title: "Rive Sud")
            add(title: "Rive Nord")
            add(title: "Montérigie")
            add(title: "Montréal")
            addRoad(sector: getSectors()[0], roadTitle: "Autoroute 40 Ouest", audio: "01.wav")
            addRoad(sector: getSectors()[0], roadTitle: "Autoroute 40 Est", audio: "02.wav")
            addRoad(sector: getSectors()[1], roadTitle: "Autoroute 15 Nord", audio: "01.wav")
            addRoad(sector: getSectors()[1], roadTitle: "Autoroute 15 Sud", audio: "02.wav")
            addRoad(sector: getSectors()[2], roadTitle: "Route 338", audio: "01.wav")
            addRoad(sector: getSectors()[2], roadTitle: "Chemin de la petite fermière de la grange d'à côté", audio: "02.wav")
            addRoad(sector: getSectors()[3], roadTitle: "Rue Sainte-Catherine", audio: "02.wav")
            addRoad(sector: getSectors()[3], roadTitle: "Échangeur Turcot", audio: "01.wav")
        }
        /*
        for sector in getSectors() {
            context.delete(sector)
            for road in sector.roads?.allObjects as! [Road] {
                context.delete(road)
            }
        }
        do {
            try context.save()
        } catch {}*/
    }
    
    let context = DbContext.shared.persistentContainer.viewContext
    
    func add(title: String) {
        let newSector = NSEntityDescription.insertNewObject(forEntityName: "Sector", into: context)
        
        newSector.setValue(title, forKey: "title")
        
        do {
            try context.save()
            print("New Sector added")
        } catch  {
            print("Error while adding")
        }
    }
    
    func getSectors() -> [Sector] {
        let request: NSFetchRequest<Sector> = Sector.fetchRequest()
        do {
            let sectors = try context.fetch(request)
            return sectors as [Sector]
        } catch {
            print("error while fetching")
        }
        
        print("No data in Sector entity")
        return []
    }
    
    func addRoad(sector: Sector, roadTitle: String, audio: String) {
        let newRoad = NSEntityDescription.insertNewObject(forEntityName: "Road", into: context)
        
        newRoad.setValue(roadTitle, forKey: "title")
        newRoad.setValue(audio, forKey: "audio")
        sector.addToRoads(newRoad as! Road)
        
        do {
            try context.save()
            print("New Sector added")
        } catch  {
            print("Error while adding")
        }
    }
}
