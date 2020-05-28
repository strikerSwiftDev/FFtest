

import Foundation
import CoreData
import UIKit


class CountryEntity: NSManagedObject {
}

class CityEntity: NSManagedObject {
}

class CoreDataManager {
    static var shared = CoreDataManager()
    
    var viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    private init() {
        
    }
    
    
    func isCountryEntityExist(country: String) -> Bool {
        let request: NSFetchRequest<CountryEntity> = CountryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", country)
        
        var result = false
        do {
            let country = try viewContext.fetch(request)
            
            if country.count > 0 {
                result = true
            }
            
        } catch {
           
        }
        
        return result
    }
    
    
    
    
    func saveReceivedData(dataDictionary: [String: [String]]) {
        
        for countryName in dataDictionary.keys {
            
            if !countryName.isEmpty {
                if !isCountryEntityExist(country: countryName) {
                    let country = CountryEntity(context: viewContext)
                    country.name = countryName
                    country.id = UUID().uuidString
                    
                    if let cities = dataDictionary[countryName] {
                        for cityName in cities {
                            if !cityName.isEmpty {
                                let city = CityEntity(context: viewContext)
                                city.name = cityName
                                city.countryName = countryName
                                city.countryOwner = country
                                
                            }
                        }
                    }
                    
                }
                
                do {
                    
                    try viewContext.save()
                    
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                    
                
            }
                

        }
            
            
    }
    
    
    func getSavedCountriesArray() -> [String] {
        let request: NSFetchRequest<CountryEntity> = CountryEntity.fetchRequest()
        var result = [String]()
        
        do {
            let countries = try viewContext.fetch(request)
            
            for country in countries {
                if let name = country.name {
                    result.append(name)
                }
            }
            
        } catch {
//            throw error
        }
        
        return result
    }
    
    
    func getSavedCitiesArrayBy(country: String) -> [String] {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "countryName == %@", country)
        var result = [String]()
    
        do {
            let cities = try viewContext.fetch(request)
            
            for city in cities {
                if let cityName = city.name {
                    result.append(cityName)
                }
                
            }
           
            
        } catch {
//            throw error
        }
        
        return result
    }
    
    
    
}
