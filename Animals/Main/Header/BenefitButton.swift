//
//  BenefitButton.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class BenefitButton: UIButton {

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setView
    private func setView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 14
        self.backgroundColor = .systemGray6
        
        self.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        self.setTitleColor(.black, for: .normal)
    }
    
}
