//
//  FeedTableViewCell.swift
//  WhereAtV2
//
//  Created by Katia Hajjar on 4/5/17.
//  Copyright © 2017 Katia Hajjar. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var statusUpdate: UILabel!
    
    @IBOutlet weak var meetupTitle: UILabel!
    
    @IBOutlet weak var Start: UILabel!
    
    @IBOutlet weak var End: UILabel!
    
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var Invitee: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
