//
//  SignUpVC.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import Firebase
class SignUpVC: UIViewController {

    
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordConfirmTF: UITextField!
    @IBOutlet weak var userPaswwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpButtonClicked(_ sender: Any) {
        if userEmailTF.text != "" || userNameTF.text != "" || userPaswwordTF.text != "" || passwordConfirmTF.text != "" {
       
            if userPaswwordTF.text == passwordConfirmTF.text {
                Auth.auth().createUser(withEmail: userEmailTF.text!, password: userPaswwordTF.text!) { authData, error in
                    if error != nil {
                        AlertManager.alert(title: "Error", message: error?.localizedDescription ?? "undefined error", vc: self)
                    }else{
                        
                        self.setDataToFirestore()
                        
                        self.performSegue(withIdentifier: "toLogInScreen", sender: nil)
                    }
                }
            }else{
                AlertManager.alert(title: "Error", message: "Passwords not match", vc: self)
            }
        }else{
            AlertManager.alert(title: "Error", message: "fields not be blank", vc: self)
        }
    }
    
    func setDataToFirestore(){
        let firestore = Firestore.firestore()
        let userDictionary = ["email":self.userEmailTF.text!, "username": self.userNameTF.text!] as [String:Any]
        firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
            if error != nil {
                AlertManager.alert(title: "Error", message: error?.localizedDescription ?? "no internet connection", vc: self)
            }else{
                AlertManager.alert(title: "Success", message: "Registration is success", vc: self)
            }
        }
    }
}
