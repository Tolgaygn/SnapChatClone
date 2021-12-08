//
//  SnapVC.swift
//  SnapChat
//
//  Created by Tolga on 24.09.2021.
//

import UIKit
import ImageSlideshow
import SDWebImage

class SnapVC: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var selectedSnap : Snap?
    var inputArray = [SDWebImageSource]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let snap = selectedSnap {
            
            timeLabel.text = "Kalan Süre: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                
                inputArray.append(SDWebImageSource(urlString: imageUrl)!)
                
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
        

        // Do any additional setup after loading the view.
    }
    

 
    

}
