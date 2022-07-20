//
//  DetailedImageView.swift
//  STUDI
//
//  Created by peo on 2022/07/15.
//

import UIKit

class DetailedImageView: UIView {
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let animalImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "test"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func makeSubviews() {
        self.addSubview(closeButton)
        self.addSubview(animalImageView)
    }
    
    func makeConstraints() {
        let closeButtonConstraints = [closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24),
                                      closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)]
        NSLayoutConstraint.activate(closeButtonConstraints)
        
        let animalImageViewConstraints = [animalImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                          animalImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                          animalImageView.topAnchor.constraint(equalTo: self.topAnchor),
                                          animalImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)]
        NSLayoutConstraint.activate(animalImageViewConstraints)
    }
}
