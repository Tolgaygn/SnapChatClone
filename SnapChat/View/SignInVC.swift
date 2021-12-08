//
//  ViewController.swift
//  SnapChat
//
//  Created by Tolga on 24.09.2021.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func makeAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwText.text != "" {
            
            Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwText.text!) { auth, error in
                
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                } else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
                
            }
            
        } else {
            makeAlert(title: "Hata", message: "Email/Şifre Hatalı")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && userNameText.text != "" && passwText.text != "" {
            
            Auth.auth().createUser(withEmail: self.emailText.text!, password: self.passwText.text!) { auth, error in
                
                if error != nil {
                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                } else {
                    
                    let userInfo = ["email" : self.emailText.text, "username" : self.userNameText.text] as [String:Any]
                    
                    Firestore.firestore().collection("UserInfo").addDocument(data: userInfo) { error in
                        
                        if error != nil {
                            self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                        } else {
                            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                        }
                        
                    }
                    
                }
                
            }
            
        } else {
            makeAlert(title: "Hata", message: "Email/KullanıcıAdı/Şifre Hatalı")
        }
        
    }
    
    

}

