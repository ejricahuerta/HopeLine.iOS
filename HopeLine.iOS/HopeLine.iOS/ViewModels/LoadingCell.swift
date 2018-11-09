//
//  LoadingCell.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-09.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func setUp(title : String ,desc : String){
        self.titleLabel.text = title
        self.descLabel.text = desc
    }
}
