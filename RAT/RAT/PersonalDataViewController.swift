//
//  PersonalDataViewController.swift
//  RAT
//
//  Created by Алексаndr on 21.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class PersonalDataViewController: UIViewController {

    var person = Person()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        person = DataBaseHelper.getPerson()
        NotificationCenter.default.addObserver(self, selector: #selector(editUserCallback(_:)), name: .editUserCallback, object: nil)
        
        
        emailTextField.text=person.email
        //passwordTextField.text=person.password
        firstnameTextField.text=person.firstname
        lastnameTextField.text=person.lastname
        phoneTextField.text = person.phone
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        addTapGestureToHideKeyboard()
        
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        emailTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        passwordTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        repeatPasswordTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        repeatPasswordTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        phoneTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        phoneTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        lastnameTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        lastnameTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        firstnameTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        firstnameTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
    }
    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    
    @IBAction func saveChange(_ sender: Any) {
        let id = person.id
        person=Person()
        person.actual=true
        person.id=id
        person.email = emailTextField.text!
        //if passwordTextField.text ==""
        //{person.password = passwordTextField.text!}
        
        person.firstname = firstnameTextField.text!
        person.lastname = lastnameTextField.text!
        person.phone = phoneTextField.text!
        
        /*
         person.email = "user@mail.ru"
         person.password = "qwerty"
         person.firstname = "user"
         person.lastname = "userovich"
         person.phone = "88005553535"
         */
        
        
        
        /*
         let nPerson=DataBaseHelper.getPerson()
         nPerson.id=person.id
         nPerson.email=person.email
         nPerson.password=person.password
         nPerson.firstname=person.firstname
         nPerson.lastname=person.lastname
         nPerson.phone=person.phone
         nPerson.vehicles=person.vehicles
         */
        APIHelper.editUserRequest(user: person)
    }
    
    func editUserCallback(_ notification: NSNotification){
        DataBaseHelper.setPerson(person:person)
        self.navigationController?.popViewController(animated: true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        //scrollView.setContentOffset(CGPoint.init(x: 0, y: 110), animated: true)
        scrollView.contentSize.height = 810
    }
    
    func keyboardWillHide(_ notification: Notification) {
        //scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        scrollView.contentSize.height = 500
        
    }
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    func tapGesture() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
        lastnameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        
    }
    


}
