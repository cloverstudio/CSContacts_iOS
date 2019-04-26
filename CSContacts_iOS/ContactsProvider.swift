//
//  ContactsProvider.swift
//  ContactSync
//
//  Created by Vedran on 27/03/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import RxSwift
import Contacts
import Reachability
import RxReachability

public class CSContactsProvider {
    
    // MARK: Public Variables
    public var contacts: Observable<[PhoneContact]>!
    public var statusUpdate:PublishSubject<String> = PublishSubject()
    
    public static let instance = CSContactsProvider()
    
    // MARK: Private Variables
    let store = CNContactStore()
    let bag = DisposeBag()
    var reachability: Reachability?
    private var url: URL?
    
    
    private let shouldUpdateContactsFlag: Variable<Bool> = Variable(true)
    private var onFetch: PublishSubject<Void> = PublishSubject()
    
    // MARK: Start The Module
    public func start(contactSyncUrl:URL) {
        if reachability == nil {
            reachability = Reachability()
            try? reachability?.startNotifier()
        }
        
        if contacts == nil {
            /* Triggering logic:
             1. The main trigger which combines reachability and the shouldUpdateContactsFlag.
             When reachable (has internet connection) the flat is returned, whether true or false
             */
            let initiateUpdate = reachability!
                .rx
                .isReachable
                .filter{ $0 }
                .flatMapLatest { [unowned self] _ in
                    return self.shouldUpdateContactsFlag.asObservable()
                }
                .debug("initiateUpdate:", trimOutput: true)
            
            /*
             Update Contacts Triggers
             2. Update Contacts Triggers combines possible contact initiators e.g. contact store changed,
             and binds the to the should update flag.
             */
            Observable.of(manualTrigger, accessChangedTrigger, storeChangedTrigger)
                .merge()
                .debug("Update triggered", trimOutput: true)
                .bind(to: shouldUpdateContactsFlag)
                .disposed(by: bag)
            
            // Fetching Contacts from Phone
            let contacts = initiateUpdate
                .filter{ $0 }
                .flatMapLatest{ [unowned self] granted in
                    return granted ? DeviceContacts.contactsWhenAccessGranted(forStore: self.store) : Single.just([])
                }
                .debug("Contacts Stream State:", trimOutput: true)
                .share()
            
            // Debuger driver
            contacts.map{ _ in "Contacts fetched success"}
                .bind(to: statusUpdate)
                .disposed(by: bag)
            
            // Fetching Matching Contacts From Server
            let apiContacts = contacts.flatMapLatest{
                ApiEndpoints.fetchMatches(forDeviceContacts: $0,
                                          syncUrl: contactSyncUrl)
                    .catchErrorJustReturn(nil)
                }
                .debug("Api Contact State:", trimOutput: true)
                .share()
            /*
             3. The flat is set to false once api returns non nil value.
             */
            apiContacts.map{ contacts in
                contacts == nil
                }
                .filter{ !$0 }
                .bind(to: shouldUpdateContactsFlag)
                .disposed(by: bag)
            
            // Debuger driver
            apiContacts.map{ cntct in
                return cntct == nil ? "Api Contact call Error" : "Api Contacts fetch Success"
                }
                .bind(to: statusUpdate)
                .disposed(by: bag)
            
            // Creating new Contacts List from Api response and Phone Contacts
            let matchingContacts = apiContacts.withLatestFrom(contacts) { apiCntct, cntct -> [PhoneContact]? in
                guard let apicntcts = apiCntct else { return nil }
                return ContactsFromApiImporter.importContactsFromApi(phoneContacts: cntct,
                                                                     apiContactData: apicntcts)
                }
                .filter{ $0 != nil }
                .map{ $0! }
                .debug("Matching Contacts State:", trimOutput: true)
            
            // Fetching Contacts from local Storage
            let realmContacts = RealmHandler.getObjectsFromDatabase()
                .asObservable()
                .debug("Fetched Realm Contacts", trimOutput: true)
                .share(replay: 1, scope: .forever)
            
            // Debuger driver
            realmContacts.filter{ !$0.isEmpty }
                .concat(Observable.never())
                .map{ _ in "Pulled Contacts from DB" }
                .bind(to: statusUpdate)
                .disposed(by: bag)
            
            // Merged Contacts gotten with the fetch + server, or from Storage
            let contactsResult = Observable.of(realmContacts, matchingContacts)
                .merge()
                .share(replay: 1, scope: .forever)
            
            /* Trigger which switches from Realm fetch to current Contact updates
             When contacts are fetched from the store for the first time, this observable
             switches and starts monitoring any future contact updates gotten from
             Phonebook + API and stores this locally
             */
            let saveContactsTrigger = realmContacts.flatMapLatest{ _ in
                return contactsResult
                }
                .share()
            
            saveContactsTrigger.skip(1).subscribe(onNext: { cnt in
                let realmObjects = cnt.map{ $0.toRealmObject() }
                RealmHandler.saveToDatabase(realmObjects)
            })
                .disposed(by: bag)
            
            
            // Debuger driver
            saveContactsTrigger.map{ _ in "Saving Contacts To DB"}
                .bind(to: statusUpdate)
                .disposed(by: bag)
            
            // Debuger driver
            contactsResult.map{ _ in "Contacts Updated"}
                .bind(to: statusUpdate)
                .disposed(by: bag)
            
            
            // Returning the end observable Sequence
            self.contacts = contactsResult.share(replay: 1, scope: .forever)
        }
    }
    
    public func startWithMockContacts(contacts: Observable<[PhoneContact]>) {
        self.contacts = contacts
    }
    
    // MARK: Public Methods
    public func pullContacts() {
        onFetch.onNext(())
    }
    
    // MARK: Helper variables
    var manualTrigger: Observable<Bool> {
        let trigger = self.onFetch
            .map{ _ in true }
            .debug("Trigger Changed", trimOutput: true)
            .share()
        
        trigger
            .map{ _ in "Fetch Contacts Triggered" }
            .bind(to: statusUpdate)
            .disposed(by: bag)
        
        return trigger
    }
    
    var accessChangedTrigger: Observable<Bool> {
        let trigger = DeviceContacts.accessChangedTrigger(forStore: store)
            .share()
        
        trigger
            .map{ _ in "Contacts Permission Changed" }
            .bind(to: statusUpdate)
            .disposed(by: bag)
        
        return trigger
    }
    
    var storeChangedTrigger: Observable<Bool> {
        let trigger = DeviceContacts.storeChangedTrigger(forStore: store)
            .share()
        
        trigger
            .map{ _ in "Contacts In Phone Changed" }
            .bind(to: statusUpdate)
            .disposed(by: bag)
        
        return trigger
    }
    
}


