//
//  QLLink+CoreDataProperties.swift
//  MiniiURL
//
//  Created by Mambatukaa on 2024.09.04.
//
//

import Foundation
import CoreData


extension QLLink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QLLink> {
        return NSFetchRequest<QLLink>(entityName: "QLLink")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var url: String?
  
    var wrappedID: UUID { id! }
    var wrappedTitle: String { title! }
    var wrappedURL: URL { URL(string: url!)! }
}

extension QLLink : Identifiable {

}
