//
//  RealmHandler.swift
//  ContactSync
//
//  Created by Vedran on 01/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class RealmHandler {
    
    // MARK: Realm Configuration
    
    class var realmConfiguration: Realm.Configuration {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("contacts.realm")
        
        var config = Realm.Configuration.init()
        config.fileURL = url
        
        return config
    }
    
    class var realm: Realm? {
        return try? Realm(configuration: self.realmConfiguration)
    }
    
    // MARK: Methods for Saving / Fetching Contacts form Realm store
    
    class func saveToDatabase(_ phoneContacts: [PhoneContactsReal]) {
        guard let realm = self.realm else { return }
        print("Realm - Saving to Database")
        try? realm.write {
            realm.deleteAll()
            realm.add(phoneContacts)
        }
    }
    
    class func getObjectsFromDatabase() -> Single<[PhoneContact]> {
        return Single.create(subscribe: { observer in
            print("Realm - Reading Database")
            guard let realm = self.realm else {
                observer(.success([]))
                return Disposables.create()
            }
            let objects = Array(realm.objects(PhoneContactsReal.self)).map { $0.toPhoneContact() }
            observer(.success(objects))
            return Disposables.create()
        })
    }
    
}



