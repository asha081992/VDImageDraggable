//
//  VDImageZoomDraggable.swift
//  VDImageZoomDraggable
//
//  Created by bigscal on 08/07/16.
//  Copyright © 2016 Asha. All rights reserved.
//

import Foundation
import UIKit

class VDImageZoomDraggable: UIImageView, UIGestureRecognizerDelegate {
    
    //Reset temp imageview
    var imageForReset: UIImageView = UIImageView()
    
    /**
     Initializer to initalize image view with frame.
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = (self.window?.frame)!
        self.enableZoomInOutToImage()


    }
    
    /**
     Initializer to initalize image view with image and frame.
     */
    init(frame: CGRect, image:UIImage?) {
        super.init(frame: frame)
        self.frame = frame
        self.image = image
        self.userInteractionEnabled = true

        
    }
    
    // pragma mark - Utilities Method
    
    /**
    Enabled Zoom In and Zoom out on image.
    */
    func enableZoomInOutToImage(){
        let pinchRecognizer :UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("scalePiece:"))
        pinchRecognizer.delegate = self
        self.addGestureRecognizer(pinchRecognizer)
    }
    
    
    /**
     Enabled to reset image on long press.
     */
    func allowsToResetImageOnLongPress(){
        let longRecognizer :UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("showResetMenu:"))
        longRecognizer.delegate = self
        self.addGestureRecognizer(longRecognizer)
    }
    
    
    /**
     Enabled to be drag and move on touch. On drag event image will be move on accordingly.
     */
    func makeImageDraggable(){
        let panRecognizer :UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panPiece:"))
        panRecognizer.delegate = self
        self.addGestureRecognizer(panRecognizer)
    }
    
    
    /**
     Enabled to be Rotate 360 Degree. On drag event image will be move on accordingly.
     */
    func makeImageRotable(){
        let rotateRecognizer :UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: Selector("rotatePiece:"))
        rotateRecognizer.delegate = self
        self.addGestureRecognizer(rotateRecognizer)

    }
    

    /**
     Thrown error if class modified anonymously.
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /**
    Scale and rotation transforms are applied relative to the layer's anchor point this method moves a gesture recognizer's view's anchor point between the user's fingers.
    */
    func adjustAnchorPointForGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            
        let image: UIImageView = (gestureRecognizer.view as? UIImageView)!
            
        let locationInView : CGPoint = gestureRecognizer.locationInView(image)
        let locationInSuperview : CGPoint = gestureRecognizer.locationInView(image.superview)
        
        image.layer.anchorPoint = CGPointMake(locationInView.x / image.bounds.size.width, locationInView.y / image.bounds.size.height);
        image.center = locationInSuperview
        }
    }
    

    /**
    Display a menu with a single item to allow the piece's transform to be reset.
    */
    func showResetMenu(gestureRecognizer: UILongPressGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
    
            self.becomeFirstResponder()
            self.imageForReset = (gestureRecognizer.view as? UIImageView)!
        
            /*
            Set up the reset menu.
            */
            let menuItemTitle : String = NSLocalizedString("Reset", comment: "Reset menu item title")
            let resetMenuItem = UIMenuItem(title: menuItemTitle, action: Selector("resetPiece:"))
            
            let menuItemCloseTitle : String = NSLocalizedString("Cancel", comment: "Close menu item title")
            let closeMenuItem = UIMenuItem(title: menuItemCloseTitle, action: Selector("closePiece:"))
            
            let menuController = UIMenuController.sharedMenuController()
            menuController.menuItems = [resetMenuItem,closeMenuItem]
            
            let location: CGPoint = gestureRecognizer.locationInView(gestureRecognizer.view)
            let menuLocation = CGRectMake(location.x, location.y, 0, 0)
            menuController.setTargetRect(menuLocation, inView: gestureRecognizer.view!)
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    
    /**
    Close menu.
     */
    func closePiece(controller: UIMenuController)
    {

    }
    
    /**
    Animate back to the default anchor point and transform.
    */
    func resetPiece(controller: UIMenuController)
    {
        
        let imageForReset :UIImageView  = self.imageForReset
    
        let centerPoint: CGPoint = CGPointMake(CGRectGetMidX(imageForReset.bounds), CGRectGetMidY(imageForReset.bounds));
        let locationInSuperview : CGPoint =  imageForReset.convertPoint(centerPoint, toView: imageForReset.superview)
        imageForReset.layer.anchorPoint = CGPointMake(0.5, 0.5)
        imageForReset.center = locationInSuperview

        UIView.animateWithDuration(0.1) { () -> Void in
            imageForReset.transform = CGAffineTransformIdentity
        }
    
    }
    
    // UIMenuController requires that we can become first responder or it won't display
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    
//    #pragma mark - Touch handling
    
    /**
    Shift the piece's center by the pan amount.
    Reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position.
    */
    func panPiece(gestureRecognizer: UIPanGestureRecognizer)
    {
        let image: UIImageView = (gestureRecognizer.view as? UIImageView)!
    
        self.adjustAnchorPointForGestureRecognizer(gestureRecognizer)
    
        
        if(gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed){
            let translation : CGPoint = gestureRecognizer.translationInView(image.superview)
            image.center = CGPointMake((image.center.x + translation.x), (image.center.y + translation.y))
            gestureRecognizer.setTranslation(CGPointZero, inView: image.superview)
        }
    }

    
    /**
    Rotate the piece by the current rotation.
    Reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation.
    */
    func rotatePiece(gestureRecognizer: UIRotationGestureRecognizer)
    {
        self.adjustAnchorPointForGestureRecognizer(gestureRecognizer)
        if(gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed){
            gestureRecognizer.view?.transform = CGAffineTransformRotate((gestureRecognizer.view?.transform)!, gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    
    }

   
    /**
    Scale the piece by the current scale.
    Reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale.
    */
    func scalePiece(gestureRecognizer: UIPinchGestureRecognizer)
    {
            self.adjustAnchorPointForGestureRecognizer(gestureRecognizer)
            if(gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed){
                gestureRecognizer.view?.transform = CGAffineTransformScale((gestureRecognizer.view?.transform)!, gestureRecognizer.scale, gestureRecognizer.scale)
                gestureRecognizer.scale = 1.0
            }
    }
        
    
    
    /**
    Ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously.
    Prevent other gesture recognizers from recognizing simultaneously.
    */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // If the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition.
        if (gestureRecognizer.view != self ) {
            return false;
        }
        
        // If the gesture recognizers are on different views, don't allow simultaneous recognition.
        if (gestureRecognizer.view != otherGestureRecognizer.view) {
            return false;
        }
        
        // If either of the gesture recognizers is the long press, don't allow simultaneous recognition.
        if((gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer.classForCoder())) || (otherGestureRecognizer.isKindOfClass(UILongPressGestureRecognizer.classForCoder())) ) {
            return false
        }

        
        return true;
    }
    
    

}