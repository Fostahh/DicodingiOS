//
//  HomeViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import UIKit
import Combine
import Core
import Common

public class HomeViewController: UIViewController {
    
    // MARK: - Navigation
    public enum Navigation {
        case detailVideoGame(Int)
    }
    public var onNavigationEvent: ((Navigation) -> Void)?
    
    // MARK: - Init
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var statusBarView: UIView!
    @IBOutlet private var gameSearchBar: UISearchBar!
    @IBOutlet private weak var gameTableView: UITableView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - Private Properties
    private let viewModel: HomeViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Override Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindObserver()
        configureSearchBar()
        configureTableView()
        viewModel.retrieveGames()
    }
    
    // MARK: - Private Methods
    private func bindObserver() {
        viewModel.loadingObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.configureView(isLoading: isLoading)
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            })
            .store(in: &cancellables)
        
        viewModel.gamesObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.configureView()
                self?.gameTableView.reloadData()
            })
            .store(in: &cancellables)

        viewModel.errorObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.configureView(isError: true, errorMessage: errorMessage)
            })
            .store(in: &cancellables)
        
        bindForSearchBarText()
    }
    
    private func bindForSearchBarText() {
        NotificationCenter.default.publisher(
            for: UISearchTextField.textDidChangeNotification,
            object: gameSearchBar.searchTextField
        ).map { ($0.object as? UISearchTextField)?.text }
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] query in
                if let query = query, !query.isEmpty {
                    self?.viewModel.retrieveGamesByName(query: query)
                } else {
                    self?.viewModel.retrieveGames()
                }
            })
            .store(in: &cancellables)
    }
    
    private func configureSearchBar() {
        navigationItem.titleView = gameSearchBar
        statusBarView.backgroundColor = gameSearchBar.backgroundColor
        gameSearchBar.searchTextField.leftView?.tintColor = .systemBlue
        gameSearchBar.searchTextField.backgroundColor = .white
        gameSearchBar.backgroundImage = UIImage()
        gameSearchBar.searchTextField.font = UIFont(name: "KohinoorBangla-Regular", size: 18)
        gameSearchBar.searchTextField.placeholder = "search_bar_placeholder".localized()
    }
    
    private func configureTableView() {
        gameTableView.registerCellNib(GameTableViewCell.self, module: CommonConstants.module)
        gameTableView.rowHeight = UITableView.automaticDimension
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.separatorStyle = .none
        gameTableView.showsHorizontalScrollIndicator = false
        gameTableView.showsVerticalScrollIndicator = false
    }
    
    private func configureView(isLoading: Bool = false, isError: Bool = false, errorMessage: String = "") {
        loadingView.isHidden = isLoading ? false : true
        gameTableView.isHidden = isLoading ? true : isError
        errorLabel.isHidden = isLoading ? true : !isError
        errorLabel.text = isLoading ? nil : errorMessage
    }
}

extension HomeViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getVideoGamesSize()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GameTableViewCell
        let viewParam = viewModel.getCellViewParam(indexPath: indexPath.row)
        cell.selectionStyle = .none
        cell.configureView(viewParam: viewParam)
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onNavigationEvent?(.detailVideoGame(viewModel.getVideoGame(indexPath: indexPath.row).id))
    }
    
}
