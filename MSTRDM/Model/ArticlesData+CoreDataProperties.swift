//
//  ArticlesData+CoreDataProperties.swift
//  
//
//  Created by Zakirov Tahir on 27.02.2021.
//
//

import Foundation
import CoreData


extension ArticlesData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticlesData> {
        return NSFetchRequest<ArticlesData>(entityName: "ArticlesData")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: Data?
    @NSManaged public var url: String?

}
