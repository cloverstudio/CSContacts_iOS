//
//  PhoneContact.swift
//  ContactSync
//
//  Created by Vedran on 26/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import Contacts

public class PhoneContact {
    
    public let phoneNumbers:[String]?
    public let name:String?
    public let serverId:String?
    public let phoneIdentifier:String
    public var email:String?
    
    public var isFavourite = false
    
    public init(phoneIdentifier: String, serverId: String, name: String, email: String?, phoneNumbers: [String]?) {
        self.phoneIdentifier = phoneIdentifier
        self.serverId = serverId
        self.name = name
        self.phoneNumbers = phoneNumbers
        self.isFavourite = true
    }
    
    public convenience init?(fromUserData data: [String : Any], phoneId: String) {
        guard let id = data["_id"] as? String,
            let phoneNumber = data["phoneNumber"] as? String,
            let name = data["name"] as? String else {
                return nil
        }
        self.init(phoneIdentifier: phoneId,
                  serverId: id, name: name,
                  email: nil,
                  phoneNumbers: [phoneNumber])
    }
    
    public convenience init?(contact: CNContact, data: [String : Any]) {
        guard let serverId = data["_id"] as? String,
        let phoneNumber = data["phoneNumber"] as? String else {
            return nil
        }
        
        self.init(phoneIdentifier: contact.identifier,
                  serverId: serverId,
                  name: contact.singleStringName(),
                  email: contact.emailAddresses.first?.value as String?,
                  phoneNumbers: [phoneNumber])
    }
    
    func toRealmObject() -> PhoneContactsReal {
        return PhoneContactsReal(withPhoneContact: self)
    }
    
}

extension PhoneContact: Equatable {
    public static func == (lhs: PhoneContact, rhs: PhoneContact) -> Bool {
        return lhs.phoneIdentifier == rhs.phoneIdentifier && lhs.serverId == rhs.serverId
    }
}


