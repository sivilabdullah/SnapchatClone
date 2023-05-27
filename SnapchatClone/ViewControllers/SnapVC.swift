//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by abdullah's Ventura on 27.05.2023.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher
import Kingfisher

class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var inputArray = [KingfisherSource]()
    var sourceSnap : Snap?
    var imageSlideShow = ImageSlideshow()
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        if let snap = sourceSnap {
            timeLabel.text = "\(snap.timeDifference)"
            for imageUrl in  snap.imageUrlArray{
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            //add slideshow
            imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
        
            imageSlideShow.zoomEnabled = true
            
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
              imageSlideShow.addGestureRecognizer(gestureRecognizer)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
    }
    @objc func didTap (){
        imageSlideShow.presentFullScreenController(from: self)
    }


}
