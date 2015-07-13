//
//  ShowDocumentNavigationController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/11/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class ShowDocumentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = ColorsPallete.orangeLight()
        navigationBar.alpha = 1.0
        navigationBar.translucent = false
        
        let gradient = [ColorsPallete.orangeLight().CGColor, ColorsPallete.orangeDark().CGColor]
        CRGradientNavigationBar.appearance().setBarTintGradientColors(gradient)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
