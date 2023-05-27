//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource{
 
    
    @IBOutlet weak var tableView: UITableView!
    let dB = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        getSnapsFromFirebase()
        getUserInfo()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.userName.text = snapArray[indexPath.row].username
        let imageURL = URL(string: snapArray[indexPath.row].imageUrlArray[0])
        cell.configure(withImageURL: imageURL!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 600 // İstediğiniz hücre yüksekliğini burada belirtebilirsiniz
        }
    func getSnapsFromFirebase(){
        dB.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                AlertManager.alert(title: "error", message: error?.localizedDescription ?? "undefined error", vc: self)
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentId = document.documentID
                        if let username = document.get("snapOwner") as? String{
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp{
                                    
                                    //show Remain time
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24 {
                                            //Delete Snap
                                            self.dB.collection("Snaps").document(documentId).delete { error in
                                                if error != nil {
                                                    AlertManager.alert(title: "error", message: error?.localizedDescription ?? "delete snap error", vc: self)
                                                }
                                            }
                                        }else{
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(),timeDifference: 24 - difference)
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
    
    
    func getUserInfo(){
        
        dB.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
            .getDocuments { snapshot, error in
                if error != nil {
                  print("Error")
                }else{
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents{
                            if let userName = document.get("username") as? String{
                                UserInfo.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                UserInfo.sharedUserInfo.username = userName
                                
                        }
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.sourceSnap = chosenSnap
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
