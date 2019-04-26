//
//  DebugCell.swift
//  ContactSync
//
//  Created by Vedran on 15/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit

class DebugCell: UITableViewCell {

    static let kIdentifier = "Cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.textColor = .white
        self.textLabel?.isHidden = false
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
