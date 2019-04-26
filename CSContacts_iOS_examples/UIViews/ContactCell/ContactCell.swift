//
//  ContactCell.swift
//  ContactSync
//
//  Created by Vedran on 26/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    static let identifier = "contact_cell_identifier"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var favouriteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emailLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setContact(_ contact: PhoneContact) {
        nameLabel.text = contact.name
        favouriteLabel.isHidden = !contact.isFavourite
        emailLabel.text = contact.email
        if let phoneNumbers = contact.phoneNumbers {
            phoneNumberLabel.text = phoneNumbers.reducePhoneNumbersToString().replacingOccurrences(of: ",", with: "\n")
        }
    }
    
}
