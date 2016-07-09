//
//  PricebookTemplateItemCell.swift
//  Selection
//
//  Created by April on 7/6/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class PricebookTemplateItemCell: CiaCell {
    @IBOutlet var seperatorLineWidth : NSLayoutConstraint!{
        didSet{
            seperatorLineWidth.constant = 1.0 / UIScreen.mainScreen().scale
            self.updateConstraintsIfNeeded()
        }
    }
     @IBOutlet var backView: UIView!
    @IBOutlet var fsImage: UIImageView!
    
    var superActionView : AnyObject?{
        didSet{
            toADDClockInTap()
        }
    }
    
    private func toADDClockInTap(){
        if let _ = superActionView, let _ = fsImage {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:superActionView!, action:#selector(PricebookTemplateItemsViewController.imageTapped(_:)))
            fsImage.userInteractionEnabled = true
            tapGestureRecognizer.numberOfTapsRequired = 1
            fsImage.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    @IBOutlet var areacodeLbl: UILabel!
    @IBOutlet var areaNameLbl: UILabel!
    @IBOutlet var partNoLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    
    func setCellContentDetail(item : PricebookTemplateItemListI){
        if item.fs ?? 0 == 1 {
            fsImage.image = UIImage(named: "pic")
        }else{
            fsImage.image = nil
        }
        areacodeLbl.text = item.areacode ?? ""
        areaNameLbl.text = item.areaname ?? ""
        partNoLbl.text = item.part ?? ""
        descriptionLbl.text = item.xdescription ?? ""
        if item.quantity == ".000" {
            quantityLbl.text = ""
        }else{
            quantityLbl.text = item.quantity ?? ""
        }
        
        if (areacodeLbl.text ?? "").containsString("-") {
            backView.backgroundColor = UIColor.whiteColor()
        }else{
            backView.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
        }
    }
    
}
