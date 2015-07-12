//
//  LoginViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/9/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

// MARK: CLASS INIT
class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var imageLogo: UIImageView?
    var currentTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewStyling()
        initImageLogo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewStyling() {
        let orange = ColorsPallete.orangeDark()
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [ColorsPallete.orangeLight().CGColor, ColorsPallete.orangeDark().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        loginView.alpha = 0.0
        loginButton.alpha = 0.0
        loginView.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        
        usernameTextField.layer.borderColor = orange.CGColor
        usernameTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = orange.CGColor
        passwordTextField.layer.borderWidth = 0.5
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: orange])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: orange])
    }
}

extension LoginViewController: POPAnimationDelegate {
    
    func initImageLogo() {
        var image = UIImage(named: "Icon")
        
        imageLogo = UIImageView(frame: CGRectMake(view.center.x - (image!.size.width / 2), view.center.y - (image!.size.height / 2), image!.size.width, image!.size.height))
        imageLogo!.image = image
        view.addSubview(imageLogo!)
        
        viewWillAnimateLogo()
    }
    
    func viewWillAnimateLogo() {
        
        let origin = imageLogo!.frame.origin
        let size = imageLogo!.frame.size
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        let destinationFrame = CGRectMake(origin.x, origin.y - 150.0, size.width, size.height)
        
        animation.springSpeed = 0.5
        animation.toValue = NSValue(CGRect: destinationFrame)
        animation.name = "imageLogo"
        animation.delegate = self
        
        imageLogo!.pop_addAnimation(animation, forKey: "imageLogo")
    }
    
    func viewWillAnimateLoginView() {
        
        let animation = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        
        animation.toValue = 0.5
        animation.name = "loginView"
        animation.delegate = self
        
        loginView.pop_addAnimation(animation, forKey: "loginView")
    }
    
    func viewWillAnimateLoginButton() {
        
        let animation = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
        
        animation.toValue = 1.0
        animation.name = "loginButton"
        animation.delegate = self
        
        loginButton.pop_addAnimation(animation, forKey: "loginButton")
    }
    
    func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        
        if anim.name == "imageLogo" {
            imageLogo!.pop_removeAnimationForKey("imageLogo")
            viewWillAnimateLoginView()
            viewWillAnimateLoginButton()
        } else if anim.name == "loginView" {
            loginView.pop_removeAnimationForKey("loginView")
            loginView.pop_removeAnimationForKey("loginButton")
        }
        
    }
}

// MARK: UITEXTFIELD
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextField = textField
        currentTextField?.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func viewDidTapped(sender: AnyObject) {
        currentTextField?.resignFirstResponder()
    }
}

// MARK: UIBUTTON
extension LoginViewController {
    
    @IBAction func loginButtonDidTapped(sender: AnyObject) {
        
        if count(usernameTextField.text) < 1 ||
           count(passwordTextField.text) < 1 {
            showAlertForInvalidCredentials()
        } else {
            performSegueWithIdentifier("showTabBarController", sender: self)
        }
    }
}

// MARK: ALERT
extension LoginViewController {
    
    func showAlertForInvalidCredentials() {
        
        let alert = UIAlertController(title: "Invalid Credentials", message: "You have inserted incorrect username or password", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
