//
//  VideoViewController.swift
//  Movies
//
//  Created by Konstantin Chukhas on 17.10.2023.
//

import UIKit
import YoutubePlayerView

class VideoViewController: UIViewController {
    
    @IBOutlet weak var playerView: YoutubePlayerView!
    @IBOutlet weak var backButton: UIButton!
    private var initialTransform: CGAffineTransform!
    var youtubeID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupPlayer()
        setupUI()
    }
    
    private func setupUI() {
        backButton.setTitle(NSLocalizedString("back"), for: .normal)
    }
    
    private func setupGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        playerView.addGestureRecognizer(pinchGesture)
        playerView.isUserInteractionEnabled = true
        initialTransform = playerView.transform

    }
    
    private func setupPlayer() {
        guard let id = youtubeID else { return }
        let playerVars: [String: Any] = [
            "controls": 1,
            "modestbranding": 1,
            "playsinline": 1,
            "origin": "https://youtube.com",
            "autoplay": 0,
        ]
        
        playerView.loadWithVideoId(id,with: playerVars)
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
           guard let view = gestureRecognizer.view else { return }

           if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
               view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
               gestureRecognizer.scale = 1.0
           } else if gestureRecognizer.state == .ended {
               if view.transform.a < initialTransform.a {
                   UIView.animate(withDuration: 0.3) {
                       view.transform = self.initialTransform
                   }
               } else {
                   let maxScale: CGFloat = 3.0 // Maximum allowed zoom
                   if view.transform.a > maxScale {
                       UIView.animate(withDuration: 0.3) {
                           view.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                       }
                   }
               }
           }
       }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
