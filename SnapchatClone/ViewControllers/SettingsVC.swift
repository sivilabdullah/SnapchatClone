//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import Firebase
class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutBtnClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogOut", sender: nil)
        }catch{
            AlertManager.alert(title: "error", message: "Log out error", vc: self)
        }
    }
  

}
