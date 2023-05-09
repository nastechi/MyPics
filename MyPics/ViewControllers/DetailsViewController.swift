//
//  DetailsViewController.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit

final class DetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let gridImage: UIImage
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = gridImage
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    init(gridImage: UIImage) {
        self.gridImage = gridImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        layoutView()
        addPinchGesture()
    }
    
    private func addPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
        pinch.delegate = self
        imageView.addGestureRecognizer(pinch)
    }
    
    @objc private func didPinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            setImageViewFrame(scale: sender.scale)
        } else if sender.state == .ended || sender.state == .cancelled || sender.state == .failed {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setImageViewFrame(scale: 1)
            }
        }
    }
    
    private func layoutView() {
        view.backgroundColor = UIColor(named: K.Colors.background)
        view.addSubview(imageView)
        setImageViewFrame(scale: 1)
        navigationController?.hidesBarsOnTap = true
    }
    
    private func setImageViewFrame(scale: CGFloat) {
        let multiplier = view.frame.width / gridImage.size.width
        
        imageView.frame = CGRect(x: 0, y: 0, width: Int(view.frame.width * scale), height: Int(gridImage.size.height * multiplier * scale))
        imageView.center = view.center
    }

}
