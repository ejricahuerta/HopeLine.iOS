//
//  CommonCell.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class CommonCell: UITableViewCell {

 

    @IBOutlet weak var commonTitle: UILabel!
    @IBOutlet weak var commonLink: UILabel!
    @IBOutlet weak var commonDescription: UITextView!
    @IBOutlet weak var commonImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
