import CoreData

class CacheManager {
    let context: NSManagedObjectContext
    let cacheSize: Int = 5  // Limit to 5 items

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Function to get a QLLink from the cache by longUrl
    func getLink(forLongUrl longUrl: String) -> QLLink? {
        let fetchRequest: NSFetchRequest<QLLink> = QLLink.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "longUrl == %@", longUrl)

        do {
            let result = try context.fetch(fetchRequest)
            if let qlLink = result.first {
                // Update the timestamp to mark it as recently used
                qlLink.timestamp = Date()
                try context.save()  // Save the updated timestamp
                return qlLink
            } else {
                print("Link with longUrl '\(longUrl)' not found in cache.")
            }
        } catch {
            print("Failed to fetch link: \(error)")
        }
        return nil
    }

    // Function to add or update a QLLink in the cache
    func setLink(shortUrl: String, forLongUrl longUrl: String) {
        // Check if the QLLink already exists in the cache
        if let qlLink = getLink(forLongUrl: longUrl) {
            // Update the existing link's shortUrl and timestamp
            qlLink.shortUrl = shortUrl
            qlLink.timestamp = Date()
        } else {
            // Insert a new link if it's not present
            let qlLink = QLLink(context: context)
            qlLink.longUrl = longUrl
            qlLink.shortUrl = shortUrl
            qlLink.timestamp = Date()
        }

        // Save and check if the cache size exceeds the limit
        do {
            try context.save()
            trimCacheIfNeeded()
        } catch {
            print("Failed to save link: \(error)")
        }
    }

    // Function to trim the cache if it exceeds the size limit
    private func trimCacheIfNeeded() {
        let fetchRequest: NSFetchRequest<QLLink> = QLLink.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > cacheSize {
                // Remove the oldest items (least recently used)
                let itemsToRemove = results.prefix(results.count - cacheSize)
                for item in itemsToRemove {
                    context.delete(item)
                }
                try context.save()
            }
        } catch {
            print("Failed to trim cache: \(error)")
        }
    }
}
