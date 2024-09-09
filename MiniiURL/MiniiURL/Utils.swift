import Foundation

// Define a custom error type for configuration errors
enum ConfigError: Error {
    case fileNotFound
    case keyNotFound(String)
}

class Utils {
    static let shared = Utils()  // Singleton instance (optional)

    // Fetches a configuration item from the Config.plist
    func getConfigItem(name: String) throws -> String {
        // Check if the config file exists
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            throw ConfigError.fileNotFound  // Throw error if file is not found
        }

        // Check if the config file can be loaded as NSDictionary
        guard let config = NSDictionary(contentsOfFile: path) else {
            throw ConfigError.fileNotFound  // Throw error if file can't be read
        }

        // Check if the requested item exists in the config
        guard let item = config[name] as? String else {
            throw ConfigError.keyNotFound(name)  // Throw error if key not found
        }

        return item
    }
}
