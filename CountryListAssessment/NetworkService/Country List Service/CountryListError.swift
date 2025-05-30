//
//  CountryListError.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//
import Foundation

enum CountryError: Error, LocalizedError {
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .decodingError(let err): return "Decoding failed: \(err.localizedDescription)"
        case .networkError(let err): return "Network failed: \(err.localizedDescription)"
        }
    }
}
