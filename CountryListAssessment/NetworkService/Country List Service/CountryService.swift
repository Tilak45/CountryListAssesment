//
//  CountryService.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//
import Foundation

protocol CountryServiceProtocol {
    func fetchCountries() async throws -> [Country]
    func filterCountries(_ countries: [Country], by keyword: String) -> [Country]
}

class CountryService: CountryServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchCountries() async throws -> [Country] {
        do {
            let countries: [Country] = try await networkClient.request(for: CountriesEndpoint(), type: [Country].self)
            return countries
        } catch let decodingError as DecodingError {
            throw CountryError.decodingError(decodingError)
        } catch {
            throw CountryError.networkError(error)
        }
    }

    func filterCountries(_ countries: [Country], by keyword: String) -> [Country] {
        let lowercased = keyword.lowercased()
        return countries.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.code.lowercased().contains(lowercased) ||
            $0.capital.lowercased().contains(lowercased) ||
            $0.region.lowercased().contains(lowercased)
        }
    }
}
