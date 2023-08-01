//
//  HomeViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 08/01/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet private var gameSearchBar: UISearchBar!
    @IBOutlet private weak var gameTableView: UITableView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private let viewModel: HomeViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindObserver()
        configureSearchBar()
        configureTableView()
        viewModel.retrieveGames()
    }
    
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
        gameSearchBar.searchTextField.leftView?.tintColor = .systemBlue
        gameSearchBar.searchTextField.backgroundColor = .white
        gameSearchBar.backgroundImage = UIImage()
        gameSearchBar.searchTextField.font = UIFont(name: "KohinoorBangla-Regular", size: 18)
    }
    
    private func configureTableView() {
        gameTableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: GameTableViewCell.identifier)
        gameTableView.rowHeight = UITableView.automaticDimension
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.separatorStyle = .none
        gameTableView.showsHorizontalScrollIndicator = false
        gameTableView.showsVerticalScrollIndicator = false
    }
    
    private func configureView(isLoading: Bool = false, isError: Bool = false, errorMessage: String = "") {
        if isLoading {
            loadingView.isHidden = false
            gameTableView.isHidden = true
            errorLabel.isHidden = true
            errorLabel.text = nil
        } else {
            loadingView.isHidden = true
            gameTableView.isHidden = isError
            errorLabel.isHidden = !isError
            errorLabel.text = errorMessage
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getVideoGamesSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GameTableViewCell.identifier,
            for: indexPath
        ) as? GameTableViewCell else { return UITableViewCell() }
        
        let game = viewModel.getVideoGame(indexPath: indexPath.row)
        cell.selectionStyle = .none
        cell.configureView(game: game)
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailGameViewController(
            viewModel: DetailGameViewModel(useCase: Injection.init().provideDetail()),
            gameId: viewModel.getVideoGame(indexPath: indexPath.row).id
        )
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
