//
//  STMediumSiftCoreDataObject+CoreDataProperties.swift
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

import Foundation
import CoreData

extension STMediumSiftCoreDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STMediumSiftCoreDataObject> {
        return NSFetchRequest<STMediumSiftCoreDataObject>(entityName: "STMediumSiftCoreDataObject");
    }

    @NSManaged public var index: Int64
    @NSManaged public var title: String?
    @NSManaged public var visible: NSSet?

}

// MARK: Generated accessors for visible
extension STMediumSiftCoreDataObject {

    @objc(addVisibleObject:)
    @NSManaged public func addToVisible(_ value: STMediumVisibleTypeCoreDataObject)

    @objc(removeVisibleObject:)
    @NSManaged public func removeFromVisible(_ value: STMediumVisibleTypeCoreDataObject)

    @objc(addVisible:)
    @NSManaged public func addToVisible(_ values: NSSet)

    @objc(removeVisible:)
    @NSManaged public func removeFromVisible(_ values: NSSet)

}
