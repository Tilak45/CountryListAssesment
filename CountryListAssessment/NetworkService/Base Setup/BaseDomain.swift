//
//  BaseDomain.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//

import Foundation

enum BaseURL: String {
    case baseUrl = "https://gist.githubusercontent.com"
    // Add more base URLs if needed
}

protocol APIEndpoint {
    var baseURL: BaseURL { get }
    var path: String { get }
    var method: HttpMethodType { get }
    var body: Data? { get }
    var fullURL: URL? { get }
}

extension APIEndpoint {
    var fullURL: URL? {
        URL(string: baseURL.rawValue + path)
    }
}

enum HttpMethodType: String {
    case get = "GET"
    case post = "POST"
}
