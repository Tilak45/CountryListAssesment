//
//  CountryListViewModel.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//
import Foundation

class CountriesViewModel {

    private let countryService: CountryServiceProtocol
    var allCountries: [Country] = []
    private(set) var filteredCountries: [Country] = []

    var onDataUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    init(countryService: CountryServiceProtocol = CountryService()) {
        self.countryService = countryService
    }

    func fetchCountries() async {
        do {
            let countries = try await countryService.fetchCountries()
            self.allCountries = countries
            self.filteredCountries = countries
                self.onDataUpdated?()

        } catch {
                self.onError?(error)
        }
    }

    func filterCountries(searchText: String) {
        if searchText.isEmpty {
            filteredCountries = allCountries
        } else {
            filteredCountries = countryService.filterCountries(allCountries, by: searchText)
        }
        onDataUpdated?()
    }
}
