//
//  CustomNavigationController.swift
//  MyPics
//
//  Created by Анастасия on 05.05.2023.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.hidesBarsOnTap = false
        return super.popViewController(animated: animated)
    }

}
