//
//  StringExtension.swift
//  ContactSync
//
//  Created by Vedran on 25/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit

extension String {
    
    public func toPhoneNumbersArray() -> [String] {
        let components = self.components(separatedBy: ",")
        return components
    }
    
}




