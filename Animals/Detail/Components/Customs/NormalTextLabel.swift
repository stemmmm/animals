//
//  NormalTextLabel.swift
//  STUDI
//
//  Created by peo on 2022/07/14.
//

import UIKit

class NormalTextLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = .systemFont(ofSize: 14, weight: .regular)
        textColor = .init(red: 13/255, green: 13/255, blue: 13/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
