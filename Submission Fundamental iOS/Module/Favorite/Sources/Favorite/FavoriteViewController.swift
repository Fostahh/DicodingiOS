//
//  FavoriteViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 02/04/23.
//

import Foundation
import UIKit
import Combine
import Core
import Common

public class FavoriteViewController: UIViewController {
    
    // MARK: - Navigation
    public enum Navigation {
        case detailVideoGame(Int)
    }
    public var onNavigationEvent: ((Navigation) -> Void)?
    
    // MARK: - Init
    public init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FavoriteViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    private let viewModel: FavoriteViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Override Methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Your Favorite Games"
        configureTableView()
        bindObserver()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.retrieveGames()
    }
    
    // MARK: - Private Methods
    private func configureTableView() {
        tableView.registerCellNib(GameTableViewCell.self, module: CommonConstants.module)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
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
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)

        viewModel.errorObservable
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.configureView(isError: true, errorMessage: errorMessage)
            })
            .store(in: &cancellables)
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

extension FavoriteViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onNavigationEvent?(.detailVideoGame(viewModel.getVideoGame(indexPath: indexPath.row).id))
    }
}
