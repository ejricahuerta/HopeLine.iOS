//
//  HomeCell.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-10.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(title : String , desc : String, url : String ,color : UIColor)  {
        let img : UIImage?
        titleLabel.text = title
        descLabel.text = desc
        self.layer.masksToBounds = true
        descLabel.backgroundColor = color
        //self.layer.backgroundColor = color.cgColor
            //color.cgColor
        self.layer.cornerRadius = 8
        
        
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
       
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
