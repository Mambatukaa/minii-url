//
//  APIService.swift
//  MiniiURL
//
//  Created by Mambatukaa on 2024.09.08.
//

import Foundation

class APIService {
  static let shared = APIService()  // Singleton instance (optional)
  
  
  // Function to get the short URL code
  func getShortUrlCode(longURL: String) async throws -> String {
    let API_URL = try Utils.shared.getConfigItem(name: "API_URL")

    print("API_URL:", API_URL)
    
    guard let url = URL(string: (API_URL) + "/url") else {
      throw URLError(.badURL)  // Throw an error instead of printing and returning ""
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let json: [String: String] = ["LongUrl": longURL]
    
    do {
      // Convert the parameters to JSON data and set the request body
      request.httpBody = try JSONSerialization.data(withJSONObject: json)
      
      
      // Debug print to check if the body is correctly formed
      if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
        print("Request Body: \(jsonString)")
      }
      
    } catch {
      throw URLError(.cannotCreateFile)  // Throw an error if JSON serialization fails
    }
    
    
    do {
      // Make the network request using async/await
      let (data, response) = try await URLSession.shared.data(for: request)
      
      
      // Check for successful response
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        // Convert the data to string
        if let responseDataString = String(data: data, encoding: .utf8) {
          print("Response received short URL code: \(responseDataString)")
          return responseDataString
        } else {
          throw URLError(.cannotDecodeRawData)
        }
      } else {
        throw URLError(.badServerResponse)
      }
    } catch {
      // Rethrow the error to be caught by the caller
      print("Network request failed: \(error)")
      throw error
    }
  }
}
