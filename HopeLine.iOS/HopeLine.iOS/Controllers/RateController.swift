//
//  RateController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-12.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

protocol ViewDismiss : class{
    func didRate(isDone : Bool) -> Void
}

class RateController: UIViewController {

     var  dismissDelegate : ViewDismiss?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func imgTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.dismissDelegate?.didRate(isDone: true)
        }

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
