//
//  MainController.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-01.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    var datafetcher : DataFetcher?
    let nameService  = NameGeneratorService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor  = primarybg
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
