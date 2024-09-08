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
  
  var wrappedShortUrl: URL {  URL(string: shortUrl!)!  }
  var wrappedLongUrl: URL { URL(string: longUrl!)! }
}

extension QLLink : Identifiable {
  
}
