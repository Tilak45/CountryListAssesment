//
//  Localization.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//
import Foundation

enum CountryListLocalizable {
    static let noCountriesFound = NSLocalizedString("No countries found", comment: "Displayed when no countries match the search")
    static let countriesTitle = NSLocalizedString("Countries", comment: "Title for countries screen")
    static let searchPlaceholder = NSLocalizedString("Search Country or Capital", comment: "Placeholder text for country search bar")
}

enum CountryListCellConstants {
    static let capitalPrefix = NSLocalizedString("Capital: ", comment: "Prefix label for country's capital city")
    static let identifier = "CountryListTableViewCell"
    static let fatalInitCoderMessage = "init(coder:) has not been implemented"
}
