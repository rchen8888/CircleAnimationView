//
//  ViewController.swift
//  CircleAnimationView
//
//  Created by cxt on 12/17/15.
//  Copyright © 2015 cxt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var cv = CircleAnimationView(frame: CGRectMake(0,0,100,100))
//    var view1 = UIView(frame: CGRect(x: 10,y: 10,width: 100,height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view1.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(view1)
        // Do any additional setup after loading the view, typically from a nib.
//        let cv =
        
        cv.center = self.view.center
        cv.lineWidth = 5
        cv.lineColor = UIColor.blueColor()
//        cv.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(cv)
        let longTap = UILongPressGestureRecognizer(target: self, action: Selector("longPressOptionView:"))
        longTap.minimumPressDuration = 0.01
        self.view.addGestureRecognizer(longTap)
//        view1.addGestureRecognizer(longTap)
//
//        self.
//        self.view.UIForceTouchCapability  =  UIForceTouchCapability.Unavailable
    }

    

    func longPressOptionView(gesture:UILongPressGestureRecognizer){
        
        
//        if 
        
        
        switch gesture.state{
        case .Began:
            cv.startAnimation()
        case .Ended:
            if cv.isLoading{
                
            }else{
            cv.cancelAnimation()
            }
        case .Cancelled:
            if cv.isLoading{
                
            }else{
                cv.cancelAnimation()
            }
        default:
            print(0)
        }
        
        
    }
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

