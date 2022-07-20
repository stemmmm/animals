//
//  TableHeaderView.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class TableHeaderView: UIView {

    // MARK: - views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "입양을 기다리는 아이들"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let benefitButton: BenefitButton = {
        let button = BenefitButton()
        button.setTitle("🎉 입양 혜택을 확인하세요!", for: .normal)
        return button
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, benefitButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewConstraints() {
        self.addSubview(headerStackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        benefitButton.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            headerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            headerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            benefitButton.widthAnchor.constraint(equalToConstant: 350),
            benefitButton.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
    
}
