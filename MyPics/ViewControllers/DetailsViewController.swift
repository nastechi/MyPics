//
//  DetailsViewController.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let gridImage: UIImage
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = gridImage
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(gridImage: UIImage) {
        self.gridImage = gridImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func layoutView() {
        view.backgroundColor = UIColor(named: K.Colors.background)
        view.addSubview(imageView)
        setupConstrains()
    }
    
    private func setupConstrains() {
        
        let multiplier = view.frame.width / gridImage.size.width
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: gridImage.size.height * multiplier).isActive = true
    }

}
