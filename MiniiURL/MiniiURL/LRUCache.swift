import CoreData
import AppKit

class CacheManager {
    let context: NSManagedObjectContext
    let cacheSize: Int = 5  // Limit to 5 items

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Function to get a QLLink from the cache by longURL
    func getLink(forLongURL longURL: String) -> QLLink? {
        let fetchRequest: NSFetchRequest<QLLink> = QLLink.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "longURL == %@", longURL)

        do {
            let result = try context.fetch(fetchRequest)
            if let qlLink = result.first {
                // Update the timestamp to mark it as recently used
                qlLink.timestamp = Date()
                try context.save()  // Save the updated timestamp
                return qlLink
            } else {
                print("Link with longURL '\(longURL)' not found in cache.")
            }
        } catch {
            print("Failed to fetch link: \(error)")
        }
        return nil
    }

    // Function to add or update a QLLink in the cache
    func setLink(shortURL: String, forLongURL longURL: String) {
        // Check if the QLLink already exists in the cache
        if let qlLink = getLink(forLongURL: longURL) {
            // Update the existing link's shortURL and timestamp
            qlLink.shortURL = shortURL
            qlLink.timestamp = Date()
        } else {
            // Insert a new link if it's not present
            let qlLink = QLLink(context: context)
            qlLink.longURL = longURL
            qlLink.shortURL = shortURL
            qlLink.timestamp = Date()
        }

        // Save and check if the cache size exceeds the limit
        do {
            try context.save()
            NSSound(named: "Glass")?.play()

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
