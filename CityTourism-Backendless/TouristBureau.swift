//
//  TouristBureau.swift
//  CityTourism-Backendless
//
//  Created by Michael Rogers on 9/15/18.
//  Copyright © 2018 Michael Rogers. All rights reserved.
//

import Foundation


// This extension is necessary for our Notifications mechanism
extension Notification.Name {
    static let CitiesRetrieved = Notification.Name("Cities Retrieved")
    static let TouristSitesForSelectedCityRetrieved = Notification.Name("Tourist Sites for Selected City Retrieved")
    static let TouristSitesRetrieved = Notification.Name("Tourist Sites Retrieved")
}

// TouristBureau is our model class
// It stores all the cities
// It can also work with a selected city, to get tourist sites for it

class TouristBureau {
    
    let backendless = Backendless.sharedInstance()!
    var cityDataStore:IDataStore!
    var touristSitesDataStore:IDataStore!
    static var touristBureau:TouristBureau = TouristBureau() // our singleton
    
    var cities:[City] =  []              // all cities in our model
    var touristSites:[TouristSite] = []  // all tourist sites. Currently unused ...

    subscript(index:Int) -> City {      // now we can write sharedInstance[j] to retrieve the jth City
        return cities[index]
    }
    
    var selectedCity:City?                              // the city that we selected in CitiesTableViewController and will display tourist sites for
    var touristSitesForSelectedCity:[TouristSite] = [] // tourist sites for our selected city
    
    private init(){
        cityDataStore = backendless.data.of(City.self)                  // our connections to Backendless tables
        touristSitesDataStore = backendless.data.of(TouristSite.self)
    }
    
    // returns: # of cities
    func numCities() -> Int {
        return cities.count     //return cityDataStore.getObjectCount().intValue would
    }
    
    // returns: # of tourist sites
    func numTouristSites() -> Int {
        return touristSites.count
    }
    
    // returns: # of tourist sites for selected city
    func numTouristSitesForSelectedCity() -> Int {
        return touristSitesForSelectedCity.count
    }
    
    // Methods for fetching cities and tourist sites
    
    // fetches all cities and their tourist sites, storing results in cities
    func retrieveAllCities() {
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setRelated(["touristSites"])      // TouristSites referenced in City's touristSites property will be retrieved for each City
        queryBuilder!.setPageSize(100)                  // up to 100 TouristSites can be retrieved for each City)
        
        Types.tryblock({() -> Void in
            self.cities = self.cityDataStore.find(queryBuilder) as! [City]
            
        },
        catchblock: {(fault) -> Void in print(fault ?? "Something has gone wrong  reloadingAllCities()")}
        )
        
    }
    
    // fetch all cities and their tourist sites asychronously, storing results in cities
    func retrieveAllCitiesAsynchronously() {
        let queryBuilder = DataQueryBuilder()
        queryBuilder!.setRelated(["touristSites"]) // TouristSites referenced in City's touristSites                                             // field will be retrieved for each City
        queryBuilder!.setPageSize(100) // up to 100 TouristSites can be retrieved for each City
        cityDataStore.find(queryBuilder, response: {(results) -> Void in
            self.cities = results as! [City]
            NotificationCenter.default.post(name: .CitiesRetrieved, object: nil) // broadcast a Notification that Cities have been retrieved
        }, error: {(exception) -> Void in
            print(exception.debugDescription)
        })
        
    }
    
    // fetches all tourist sites storing results in touristsites
    func retrieveAllTouristSites() {
        
        Types.tryblock({() -> Void in self.touristSites = self.touristSitesDataStore.find() as! [TouristSite]}, catchblock: {(fault) -> Void in print(fault ?? "Something has gone wrong when retrievingAllTouristSites()")})
        
    }
    
    
    // fetch all tourist sites, storing results in touristSites
    func retrieveAllTouristSitesAsynchronously() {
        let startDate = Date()
        
        touristSitesDataStore.find({
            (retrievedTouristSites) -> Void in
            self.touristSites = retrievedTouristSites as! [TouristSite]
            NotificationCenter.default.post(name: .TouristSitesRetrieved, object: nil) // broadcast a Notification that tourist sites have been retrieved

        },
                           error: {(exception) -> Void in
                            print(exception.debugDescription)
        })
        print("Done in \(Date().timeIntervalSince(startDate)) seconds ")
    }

    // fetches TouristSites for selected city and reloads touristSitesForSelectedCity
    func retrieveTouristSitesForSelectedCity() {
        let startDate = Date()
        
        Types.tryblock( {
            let queryBuilder:DataQueryBuilder = DataQueryBuilder()
            queryBuilder.setWhereClause("name = '\(self.selectedCity?.name! ?? "")'" ) // fetch that one City
            queryBuilder.setPageSize(100)
            queryBuilder.setRelated( ["touristSites"] )
            let result = self.cityDataStore.find(queryBuilder) as! [City] // query returns an array, but we will only have 1 element
            self.touristSitesForSelectedCity = result[0].touristSites     // now we have all its touristSites
            NotificationCenter.default.post(name: .TouristSitesForSelectedCityRetrieved, object: nil) // broadcast a Notification that tourist sites have been retrieved
        },
                        catchblock: {(exception) -> Void in
                            print("Oopsie retrieving tourist sites for selected city -- \(exception.debugDescription)")
        })
        print("Done in \(Date().timeIntervalSince(startDate)) seconds ")
    }
    
    
    // fetches TouristSites for selected city and reloads touristSitesForSelectedCity
    func retrieveTouristSitesForSelectedCityAsynchronously() {
        let startDate = Date()
        
        let queryBuilder:DataQueryBuilder = DataQueryBuilder()
        queryBuilder.setWhereClause("name = '\(self.selectedCity?.name! ?? "")'" ) // restrict ourselves to one city
        queryBuilder.setPageSize(100)
        queryBuilder.setRelated( ["touristSites"] )
        self.cityDataStore.find(queryBuilder,
                                response: {(results) -> Void in
                                    let city = results![0] as! City
                                    self.touristSitesForSelectedCity = city.touristSites
                                    NotificationCenter.default.post(name: .TouristSitesForSelectedCityRetrieved, object: nil) // broadcast the fact that tourist sites for selected city have been retrieved
        }, error: {(exception) -> Void in
            print(exception.debugDescription)
        })
        print("Done in \(Date().timeIntervalSince(startDate)) seconds ")
    }
    
    
    // Methods for saving cities and tourist sites
    
    // creates a City, saves it both locally and in the data store
    func saveCity(named name:String, population:Int) {
        
        //
        var cityToSave = City(name: name, population: population, touristSites: [])
        cityToSave = cityDataStore.save(cityToSave) as! City // so our local version, in cities, has the objectId filled in
        cities.append(cityToSave)
        
        //
    }
    
    // creates a City, saves it both locally and in the data store
    func saveCityAsynchronously(named name:String, population:Int) {
        
        //
        
        var cityToSave = City(name: name, population: population, touristSites: [])
        cityDataStore.save(cityToSave, response: {(result) -> Void in
            cityToSave = result as! City
            self.cities.append(cityToSave)
            self.retrieveAllCitiesAsynchronously()},
                           error:{(exception) -> Void in
                            print(exception.debugDescription)
                            
        })
        
        //
    }
    
    
    // saves a (new) tourist site for the selected city
    func saveTouristSiteForSelectedCity(touristSite:TouristSite) {
        print("Saving the tourist site for the selected city...")
        let startingDate = Date()
        Types.tryblock({
            let savedTouristSite = self.touristSitesDataStore.save(touristSite) as! TouristSite // save one of its TouristSites
            self.cityDataStore.addRelation("touristSites:TouristSite:n", parentObjectId: self.selectedCity!.objectId, childObjects: [savedTouristSite.objectId!])
            
        }, catchblock:{ (exception) -> Void in
            print(exception.debugDescription)
        })
        
        print("Done!! in \(Date().timeIntervalSince(startingDate)) seconds")
    }
    
    
    // Methods for deleting ... pending
    
    func removeCity(objectId:String){
        
    }
    
    

    
}
