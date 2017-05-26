//
//  ViewController.swift
//  RAT
//
//  Created by Kirill on 3/16/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase

class ViewController: UIViewController {


    
    @IBOutlet weak var imageLabelView: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var registrationLabel: UILabel!
    
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var vkLogInButton: UIButton!
    
    @IBOutlet weak var facebookLogInButton: UIButton!
    
    @IBOutlet weak var fbView: UIView!
    
    @IBOutlet weak var vkView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func logIn(_ sender: Any) {
        // TODO: проверить вводимые поля
        /*
        person.email = emailTextField.text!
        person.password = passwordTextField.text!
         */
        let person = Person()
        person.email = "user@mail.ru"
        person.password = "qwerty"
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in // 2
            if let err = error { // 3
                print(err.localizedDescription)
                return
            }
        })
        APIHelper.logInRequest(person: person)
        
    }
    
    @IBAction func vkLogIn(_ sender: Any) {
        let vk = VKHelper()
        vk.authorize()
        vk.getState()
    }
    
    @IBAction func facebookLogIn(_ sender: Any) {
        
    }
    
    func logInCallback(_ notification: NSNotification){
        let person = Person()
        let data = notification.userInfo
        let id = data?["user_id"] as! Int
        let email = data?["email"] as! String
        let firstname = data?["firstname"] as! String
        let lastname = data?["lastname"] as! String
        let phone = data?["phone"] as! String
        DataBaseHelper.clearActualPerson()
        DataBaseHelper.setPerson(person: person, id: id, email: email, firstname: firstname, lastname: lastname, phone: phone, actual: true)
        performSegue(withIdentifier: "fromAuthorizationToListOfVehiclesSegue", sender: person)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(logInCallback(_:)), name: .logInCallback, object: nil)
        
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        emailTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        passwordTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        // сделать navigationBar прозрачным
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        addTapGestureToHideKeyboard()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAuthorizationToListOfVehiclesSegue"{
            APIHelper.getListsOfVehiclesAndCrashesRequest()
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 100), animated: true)
       // scrollView.contentSize.height = 610
    }
    
    func keyboardWillHide(_ notification: Notification) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: -64), animated: true)
        //scrollView.contentSize.height = 500
        
    }
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    func tapGesture() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
   


}

