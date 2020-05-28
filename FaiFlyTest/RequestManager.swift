
import Foundation
import SwiftyJSON

class RequesManager {
    static let shared = RequesManager()
    
    
    
    private let stringURL = "https://raw.githubusercontent.com/David-Haim/CountriesToCitiesJSON/master/countriesToCities.json"
    
    var dictOfCountriesAndCities = [String:[String]]()

    
    private init () {
        
    }
    
    
    func downloadData(completionHandler: @escaping () -> Void) {
        if let url = URL(string: stringURL){
            
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print (error)
                        //proceed error
                    } else {
                        
                        if let usableResponse = response as? HTTPURLResponse, usableResponse.statusCode == 200 {
                            
                            if let usableData = data {
                                self.serialiseJSONwiht(dowloadedData: usableData)
                                completionHandler()
                                
                                
                            } else {
                                //proceed bad data
                            }
                        } else {
                            // proceed bad response
                            //print(response)
                        }
                    }
                }
                
                task.resume()

            
        }else {
            //proceed Bad URL Case
        }
    }
    
    func serialiseJSONwiht(dowloadedData: Data) {
        
        if let json = try? JSON(data: dowloadedData) {
            dictOfCountriesAndCities = json.dictionaryObject as! [String : [String]]
            DispatchQueue.main.async {
                CoreDataManager.shared.saveReceivedData(dataDictionary: self.dictOfCountriesAndCities)
            }
           
        } else {
            //proceed incorrect json data
        }

    }
    
    
    
    func getDataFor(city: String, completionHandler: @escaping ([String])-> Void) {

        let baseStringURL = "http://api.geonames.org/wikipediaSearchJSON?"
        let maxRows = "10"
        let username = "anatol"
        
        let stringURL = baseStringURL+"q="+city+"&maxRows="+maxRows+"&username="+username
//        print(stringURL)
        if let url = URL(string: stringURL){
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print (error)
                    completionHandler([])
                    //proceed error
                } else {
                    
                    if let usableResponse = response as? HTTPURLResponse, usableResponse.statusCode == 200 {
                        
                        if let usableData = data {
                            if let json = try? JSON(data: usableData) {
                                if !json["geonames"].arrayValue.isEmpty {
                                    completionHandler([
                                        json["geonames"].arrayValue[0].dictionaryValue["summary"]!.stringValue,
                                        json["geonames"].arrayValue[0].dictionaryValue["lng"]!.stringValue,
                                        json["geonames"].arrayValue[0].dictionaryValue["lat"]!.stringValue
                                        ])
                                } else {
                                    completionHandler([])
                                }
                                
                            } else {
//                                print("bad JSON parsing")
                              completionHandler([])
                                
                            }
                            
                        } else {
//                            print("bad data")
                            completionHandler([])
                            //proceed bad data
                            
                        }
                    } else {
//                        print(response!)
                        completionHandler([])
                        // proceed bad response
                    }
                }
            }
            
            task.resume()
            
        }else {
//            print("bad URL")
            completionHandler([])
            //proceed Bad URL Case
        }

    }
    
    
    

}
