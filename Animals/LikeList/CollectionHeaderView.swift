//
//  CollectionHeaderView.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class CollectionHeaderView: UICollectionReusableView {
    
    // MARK: - view
    private let benefitButton: BenefitButton = {
        let button = BenefitButton()
        button.setTitle("🐶 공고 종료된 아이들은\n자동으로 목록에서 사라져요", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHeaderStackViewConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 오토레이아웃
    private func setHeaderStackViewConstraint() {
        self.addSubview(benefitButton)
        benefitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            benefitButton.heightAnchor.constraint(equalToConstant: 66),
            benefitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            benefitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            benefitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
    
}
