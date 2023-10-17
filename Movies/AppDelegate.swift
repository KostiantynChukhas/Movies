//
//  AppDelegate.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var appCoordinator: AppCoordinator?
    internal var window: UIWindow?
    var reachability: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        setupReachability()
        return true
    }

    func setupReachability() {
        // Allocate a reachability object
        reachability = try? Reachability()
        
        // Notify the user when the network status changes
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection == .unavailable && reachability.connection != .wifi  && reachability.connection != .cellular {
            AlertHelper.showAlert(on: .topViewController, message: NSLocalizedString("internet_error"))
        }
    }
   
}

