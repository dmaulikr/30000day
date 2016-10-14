//
//  STMediumVisibleTypeCoreDataObject+CoreDataProperties.swift
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

import Foundation
import CoreData

extension STMediumVisibleTypeCoreDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<STMediumVisibleTypeCoreDataObject> {
        return NSFetchRequest<STMediumVisibleTypeCoreDataObject>(entityName: "STMediumVisibleTypeCoreDataObject");
    }

    @NSManaged public var status: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var visibleType: Int64
    @NSManaged public var sift: STMediumSiftCoreDataObject?

}
