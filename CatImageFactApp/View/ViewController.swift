//
//  ViewController.swift
//  CatImageFactApp
//
//  Created by Mayur Chaudhary on 13/12/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private let viewModel = CatViewModel(apiService: APIService())
    private var cancellables = Set<AnyCancellable>()
    private var isHintDisplayed = false // Flag to track if the hint was shown
    
    //MARK:- UIViewController Life Cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchCatData()
    }
    
    // MARK:- Data SetUp Methods
    private func setupUI() {
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        // For Loading Facts
        viewModel.$catFact
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fact in
                self?.factLabel.text = fact
            }
            .store(in: &cancellables)
        
        // For Loading Cat Image URL
        viewModel.$catImageURL
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageURL in
                guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }
                self?.imageLoader.startAnimating()
                self?.imageView.loadImage(from: url) {
                    self?.imageLoader.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // For Showing Loader in Controller
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loader.startAnimating()
                } else {
                    self?.loader.stopAnimating()
                    self?.showHintIfNeeded() // Show hint after the first request
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func screenTapped() {
        viewModel.fetchCatData()
    }
    
    private func showHintIfNeeded() {
        // Show hint only if it hasn't been displayed yet
        guard !isHintDisplayed else { return }
        isHintDisplayed = true
        
        hintLabel.alpha = 1
        UIView.animate(withDuration: 2.0, delay: 2.0, options: []) { [weak self] in
            self?.hintLabel.alpha = 0
        }
    }
}

