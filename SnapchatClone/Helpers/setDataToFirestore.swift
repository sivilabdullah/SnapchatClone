//
//  setDataToFirestore.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 28.05.2023.
//

import Foundation
import FirebaseFirestore

class setDataToFirestore{
    
    class func setData(data1:String,data1Key:String,data2:String,data2Key:String){
        let firestore = Firestore.firestore()
        let userDictionary = [data1Key: data1, data2Key:data2] as [String:Any]
        firestore.collection("UserInfo").addDocument(data: userDictionary){ error in
            if error != nil {
                
            }
        }
        
    }
    
}
