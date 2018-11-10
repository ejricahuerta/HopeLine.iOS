//
//  HomeController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-10.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let titles = ["Communities", "Resources"]
    var communities = NSMutableArray()
    var resources = NSMutableArray()
    var datafetcher : DataFetcher?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var talkToMentorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        datafetcher = DataFetcher()
        
        for title in titles {
            datafetcher?.GetData(forAction: title, handler: { (response) in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    self.populateList(forlist: title ,data: data  as! [NSDictionary])
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        if section == 0 {
            row =  communities.count
        }
        
        if section == 1 {
            row =  resources.count
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = titles[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        
        cell.layer.backgroundColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
    
        

        if title == titles[0] {
            let community = communities[indexPath.row] as! Community
            cell.titleLabel.text = community.name
            cell.descLabel.text = community.desc
        }
        else {
            let resource = resources[indexPath.row] as! Resource
            cell.titleLabel.text = resource.name
            cell.descLabel.text = resource.desc
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let community = communities.object(at: indexPath.row) as! Community
            let url = URL(string: community.url!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        else {
            let resource = resources.object(at: indexPath.row) as! Resource
            let url = URL(string: resource.url!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    
    func populateList(forlist : String ,data : [NSDictionary]){
        for item in data {
            if forlist == titles[0] {
                let community = Community(id: item.value(forKey: "id") as? Int, name: item.value(forKey: "name") as! String, desc: item.value(forKey:"description") as! String, url: item.value(forKey: "url") as! String)
                print(community.name!)
                communities.add(community)
            }
            else {
                let resource = Resource(id: item.value(forKey: "id") as! Int, name: item.value(forKey: "name") as! String, desc: item.value(forKey:"description") as! String, url: item.value(forKey: "url") as! String)
                print(resource.name!)
                resources.add(resource)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
}
