//
//  LogInVC.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import Firebase
class LogInVC: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userPasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        if userNameTF.text != "" && userPasswordTF.text != "" {
            Auth.auth().signIn(withEmail: userNameTF.text!, password: userPasswordTF.text!) { authData, error in
                if error != nil {
                    AlertManager.alert(title: "Error", message: error?.localizedDescription ?? "Login Error", vc: self)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
    }
}
