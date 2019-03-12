//
//  TouristSitesForSelectedCityTableViewController.swift
//  CityTourism-Backendless
//
//  Created by Michael Rogers on 9/15/18.
//  Copyright © 2018 Michael Rogers. All rights reserved.
//

import UIKit

class TouristSitesForSelectedCityTableViewController: UITableViewController {
    
    var touristBureau:TouristBureau!
    var selectedCity:City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touristBureau = TouristBureau.touristBureau
        // we will be notified when a .TouristSitesForSelectedCityReloded notification is posted
        // and we will then invoke 
        NotificationCenter.default.addObserver(self, selector: #selector(touristSitesForSelectedCityRetrieved), name: .TouristSitesForSelectedCityRetrieved, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let startDate = Date()
        //touristBureau.reloadTouristSitesForSelectedCity()
        self.navigationItem.title = touristBureau.selectedCity?.name!
        touristBureau.retrieveTouristSitesForSelectedCityAsynchronously()
        tableView.reloadData()
        
        print("Done in \(Date().timeIntervalSince(startDate)) seconds ")
    }
    
     // when the model reports that our local version of touristSites has been retrieved, this will be called. This lets us work asynchronously
      @objc func touristSitesForSelectedCityRetrieved() {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return touristBureau.numTouristSitesForSelectedCity()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "touristSiteCell", for: indexPath)
        
        // Configure the cell...
        
        let touristSite = touristBureau.touristSitesForSelectedCity[indexPath.row]
        cell.textLabel?.text = touristSite.name
        cell.detailTextLabel?.text = "\(touristSite.admissionFee)"
        
        return cell
    }
    
  
    // MARK: - Navigation
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Tourist Site Details"
        {        let touristSiteDetailsVC = segue.destination as! TouristSiteDetailsViewController
            
            touristSiteDetailsVC.touristSite =  touristBureau.touristSitesForSelectedCity[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
}
