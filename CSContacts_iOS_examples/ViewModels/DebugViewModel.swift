//
//  DebugViewModel.swift
//  ContactSync
//
//  Created by Vedran on 15/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DebugViewModel {
    
    let updates:ReplaySubject<[String]> = ReplaySubject.create(bufferSize: 1)
    let hideUnhideView: Driver<Bool>
    let bag = DisposeBag()
    
    init(withStatusUpdates updatesObservable: Observable<String>) {
        let buffer:Variable<[String]> = Variable([])
        
        buffer
            .asObservable()
            .bind(to: updates)
            .disposed(by: bag)
        
        updatesObservable
            .map({ value in
                let date = Date().timeIntervalSince1970
                return "\(date) - \(value)"
            })
            .map { update in
            return buffer.value + [update]
        }
        .bind(to: buffer)
        .disposed(by: bag)
        
        
        let updatesStarted = updatesObservable
            .map{ _ in false }
        
       let updatesDone = updatesObservable
            .throttle(10.0, scheduler: MainScheduler.instance)
            .delay(5.0, scheduler: MainScheduler.instance)
            .map{ _ in true }
        .share()
        
        updatesDone
        .subscribe(onNext: { _ in
            buffer.value = []
        })
        .disposed(by: bag)
        
        hideUnhideView = Observable
            .of(updatesStarted, updatesDone)
            .merge()
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
    }
    
    func bindToTableView(tableView: UITableView) {
        let nib = UINib(nibName: String(describing: DebugCell.self),
                        bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DebugCell.kIdentifier)
        
        let updatesDriver = updates.asDriver(onErrorJustReturn: [])
        
        updatesDriver
            .drive(tableView.rx.items(cellIdentifier: DebugCell.kIdentifier, cellType: DebugCell.self))
            { (_, value, cell) in
                cell.textLabel?.text = value
            }
            .disposed(by: bag)
        
        updatesDriver
            .throttle(1.0)
            .map{ _ in
                let y = tableView.contentSize.height - tableView.bounds.height
                return CGPoint(x: 0, y: y)
            }
            .drive(tableView.rx.contentOffset)
            .disposed(by: bag)
    }
    
    func bindHideUnhideView(view: UIView) {
        hideUnhideView
            .drive(view.rx.isHidden)
            .disposed(by: bag)
    }
    
}




