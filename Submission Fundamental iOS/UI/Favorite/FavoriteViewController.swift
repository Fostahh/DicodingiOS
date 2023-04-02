//
//  FavoriteViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 02/04/23.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Your Favorite Games"
        configureTableView()
        bindObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.retrieveGames()
    }
    
    private func configureTableView() {
        tableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: GameTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func bindObserver() {
        viewModel.loadingObservable = { [weak self] isLoading in
            self?.configureView(isLoading: isLoading)
            if isLoading {
                self?.loadingView.startAnimating()
            } else {
                self?.loadingView.stopAnimating()
            }
        }
        
        viewModel.errorObservable = { [weak self] errorMessage in
            self?.configureView(isError: true, errorMessage: errorMessage)
        }
        
        viewModel.gamesObservable = { [weak self] _ in
            self?.configureView()
            self?.tableView.reloadData()
        }
    }
    
    private func configureView(isLoading: Bool = false, isError: Bool = false, errorMessage: String = "") {
        if isLoading {
            loadingView.isHidden = false
            tableView.isHidden = true
            informationLabel.isHidden = true
            informationLabel.text = nil
        } else {
            loadingView.isHidden = true
            tableView.isHidden = isError
            informationLabel.isHidden = !isError
            informationLabel.text = errorMessage
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    
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

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailGameViewController(nibName: "DetailGameViewController", bundle: nil)
        detailVC.gameId = viewModel.getVideoGame(indexPath: indexPath.row).id
        detailVC.isFromFavoriteScreen = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
