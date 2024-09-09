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
  
  @NSManaged public var shortURL: String?
  @NSManaged public var longURL: String?
  @NSManaged public var timestamp: Date?

  var wrappedShortURL: URL {  URL(string: shortURL!)!  }
  var wrappedLongURL: URL { URL(string: longURL!)! }
  var wrappedTimestamp: Date { timestamp! }
}

extension QLLink : Identifiable {
  
}
