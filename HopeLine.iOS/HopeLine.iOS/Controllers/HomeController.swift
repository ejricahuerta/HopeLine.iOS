//
//  HomeController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var datafetcher = DataFetcher()
    let  reuseIdentifier = "HomeCell"
    //Collection View
    var stringData = Array<String>()
    var viewTitle : String = "";
    
    let homeData = ["We're here to help you. Click the button below to speak to a mentor", " Our map page is a customized google map that provides geolocation,search functionality, and a custom search filter that would show the nearest hospitals, pharmacies, medical institutions, and doctors. ", " Community page is a collection of links to other organizations that provide a similar cause to ours which includes suicide hotlines, mental health awareness foundations, and other applications that are dedicated to imporving peoples lives. ", " Resources page is a collection of links to topics related to mental health or other life issues. If you want to learn more about the different types of information related about mental health and suicide then you can visit our resources page. "]
    
    let homeImages = [#imageLiteral(resourceName: "homechat"),#imageLiteral(resourceName: "homemap"),#imageLiteral(resourceName: "homecommunity"),#imageLiteral(resourceName: "homeweb")]
    let titles = ["Talk to Mentor Now", "Use our Map", "Join Commnunity", "Go to Resources"]
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
        
        cell.backgroundColor = UIColor(red: 111, green: 331, blue: 20, alpha: 1)
        cell.textView.text = self.homeData[indexPath.row]
        cell.homeImage.image = homeImages[indexPath.row]
        cell.cellButton.setTitle(titles[indexPath.row], for: .normal)
        cell.cellButton.tag = indexPath.row
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.contains("resourcesSegue"))! {
            let view  = segue.destination as! CommonResourcesView
            view.title = viewTitle
        }
    }

    
    @IBAction func cellButtonClicked(_ sender: SecondaryButton) {
        
        switch sender.titleLabel?.text {
        case titles[0]?:
            self.tabBarController?.selectedIndex = 2
            break
        case titles[1]?:
            self.tabBarController?.selectedIndex = 1
            break
        case titles[2]?:
            viewTitle = "communities"
            break
        case titles[3]?:
            viewTitle = "resources"
            break
        default:
            print("nothing here...")
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var uuid = NSUUID().uuidString
        uuid = String(uuid.prefix(8))
        print("ID:  \(uuid)" )
    }
    // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
