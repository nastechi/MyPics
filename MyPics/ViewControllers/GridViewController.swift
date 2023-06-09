//
//  GridViewController.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit
import Combine

final class GridViewController: UIViewController {
    
    private var viewModel = GridViewModel()
    private var images = [ImageModel]()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: K.Colors.background)
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
        navigationController?.isNavigationBarHidden = true
        setupCollectionView()
        setupBindings()
        layoutView()
        viewModel.fetchImages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstrains()
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
        setupConstrains()
    }
    
    private func setupConstrains() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension GridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let link = images[indexPath.row].link
        if let fullImage = viewModel.getFullImage(forLink: link) {
            let detailVC = DetailsViewController(gridImage: fullImage)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
        }
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
        let numberOfItemsPerRow = Int(view.frame.width / K.CollectionSizes.minimumItemWidth)
        let side = (view.frame.size.width / CGFloat(numberOfItemsPerRow)) - (K.CollectionSizes.spacing * CGFloat(numberOfItemsPerRow - 1))
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        K.CollectionSizes.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        K.CollectionSizes.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: K.CollectionSizes.spacing, left: K.CollectionSizes.spacing, bottom: K.CollectionSizes.spacing, right: K.CollectionSizes.spacing)
    }
}
