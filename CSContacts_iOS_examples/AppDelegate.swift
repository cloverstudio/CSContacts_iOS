//
//  AppDelegate.swift
//  CSContacts_iOS_examples
//
//  Created by Vedran on 26/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import UIKit
import Pods_CSContacts_iOS

let kServerEndpoint = "https://app.qrios.pw/api/v2/user/sync"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    weak var debugOverlay:DebugView?
    
    func addDebugOverlay() {
        guard self.debugOverlay == nil else { return }
        
        if let window = window {
            let bounds = window.bounds
            let kViewHeight:CGFloat = 156.0
            let yPos:CGFloat = bounds.size.height - kViewHeight
            let frame = CGRect(x: 0, y: yPos, width: bounds.width, height: kViewHeight)
            
            let debugOverlay = DebugView(frame: frame,
                                         status: CSContactsProvider.instance.statusUpdate)
            
            
            window.addSubview(debugOverlay)
            self.debugOverlay = debugOverlay
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        CSContactsProvider.instance.start(contactSyncUrl: URL(string: kServerEndpoint)!)
        
        return true
    }


}

