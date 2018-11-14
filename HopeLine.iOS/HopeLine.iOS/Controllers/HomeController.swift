//
//  HomeController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-10.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let colors = [color1, color2, color3, color4, color5]
    @IBOutlet weak var header: UIView!
    let bgImages = [#imageLiteral(resourceName: "lemur-760502-unsplash"),#imageLiteral(resourceName: "nick-tree-726418-unsplash"),#imageLiteral(resourceName: "chuttersnap-648746-unsplash"),#imageLiteral(resourceName: "cesar-couto-420982-unsplash"),#imageLiteral(resourceName: "malte-wingen-1074787-unsplash"),#imageLiteral(resourceName: "john-westrock-657181-unsplash"),#imageLiteral(resourceName: "nick-tree-726418-unsplash"),#imageLiteral(resourceName: "alex-eckermann-1098322-unsplash"),#imageLiteral(resourceName: "pawel-czerwinski-1056851-unsplash"),#imageLiteral(resourceName: "isak-combrinck-1141670-unsplash")]
    let titles = ["Communities", "Resources"]
    var communities = NSMutableArray()
    var resources = NSMutableArray()
    var datafetcher : DataFetcher?
    

    @IBOutlet weak var talktoMentorButton: PrimaryButton!
    @IBOutlet weak var connectionInfo: UILabel!
    @IBOutlet weak var loadingInfo: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var talkToMentorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingInfo.startAnimating()
        self.loadingInfo.hidesWhenStopped = true
        //headerView.layer.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "sebastian-muller-52-unsplash")).cgColor
        headerView.layer.cornerRadius = 8
        datafetcher = DataFetcher()
        
        for title in titles {
            datafetcher?.GetData(forAction: title, handler: { (response) in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.items?.forEach({ (item) in
                            item.isEnabled = false
                        })
                        self.talktoMentorButton.isEnabled = false
                        self.connectionInfo.backgroundColor = UIColor.red
                        self.connectionInfo.text = "Unable to Connect to HopeLine."
                        self.loadingInfo.stopAnimating()

                    }

                case .success(let data):
                    self.loadingInfo.isHidden = true
                    self.populateList(forlist: title ,data: data  as! [NSDictionary])
                }
            })
        }
    }

    @IBAction func homeButtonTapped(_ sender: PrimaryButton) {
        self.tabBarController?.selectedIndex = 2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titles.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        //1
//        switch kind {
//        //2
//        case UICollectionElementKindSectionHeader:
//            //3
//            var headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                             withReuseIdentifier: "homeHeader",
//                                                                             for: indexPath)
//            headerView = titles[(indexPath as NSIndexPath).section]
//            return headerView
//        default:
//            //4
//            assert(false, "Unexpected element kind")
//        }
//    }

    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var row = 0
        if section == 0 {
            row =  communities.count
        }
        if section == 1 {
                 row =  resources.count
      }
       return row
    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let title = titles[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCell
        
                //let color = UIColor(patternImage: bgImages[Int(arc4random_uniform(UInt32(bgImages.count)))])
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        if title == titles[0] {
                let community = communities[indexPath.row] as! Community
                cell.setUp(title: community.name!, desc: community.desc!,url: community.imgUrl!, color : color)
            }
        else {
            let resource = resources[indexPath.row] as! Resource
            cell.setUp(title: resource.name!, desc: resource.desc!, url : resource.imgUrl!, color: color)
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                let community = Community(id: item.value(forKey: "id") as? Int, name: item.value(forKey: "name") as! String, desc: item.value(forKey:"description") as! String, url: item.value(forKey: "url") as! String, img: item.value(forKey: "imageURL") as! String)
                print(community.name!)
                communities.add(community)
            }
            else {
                let resource = Resource(id: item.value(forKey: "id") as! Int, name: item.value(forKey: "name") as! String, desc: item.value(forKey:"description") as! String, url: item.value(forKey: "url") as! String, img: item.value(forKey: "imageURL") as! String)
                print(resource.name!)
                resources.add(resource)
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }
}


//    func numberOfSections(in tableView: UITableView) -> Int {
//        return titles.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var row = 0
//        if section == 0 {
//            row =  communities.count
//        }
//
//        if section == 1 {
//            row =  resources.count
//        }
//        return row
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let title = titles[indexPath.section]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
//
//        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//        if title == titles[0] {
//            let community = communities[indexPath.row] as! Community
//            cell.setUp(title: community.name!, desc: community.desc!, color : color)
//        }
//        else {
//            let resource = resources[indexPath.row] as! Resource
//            cell.setUp(title: resource.name!, desc: resource.desc!, color: color)
//            }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return titles[section]
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            let community = communities.object(at: indexPath.row) as! Community
//            let url = URL(string: community.url!)
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        }
//        else {
//            let resource = resources.object(at: indexPath.row) as! Resource
//            let url = URL(string: resource.url!)
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        }
//    }
//
