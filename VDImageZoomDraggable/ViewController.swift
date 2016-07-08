//
//  ViewController.swift
//  VDImageZoomDraggable
//
//  Created by bigscal on 08/07/16.
//  Copyright © 2016 Asha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageView : VDImageZoomDraggable?
    @IBOutlet var productimage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView = VDImageZoomDraggable(frame: self.view!.frame, image: UIImage(named: "Dress"))
        self.imageView!.userInteractionEnabled = true
        self.imageView!.makeImageDraggable()
        self.imageView!.enableZoomInOutToImage()
        self.imageView!.makeImageRotable()
        self.imageView!.allowsToResetImageOnLongPress()

        self.view.addSubview(self.imageView!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

