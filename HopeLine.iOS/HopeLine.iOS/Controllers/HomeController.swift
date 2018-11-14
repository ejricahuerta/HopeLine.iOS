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
    var timer : Timer?
    var isReloading  = false
    
    @IBOutlet weak var loadingInfo: UIActivityIndicatorView!
    @IBOutlet weak var connectionLostImage: UIImageView!
    @IBOutlet weak var talktoMentorButton: PrimaryButton!
    @IBOutlet weak var connectionInfo: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var talkToMentorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode  = .always
        self.collectionView.autoresizesSubviews = true
        
        
        self.connectionLostImage.isHidden = true
        self.loadingInfo.startAnimating()
        self.loadingInfo.hidesWhenStopped = true
        //headerView.layer.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "sebastian-muller-52-unsplash")).cgColor
        headerView.layer.cornerRadius = 8
        headerView.layer.addBorder(edge: UIRectEdge.bottom, color: primarybg, thickness: 1)
        datafetcher = DataFetcher()
        Load()
    }

    @IBAction func reloadData(_ sender: UIBarButtonItem) {
        self.isReloading = true
        self.timer?.invalidate()
        self.connectionInfo.isHidden = false
        self.connectionInfo.text = "Reconnecting..."
        self.connectionInfo.backgroundColor = UIColor.lightGray
        self.connectionLostImage.isHidden = true
        self.loadingInfo.startAnimating()
        self.loadingInfo.isHidden = false
        self.Load()
        self.isReloading = false
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
        
//        let color = UIColor(patternImage: bgImages[Int(arc4random_uniform(UInt32(bgImages.count)))])
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
    func Load()
    {
        for title in titles {
            datafetcher?.GetData(forAction: title, handler: { (response) in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.items?.forEach({ (item) in
                            item.isEnabled = false
                        })
                        if self.communities.count == 0 && self.resources.count == 0 {
                            self.connectionLostImage.isHidden = false
                        }
                        self.talktoMentorButton.isEnabled = false
                        self.connectionInfo.backgroundColor = UIColor.red
                        self.connectionInfo.text = "Unable to Connect to HopeLine."
                        self.loadingInfo.stopAnimating()
                    }
                    
                case .success(let data):

                    DispatchQueue.main.async {
                        self.loadingInfo.isHidden = true
                        self.connectionLostImage.isHidden = true
                        self.talktoMentorButton.isEnabled = true
                        self.connectionInfo.backgroundColor = UIColor.green
                        self.connectionInfo.text = "Connected to HopeLine."
                        var counter = 0
                        self.timer  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                            if counter == 5   || self.isReloading {
                                self.connectionInfo.isHidden = true
                                timer.invalidate()

                            }
                            else {
                                counter += 1
                            }
                            print("Counter : \(counter)")
                        })
                        self.loadingInfo.stopAnimating()
                        self.tabBarController?.tabBar.items?.forEach({ (item) in
                            item.isEnabled = true
                        })
                        counter = 0
                    }
                    self.populateList(forlist: title ,data: data  as! [NSDictionary])
          
                }
            })
        }

    }
}

