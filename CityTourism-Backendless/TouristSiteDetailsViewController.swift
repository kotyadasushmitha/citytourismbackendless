//
//  TouristSiteDetailsViewController.swift
//  CityTourism-Backendless
//
//  Created by Michael Rogers on 10/23/18.
//  Copyright © 2018 Michael Rogers. All rights reserved.
//

import UIKit

class TouristSiteDetailsViewController: UIViewController {

    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var admissionTF: UILabel!
    
    var touristSite:TouristSite!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = touristSite.name
        self.nameTF.text = touristSite.name
        self.admissionTF.text = String(format:"$%.2f",touristSite.admissionFee)
    }
    

}
