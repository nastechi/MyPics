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
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.center = view.center
        loader.color = UIColor(named: K.Colors.accent)
        loader.hidesWhenStopped = true
        loader.startAnimating()
        return loader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBindings()
        layoutView()
        viewModel.fetchImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
                    self?.loader.stopAnimating()
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func goToDetailsScreen(image: UIImage) {
        navigationController?.pushViewController(DetailsViewController(gridImage: image), animated: true)
    }
    
    private func layoutView() {
        view.backgroundColor = UIColor(named: K.Colors.background)
        view.addSubview(collectionView)
        view.addSubview(loader)
        navigationController?.isToolbarHidden = true
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
        let side = (view.frame.size.width / K.CollectionSizes.numberOfItemsPerRow) - K.CollectionSizes.spacing
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        K.CollectionSizes.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        K.CollectionSizes.spacing
    }
}
