//
//  HeartButton.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/20.
//

import UIKit

final class HeartButton: UIButton {

    var isOn: Bool = false {
        didSet {
            setView()
        }
    }
    
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
        if isOn == false {
            self.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            self.tintColor = .gray
        } else {
            self.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.tintColor = .red
        }
    }

}
