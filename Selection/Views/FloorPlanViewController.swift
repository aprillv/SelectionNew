//
//  FloorPlanViewController.swift
//  Selection
//
//  Created by April on 6/3/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit
import Alamofire


class FloorPlanViewController:  BaseViewController{
    // MARK: paramater from last page
    var floorplanInfo : FloorplanItem?
    
//    var scale : Float = 1.0
//    var rect = CGRectZero
    
    var CategoryList: [CategoryItem]? {
        didSet{
            addPolygon()
        }
    }
    
    func addPolygon() {
        if let img = view.viewWithTag(1) as? UIImageView, item = floorplanInfo {
            img.contentMode = .ScaleAspectFit
            
            img.sd_setImageWithURL(NSURL(string: "https://contractssl.buildersaccess.com/baselection_floorplanimage?idcia=\(item.ciaid!)&idfloorplan=\(item.idnumber!)&isthumbnail=0"), completed: { (_, _, _, _) -> Void in
                //                        self.spinner.stopAnimating()
                self.spinner.stopAnimating()
                self.loadingLbl.hidden = true
                let (rect, scale) = self.getImageFrame(img)
//                self.rect = rect1
//                self.scale = scale1
                img.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.New, context: nil)
                self.finished = true
                if let cl = self.CategoryList {
                    
                        for item in cl {
                            let t = TouchView(frame: CGRect(x: rect.origin.x + (CGFloat(item.minX ?? 0) * CGFloat(scale)), y: rect.origin.y  + CGFloat(item.minY ?? 0) * CGFloat(scale), width: CGFloat(Int(item.maxX!) - Int(item.minX!)) * CGFloat(scale), height: CGFloat(Int(item.maxY!) - Int(item.minY!)) * CGFloat(scale)), withItem: item, withScale: scale)
                            t.backgroundColor = UIColor.clearColor()
                            img.addSubview(t)
                            t.addAction(target: self, action: #selector(FloorPlanViewController.ClickCategroy(_:)))
                            
                        }
                    
                    
                }
            })
        }
        
        
    }
    
    func ClickCategroy(tap : UITapGestureRecognizer) {
        if let t = tap.view as? TouchView {
            print(t.CategoryDetail?.ncategory)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let img = view.viewWithTag(1) as? UIImageView {
        let (rect, scale) = getImageFrame(img)
            for u in img.subviews {
                if let t = u as? TouchView{
                    if t.ImgScale != scale {
                        if let item = t.CategoryDetail {
                            t.ImgScale = scale
                            t.frame = CGRect(x: rect.origin.x + (CGFloat(item.minX ?? 0) * CGFloat(scale)), y: rect.origin.y  + CGFloat(item.minY ?? 0) * CGFloat(scale), width: CGFloat(Int(item.maxX!) - Int(item.minX!)) * CGFloat(scale), height: CGFloat(Int(item.maxY!) - Int(item.minY!)) * CGFloat(scale))
                            t.setNeedsDisplay()
                        }
                    }
                    
                    
                }
            }
        }
        
    }
    
    private func getFloorPlan(){
    
    }
   
    
    
    
    private func getCategory() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        let request = ["idcia": floorplanInfo?.ciaid ?? "",
                       "idfloorplan" : floorplanInfo?.idnumber ?? "",
                       "email": userInfo.stringForKey(CConstants.UserInfoEmail) ?? "",
                       "password": userInfo.stringForKey(CConstants.UserInfoPwd) ?? "",
                       "username" : userInfo.stringForKey(CConstants.LoggedUserNameKey) ?? " ",
                       "floorplanname": floorplanInfo?.floorplanname ?? " "]
//        print(request)
        Alamofire.request(.POST,
            CConstants.ServerURL + "baselection_categoryRequest.json",
            parameters: request).responseJSON{ (response) -> Void in
                if response.result.isSuccess {
                    print(response.result.value)
                    if let rtnValue = response.result.value as? [[String: AnyObject]]{
                        var na = [CategoryItem]()
                        for rtn in rtnValue {
                            na.append(CategoryItem(dicInfo: rtn))
                        }
                        self.CategoryList = na
                    }else{
                        //                    self.doLogin()
                    }
                }else{
                    //                self.doLogin()
                }
        }
        
        
    }
    
    
    
//    UIImageView *iv; // your image view
//    CGSize imageSize = iv.image.size;
//    CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
//    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
//    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
    @IBOutlet var backItem: UIBarButtonItem!
    func getImageFrame(img: UIImageView) -> (CGRect, Float){
        let imageSize = img.image?.size ?? CGSize(width: 0, height: 0)
        let imageScale = fminf(Float(img.bounds.width/imageSize.width), Float(img.bounds.height/imageSize.height))
       let  scaledImageSize = CGSizeMake(imageSize.width*CGFloat(imageScale), imageSize.height*CGFloat(imageScale))
       return (CGRectMake(CGFloat(roundf(Float(0.5)*(Float(img.bounds.width-scaledImageSize.width)))), CGFloat(roundf(Float(0.5)*(Float(img.bounds.height-scaledImageSize.height)))), CGFloat(roundf(Float(scaledImageSize.width))), CGFloat(roundf(Float(scaledImageSize.height)))), imageScale)
    }
    
    var finished = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        title = "Floorplan # \(floorplanInfo?.idnumber ?? "") - \(floorplanInfo?.floorplanname ?? " ")"
        spinner.startAnimating()
        loadingLbl.hidden = false
        
        
        
        getCategory()
        
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let img = view.viewWithTag(1) as? UIImageView{
            img.removeObserver(self, forKeyPath: "center", context: nil)
            
        }
    }
    @IBOutlet var spinner: UIActivityIndicatorView!{
        didSet{
            spinner.hidesWhenStopped = true
        }
    }
    @IBOutlet var loadingLbl: UILabel!{
        didSet{
            loadingLbl.hidden = true
        }
    }

}
