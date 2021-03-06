//
//  MapZoomViewController.swift
//  CoolestProjects
//
//  Created by Richard Toolan on 11/06/2016.
//  Copyright © 2016 coderdojo. All rights reserved.
//

import UIKit

class MapZoomViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: AppColors.yellowColor,
            NSFontAttributeName : AppFonts.navbarTitleFont
        ]
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = self.image
        self.title = self.navigationTitle
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MapZoomViewController.donePressed)), animated: false)
        
        let buttonAttributes = [
            NSFontAttributeName: AppFonts.navigationBarButton,
            NSForegroundColorAttributeName: AppColors.yellowColor
        ]
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: .normal)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView;
    }
    
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
