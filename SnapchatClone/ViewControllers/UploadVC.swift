//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import PhotosUI
class UploadVC: UIViewController, PHPickerViewControllerDelegate{
   
    

    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessGalery))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    

    
    
    @objc func accessGalery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            let previousImage = imageView.image
            itemProvider.loadObject(ofClass: UIImage.self){[weak self] image, error in
                DispatchQueue.main.async {
                    //select image process
                    guard let self = self, let image = image as? UIImage, self.imageView.image == previousImage else {return}
                    self.imageView.image = image
                }
            }
        }
    }
    @IBAction func publishButtonClicked(_ sender: Any) {
        //MARK: - Storage
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("Media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metaData, error in
                if error != nil{
                    AlertManager.alert(title: "Error", message: error?.localizedDescription ?? "image is not saved", vc: self)
                }else{
                    imageReference.downloadURL { url, error in
                        if error != nil {
                            AlertManager.alert(title: "Error", message: error?.localizedDescription ?? "undefined error", vc: self)
                        }else{
                            let imageUrl = url?.absoluteString
                            
                            //MARK: - Database
                            
                            let firestore = Firestore.firestore()
                            
                            //bir kullanicinin eger daha once bir kaydettigi resmi varsa bunu  ayni url icine dizi seklinde kaydetmeliyiz ki slider seklinde feed'de gosterelim
                            ///Kontrol
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserInfo.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    AlertManager.alert(title: "error", message: error?.localizedDescription ?? "undefined error", vc: self)
                                }else{
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        //second or more upload
                                        for document in snapshot!.documents{
                                            let documentId = document.documentID
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String:Any]
                                                firestore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                    if error != nil {
                                                        AlertManager.alert(title: "error", message: error?.localizedDescription ?? "undefined error", vc: self)
                                                    }else{
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "upload")
                                                    }
                                                }
                                            }else{
                                                
                                            }
                                        }
                                    }else{
                                        //first upload
                                        let snapDictionary = ["imageUrlArray": [imageUrl!], "snapOwner": UserInfo.sharedUserInfo.username,"date": FieldValue.serverTimestamp()] as [String:Any]
                                        firestore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil{
                                                AlertManager.alert(title: "Error", message: error?.localizedDescription ?? "undefined error", vc: self)
                                            }else{
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "upload")
                                            }
                                        }
                                    }
                                }
                            }
                            ///kontrol
                        }
                    }
                }
            }
        }
    }

}
