//
//  PraiseReplyStorageObject+CoreDataProperties.swift
//  30000day
//
//  Created by GuoJia on 16/10/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

import Foundation
import CoreData


extension PraiseReplyStorageObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PraiseReplyStorageObject> {
        return NSFetchRequest<PraiseReplyStorageObject>(entityName: "PraiseReplyStorageObject");
    }

    @NSManaged public var messageId: String?
    @NSManaged public var messageType: Int64
    @NSManaged public var metaData: NSData?
    @NSManaged public var readState: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var visibleType: Int64

}
