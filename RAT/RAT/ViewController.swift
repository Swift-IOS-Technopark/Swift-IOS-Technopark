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
import VK_ios_sdk
let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
fileprivate var SCOPE: [Any]? = nil



class ViewController: UIViewController,VKSdkDelegate,VKSdkUIDelegate {


    

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
        print("вк_логин")
        SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_OFFLINE]
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
        
        VKSdk.authorize(SCOPE)
        print("авторизация прошла")
        /*
         чтобы добраться до имени, телефона и тп, нужно использовать что-то вроде этого VKSdk.accessToken().localUser.first_name
         но в этой вьюхе работать не будет. почему не знаю. внизу принты раскомменчивать нельзя, висят для примера
         print(VKSdk.accessToken().localUser.first_name)
         print(VKSdk.accessToken().localUser.phone)
         print(VKSdk.accessToken().localUser.mobile_phone)

 */
        
        
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
            //APIHelper.getListsOfVehiclesAndCrashesRequest()
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
    
    func vkSdkShouldPresent(_ controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError) {
        if let captchaVC = VKCaptchaViewController.captchaControllerWithError(captchaError) {
            present(captchaVC, animated: true, completion: nil)
        }
    }
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult) {
        if (result.token != nil) {
            print("авторизован")
            print(result.token.email)
            
        } else if (result.error != nil) {
            let alertVC = UIAlertController(title: "", message: "Access denied\n\(result.error)", preferredStyle: UIAlertControllerStyle.alert)
            alertVC.addAction(okButton)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        let alertVC = UIAlertController(title: "", message: "Access denied", preferredStyle: UIAlertControllerStyle.alert)
        alertVC.addAction(okButton)
        self.present(alertVC, animated: true, completion: nil)
    }



}

