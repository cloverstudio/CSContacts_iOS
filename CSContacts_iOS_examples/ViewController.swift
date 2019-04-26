//
//  ViewController.swift
//  CSContacts_iOS_examples
//
//  Created by Vedran on 26/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    @IBOutlet weak var showContactsBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CSContacts Example"
        
        showContactsBtn
            .rx
            .tap
            .throttle(2.0, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let nav = self?.navigationController else { return }
                Wireframe.goToContacts(fromNav: nav)
            })
            .disposed(by: bag)
    }


}

