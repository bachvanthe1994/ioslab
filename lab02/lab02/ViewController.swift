//
//  ViewController.swift
//  lab02
//
//  Created by thebv on 09/10/2024.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var vContent: UIView!
    var imgUse: UIImageView = UIImageView.init(frame: .init(x: 100, y: 100, width: 100, height: 200))
    var currentTransform: CGAffineTransform? = nil
    var pinchStartImageCenter: CGPoint = CGPoint(x: 0, y: 0)
    let maxScale: CGFloat = 6.0
    let minScale: CGFloat = 1.0
    var currentScale: CGFloat = 1.0
    var frameActual = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        self.vContent.clipsToBounds = true
        self.imgUse.layer.borderColor = UIColor.green.cgColor
        self.imgUse.layer.borderWidth = 2
        self.imgUse.image = UIImage(named: "image")
        self.imgUse.contentMode = .scaleToFill
        self.vContent.addSubview(self.imgUse)
        self.setupImageGesture()
    }
    
    func setupImageGesture() {
        self.frameActual = self.imgUse.frame
        self.imgUse.isUserInteractionEnabled = true
        
        // Rotation image
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotatedImage(_:)))
        self.imgUse.addGestureRecognizer(rotate)
        // Zoom image
        let pinchGetsture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchActionZoomImage))
        pinchGetsture.delegate = self
        self.imgUse.addGestureRecognizer(pinchGetsture)
        
        // Move image
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panActionmoveImage))
        panGesture.delegate = self
        self.imgUse.addGestureRecognizer(panGesture)
    }
    
    // Rotation image
    @objc func rotatedImage(_ sender: UIRotationGestureRecognizer) {
        guard let view = sender.view else { return }
        switch sender.state {
        case .changed:
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        default: break
        }
    }
    
    // Image zoom in and zoom out
    @objc func pinchActionZoomImage(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began { // Begin pinch
            // Store current transfrom of UIImageView
            self.currentTransform = imgUse.transform
            
            // Store initial loaction of pinch action
            self.pinchStartImageCenter = imgUse.center
            
            let touchPoint1 = gesture.location(ofTouch: 0, in: imgUse)
            let touchPoint2 = gesture.location(ofTouch: 1, in: imgUse)
            
        } else if gesture.state == UIGestureRecognizer.State.changed { // Pinching in operating
            // Store scale
            
            let pinchCenter = CGPoint(x: gesture.location(in: imgUse).x - imgUse.bounds.midX,
                                      y: gesture.location(in: imgUse).y - imgUse.bounds.midY)
            let transform = imgUse.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            imgUse.transform = transform
            gesture.scale = 1
            
        }
        if gesture.state == UIGestureRecognizer.State.ended { // End pinch
            // Get current scale
            let currentScale = sqrt(abs(imgUse.transform.a * imgUse.transform.d - imgUse.transform.b * imgUse.transform.c))
            if currentScale <= self.minScale { // Under lower scale limit
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    self.imgUse.center = CGPoint(x: self.imgUse.frame.size.width / 2, y: self.imgUse.frame.size.height / 2)
                    self.imgUse.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
                    self.imgUse.frame = self.frameActual
                }, completion: {(finished: Bool) -> Void in
                })
            } else if self.maxScale <= currentScale { // Upper higher scale limit
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    //ignore
                }, completion: {(finished: Bool) -> Void in
                })
            }
        }
    }
    
    @objc func panActionmoveImage(gesture: UIPanGestureRecognizer) {
        
        // Store current transfrom of UIImageView
        let transform = imgUse.transform
        
        // Initialize imageView.transform
        imgUse.transform = CGAffineTransform.identity
        
        // Move UIImageView
        let point: CGPoint = gesture.translation(in: imgUse)
        let movedPoint = CGPoint(
            x: imgUse.center.x + point.x,
            y: imgUse.center.y + point.y
        )
        imgUse.center = movedPoint
        
        // Revert imageView.transform
        imgUse.transform = transform
        
        // Reset translation
        gesture.setTranslation(CGPoint.zero, in: imgUse)
        
    }
    
}

