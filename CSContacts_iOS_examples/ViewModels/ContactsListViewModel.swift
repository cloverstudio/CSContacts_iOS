//
//  ContactsListViewModel.swift
//  ContactSync
//
//  Created by Vedran on 15/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactsListViewModel {
    
    let phoneContacts: Driver<[PhoneContact]>
    let bag = DisposeBag()
    var tableView: UITableView?
    
    init(withDriver driver: Observable<[PhoneContact]>) {
        self.phoneContacts = driver.asDriver(onErrorJustReturn: [])
    }
    
    func bindToTableview(tableView: UITableView) {
        guard self.tableView == nil else { return }
        self.tableView = tableView
        
        let nib = UINib(nibName: String(describing: ContactCell.self),
                         bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: ContactCell.identifier)

        phoneContacts
            .drive(tableView
                .rx
                .items(cellIdentifier: ContactCell.identifier,
                       cellType: ContactCell.self)){ (_, contact, cell) in
                        cell.setContact(contact)
            }.disposed(by: self.bag)
    }
    
    deinit {
        print("Deiniting: \(String(describing: self))")
    }
    
}


