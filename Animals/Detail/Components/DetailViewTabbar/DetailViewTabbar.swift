//
//  DetailViewTabbar.swift
//  STUDI
//
//  Created by peo on 2022/07/14.
//

import UIKit

class DetailViewTabbar: UIView {
    var likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let contactButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(red: 103/255, green: 195/255, blue: 135/255, alpha: 1)
        button.layer.cornerRadius = 14
        button.setTitle("보호소 연락하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: DetailViewTabbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeSubviews()
        makeConstraints()
        configureBorder()
        setDelegate()
    }
    
    private func makeSubviews() {
        [likeButton, contactButton].forEach { self.addSubview($0) }
    }
    
    private func configureBorder() {
        self.layer.borderWidth = 0.4
        self.layer.borderColor = .init(red: 198/255, green: 197/255, blue: 202/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Make Constraints

extension DetailViewTabbar {
    private func makeConstraints() {
        let likeButtonConstraints = [likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                                     likeButton.centerYAnchor.constraint(equalTo: contactButton.centerYAnchor),
                                     likeButton.widthAnchor.constraint(equalToConstant: 27.5),
                                     likeButton.heightAnchor.constraint(equalToConstant: 24.5)]
        
        let contactButtonConstraints = [contactButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 26),
                                        contactButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                                        contactButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                                        contactButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -52)]
        
        [likeButtonConstraints, contactButtonConstraints].forEach { NSLayoutConstraint.activate($0) }
    }
}

// MARK: - Delegate

extension DetailViewTabbar {
    func setDelegate() {
        contactButton.addTarget(self, action: #selector(contactButtonDidTap), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
    
    @objc func contactButtonDidTap() {
        delegate?.contactButtonDidTap()
    }
    
    @objc func likeButtonDidTap() {
        delegate?.likeButtonDidTap()
    }
}
