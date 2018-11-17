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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(name : String , msg : String, color : UIColor){
        msgBox.text = msg
        userName.textColor = color
        msgBox.layer.addBorder(edge: UIRectEdge.left, color: color, thickness: 5)

        if name.contains("Guest") {
            userName.text = "You"
        }
        else if name.contains("system") {
            userName.text = "Sys"
        }
        else {
            userName.text = "Mentor"
        }
       }

}

