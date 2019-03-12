//
//  CitiesTableViewController.swift
//  CityTourism-Backendless
//
//  Created by Michael Rogers on 9/15/18.
//  Copyright © 2018 Michael Rogers. All rights reserved.
//

// https://cocoacasts.com/what-is-notification-name-and-how-to-use-it

import UIKit

// This is the TVC for all cities
class CitiesTableViewController: UITableViewController {

    var touristBureau:TouristBureau!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        touristBureau = TouristBureau.touristBureau // our model -- storing it in a local variable so we don't always have to keep writing TouristBureau.touristBureau :-)
        
        // We will be notified when a .CitiesRetrieved notification is posted
        // and the citiesRetrieved() method will be triggered
        // this is how we can handle asynchronous retrieval in our model
        NotificationCenter.default.addObserver(self, selector: #selector(citiesRetrieved), name: .CitiesRetrieved, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        touristBureau.retrieveAllCities()
        //touristBureau.retrieveAllCitiesAsynchronously() // this is faster ...
        tableView.reloadData()
    }
    
    
    // when the model reports that our local version of cities has been retrieved, this will be called. This lets us work asynchronously
    @objc func citiesRetrieved(){
        tableView.reloadData()
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return touristBureau.numCities()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        let city = touristBureau[indexPath.row]
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = "\(city.population)"

        return cell
    }
    
    // tapped on a row, so tell the tourist bureau that we've selected a city
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touristBureau.selectedCity = touristBureau[indexPath.row]
    }

}
