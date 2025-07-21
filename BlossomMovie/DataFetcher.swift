//
//  DataFetcher.swift
//  BlossomMovie
//
//  Created by Dwight Mcleish Jr on 7/13/25.
//

import Foundation

// Get the base URL from the shared API configuration singleton
let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
// Get the API key from the shared API configuration singleton
let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey

// Async function that takes a media type string and returns an array of Title objects
func fetchTitles(for media:String) async throws -> [Title] {
    // Check if base URL exists, throw error if nil
    guard let baseURL = tmdbBaseURL else {
        throw NetworkError.missingConfig
    }
    // Check if API key exists, throw error if nil
    guard let apiKey = tmdbAPIKey else {
        throw NetworkError.missingConfig
    }
    
    // Build the complete URL by chaining methods
    guard let fetchTitlesURL = URL(string: baseURL)?
        // Add the trending endpoint path with media type interpolated
        .appending(path: "3/trending/\(media)/day")
        // Add the API key as a query parameter
    .appending(queryItems: [
        URLQueryItem(name: "api_key", value: apiKey)
    ]) else {
        // Throw error if URL building fails
        throw NetworkError.urlBuildFailed
    }
    
    // Print the final URL to console for debugging
    print(fetchTitlesURL)
    
    // Make HTTP request and wait for response, returning data and response object
    let (data,urlResponse) = try await URLSession.shared.data(from: fetchTitlesURL)
    
    // Cast response to HTTPURLResponse and check if status code is 200 (success)
    guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
        // Create and throw custom network error with status code details
        throw NetworkError.badURLResponse(underlyingError: NSError(
            domain: "DataFetcher",
            code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
            userInfo: [NSLocalizedDescriptionKey : "Invalid HTTP Response"]))
    }
    
    // Create JSON decoder instance
    let decoder = JSONDecoder()
    // Set decoder to convert snake_case JSON keys to camelCase Swift properties
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    // Decode the JSON data into APIObject type and return its results array
    return try decoder.decode(APIObject.self, from: data).results
}
