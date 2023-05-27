//
//  TableViewCell.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import SDWebImage
class TableViewCell: UITableViewCell {

 
    
    //custom
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    let imageViewCell: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFit
           imageView.clipsToBounds = true
           imageView.frame = CGRect(x: 0, y: 78, width: 393, height: 500)
           return imageView
       }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           // Hücre içindeki etiket ve resim görünümünü ekliyoruz
           addSubview(userName)
           addSubview(imageViewCell)
           
           // Etiketin constraints'lerini ayarlıyoruz
           NSLayoutConstraint.activate([
               userName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
               userName.topAnchor.constraint(equalTo: topAnchor, constant: 5),
               userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
           ])
           
           // Resim görünümünün constraints'lerini ayarlıyoruz
           NSLayoutConstraint.activate([
               imageViewCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
               imageViewCell.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 0),
               imageViewCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
               imageViewCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
           ])
       }
    func configure(withImageURL imageURL: URL) {
           URLSession.shared.dataTask(with: imageURL) { [weak self] (data, response, error) in
               guard let self = self, let data = data, let image = UIImage(data: data) else {
                   return
               }
               
               let targetSize = CGSize(width: 393, height: 490)
               let scaledImage = self.scaleImage(image, toSize: targetSize)
               
               DispatchQueue.main.async {
                   self.imageViewCell.image = scaledImage
               }
           }.resume()
       }
       
       private func scaleImage(_ image: UIImage, toSize targetSize: CGSize) -> UIImage {
           let renderer = UIGraphicsImageRenderer(size: targetSize)
           let scaledImage = renderer.image { (context) in
               image.draw(in: CGRect(origin: .zero, size: targetSize))
           }
           return scaledImage
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
   }
