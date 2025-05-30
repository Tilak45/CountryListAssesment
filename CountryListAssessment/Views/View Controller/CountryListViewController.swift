//
//  CountryListViewController.swift
//  CountryListAssessment
//
//  Created by Tilak k on 30/05/25.
//

import UIKit
protocol CountryListView: AnyObject {
    var tableView: UITableView { get }
    var noResultsLabel: UILabel { get }
    var searchController: UISearchController { get }
}

class CountryListViewController: UIViewController, CountryListView {

    let tableView = UITableView()
    let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = CountryListLocalizable.noCountriesFound
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let uiController = CountryListUIController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        uiController.view = self
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
