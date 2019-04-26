//
//  ContactsFromApiImporter.swift
//  ContactSync
//
//  Created by Vedran on 26/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import Contacts

class ContactsFromApiImporter {
    
    /*
     Method responcible for Determining which Phone contacts are present on the Server.
     Returns PhoneContact by combining data from the Phone Contacts store and information from
     the server, such as serverId.
     */
    class func importContactsFromApi(phoneContacts: [CNContact], apiContactData: [[String : Any]]) -> [PhoneContact] {
        guard !apiContactData.isEmpty else { return [] }
        
        var retArray = [PhoneContact]()
        
        for apiCntc in apiContactData {
            guard let phoneNumber = apiCntc["phoneNumber"] as? String else { continue }
            
            guard let matchingContact = (phoneContacts.filter{ $0.phoneNumbers.getStringNumbers().contains(phoneNumber) }).first,
                let retContact = PhoneContact(contact: matchingContact, data: apiCntc) else {
                    continue
            }
            
            retContact.email = matchingContact.emailAddresses.first?.value as String?
            retArray.append(retContact)
        }
        
        return retArray
    }
    
}


