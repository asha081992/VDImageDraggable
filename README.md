# VDImageDraggable

**VDImageDraggable** is third party library that uses various gesture recognizers like UILongPressGestureRecognizer, UIRotationGestureRecognizer, UIPanGestureRecognizer, UIPinchGestureRecognizer
to enable users to rotate, zoom, reset and drag image.

It is built in swift language and supports iOS 8+.

## Demo 
** Simple demonstration of image**
![demo image](https://media.giphy.com/media/sKITyDWrBVNkY/giphy.gif)

## Features
 + Enabled image to be moved, rotate, reset and draggable.
 + Easy Integration
 + built in swift
 
## Getting Started
### Import file "VDImageZoomDraggable.swift"
  - Drag & Drop VDImageZoomDraggable.swift file into your project.
  
### Make use of VDImageZoomDraggable.swift
  - Add below code to sample file.
  
        self.imageView = VDImageZoomDraggable(frame: self.view!.frame, image: UIImage(named: "Dress"))
        self.imageView!.userInteractionEnabled = true
        self.imageView!.makeImageDraggable()
        self.imageView!.enableZoomInOutToImage()
        self.imageView!.makeImageRotable()
        self.imageView!.allowsToResetImageOnLongPress()
        self.view.addSubview(self.imageView!)

  
## Issues & Contact
  + If you have any question regarding the usage, please refer to the example project for more details.
  + If you find any bug, please submit an issue.
