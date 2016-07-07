//
//  PricebookItemTableViewCell.swift
//  Selection
//
//  Created by April on 7/5/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class PricebookItemTableViewCell: CiaCell {

   
    @IBOutlet var seperatorLineWidth : NSLayoutConstraint!{
        didSet{
            seperatorLineWidth.constant = 1.0 / UIScreen.mainScreen().scale
            self.updateConstraintsIfNeeded()
        }
    }
    @IBOutlet var templateIdLbl: UILabel!{
        didSet{
            templateIdLbl.textAlignment = .Center
        }
    }
    @IBOutlet var templateNameLbl: UILabel!
    @IBOutlet var priceLevelLbl: UILabel!{
        didSet{
            priceLevelLbl.textAlignment = .Center
        }
    }
    @IBOutlet var pricebookLbl: UILabel!{
        didSet{
            pricebookLbl.textAlignment = .Right
        }
    }
    
    func setContentDetail(item : PricebookTemplateItem) {
        templateIdLbl.text = item.tid
        templateNameLbl.text = item.tname
        priceLevelLbl.text = item.pricelevel
        if item.pricebook != "0.00" {
            pricebookLbl.text = item.pricebook
        }else{
            pricebookLbl.text = ""
        }
        
    }
    
}
