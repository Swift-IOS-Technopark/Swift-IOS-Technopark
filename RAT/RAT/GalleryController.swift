//
//  GalleryController.swift
//  RAT
//
//  Created by Анастасия Шахлан on 17.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class GalleryController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pictureForButton: UIButton!
    
    @IBAction func galleryButton(_ sender: Any) {
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        pictureForButton.setTitle("", for: .normal)
        pictureForButton.setBackgroundImage(info[UIImagePickerControllerOriginalImage] as? UIImage, for: .normal)
        self.dismiss(animated: true, completion: nil)
        
    }

}
