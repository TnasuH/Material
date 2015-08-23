//
//  PulseView.swift
//  MaterialKit
//
//  Created by Adam Dahan on 2015-08-23.
//  Copyright (c) 2015 GraphKit Inc. All rights reserved.
//

import UIKit

public class PulseView : UIView {

    internal lazy var views: NSMutableDictionary = NSMutableDictionary()
    
    public var backgroundColorView: UIView?
    public var pulseView: UIView?
    
    public var color: UIColor?
    public var pulseColor: UIColor?
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    internal func initialize() {
        setupSelf()
        setupLayer()
        setupBackgroundColorView()
        constrainSubviews()
    }
    
    private func setupSelf() {
        color = UIColor.clearColor()
        pulseColor = UIColor.whiteColor()
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor(red: 66.0/255.0, green: 91.0/255.0, blue: 103.0/255.0, alpha: 1.0)
    }
    
    private func setupLayer() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0.5, 0.5)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.4
        layer.cornerRadius = 2.0
    }
    
    // We need this view so we can use the masksToBounds
    // so the pulse doesn't animate off the button
    func setupBackgroundColorView() {
        backgroundColorView = UIView()
        backgroundColorView?.userInteractionEnabled = false
        backgroundColorView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColorView!.layer.cornerRadius = 2.0
        backgroundColorView!.backgroundColor = color
        backgroundColorView!.layer.masksToBounds = true
        addSubview(backgroundColorView!)
        views.setObject(backgroundColorView!, forKey: "bgView")
    }
    
    internal func constrainSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bgView]-(0)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[bgView]-(0)-|", options: nil, metrics: nil, views: views as [NSObject : AnyObject]))
    }
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        pulseTouches(touches)
    }
    
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        shrink()
        removePulse()
    }
    
    public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        shrink()
        removePulse()
    }
    
    func pulseTouches(touches: NSSet) {
        let touch = touches.allObjects.last as! UITouch
        let touchLocation = touch.locationInView(self)
        pulseView = UIView()
        pulseView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        var width = bounds.size.width / 3.0
        pulseView!.frame = CGRectMake(0, 0, width, width)
        pulseView!.layer.cornerRadius = width / 2.0
        pulseView!.center = touchLocation
        pulseView!.backgroundColor = pulseColor!.colorWithAlphaComponent(0.1)
        backgroundColorView!.addSubview(pulseView!)
        UIView.animateWithDuration(0.3, animations: {
            self.pulseView!.transform = CGAffineTransformMakeScale(3, 3)
            self.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }, completion: nil)
    }
    
    func shrink() {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: nil, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func removePulse() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pulseView?.alpha = 0.0
            }) { (finished) -> Void in
                self.pulseView?.removeFromSuperview()
                self.pulseView = nil
        }
    }
}
