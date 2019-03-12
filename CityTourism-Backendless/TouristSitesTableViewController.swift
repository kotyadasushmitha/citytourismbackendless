//
//  TouristSitesTableViewController.swift
//  CityTourism-Backendless
//
//  Created by Michael Rogers on 9/15/18.
//  Copyright © 2018 Michael Rogers. All rights reserved.
//

import UIKit

// This is the TVC for all tourist sites
class TouristSitesTableViewController: UITableViewController {

    var touristBureau:TouristBureau!

    override func viewDidLoad() {
        super.viewDidLoad()

        touristBureau = TouristBureau.touristBureau // our model -- storing it in a local variable so we don't always have to keep writing TouristBureau.touristBureau :-)
    
    // We will be notified when a .CitiesReloaded notification is posted
    // and the citiesReloaded() method will be triggered
    // this is how we can handle asynchronous retrieval in our model
    NotificationCenter.default.addObserver(self, selector: #selector(touristSitesRetrieved), name: .TouristSitesRetrieved, object: nil)
    
}

override func viewWillAppear(_ animated: Bool) {
    touristBureau.retrieveAllTouristSites()
    tableView.reloadData()
}


// when the model reports that our local version of touristSites has been retrieved, this will be called. This lets us work asynchronously
@objc func touristSitesRetrieved(){
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
        return touristBureau.numTouristSites()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "touristSiteCell", for: indexPath)
        
        let touristSite = touristBureau.touristSites[indexPath.row]
        cell.textLabel?.text = touristSite.name
        cell.detailTextLabel?.text = String(format:"$%.2f",touristSite.admissionFee)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
