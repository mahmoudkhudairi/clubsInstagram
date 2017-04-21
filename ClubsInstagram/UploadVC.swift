//
//  UploadVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class UploadVC: UIViewController {
    var userName = ""
    var userProfilePicture = ""
    var postIsLiked = false
    var numberOfPostLikes = 0
    var postNum = 0
    var postId = ""
    
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        handleImage()
       
        UploadButton.isEnabled = false
    }
    
        
   
    
    @IBAction func UploadButtonTapped(_ sender: Any) {
    
       
        if photoImageView.image == UIImage(named: "tapmeimage"){
            
        }else{
            
        
        
          //  guard let userUid = FIRAuth.auth()?.currentUser?.uid else {return}
        
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("postsImages").child("\(imageName).jpeg")
            
            let image = self.photoImageView.image
            guard let imageData = UIImageJPEGRepresentation(image!, 0.1) else { return }
            
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            storageRef.put(imageData, metadata: metaData, completion: { (metadata, error) in
                
                if error != nil {
                    print("Image error: \(error)")
                    return
                }
                
                if let photoImageUrl = metadata?.downloadURL()?.absoluteString,
                    let captionText = self.captionTextView.text {
                    guard let userUid = FIRAuth.auth()?.currentUser?.uid else {return}
                    FIRDatabase.database().reference().child("users").child(userUid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            let user = User(dictionary: dictionary)
                            
                            user.id = snapshot.key
                            guard let username = user.name,
                            let pic = user.profileImageUrl else {return}
                            
                             self.userName = username
                             self.userProfilePicture = pic
                         
                        }
                        //TODO:Add the liked bool and Int
                        let values = ["caption": captionText, "userId": userUid, "postImageUrl": photoImageUrl,"userName":self.userName, "userProfileImageURL":self.userProfilePicture, "likeImageIsTapped": self.postIsLiked, "numberOfLikes": self.numberOfPostLikes] as [String : Any]
                        self.registerPostIntoDataBase(userUid, values: values as [String : AnyObject])
                        
                    }, withCancel: nil)
                   
                   
                }
               
                
            })
            self.photoImageView.image = UIImage(named: "tapmeimage")
            self.tabBarController?.selectedIndex = 0
           
        
            

        }
        
    }

    func registerPostIntoDataBase(_ uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://clubsinstagram.firebaseio.com/")
       
        let postsReference = ref.child("posts").childByAutoId()
        postsReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("Error saving user: \(err)")
                return
            }
            
            let posts = ["posts/\( postsReference.key)" : true]
            
            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(posts)
           
            
        })
      
         self.captionTextView.text = ""
        
    }
   
    func handleImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(choosePostImage))
        
        photoImageView.isUserInteractionEnabled = true
       photoImageView.addGestureRecognizer(tap)
    }

    func choosePostImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    
   

}
extension UploadVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            photoImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        UploadButton.isEnabled = true
    }
    
}
