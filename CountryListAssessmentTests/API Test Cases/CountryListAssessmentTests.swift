//
//  CountryListAssessmentTests.swift
//  CountryListAssessmentTests
//
//  Created by Tilak k on 30/05/25.
//

import Testing
@testable import CountryListAssessment
import Foundation
import XCTest

class MockNetworkClient: NetworkClientProtocol {
    var result: Result<Data, Error>?

    func request<T>(for endpoint: APIEndpoint, type: T.Type) async throws -> T where T : Decodable {
        switch result {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw error
        case .none:
            fatalError("No result set on mock")
        }
    }
}



final class CountryServiceTests: XCTestCase {

    // Sample country JSON
    let mockJSON = """
    [
        {
            "name": "India",
            "code": "IN",
            "capital": "New Delhi",
            "region": "Asia"
        },
        {
            "name": "France",
            "code": "FR",
            "capital": "Paris",
            "region": "Europe"
        }
    ]
    """.data(using: .utf8)!

    struct InvalidMockEndpoint: APIEndpoint {
        var baseURL: BaseURL = .baseUrl
        var path: String = "/invalid"
        var method: HttpMethodType = .get
        var body: Data? = nil
    }

    func testFetchCountries_Success() async throws {
        // Given
        let mockClient = MockNetworkClient()
        mockClient.result = .success(mockJSON)

        let service = CountryService(networkClient: mockClient)

        // When
        let countries = try await service.fetchCountries()

        // Then
        XCTAssertEqual(countries.count, 2)
        XCTAssertEqual(countries[0].name, "India")
        XCTAssertEqual(countries[1].capital, "Paris")
    }

    func testFetchCountries_Failure() async {
        // Given
        let mockClient = MockNetworkClient()
        mockClient.result = .failure(NSError(domain: "TestError", code: 999, userInfo: nil))

        let service = CountryService(networkClient: mockClient)

        // When / Then
        do {
            _ = try await service.fetchCountries()
            XCTFail("Expected to throw error, but succeeded")
        } catch let error as CountryError {
            switch error {
            case .networkError(let err as NSError):
                XCTAssertEqual(err.code, 999)
            default:
                XCTFail("Expected network error with code 999")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchCountries_DecodingError() async {
        // Given: Invalid JSON
        let invalidJSON = "Invalid JSON".data(using: .utf8)!
        let mockClient = MockNetworkClient()
        mockClient.result = .success(invalidJSON)

        let service = CountryService(networkClient: mockClient)

        // When / Then
        do {
            _ = try await service.fetchCountries()
            XCTFail("Expected decoding error")
        } catch let error as CountryError {
            switch error {
            case .decodingError:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected decoding error")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
