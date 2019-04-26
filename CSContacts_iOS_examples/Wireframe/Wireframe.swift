//
//  Wireframe.swift
//  ContactSync
//
//  Created by Vedran on 15/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit

class Wireframe {
    
    class func goToContacts(fromNav nav: UINavigationController) {
        let vcName = String(describing: ContactsVC.self)
        let storyBoard = UIStoryboard(name: vcName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: vcName)
        nav.pushViewController(vc, animated: true)
    }
    
    
    
}



