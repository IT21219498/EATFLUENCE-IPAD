//
//  FoodPostEntity+CoreDataProperties.swift
//  EATFLUENCEiPad
//
//  Created by Pasindu Jayasinghe on 6/21/25.
//
//

import Foundation
import CoreData


extension FoodPostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodPostEntity> {
        return NSFetchRequest<FoodPostEntity>(entityName: "FoodPostEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var username: String?
    @NSManaged public var caption: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var timestamp: Date?
    @NSManaged public var sketchImageData: Data?

}

extension FoodPostEntity : Identifiable {

}
