//
//  ColumnFlowLayout.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/17.
//

import UIKit

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    // layout invalidate 될때 마다 호출 - 화면이 변할 때(회전 등)
    override func prepare() {
        super.prepare()
        
        self.scrollDirection = .vertical
        
        self.itemSize = CGSize(width: 165, height: 210)
        self.headerReferenceSize = CGSize(width: 390, height: 105)

        self.sectionInset = .init(top: 0, left: 20, bottom: 20, right: 20)
        self.minimumInteritemSpacing = 20
        self.minimumLineSpacing = 16
    }
    
}
