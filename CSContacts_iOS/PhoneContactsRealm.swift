//
//  PhoneContactsRealm.swift
//  ContactSync
//
//  Created by Vedran on 01/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import RealmSwift

class PhoneContactsReal: Object {
    
    override static func primaryKey() -> String? {
        return "serverId"
    }
    
    @objc dynamic var phoneNumbers: String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var serverId:String = ""
    @objc dynamic var phoneIdentifier:String = ""
    @objc dynamic var email:String = ""
    
    convenience init(withPhoneContact phoneContact: PhoneContact) {
        self.init()
        self.name = phoneContact.name ?? ""
        self.serverId = phoneContact.serverId ?? ""
        self.phoneIdentifier = phoneContact.phoneIdentifier
        self.email = phoneContact.email ?? ""
        
        if let phoneNumbers = phoneContact.phoneNumbers {
            self.phoneNumbers = phoneNumbers.reducePhoneNumbersToString()
        }
    }
    
    func toPhoneContact() -> PhoneContact {
        let contact = PhoneContact(phoneIdentifier: self.phoneIdentifier,
                            serverId: self.serverId,
                            name: self.name,
                            email: self.email,
                            phoneNumbers: self.phoneNumbers.toPhoneNumbersArray())
        contact.isFavourite = true
        return contact
    }
    
}




