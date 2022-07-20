//
//  RegionSelectButton.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class RegionSelectButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // chevron 위치 오른쪽으로
        self.semanticContentAttribute = .forceRightToLeft
    }
    
}
