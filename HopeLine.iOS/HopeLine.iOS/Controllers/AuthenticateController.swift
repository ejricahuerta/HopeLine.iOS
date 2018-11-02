//
//  AuthenticateController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class AuthenticateController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var guestTextField: PrimaryText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textChanged(_ sender: PrimaryText) {
        if sender.text!.characters.count > 15 {
            sender.text!.characters.removeLast()
        }
    }
    
}
