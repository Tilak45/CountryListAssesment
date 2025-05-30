//
//  CountryListUIViewController.swift
//  CountryListAssessment
//
//  Created by Tilak K on 30/05/25.
//
import UIKit

class CountryListUIController: NSObject {

    weak var view: CountryListView? {
        didSet {
            guard let view = view else { return }
            configure(view: view)
        }
    }
    
    private let viewModel = CountriesViewModel()
    private var tableViewHandler: CountryTableViewHandler!

    private func configure(view: CountryListView) {
        setupUI(view: view)
        configureTableView(view: view)
        configureSearchController(view: view)
        setupBindings()
        fetchData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI(view: CountryListView) {
        // Configure view controller UI properties (e.g., title, background)
        if let vc = view as? UIViewController {
            vc.title = CountryListLocalizable.countriesTitle
            vc.view.backgroundColor = .systemBackground
            vc.navigationController?.navigationBar.prefersLargeTitles = true
            vc.navigationItem.largeTitleDisplayMode = .always
        }
        
        view.noResultsLabel.isHidden = true
    }
    
    private func configureTableView(view: CountryListView) {
        view.tableView.register(CountryListTableViewCell.self, forCellReuseIdentifier: CountryListTableViewCell.identifier)
        tableViewHandler = CountryTableViewHandler(viewModel: viewModel)
        view.tableView.dataSource = tableViewHandler
        view.tableView.delegate = tableViewHandler
        view.tableView.rowHeight = UITableView.automaticDimension
        view.tableView.estimatedRowHeight = 80
    }
    
    private func configureSearchController(view: CountryListView) {
        view.searchController.searchResultsUpdater = self
        view.searchController.obscuresBackgroundDuringPresentation = false
        view.searchController.searchBar.placeholder = CountryListLocalizable.searchPlaceholder
        
        if let vc = view as? UIViewController {
            vc.navigationItem.searchController = view.searchController
            vc.definesPresentationContext = true
        }
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let view = self.view else { return }
                view.tableView.reloadData()
                view.noResultsLabel.isHidden = !self.viewModel.filteredCountries.isEmpty
            }
        }
    }
    
    // MARK: - Data Fetch
    
    private func fetchData() {
        Task {
            await viewModel.fetchCountries()
        }
    }
}

extension CountryListUIController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.filterCountries(searchText: query)
    }
}
