//
//  FeedCell.swift
//  TravellerStop
//
//  Created by HilalOruc on 20.08.2021.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var imgIV: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var explanationLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
