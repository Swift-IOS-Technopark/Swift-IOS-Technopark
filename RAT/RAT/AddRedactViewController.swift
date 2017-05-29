//
//  AddRedactViewController.swift
//  RAT
//
//  Created by Алексаndr on 21.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class AddRedactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var pictureData : NSData = NSData.init()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var vinTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var marketSwitch: UISwitch!
    
    //buttons
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var imageButton: UIButton!
  //<UIImage: 0x608000490950> size {3000, 2002} orientation 0 scale 1.000000
    @IBAction func addImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
 
    
    var vehicle: Vehicle? = nil
    
    var person = Person()
    //MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        person = DataBaseHelper.getPerson()
        
        //config buttons
        if vehicle == nil{
            saveButton.isHidden = true
            deleteButton.isHidden = true
            addButton.isHidden = false
            marketSwitch.isOn = false
        }
        else{
            
            vinTextField.text = vehicle?.VIN
            numberTextField.text = vehicle?.number
            brandTextField.text = vehicle?.brand
            modelTextField.text = vehicle?.model
            yearTextField.text = vehicle?.year
            marketSwitch.isOn = (vehicle?.isAuction)!
            
            saveButton.isHidden = false
            deleteButton.isHidden = false
            addButton.isHidden = true

        }
        if vehicle != nil {
            if let image = vehicle!.picture as Data? {
                photoImageView.image = UIImage.init(data: image)
            }
            else{
                photoImageView.image = UIImage.init(named: "машина2")
            }
        }
        else{
            photoImageView.image = UIImage.init(named: "машина2")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(addVehicleCallback(_:)), name: .addVehicleCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeVehicleCallback(_:)), name: .changeVehicleCallback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteVehicleCallback(_:)), name: .deleteVehicleCallback, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        addTapGestureToHideKeyboard()
        /*
         @IBOutlet weak var numberTextField: UITextField!
         @IBOutlet weak var vinTextField: UITextField!
         @IBOutlet weak var brandTextField: UITextField!
         @IBOutlet weak var modelTextField: UITextField!
         @IBOutlet weak var yearTextField: UITextField!

 */
        
        numberTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        numberTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        vinTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        vinTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        brandTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        brandTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        modelTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        modelTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
        yearTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        yearTextField.borderStyle = UITextBorderStyle(rawValue: 0)!
        
    }
    
    
    
    @IBAction func addVehicle(_ sender: Any) {
        
        vehicle = Vehicle()
        vehicle?.VIN = vinTextField.text!
        vehicle?.number = numberTextField.text!
        vehicle?.brand = brandTextField.text!
        vehicle?.model = modelTextField.text!
        vehicle?.year = yearTextField.text!
        vehicle?.owner = person
        vehicle?.isAuction = marketSwitch.isOn
        APIHelper.addVehiclesRequest(vehicle: vehicle!,user: person)
    }
    
    @IBAction func saveChangeOfVehicle(_ sender: Any) {
        let id = vehicle?.id
        vehicle = Vehicle()
        vehicle?.id = id!
        vehicle?.VIN = vinTextField.text!
        vehicle?.number = numberTextField.text!
        vehicle?.brand = brandTextField.text!
        vehicle?.model = modelTextField.text!
        vehicle?.year = yearTextField.text!
        vehicle?.owner = person
        vehicle?.isAuction = marketSwitch.isOn
        APIHelper.changeVehicleRequest(vehicle: vehicle!)
//        vehicle?.picture = pictureData
        DataBaseHelper.setVehiclePicture(data: pictureData, vehicle: vehicle!)
        
    }
    
    @IBAction func deleteVehicle(_ sender: Any) {
        APIHelper.deleteVehicleRequest(vehicle: vehicle!)
    }
    
    
    
    //call backs
    func addVehicleCallback(_ notification: NSNotification){
        print("call_back")
        let data = notification.userInfo
        let id = data?["vehicle_id"] as! Int
        vehicle?.id=id
        DataBaseHelper.setVehicle(person: person, vehicle: vehicle! )
        DataBaseHelper.setVehiclePicture(data: pictureData, vehicle: vehicle!)
        APIHelper.getListOfVehiclesRequest()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func changeVehicleCallback(_ notification: NSNotification){
        print("call_back")
        DataBaseHelper.setVehicle(vehicle: vehicle! )
        
        APIHelper.getListsOfVehiclesAndCrashesRequest()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func deleteVehicleCallback(_ notification: NSNotification){
        print("call_back")
        DataBaseHelper.deleteVehicle(vehicle: vehicle! )
        APIHelper.getListsOfVehiclesAndCrashesRequest()
        //perfom seg for back
        //
        //self.navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "FromDeleteVehicleToVehicleController", sender: self)
    }
    
    
    
    
    
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //  imageField.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
       // photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // надо для сохранения фото в профиле
        
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        pictureData = UIImageJPEGRepresentation( photoImageView.image!, 1)! as NSData
        
      //  vehicle?.picture = pictureData
//        if vehicle != nil {
//            DataBaseHelper.setVehiclePicture(data: pictureData, vehicle: vehicle!)
//        }
        print("picture")
        //photoImageView.image = UIImage.init(data: vehicle?.picture as! Data)
        
        self.dismiss(animated: true, completion: nil)
        
    }/*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
 
        // Set photoImageView to display the selected image.
//        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
*/
    /*
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        //nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerController, animated: true, completion: nil)
    }
*/

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
        
        numberTextField.resignFirstResponder()
        vinTextField.resignFirstResponder()
        brandTextField.resignFirstResponder()
        modelTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        
        
        
    }
}
