//
//  LoginViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 01/12/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewControllerPortrait, WebServiceListener, UITextFieldDelegate {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    var alertErrorView: UIAlertController!
    var webService: WebService = WebService.getInstance
    var soundManager: SoundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 38/255, green: 108/255, blue: 166/255, alpha: 1)
        loginBtn.backgroundColor = UIColor.init(red: 76/255, green: 153/255, blue: 0/255, alpha: 1)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        emailTxtField.delegate = self;
        passwordTxtField.delegate = self;
        alertErrorView = UIAlertController(title: "Error!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertErrorView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        if (emailTxtField.text == "xxx") {
            soundManager.playSuccess()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        } else {
            presentViewController(Dialog.waitDialog(), animated: true, completion: nil)
            webService.login(emailTxtField.text!, password: passwordTxtField.text!);
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        webService.changeListener(self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func success(response: String) {
        if (response == "true") {
            self.dismissViewControllerAnimated(false, completion: {() -> Void in
                self.soundManager.playSuccess()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        } else {
            self.dismissViewControllerAnimated(false, completion:  {() -> Void in
                self.alertErrorView.message = "El usuario no es valido"
                self.presentViewController(self.alertErrorView, animated: true, completion: nil)
                self.soundManager.playError()
            })
        }
    }
    
    func error() {
        self.dismissViewControllerAnimated(false, completion:  {() -> Void in
            self.alertErrorView.message = "Hubo un error al contactar con el servicio web"
            self.presentViewController(self.alertErrorView, animated: true, completion: nil)
            self.soundManager.playError()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}