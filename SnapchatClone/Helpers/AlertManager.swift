//
//  AlertManager.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import Foundation
import UIKit
class AlertManager{
      class func alert(title:String, message: String, vc: UIViewController ){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            vc.present(alert, animated: true)
        }
}
