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
  
  @NSManaged public var shortUrl: String?
  @NSManaged public var longUrl: String?
  @NSManaged public var timestamp: Date?

  var wrappedShortUrl: URL {  URL(string: shortUrl!)!  }
  var wrappedLongUrl: URL { URL(string: longUrl!)! }
  var wrappedTimestamp: Date { timestamp! }
}

extension QLLink : Identifiable {
  
}
