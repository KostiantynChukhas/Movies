//
//  AlertHelper.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//


import Foundation
import UIKit
import NotificationBannerSwift

let MaxBannersOnScreen = 3

class AlertHelper {
    struct AlertAction {
        static let ok = AlertAction(title: "OK")
        static let cancel = AlertAction(title: "Cancel",
                                        style: .cancel)
        
        let title: String?
        let style: UIAlertAction.Style
        let handler: EmptyClosureType?
        init(title: String?, style: UIAlertAction.Style = .default, handler: EmptyClosureType? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }
    
    static let bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: MaxBannersOnScreen)
    
    static func showAlert(on viewController: UIViewController? = .topViewController,
                          title: String? = nil,
                          message: String? = nil,
                          actions: [AlertAction] = [.ok]) {
        DispatchQueue.main.async {
            guard let root = viewController else { return }
        
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            actions.forEach { action in
                let handler: SimpleClosure<UIAlertAction>? = { _ in
                    alertController.dismiss(animated: true)
                    action.handler?()
                }
                alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: handler))
            }
            
            root.present(alertController, animated: true)
        }
    }
    
    /// If viewController - nil, shows banner on main window, queue - ignored.
    static func showBanner(on viewController: UIViewController? = nil,
                           style: BannerStyle = .danger,
                           text: String = "Error!",
                           queue: NotificationBannerQueue = bannerQueue,
                           delay: Double = 0,
                           duration: Double = 5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let banner = FloatingNotificationBanner(subtitle: text,
                                                    subtitleFont: .systemFont(ofSize: 16, weight: .medium),
                                                    style: style)
            banner.duration = duration
            banner.show(queue: viewController == .none ? bannerQueue : queue,
                        on: viewController,
                        edgeInsets: .init(top: 8, left: 8, bottom: 8, right: 8),
                        cornerRadius: 8,
                        shadowColor: .init(red: 43, green: 44, blue: 48, alpha: 1),
                        shadowOpacity: 0.1,
                        shadowBlurRadius: 8,
                        shadowCornerRadius: 4,
                        shadowOffset: .init(horizontal: 0, vertical: 4))
        }
       
    }
    
    static func createAlert(from key: String) -> Error {
        let error = NSError(domain: "domain", code: 400, userInfo: [NSLocalizedDescriptionKey: key])
        return error
    }
    
    static func showSheet(on viewController: UIViewController? = .topViewController,
                          message: String,
                          items: [String],
                          completion: SimpleClosure<Int>? = nil) {
        DispatchQueue.main.async {
            guard let root = viewController else { return }
            
            let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            
            for (index, item) in items.enumerated() {
                let action = UIAlertAction(title: item, style: .default, handler: { _ in
                    alertVC.dismiss(animated: true, completion: nil)
                    completion?(index)
                })
                alertVC.addAction(action)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alertVC.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(cancel)
            
            root.present(alertVC, animated: true, completion: nil)
        }
    }
}
