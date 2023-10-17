//
//  UIViewController.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showProgressHud(message: String = "Loading...",
                 alpha: CGFloat = 0.8,
                 animated: Bool = true,
                 graceTime: Double = 0.1,
                 minShowTime: Double = 0.5,
                 mode: MBProgressHUDMode = .indeterminate,
                 completion: EmptyClosureType? = nil) {
        hideProgressHud(animated: false)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let hud = MBProgressHUD(view: self.view)
            if !self.view.subviews.contains(where: { $0 is MBProgressHUD }) {
                self.view.addSubview(hud)
            }
            hud.backgroundView.alpha = alpha
            hud.label.text = message
            hud.graceTime = graceTime
            hud.minShowTime = minShowTime
            hud.mode = mode
            hud.completionBlock = {
                hud.removeFromSuperview()
                completion?()
            }
            hud.show(animated: animated)
        }
    }
    
    func hideProgressHud(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var huds = self.view.subviews.compactMap { $0 as? MBProgressHUD }
            guard !huds.isEmpty else { return }
            let last = huds.removeLast()
            huds.forEach { $0.hide(animated: false) }
            last.hide(animated: animated)
        }
    }
}


extension UIViewController {
    static var topViewController: UIViewController? {
        var tryCount = 0
        
        if var controller = UIApplication.shared.windows.first?.rootViewController {
            while let presented = controller.presentedViewController, tryCount < 100 {
                tryCount += 1
                if let nav = presented as? UINavigationController, let last = nav.viewControllers.last {
                    controller = last
                } else if let vc = presented as UIViewController? {
                    controller = vc
                }
                DispatchQueue.main.async {
                    controller = presented
                }
            }
            return controller
        }
        return nil
    }
}

extension UIAlertController {
    static func actionSheetWithItems<A : Equatable>(items: [(title: String, value: A)], currentSelection: A? = nil, action: @escaping (A) -> Void) -> UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for (var title, value) in items {
            if let selection = currentSelection, value == selection {
                title =  title + " ✔︎"
            }
            
            let action = UIAlertAction(title: title, style: .default) { _ in
                action(value)
            }
            
            // Set the text color for the action title
            action.setValue(UIColor.white, forKey: "titleTextColor")
            
            controller.addAction(action)
        }
        
        return controller
    }
}
