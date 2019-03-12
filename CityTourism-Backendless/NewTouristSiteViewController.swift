//
//  NewTouristSiteViewController.swift
//  CityTourism-Backendless
//
//  Created by Michael Rogers on 10/23/18.
//  Copyright © 2018 Michael Rogers. All rights reserved.
//

import UIKit

class NewTouristSiteViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var admissionFeeTF: UITextField!
    
    let touristBureau = TouristBureau.touristBureau
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        touristBureau.saveTouristSiteForSelectedCity(touristSite: TouristSite(name: nameTF.text!, admissionFee: Double(admissionFeeTF.text!)))
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
