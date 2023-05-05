//
//  GridViewController.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit
import Combine

class GridViewController: UIViewController {
    
    private var viewModel = GridViewModel()
    private var images = [UIImage]()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.fetchImages()
        view.backgroundColor = UIColor(named: K.Colors.background)
    }
    
    private func bind() {
        _ = viewModel.$images.sink { images in
            self.images = images
            print("got images in vc")
        }
    }
}

