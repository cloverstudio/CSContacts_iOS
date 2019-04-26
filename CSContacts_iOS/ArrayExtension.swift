//
//  ArrayExtension.swift
//  ContactSync
//
//  Created by Vedran on 25/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import Contacts


extension Sequence where Iterator.Element == String {
    public func reducePhoneNumbersToString() -> String {
        return self.reduce("") { result, string in
            if result.isEmpty {
                return result + string
            }
            return result + "," + string
            }.replacingOccurrences(of: " ", with: "")
    }
}

extension Array where Element: CNContact {
    public func getPhoneNumbers() -> [String] {
        return self.reduce([], { result, contacts -> [String] in
            result + contacts.phoneNumbers.getStringNumbers()
        })
    }
}

extension Array where Element: CNLabeledValue<CNPhoneNumber> {
    public func getStringNumbers () -> [String] {
        let characterSet = CharacterSet(charactersIn: "+01234567890").inverted
        return self.map{ $0.value.stringValue.components(separatedBy: characterSet).joined(separator: "") }
    }
}


