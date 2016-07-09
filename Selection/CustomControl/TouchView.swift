//
//  TouchView.swift
//  Selection
//
//  Created by April on 6/3/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class TouchView: UIView {
    
//    override init(frame: CGRect)
//    {
//        super.init(frame: frame)
////        self.addge
//        self.addTarget(self, action: #selector(touchDowna), forControlEvents: UIControlEvents.TouchDown)
//       
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//            self.addTarget(self, action: #selector(touchDowna), forControlEvents: UIControlEvents.TouchDown)
//        
//    }
//    
//    
//    func touchDowna() {
//        backgroundColor = UIColor.redColor()
//    }
    
    var CategoryDetail : CategoryItem?
    var ImgScale : Float?
    
    required init(coder decoder: NSCoder) {
        CategoryDetail = nil
        ImgScale = 1
        super.init(frame: CGRectZero)
    }
    
    init(frame: CGRect, withItem item : CategoryItem, withScale scale: Float) {
        CategoryDetail = item
        ImgScale = scale
        super.init(frame: frame)
    }
    
    var lineWith : CGFloat = 3.0
    var borderColor: UIColor = UIColor.blueColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    private func fathPath() -> UIBezierPath?{
//        let a : GDataXMLD?
//        let a : GDataXMLDocument?
//        let doc:GDataXMLDocument = try! GDataXMLDocument(XMLString: "<?xml version=\"1.0\"?><points><point x=\"9\" y=\"14\" /><point x=\"250\" y=\"14\" /><point x=\"250\" y=\"231\" /><point x=\"9\" y=\"231\" /></points>", options : 0)
        if let item = CategoryDetail, let f = ImgScale {
        
            let doc: GDataXMLDocument = try! GDataXMLDocument(XMLString: item.polygon ?? "", options : 0)
            
            let users = try! doc.nodesForXPath("//point", namespaces:nil) as! [GDataXMLElement]
            
//            var minX = 10000
//            var minY = 10000
            
            var points = [CGPoint]()
            
//            var f = CGFloat(768.0/1068.0)
//            print(f)
            for user in users {
//                print(item.minX)
                let x = (Int(user.attributeForName("x").stringValue()) ?? 0 ) - Int(item.minX ?? 0)
                let y = (Int(user.attributeForName("y").stringValue()) ?? 0 ) - Int(item.minY ?? 0)
                
//                minX = min(minX, x)
//                minY = min(minY, y)
                
//                print(x, y)
                points.append(CGPoint(x: CGFloat(x) * CGFloat(f), y: CGFloat(y) * CGFloat(f)))
                
            }
            
            let path = UIBezierPath()
            let a = points[0]
            path.moveToPoint(a)
            points.removeFirst()
            for point in points {
                path.addLineToPoint(point)
            }
            path.addLineToPoint(a)
            
            path.lineWidth = lineWith
            
            
            
            return path
        }
        return nil
    }
    
    func addAction(target target: AnyObject?, action: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target:target, action:action)
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func drawRect(rect: CGRect) {
        
        backgroundColor = UIColor.clearColor()
        borderColor.set()
        fathPath()?.stroke()
        
        
        let textFontAttributes = [
            NSForegroundColorAttributeName: UIColor.blueColor()
        ]
       
        (CategoryDetail?.code ?? "").drawAtPoint(CGPoint(x: 4, y: 4), withAttributes: textFontAttributes)
          (CategoryDetail?.ncategory ?? "").drawAtPoint(CGPoint(x: 4, y: 18), withAttributes: textFontAttributes)
        
    }
    
//    override func layoutSubviews() {
////        print("april")
//    }
   
    var touchDown = false{
        didSet{
//            print(borderColor)
            borderColor = touchDown ? UIColor.redColor() : UIColor.blueColor()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if !touchDown{
            touchDown = true
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if self.bounds.contains(touch.locationInView(self)) {
                if !touchDown{
                    touchDown = true
                }
            }else{
                if touchDown {
                    touchDown = false
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchDown {
            touchDown = false
        }
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if touchDown {
            touchDown = false
        }
    }
    
//    override func setTitleColor(color: UIColor?, forState state: UIControlState) {
//        switch state {
//        case UIControlState.Highlighted:
//            backgroundColor = UIColor.redColor()
//        default:
//            backgroundColor = UIColor.clearColor()
//        }
//    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if self.bounds.contains(point) {
        return self
        }
        return super.hitTest(point, withEvent: event)
        
    }

}
