//
//  CustomDelegates.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/19.
//

import Foundation

protocol FilterDelegate: AnyObject {
    func applyFilter(kind: Kind?)
}

protocol ButtonDelegate: AnyObject {
    func heartButtonTapped(send item: Item)
    func heartButtonTapped(send likedAnimal: LikedAnimal, _ isLiked: Bool)
}

extension ButtonDelegate {
    
    func heartButtonTapped(send item: Item) {
        
    }
    
    func heartButtonTapped(send likedAnimal: LikedAnimal, _ isLiked: Bool) {
        
    }
}
