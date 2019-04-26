//
//  DebugView.swift
//  ContactSync
//
//  Created by Vedran on 15/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DebugView: UIView {
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DebugViewModel!
    
    init(frame: CGRect, status: Observable<String>) {
        super.init(frame: frame)
        
        let view = loadViewfromNib() as! DebugView
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        self.isHidden = true
        
        view.viewModel = DebugViewModel(withStatusUpdates: status)
        
        view.viewModel.bindHideUnhideView(view: self)
        view.viewModel.bindToTableView(tableView: view.tableView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewfromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! DebugView
    }
    
    deinit {
        print("Deiniting: \(String(describing: self))")
    }
    
}


