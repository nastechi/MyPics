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
    private var images = [ImageModel]()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        layoutView()
        setupBindings()
        viewModel.fetchImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupCollectionView() {
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: K.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupBindings() {
            viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                
                self?.images = images
                if self?.images.count ?? 0 > 0 {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        }
    
    private func bind() {
        _ = viewModel.$images.sink { [weak self] images in
            self?.images = images
            print(images)
            self?.collectionView.reloadData()
        }
    }
    
    private func goToDetailsScreen(image: UIImage) {
        navigationController?.pushViewController(DetailsViewController(gridImage: image), animated: true)
    }
    
    private func layoutView() {
        view.backgroundColor = UIColor(named: K.Colors.background)
        view.addSubview(collectionView)
        setupConstrains()
        navigationController?.isToolbarHidden = true
    }
    
    private func setupConstrains() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension GridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailsViewController(gridImage: images[indexPath.row].fullSize), animated: true)
    }
    
}

extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as? GridCollectionViewCell {
            cell.setupCell(with: images[indexPath.row].preview)
            return cell
        }
        return GridCollectionViewCell()
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.size.width / 3 - 20, height: view.frame.size.width / 3 - 20)
    }
}
