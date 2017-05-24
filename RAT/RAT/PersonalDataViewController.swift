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
        
        
    }
    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    
    
    
    
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
    
    
    


}
