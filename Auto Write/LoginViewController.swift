//
//  LoginViewController.swift
//  Auto Write
//
//  Created by wirawan sanusi on 7/9/15.
//  Copyright (c) 2015 wirawan sanusi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var currentTextField: UITextField?
    var isPlayed: Bool = false
    var destinationFrame: CGRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isPlayed {
            loginView.alpha = 0.0
            loginButton.alpha = 0.0
            loginView.layer.cornerRadius = 5
            loginButton.layer.cornerRadius = 5
            
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("viewWillAnimateLogo"), userInfo: nil, repeats: false)
            
            isPlayed = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initViewStyling() {
        let topBorder = CALayer()
        let orange = UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        topBorder.frame = CGRectMake(0.0, 0.0, passwordTextField.frame.size.width, 0.5)
        topBorder.backgroundColor = orange.CGColor
        passwordTextField.layer.addSublayer(topBorder)
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: orange])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: orange])
    }
}

extension LoginViewController: POPAnimationDelegate {
    
    func viewWillAnimateLogo() {
        initViewStyling()
        
        let origin = imageLogo.frame.origin
        let size = imageLogo.frame.size
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        destinationFrame = CGRect(x: origin.x, y: origin.y - 170.0, width: size.width, height: size.height)
        
        animation.springSpeed = 0.5
        animation.toValue = NSValue(CGRect: destinationFrame)
        animation.name = "imageLogo"
        animation.delegate = self
        
        imageLogo.pop_addAnimation(animation, forKey: "imageLogo")
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
            println(destinationFrame)
            imageLogo.pop_removeAnimationForKey("imageLogo")
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        currentTextField = textField
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        println(imageLogo.frame)
        return true
    }
    
    @IBAction func viewDidTapped(sender: AnyObject) {
        currentTextField?.resignFirstResponder()
    }
}

extension LoginViewController {
    
    @IBAction func loginButtonDidTapped(sender: AnyObject) {
        
        if count(usernameTextField.text) < 1 ||
           count(passwordTextField.text) < 1 {
            showAlertForInvalidCredentials()
        }
    }
}

extension LoginViewController {
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

extension LoginViewController {
    
    func showAlertForInvalidCredentials() {
        let alert = UIAlertController(title: "Invalid Credentials", message: "You have inserted incorrect username or password", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (alert: UIAlertAction!) -> Void in }
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
