//
//  Extensions.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import Foundation
import UIKit
import Firebase
var numberOfLikes = Int()

extension SignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            pictureImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
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
    }
    
}
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
   
    func circlerImage(){
               self.layer.cornerRadius = self.frame.height/2
                   self.layer.masksToBounds = true
    }
    
    
    //1 . Move this out from extension, to cell instead
    //2 . split this into 2 functions : set gesture and observe
    //3. use parameters
    
    func observeLikesOnPost(_ postID: String) {
        FIRDatabase.database().reference().child("post").child(postID).child("numberOfLikes").observe(.value) { (snapshot) in
            
        }
    }
    func callTapGesture(){
    
        FIRDatabase.database().reference().child("posts").observe(.value, with: { (snapshot) in
            
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                if(post.likeImageIsTapped == true){
                    
                }
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleLike))
                tap.numberOfTapsRequired = 1
                self.addGestureRecognizer(tap)
                self.isUserInteractionEnabled = true
            }
            
        }, withCancel: nil)
        
        
    }
    func handleLike (){
        
        
        
        //        let values : [String : Any] = ["numberOfLikes": numberOfLikes ?? "User", "likeImageIsTapped": updatedProfileDesc ?? "Add a Description"]
        //        ref.child("users").child("\(currentUserID)").updateChildValues(values)
        
        self.image = UIImage(named: "filled-heart")
        
    }

    
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
      
    
       //self.image = nil //it wasn't working before that !!
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
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

