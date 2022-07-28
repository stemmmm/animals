//
//  LikedAnimal+CoreDataProperties.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/28.
//
//

import Foundation
import CoreData


extension LikedAnimal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedAnimal> {
        return NSFetchRequest<LikedAnimal>(entityName: "LikedAnimal")
    }

    @NSManaged public var birth: String?
    @NSManaged public var characteristics: String?
    @NSManaged public var color: String?
    @NSManaged public var detailImage: String?
    @NSManaged public var discoveredPlace: String?
    @NSManaged public var id: String?
    @NSManaged public var kind: String?
    @NSManaged public var neutralizationStatus: String?
    @NSManaged public var noticeEndDate: String?
    @NSManaged public var noticeNumber: String?
    @NSManaged public var noticeStartDate: String?
    @NSManaged public var sexCd: String?
    @NSManaged public var shelterAddress: String?
    @NSManaged public var shelterName: String?
    @NSManaged public var telNumber: String?
    @NSManaged public var weight: String?

}

extension LikedAnimal : Identifiable {

}
