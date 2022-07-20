//
//  DetailedImageViewController.swift
//  STUDI
//
//  Created by peo on 2022/07/17.
//

import UIKit

class DetailedImageViewController: UIViewController {
    let detailedImageView = DetailedImageView()
    
    var navBarAppearance: UINavigationBarAppearance = {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.shadowColor = .clear
        return navBarAppearance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailedImageView.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        
        self.detailedImageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(doPinch)))
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.detailedImageView
    }
    
    @objc func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) {
        self.detailedImageView.animalImageView.transform = self.detailedImageView.animalImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        
        pinch.scale = 1
    }
}
