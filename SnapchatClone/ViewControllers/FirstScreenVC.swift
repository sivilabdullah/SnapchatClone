//
//  ViewController.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit

class FirstScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInBtnclicked(_ sender: Any) {
        performSegue(withIdentifier: "toLoginScreen", sender: nil)
    }
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpScreen", sender: nil)
    }
    
}

