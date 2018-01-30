//
//  DataManager.swift
//  Gratitude
//
//  Created by Heather Martin on 12/11/17.
//  Copyright © 2017 Heather Martin. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class gratitude
{
    var id: Int16?
    var datestamp: Date?
    var note: String?
    
    init(){}
    
    init(inId: Int16, inDatestamp: Date, inNote: String)
    {
        id = inId
        datestamp = inDatestamp
        note = inNote
    }
}

class DataManager
{
    
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = self.appDelegate.persistentContainer.viewContext
    }
    
    //check and see if any grats were created before the date sent in
    func tooManyGrats(deletedate: Date) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
        let predicate = NSPredicate(format: "datestamp < %@", deletedate as CVarArg)
        request.predicate = predicate
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 { return true }
        } catch {
        print(error)
        }
        return false
    }
    
    
    func deleteGratsLaterThan(date: Date) -> [gratitude] {
        var gratArray:[gratitude] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
        let predicate = NSPredicate(format: "datestamp < %@", date as CVarArg)
        request.predicate = predicate
        
        let sectionSortDescriptor = NSSortDescriptor(key: "datestamp", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for data in result as! [NSManagedObject] {
                    let grat = gratitude()
                    grat.id = data.value(forKey: "id") as? Int16
                    grat.datestamp = data.value(forKey: "datestamp") as? Date
                    grat.note = data.value(forKey: "note") as? String
                    deleteGrat(inGratId: grat.id!)
                    gratArray.append(grat)
                }
            }
        } catch {
            print(error)
        }
        return gratArray
    }
    
    //add a new grat 
    func createGrat(inNote: String, today: Bool){
        let maxId = getMaxId(entity: "Grat")
        var date = Date()
        if !today {
            date = NSCalendar.current.date(byAdding: Calendar.Component.day, value: -1, to: Date())!
        }
        
        let newGrat = NSEntityDescription.insertNewObject(forEntityName: "Grat", into: context) as! Grat
        newGrat.setValue(maxId, forKey: "id")
        newGrat.setValue(inNote, forKey: "note")
        newGrat.setValue(date, forKey: "datestamp")

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func createTestGratByDate(inDate: Date){
        let maxId = getMaxId(entity: "Grat")
        let newGrat = NSEntityDescription.insertNewObject(forEntityName: "Grat", into: context) as! Grat
        newGrat.setValue(maxId, forKey: "id")
        newGrat.setValue("test", forKey: "note")
        newGrat.setValue(inDate, forKey: "datestamp")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    //update grat note
    func updateGrat(inGratitude: gratitude){
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
            fetchRequest.predicate = NSPredicate(format: "id == %@", String(inGratitude.id!))
            
            if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0 {
                    let managedObject = fetchResults[0]
                    managedObject.setValue(inGratitude.note, forKey: "note")
                }
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    //delete a grat based on its id
    func deleteGrat(inGratId: Int16){
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
        deleteFetch.predicate = NSPredicate(format: "id == %@", String(inGratId))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print (error)
        }
    }
    
    //get all
    func getAllGrats() -> [gratitude] {
        var gratArray:[gratitude] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "datestamp", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for data in result as! [NSManagedObject] {
                    let grat = gratitude()
                    grat.id = data.value(forKey: "id") as? Int16
                    grat.datestamp = data.value(forKey: "datestamp") as? Date
                    grat.note = data.value(forKey: "note") as? String
                    gratArray.append(grat)
                }
            }
        } catch {
            print(error)
        }
        return gratArray
    }
    
    //get grats based on month
    //0 = this month, 1 = last month, 2 = last 3 months
    func getGratsByMonth(monthSelection: Int) -> [gratitude] {
        var gratArray:[gratitude] = []
        var date = Date()
        if (monthSelection == 0) {  //current month
            let components = Calendar.current.dateComponents([.year, .month], from: Date())
            date = Calendar.current.date(from: components)!
        } else if (monthSelection == 1) {  //last month
            let component:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) as NSDateComponents
            component.month -= 1
            date = Calendar.current.date(from: component as DateComponents)!
        } else if (monthSelection == 2) {   //last 3 months
            let component3:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: Date()) as NSDateComponents
            component3.month -= 3
            date = Calendar.current.date(from: component3 as DateComponents)!
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
        let predicate = NSPredicate(format: "datestamp > %@", date as CVarArg)
        request.predicate = predicate
        
        let sectionSortDescriptor = NSSortDescriptor(key: "datestamp", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for data in result as! [NSManagedObject] {
                    let grat = gratitude()
                    grat.id = data.value(forKey: "id") as? Int16
                    grat.datestamp = data.value(forKey: "datestamp") as? Date
                    grat.note = data.value(forKey: "note") as? String
                    gratArray.append(grat)
                }
            }
        } catch {
            print(error)
        }
        return gratArray
    }
    
    
    //get all based on date
    func getAllGratsByDate(inDate: Date) -> [gratitude] {
        var gratArray:[gratitude] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Grat")
        request.predicate = NSPredicate(format: "datestamp == %@", inDate as CVarArg)

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for data in result as! [NSManagedObject] {
                    let grat = gratitude()
                    grat.id = data.value(forKey: "id") as? Int16
                    grat.datestamp = data.value(forKey: "datestamp") as? Date
                    grat.note = data.value(forKey: "note") as? String
                    gratArray.append(grat)
                }
            }
        } catch {
            print(error)
        }
        return gratArray
    }
    
    func getMaxId(entity: String) -> Int16 {
        var id:Int16 = 0
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let sort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                let grat = result.first as! NSManagedObject
                id = (grat.value(forKey: "id") as? Int16)! + 1
            }
            
        } catch {
            print(error)
        }
        return id
    }
    
}
