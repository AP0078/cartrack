//
//  MockDataHelper.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import CoreData

class MockDataHelper: MockProtocol {
    
    class var shared: MockDataHelper {
        struct Singleton {
            static let instance = MockDataHelper()
        }
        return Singleton.instance
    }
    fileprivate let  database: DatabaseManager = DatabaseManager.shared
    func fetchMockData(_ completion: @escaping (Bool) -> Void) {
        if getCountryList().isEmpty {
            //Read JSON file in seperate thread
            DispatchQueue.global(qos: .background).async {
                // read JSON file, parse JSON data
                self.processData(self.readCountryFile() as AnyObject?, completion: { (complete) in
                    self.processData(self.readUserFile() as AnyObject?, completion: { (complete) in
                        //Saved
                        completion(complete)
                    })
                })
            }
        } else {
             completion(true)
        }
    }
    func readCountryFile() -> [CountryElement]? {
        let dataSourceFilename: String = "country"
        let dataSourceFilenameExtension: String = "json"
        let filemgr = FileManager.default
        let currPath = Bundle.main.path(forResource: dataSourceFilename, ofType: dataSourceFilenameExtension)
        var jsonResult: [CountryElement]?
        
        do {
            let jsonData: Data = try! Data(contentsOf: URL(fileURLWithPath: currPath!))
            
            if filemgr.fileExists(atPath: currPath!) {
                jsonResult = try? JSONDecoder().decode(CountryJson.self, from: jsonData)
            } else {
                print("\(dataSourceFilename).\(dataSourceFilenameExtension)) does not exist, therefore cannot read JSON data.")
            }
        }
        return jsonResult
    }
    func readUserFile() -> [UserElement]? {
        let dataSourceFilename: String = "user"
        let dataSourceFilenameExtension: String = "json"
        let filemgr = FileManager.default
        let currPath = Bundle.main.path(forResource: dataSourceFilename, ofType: dataSourceFilenameExtension)
        var jsonResult: [UserElement]?
        
        do {
            let jsonData: Data = try! Data(contentsOf: URL(fileURLWithPath: currPath!))
            
            if filemgr.fileExists(atPath: currPath!) {
                jsonResult = try? JSONDecoder().decode(UserJson.self, from: jsonData)
            } else {
                print("\(dataSourceFilename).\(dataSourceFilenameExtension)) does not exist, therefore cannot read JSON data.")
            }
        }
        return jsonResult
    }
    func processData(_ jsonResult: AnyObject?, completion: @escaping (Bool) -> Void) {
        if let countryList = jsonResult as? [CountryElement] {
            self.saveCountryList(countryList, completion: completion)
        } else if let userList = jsonResult as? [UserElement] {
            self.saveUserList(userList, completion: completion)
        }
    }
    func saveCountryList(_ list: [CountryElement], completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            
            //Minion Context worker with Private Concurrency type.
            let minionManagedObjectContext: NSManagedObjectContext =
                NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            minionManagedObjectContext.parent = self.database.getMainContextInstance()
            
            for country in list {
                let item = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.country.rawValue,
                                                               into: minionManagedObjectContext) as! Country
                item.setValue(country.name, forKey: CountryAttributes.name.rawValue)
                item.setValue(country.flag, forKey: CountryAttributes.flag.rawValue)
                self.database.saveContext(minionManagedObjectContext)
            }
            //Save and merge changes from Minion workers with Main context
            self.database.mergeWithMainContext()
            completion(true)
        }
    }
    func saveUserList(_ list: [UserElement], completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            
            //Minion Context worker with Private Concurrency type.
            let minionManagedObjectContext: NSManagedObjectContext =
                NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            minionManagedObjectContext.parent = self.database.getMainContextInstance()
            
            for user in list {
                let item = NSEntityDescription.insertNewObject(forEntityName: EntityTypes.user.rawValue,
                                                               into: minionManagedObjectContext) as! User
                item.setValue(user.name, forKey: UserAttributes.name.rawValue)
                item.setValue(user.password, forKey: UserAttributes.password.rawValue)
                self.database.saveContext(minionManagedObjectContext)
            }
            //Save and merge changes from Minion workers with Main context
            self.database.mergeWithMainContext()
            completion(true)
        }
    }
    func validateUser(name: String, password: String, location: String ) -> Bool {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.user.rawValue)
        
        let findByUserPredicate = NSPredicate(format: "name = '\(name)' AND password = '\(password)'")
         fetchRequest.predicate = findByUserPredicate
        
        //Execute Fetch request
        var fetchedResults = [User]()
        do {
            fetchedResults = try self.database.getMainContextInstance().fetch(fetchRequest) as! [User]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDateInDateRange error: \(fetchError.localizedDescription)")
        }
        if fetchedResults.isEmpty {
            return false
        }
        return true
    }
    func getCountryList(_ sortAscending: Bool = true ) -> [Country] {
        return getCountryList("", sortAscending)
    }
    func getCountryList(_ name: String = "", _ sortAscending: Bool = true ) -> [Country] {
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.country.rawValue)
        
        //Create sort descriptor to sort retrieved Events by Date, ascending
        let sortDescriptor = NSSortDescriptor(key: CountryAttributes.name.rawValue,
                                              ascending: sortAscending)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        if !name.isEmpty, name != "" {
            let findByNamePredicate = NSPredicate(format: "name = '\(name)'")
            fetchRequest.predicate = findByNamePredicate
        }
        
        //Execute Fetch request
        var fetchedResults = [Country]()
        do {
            fetchedResults = try self.database.getMainContextInstance().fetch(fetchRequest) as! [Country]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDateInDateRange error: \(fetchError.localizedDescription)")
        }
        
        return fetchedResults
    }
    
    func update(user: User, location: String) {
        
        let context = self.database.getMainContextInstance()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityTypes.country.rawValue)
        let predicate = NSPredicate(format: "name = '\(location)'")
        fetchRequest.predicate = predicate
        do {
            let object = try context.fetch(fetchRequest)
            if object.count == 1 {
                let country = object.first as! Country
                country.addToUsers(user)
                user.setValue(country, forKey: UserAttributes.location.rawValue)
                do {
                    try context.save()
                }
                catch {
                    print(error)
                }
            }
        }
        catch {
            print(error)
        }
    }
}
