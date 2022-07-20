//
//  CategoryLabel.swift
//  STUDI
//
//  Created by peo on 2022/07/14.
//

import UIKit

class CategoryLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = .systemFont(ofSize: 14, weight: .regular)
        textColor = .init(red: 142/255, green: 142/255, blue: 146/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
