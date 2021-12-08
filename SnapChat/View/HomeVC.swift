//
//  HomeVC.swift
//  SnapChat
//
//  Created by Tolga on 24.09.2021.
//

import UIKit
import Firebase
import SDWebImage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getSnapsFromFirebase()
        getUserInfo()
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func makeAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }

    
    func getSnapsFromFirebase() {
        
        Firestore.firestore().collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    // Saatleri ayları yılları karşılaştıracaksak eğer Calendar objesini kullanmamız gerekiyor
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if difference >= 24 {
                                            Firestore.firestore().collection("Snaps").document(documentId).delete { error in
                                                if error != nil {
                                                    self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
                                                }
                                            }
                                        } else {
                                            
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                            self.snapArray.append(snap)
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }
    
    
    
    func getUserInfo() {
        
        Firestore.firestore().collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapshot, error in
            
            if error != nil {
                self.makeAlert(title: "Hata", message: error?.localizedDescription ?? "Hata")
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        
                        if let username = document.get("username") as? String {
                            
                            UserSingleton.sharedUserInfo.username = username
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeCell
        cell.homeUserNameLabel.text = snapArray[indexPath.row].username
        cell.homeImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
        
    }
    
    

}
