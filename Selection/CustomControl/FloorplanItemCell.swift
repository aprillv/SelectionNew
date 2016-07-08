//
//  FloorplanItemCell.swift
//  Selection
//
//  Created by April on 7/8/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

//import UIKit

class FloorplanItemCell: CiaCell {
    @IBOutlet var seperatorLineWidth : NSLayoutConstraint!{
        didSet{
            seperatorLineWidth.constant = 1.0 / UIScreen.mainScreen().scale
            self.updateConstraintsIfNeeded()
        }
    }
    
    @IBOutlet var planno: UILabel!
    @IBOutlet var marketingname: UILabel!
    @IBOutlet var planname: UILabel!
    @IBOutlet var projectcnt: UILabel!
    
    func setContentDetail(item: FloorplanItem) {
        planno.text = item.idnumber
        marketingname.text = item.marketingname
        planname.text = item.floorplanname
        if item.activeprojectscnt == "0" {
            item.activeprojectscnt = ""
        }
        projectcnt.text = item.activeprojectscnt
    }
}
