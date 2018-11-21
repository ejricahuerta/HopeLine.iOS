//
//  CallDetailController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-20.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class CallDetailController: UIViewController {

    var linkTitle : String?
    var callNumber : String?
    var ttyNumber : String?

    @IBOutlet weak var ttyCallBtn: SecondaryButton!
    @IBOutlet weak var callButton: SecondaryButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = linkTitle!

        callButton.setTitle(callNumber!, for: .normal)
        ttyCallBtn.setTitle(ttyNumber!, for: .normal)
    }
    @IBAction func callTapped(_ sender: SecondaryButton) {
        var title = sender.titleLabel?.text!
         title = title?.replacingOccurrences(of: "-", with: "")
        if (title?.contains("TTY"))! {
            title?.removeFirst(5)
            print(title!)
            let url = URL(string: "tel://\(title!)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        else {
            print(title!)
            let url = URL(string: "tel://\(title!)")
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        }
    }
}
