//
//  UploadVC.swift
//  SnapChat
//
//  Created by Tolga on 24.09.2021.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uploadImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        uploadImageView.addGestureRecognizer(imageTapRecognizer)
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @objc func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        uploadImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { metadate, error in
                
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error != nil {
                            print("Hata Var")
                        } else {
                            
                            let imageURL = url?.absoluteString
                            
                            
                            
                            Firestore.firestore().collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                
                                if error != nil {
                                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                                } else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        for document in snapshot!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                
                                                imageUrlArray.append(imageURL!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                                
                                                Firestore.firestore().collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                    
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(systemName: "plus.app")
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    } else {
                                        
                                        let snapDocument = ["imageUrlArray" : [imageURL], "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp() ] as [String : Any]
                                        
                                        Firestore.firestore().collection("Snaps").addDocument(data: snapDocument) { error in
                                            
                                            if error != nil {
                                                self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                                            } else {
                                                
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(systemName: "plus.app")
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
    func makeAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    

    
}
