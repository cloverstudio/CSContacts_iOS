//
//  PhoneContacts.swift
//  ContactSync
//
//  Created by Vedran on 25/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import Contacts
import RxContacts
import RxSwift
import RxCocoa

enum PhoneContactsError: Error {
    case noContactPermission
}

class DeviceContacts {
    
    static let kContactStatusPrompted = "contact_access_prompted"
    
    private let store = CNContactStore.init()
    
    // MARK: Fetch Phone Contacts in background
    class func contactsWhenAccessGranted(forStore store: CNContactStore?) -> Single<[CNContact]> {
        return Single.create{ observable in
            DispatchQueue.global(qos: .userInitiated).async {
                print("Fetching Contacts")
                var contacts = [CNContact]()
                let keys = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey
                    ] as [Any]
                let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
                do {
                    try store?.enumerateContacts(with: request){
                        (contact, stop) in
                        // Array containing all unified contacts from everywhere
                        contacts.append(contact)
                    }
                } catch {
                    print("unable to fetch contacts")
                    observable(.error(PhoneContactsError.noContactPermission))
                }
                observable(.success(contacts))
            }
            
            return Disposables.create()
        }
    }
    
}


// MARK: Phone Contact Store Changes Triggers
extension DeviceContacts {
    
    // On Contact Permission granted / denies
    class func accessChangedTrigger(forStore store: CNContactStore) -> Observable<Bool> {
        let access = self.acces(store: store)
        return access
            .debug("\(String(describing: self.self)) Access Changed", trimOutput: true)
            .share()
    }
    
    private class func acces(store: CNContactStore) -> Observable<Bool> {
        guard !UserDefaults.standard.bool(forKey: kContactStatusPrompted) else {
            return Observable.create{ observer in
                observer.onNext(CNContactStore.authorizationStatus(for: .contacts) == .authorized)
                return Disposables.create()
            }
        }
        UserDefaults.standard.set(true, forKey: kContactStatusPrompted)
        return store.rx.requestAccess(for: CNEntityType.contacts)
    }
    
    // On Contact In Phonebook changed
    class func storeChangedTrigger(forStore store: CNContactStore) -> Observable<Bool> {
        return store
            .rx
            .didChange()
            .throttle(20.0, latest: false, scheduler: MainScheduler.instance)
            .debug("\(String(describing: self.self)) Contact Store Changed", trimOutput: true)
            .map{ _ in true }
    }
}



