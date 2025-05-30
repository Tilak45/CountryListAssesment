//
//  CountriesEndpoint.swift
//  CountryListAssessment
//
//  Created by Tilak K on 30/05/25.
//
import Foundation

struct CountriesEndpoint: APIEndpoint {
    let baseURL: BaseURL = .baseUrl
    let path: String = "/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    let method: HttpMethodType = .get
    let body: Data? = nil
}
