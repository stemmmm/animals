//
//  CoreDataManager.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/27.
//

import Foundation
import UIKit

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var context = appDelegate.persistentContainer.viewContext
    
    let modelName = "LikedAnimal"
    
    // MARK: - read
    func getLikedAnimals() -> [LikedAnimal] {
        return try! context.fetch(LikedAnimal.fetchRequest())
    }
    
    // MARK: - create
    func saveLikedAnimal(with item: Item) {
        let likedAnimal = LikedAnimal(context: context)
        likedAnimal.id = item.id
        likedAnimal.detailImage = item.detailImage
        likedAnimal.noticeNumber = item.noticeNumber
        likedAnimal.noticeStartDate = item.noticeStartDate
        likedAnimal.noticeEndDate = item.noticeEndDate
        likedAnimal.noticeLeftDays = item.noticeLeftDays
        likedAnimal.kind = item.kind
        likedAnimal.color = item.color
        likedAnimal.age = item.age
        likedAnimal.sex = item.sex
        likedAnimal.neutralizationStatus = item.neutralizationStatus
        likedAnimal.weight = item.weight
        likedAnimal.characteristic = item.description
        likedAnimal.discoveredPlace = item.discoverdPlace
        likedAnimal.shelterName = item.shelterName
        likedAnimal.shelterAddress = item.shelterAddress
        likedAnimal.telNumber = item.telNumber
        try? context.save()
    }
    
    // MARK: - delete
    func deleteLikedAnimal(_ item: LikedAnimal) {
        context.delete(item)
        try? context.save()
    }
    
}
