//
//  ImageViewerViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var imageUrlString: String?
    var image: UIImage?
    
    var photosVC: PhotosViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let image = image {
            let minScale = min(UIScreen.main.bounds.width / image.size.width, UIScreen.main.bounds.height / image.size.height)
            scrollView.minimumZoomScale = minScale
            
            scrollView.zoomScale = max(minScale, scrollView.zoomScale)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helpers
    
    func loadImage() {
        
        if let imageUrlString = imageUrlString {
            if let url = URL(string: imageUrlString) {
                
                Engine.shared.downloadImageWithUrl(url, completion: { (result, error) -> () in
                    if let image = result as? UIImage {
                        
                        let imageView = UIImageView(image: image)
                        imageView.tag = 99
                        
                        self.scrollView.addSubview(imageView)
                        self.scrollView.contentSize = CGSize(width: image.size.width, height: image.size.height)
                        
                        self.scrollView.delegate = self
                        
                        let minScale = min(UIScreen.main.bounds.width / image.size.width, UIScreen.main.bounds.height / image.size.height)
                        self.scrollView.minimumZoomScale = minScale
                        self.scrollView.maximumZoomScale = 2.0
                        
                        self.scrollView.zoomScale = 1
                        
                        // Double tap gesture
                        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ImageViewerViewController.handleDoubleTap(_:)))
                        doubleTap.numberOfTapsRequired = 2
                        doubleTap.numberOfTouchesRequired = 1
                        self.scrollView.addGestureRecognizer(doubleTap)
                        
                        self.image = image
                    }
                })
            }
        }
    }
    
    func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if scrollView.zoomScale == scrollView.minimumZoomScale {
                scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
            }
            else {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            }
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension ImageViewerViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return scrollView.viewWithTag(99)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if let view = scrollView.viewWithTag(99) {
            
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0.0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0.0)
            
            view.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        }
    }
}
