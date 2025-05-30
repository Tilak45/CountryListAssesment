//
//  ViewModelTestCase.swift
//  CountryListAssessmentTests
//
//  Created by Tilak K on 30/05/25.
//

import XCTest
@testable import CountryListAssessment
import Foundation

class MockCountryService: CountryServiceProtocol {
    var countriesToReturn: [Country] = []
    var shouldThrowError = false

    func fetchCountries() async throws -> [Country] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1001, userInfo: nil)
        }
        return countriesToReturn
    }

    func filterCountries(_ countries: [Country], by searchText: String) -> [Country] {
        return countries.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
}

final class CountriesViewModelTests: XCTestCase {

    func testFetchCountries_Success() async {
        // Given
        let mockService = MockCountryService()
        mockService.countriesToReturn = [
            Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi"),
            Country(name: "France", region: "Europe", code: "FR", capital: "Paris")
        ]
        let viewModel = CountriesViewModel(countryService: mockService)
        let expectation = XCTestExpectation(description: "Data updated called")

        viewModel.onDataUpdated = {
            expectation.fulfill()
        }

        // When
        await viewModel.fetchCountries()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.allCountries.count, 2)
        XCTAssertEqual(viewModel.filteredCountries.count, 2)
    }

    func testFetchCountries_Failure() async {
        // Given
        let mockService = MockCountryService()
        mockService.shouldThrowError = true
        let viewModel = CountriesViewModel(countryService: mockService)

        let expectation = XCTestExpectation(description: "Error callback called")

        viewModel.onError = { error in
            expectation.fulfill()
            XCTAssertEqual((error as NSError).code, 1001)
        }

        await viewModel.fetchCountries()
        await fulfillment(of: [expectation], timeout: 1.0)

    }

    func testFilterCountries_WithSearchText() {
        // Given
        let mockService = MockCountryService()
        let viewModel = CountriesViewModel(countryService: mockService)

        viewModel.allCountries = [
            Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi"),
            Country(name: "France", region: "Europe", code: "FR", capital: "Paris"),
            Country(name: "Canada", region: "North America", code: "CA", capital: "Ottawa")
        ]

        let expectation = XCTestExpectation(description: "Data updated after filtering")
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }

        // When
        viewModel.filterCountries(searchText: "an")

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.filteredCountries.count, 2) // "France" and "Canada"
    }

    func testFilterCountries_EmptySearchText() {
        // Given
        let mockService = MockCountryService()
        let viewModel = CountriesViewModel(countryService: mockService)

        viewModel.allCountries = [
            Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi")
        ]

        let expectation = XCTestExpectation(description: "Data updated on empty search")
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }

        // When
        viewModel.filterCountries(searchText: "")

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
    }
}
