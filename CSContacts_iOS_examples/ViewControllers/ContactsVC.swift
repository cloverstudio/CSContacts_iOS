//
//  ContactsVC.swift
//  ContactSync
//
//  Created by Vedran on 15/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactsVC : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ContactsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CSContacts Example"
        
        viewModel = ContactsListViewModel(withDriver: CSContactsProvider.instance.contacts)
        viewModel.bindToTableview(tableView: tableView)
    }
    
    deinit {
        print("Deiniting: \(String(describing: self))")
    }
    
}


