//
//  MockAPIEndpointTesting.swift
//  CountryListAssessmentTests
//
//  Created by Tilak K on 30/05/25.
//

import XCTest
@testable import CountryListAssessment
import Foundation


struct MockEndpoint: APIEndpoint {
    var baseURL: BaseURL = .baseUrl
    var path: String
    var method: HttpMethodType
    var body: Data? = nil
}

final class APIEndpointTests: XCTestCase {

    func testFullURLConstruction() {
        // Given
        let endpoint = MockEndpoint(path: "/tilak27/1234/raw/countries.json", method: .get)

        // When
        let fullURL = endpoint.fullURL

        // Then
        XCTAssertEqual(
            fullURL?.absoluteString,
            "https://gist.githubusercontent.com/tilak27/1234/raw/countries.json"
        )
    }

    func testHttpMethodGet() {
        let endpoint = MockEndpoint(path: "/dummy", method: .get)
        XCTAssertEqual(endpoint.method.rawValue, "GET")
    }

    func testHttpMethodPost() {
        let endpoint = MockEndpoint(path: "/dummy", method: .post)
        XCTAssertEqual(endpoint.method.rawValue, "POST")
    }

    func testEndpointWithBody() {
        // Given
        let bodyData = "{\"key\":\"value\"}".data(using: .utf8)
        let endpoint = MockEndpoint(path: "/submit", method: .post, body: bodyData)

        // Then
        XCTAssertEqual(endpoint.body, bodyData)
    }
}
