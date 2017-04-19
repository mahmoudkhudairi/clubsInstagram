//
//  EditVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

class EditVC: UIViewController {
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var currentUserID : String = ""
    var ref : FIRDatabaseReference!
    var profileImageUrl : String = ""
    var profileName : String = ""
    var profileDesc : String = ""
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var descTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        handleImage()
        if let id = currentUser?.uid {
            print("Current user id: \(id)")
            currentUserID = id
        }
        
        listenToFireBase()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func handleImage(){
        
        profileImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        profileImageView.addGestureRecognizer(tap)
        
    }
    
    func chooseProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    
    func loadProfile() {
        nameTextField.text = profileName
        descTextView.text = profileDesc
        
        let imageUrl = profileImageUrl
        profileImageView.loadImageUsingCacheWithUrlString(imageUrl)
        
    }
    
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        let updatedProfileName = nameTextField.text
        let updatedProfileDesc = descTextView.text
        //let updatedImageUrl = #imageLiteral(resourceName: "filled-heart")
        
        
        let values : [String : Any] = ["name": updatedProfileName ?? "User", "desc": updatedProfileDesc ?? "Add a Description"]
        ref.child("users").child("\(currentUserID)").updateChildValues(values)
       self.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImage(_ image: UIImage) {
        let imageName = FIRAuth.auth()?.currentUser?.email
        let ref = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.put(imageData, metadata: nil, completion: { (meta, error) in
//        ref.child("\(currentUser?.email)").put(imageData, metadata: metaData) { (meta, error) in
            
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                //save to firebase database
                self.saveImagePath(downloadPath)
                
                print("")
            }
            
        })
        
        
    }
    
    func saveImagePath(_ path: String) {
        
        let profilePictureValue : [String: Any] = ["profileImageUrl": path]
        
        ref.child("users").child(currentUserID).updateChildValues(profilePictureValue)
    }
    
    func listenToFireBase() {
        ref.child("users").child(currentUserID).observe(.value, with: { (snapshot) in
            print("Value : ", snapshot)
            
            let dictionary = snapshot.value as? [String : Any]
            
            
            
            self.profileDesc = (dictionary?["desc"] as! String)
            self.profileName = (dictionary?["name"] as! String)
            self.profileImageUrl = (dictionary?["profileImageUrl"] as! String)
            
            self.loadProfile()
        })
        
    }

    
}
extension EditVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("User canceled out of picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            profileImageView.image = selectedImage
            uploadImage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}




