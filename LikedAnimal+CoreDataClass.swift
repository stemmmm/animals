//
//  LikedAnimal+CoreDataClass.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/28.
//
//

import Foundation
import CoreData

@objc(LikedAnimal)
public class LikedAnimal: NSManagedObject {
    
    // 공고 종료일 계산
    var noticeLeftDays: String? {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let formattedDate = formatter.date(from: noticeEndDate ?? "0")
        let leftDays = now.distance(to: formattedDate ?? Date()) / (60 * 60 * 24)
        return String(Int(leftDays))
    }
    
    // 성별 한글로 바꿔줌
    var sex: String? {
        switch sexCd {
        case "M": return "남"
        case "F": return "여"
        default: return "미상"
        }
    }
    
    // 나이 계산
    var age: String? {
        String(Calendar.current.component(.year, from: Date()) - (Int(birth?.prefix(4) ?? "0") ?? 0) + 1)
    }
    
}
