//
//  CountryTableViewHandler.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//

import UIKit

final class CountryTableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: CountriesViewModel

    init(viewModel: CountriesViewModel) {
        self.viewModel = viewModel
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryListTableViewCell.identifier, for: indexPath) as? CountryListTableViewCell else {
            return UITableViewCell()
        }

        let country = viewModel.filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}
