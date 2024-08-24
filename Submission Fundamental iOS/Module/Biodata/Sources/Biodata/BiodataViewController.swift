//
//  BiodataViewController.swift
//  Submission Fundamental iOS
//
//  Created by Mohammad Azri on 19/08/23.
//

import UIKit
import Common

public class BiodataViewController: UIViewController {
    
    // MARK: - Init
    public init() {
        super.init(nibName: "BiodataViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var authorImageView: UIImageView!
    @IBOutlet private weak var authorName: UILabel!
    
    // MARK: Override Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureAuthorIdentity()
    }
    
    // MARK: - Private Methods
    private func configureAuthorIdentity() {
        authorImageView.image = .loadImageFromAsset(
            CommonImage.author.image,
            class: BiodataViewController.self,
            module: CommonConstants.module,
            renderingMode: .alwaysTemplate
        )
        authorName.text = "Mohammad Azri Khairuddin"
    }
    
}
