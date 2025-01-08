//
//  Location+CoreDataProperties.swift
//  GoWalk
//
//  Created by 박진홍 on 1/8/25.
//
//

import Foundation
import CoreData

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Location: Identifiable {
}
