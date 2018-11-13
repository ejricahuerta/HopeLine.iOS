//
//  RateController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-12.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class RateController: UIViewController {

    @IBOutlet weak var happyImg: UIImageView!
    @IBOutlet weak var sadImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func imgTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
