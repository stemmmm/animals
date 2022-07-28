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
    
    func getLikedAnimal(by item: Item) -> LikedAnimal? {
        guard let id = item.id else { return nil }
        let request = LikedAnimal.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            return try context.fetch(request).first
        } catch {
            print("failed to fetch liked animal")
            return nil
        }
    }
    
    // MARK: - create
    func saveLikedAnimal(with item: Item) {
        
        if getLikedAnimal(by: item) != nil {
            print("saved entity already exists")
            return
        }
        
        let likedAnimal = LikedAnimal(context: context)
        likedAnimal.id = item.id
        likedAnimal.detailImage = item.detailImage
        likedAnimal.noticeNumber = item.noticeNumber
        likedAnimal.noticeStartDate = item.noticeStartDate
        likedAnimal.noticeEndDate = item.noticeEndDate
        likedAnimal.kind = item.kind
        likedAnimal.color = item.color
        likedAnimal.birth = item.birth
        likedAnimal.sexCd = item.sexCd
        likedAnimal.neutralizationStatus = item.neutralizationStatus
        likedAnimal.weight = item.weight
        likedAnimal.characteristics = item.characteristics
        likedAnimal.discoveredPlace = item.discoveredPlace
        likedAnimal.shelterName = item.shelterName
        likedAnimal.shelterAddress = item.shelterAddress
        likedAnimal.telNumber = item.telNumber
        try? context.save()
        print("saved")
    }
    
    // MARK: - delete
    func deleteLikedAnimal(by likedAnimal: LikedAnimal) {
        context.delete(likedAnimal)
        try? context.save()
        print("deleted")
    }
    
    func deleteLikedAnimal(by item: Item) {
        let likedAnimals = getLikedAnimals().filter { $0.id == item.id }
        guard let likedAnimal = likedAnimals.first else { return }
        deleteLikedAnimal(by: likedAnimal)
    }
    
}
