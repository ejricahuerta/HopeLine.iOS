//
//  ChatCell.swift
//  HopeLine.iOS
//
//  Created by Edmel John Ricahuerta on 2018-11-07.
//  Copyright © 2018 prj. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    //     (220,241,230)


    @IBOutlet weak var msgBox: ChatText!
    
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layoutMargins = UIEdgeInsetsMake(8, 0, 8, 0)
        self.layer.cornerRadius = 8
        self.layer.backgroundColor  = UIColor(red: 220, green: 241, blue: 230, alpha: 1.0).cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUp(name : String , msg : String){
        userName.text = name
        msgBox.text = msg
    }

}
