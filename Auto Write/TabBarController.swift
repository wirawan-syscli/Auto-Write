//
//  TabBarController.swift
//  
//
//  Created by wirawan sanusi on 7/11/15.
//
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layer = CALayer()
        layer.frame = CGRectMake(0.0, 0.0, tabBar.frame.size.width, 3.0)
        layer.backgroundColor = ColorsPallete.orangeLight().CGColor
        tabBar.layer.addSublayer(layer)
        
        tabBar.tintColor = ColorsPallete.orangeLight()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
