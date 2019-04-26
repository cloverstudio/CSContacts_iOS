//
//  CNContactExtension.swift
//  ContactSync
//
//  Created by Vedran on 29/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import Contacts

extension CNContact {
    
    public func singleStringName() -> String {
        var nameString = ""
        
        if !givenName.isEmpty {
            nameString += givenName
        }
        
        if !middleName.isEmpty {
            nameString += " \(middleName)"
        }
        
        if !familyName.isEmpty {
            nameString += " \(familyName)"
        }
        
        return nameString
    }
    
}


