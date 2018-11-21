//
//  TemporaryController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-20.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class TemporaryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    

    @IBOutlet weak var tableView: UITableView!
    var alert : UIAlertController?
    var contacts = ["Distress Centres of Toronto" : ["416-408-4357","TTY: 416-408-0007" ], "Gerstein Centre" : ["416-929-5200", "TTY: 416-929-9647"], "Senior Safety Line":["1-866-299-1011","TTY: N/A"], "ConnexOntario" : ["1-866-531-2600", "TTY: N/A"]]
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true;
        
        
        self.alert = UIAlertController(title: "Video/Audio Under Construction", message: "Our Video and Call Service is currently down. Please see all the alternatives.", preferredStyle: UIAlertControllerStyle.alert)
        self.alert?.addAction(UIAlertAction(title: "Go Back", style: .cancel, handler: {(action) in
            self.alert?.dismiss(animated: true, completion:nil)
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.alert?.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { (action) in
            self.alert?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert!, animated: true, completion: nil)
    }
    
    
    // open a list of more call hotlines
    @IBAction func moreTapped(_ sender: SecondaryButton) {
        let url = URL(string: "https://www.toronto.ca/311/knowledgebase/kb/docs/articles/311-toronto/information-and-business-development/crisis-lines-suicide-depression-telephone-support-lines-non-crisis-mental-health-services.html")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.contains("callDetailSegue"))! {
            let view = segue.destination as! CallDetailController
            let link  = Array(contacts)[(tableView.indexPathForSelectedRow?.row)!]
            view.linkTitle  = link.key
            view.callNumber = link.value[0]
            view.ttyNumber = link.value[1]
        }
    }
    //table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "callCell")!
        cell.textLabel?.text = Array(contacts)[indexPath.row].key
        let deet = Array(contacts)[indexPath.row].value.reduce("", { a, b in
            return "\(a) \(b)"
        })
        cell.detailTextLabel?.text = deet
        
        return cell
    }
    
}
