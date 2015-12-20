//
//  CircleAnimationView.swift
//  CircleAnimationView
//
//  Created by cxt on 12/17/15.
//  Copyright © 2015 cxt. All rights reserved.
//

import UIKit

class CircleAnimationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var startAngle          : Int          = 0 //开始的角度
    var ValueAngle          : Int          = 360 //画多少度
    var lineWidth           : CGFloat      = 2 //线条的宽度
        {
        didSet{
            circleLayer.lineWidth   = lineWidth
        }
    }
    var lineColor           : UIColor      = UIColor.redColor()  //线条的颜色
        {
        didSet{
            circleLayer.strokeColor = lineColor.CGColor
        }
    }
    
    var isLoading           : Bool         = false
    var startAnimduration   : Double       = 2 //持续时间
    var startLoading        : (()->Void)?   //开始动画进入加载后回调
    
    
    func startAnimation(){self.start()}

    
    func cancelAnimation(){self.cancel()}
    
    
    
    
    
    
    
    private var nowAngle    : CGFloat      = 0
    
    private var circleLayer : CAShapeLayer = CAShapeLayer()
    
    private var vWidth      : CGFloat      = 0
    
    private var vCenter     : CGPoint      = CGPoint()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vWidth   = self.frame.size.width
        vCenter  = self.center
        circleLayer.strokeColor = lineColor.CGColor
        circleLayer.fillColor   = UIColor.clearColor().CGColor
        circleLayer.lineWidth   = lineWidth
        self.layer.addSublayer(circleLayer)
       
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
   private func start(){
        isLoading = false
        let prop = POPAnimatableProperty.propertyWithName("CircleAngle") { [unowned self] (prop:POPMutableAnimatableProperty!) -> Void in
            prop.writeBlock = {[unowned self] (obj : AnyObject!,values : UnsafePointer<CGFloat>) -> Void in
                let layer         : CAShapeLayer = obj as! CAShapeLayer
                let animationPath : UIBezierPath =  UIBezierPath()
                animationPath.addArcWithCenter(self.vCenter,
                                               radius: self.vWidth/2,
                                               startAngle: CGFloat(M_PI/180)*CGFloat(self.startAngle),
                                               endAngle: CGFloat(M_PI/180)*((-values[0])+CGFloat(self.startAngle)),clockwise: false)
                self.nowAngle  = CGFloat(values[0])
                layer.path = animationPath.CGPath
            }
          
        }
        let anBasic = POPBasicAnimation.linearAnimation()
        anBasic.property = prop as! POPAnimatableProperty
        anBasic.fromValue = 0.0
        anBasic.toValue   = ValueAngle
        anBasic.duration  = startAnimduration
        anBasic.completionBlock = { (anim : POPAnimation!,finish : Bool) -> Void in
            if finish{
                self.loading()
                
                if self.startLoading != nil{
                    self.startLoading!()
                }
            }
    
    
        }
        self.circleLayer.pop_addAnimation(anBasic, forKey: "CAngle")
    }
    
    
   private func loading(){
        isLoading = true
        self.circleLayer.pop_removeAllAnimations()
        let prop = POPAnimatableProperty.propertyWithName("CircleAngle") {[unowned self]  (prop:POPMutableAnimatableProperty!) -> Void in
            prop.writeBlock = {[unowned self]  (obj : AnyObject!,values : UnsafePointer<CGFloat>) -> Void in
                let layer         : CAShapeLayer = obj as! CAShapeLayer
                let animationPath : UIBezierPath =  UIBezierPath()
                if(values[0]*2>360){
                 animationPath.addArcWithCenter(self.vCenter, radius: self.vWidth/2, startAngle: CGFloat(M_PI/180)*CGFloat(self.startAngle), endAngle: CGFloat(M_PI/180)*(360-values[0]*2+CGFloat(self.startAngle)), clockwise: false)
                }else{
                    animationPath.addArcWithCenter(self.vCenter, radius: self.vWidth/2, startAngle: CGFloat(M_PI/180)*(360-values[0]*2)+CGFloat(M_PI/180)*CGFloat(self.startAngle), endAngle: CGFloat(M_PI/180)*((0)+CGFloat(self.startAngle)), clockwise: false)
                }
                layer.path = animationPath.CGPath
            }
        }
        let anBasic = POPBasicAnimation.linearAnimation()
        anBasic.property = prop as! POPAnimatableProperty
        anBasic.fromValue = 0.0
        anBasic.toValue   = ValueAngle
        anBasic.duration  = 3
        anBasic.repeatCount = Int.max
        self.circleLayer.pop_addAnimation(anBasic, forKey: "CAngle2")
    }
    
    
   private func cancel(){
        isLoading = false
        if self.circleLayer.pop_animationForKey("CAngle2") != nil
        {
            self.circleLayer.pop_removeAllAnimations()
            self.circleLayer.path = UIBezierPath().CGPath
        }
        else
        {
            self.circleLayer.pop_removeAllAnimations()
            let prop = POPAnimatableProperty.propertyWithName("CircleAngle") {[unowned self]  (prop:POPMutableAnimatableProperty!) -> Void in
                prop.writeBlock = {[unowned self]  (obj : AnyObject!,values : UnsafePointer<CGFloat>) -> Void in
                    let layer         : CAShapeLayer = obj as! CAShapeLayer
                    let animationPath : UIBezierPath =  UIBezierPath()
                    animationPath.addArcWithCenter(self.vCenter, radius: self.vWidth/2, startAngle: CGFloat(M_PI/180)*CGFloat(self.startAngle), endAngle: CGFloat(M_PI/180)*((-self.nowAngle+values[0])+CGFloat(self.startAngle)), clockwise: false)
                    layer.path = animationPath.CGPath
                }
                prop.readBlock = {[unowned self]  (obj : AnyObject!,values : UnsafeMutablePointer<CGFloat>) -> Void in
                    let layer         : CAShapeLayer = obj as! CAShapeLayer
                    if ((layer.superlayer?.isEqual(self.layer)) != nil){
                        layer.removeAllAnimations()
                        
                    }
                }
            }
            let anBasic = POPBasicAnimation.linearAnimation()
            anBasic.property = prop as! POPAnimatableProperty
            anBasic.fromValue = 0.0
            anBasic.toValue   = self.nowAngle
            anBasic.duration  = 0.3
            self.circleLayer.pop_addAnimation(anBasic, forKey: "CAngle3")
        }
    }
    

   
}
