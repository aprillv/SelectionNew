//
//  FloorplanAreaItem.swift
//  Selection
//
//  Created by April on 7/12/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class FloorplanAreaItemCell: CiaCell {
    @IBOutlet var seperatorLineWidth : NSLayoutConstraint!{
        didSet{
            seperatorLineWidth.constant = 1.0 / UIScreen.mainScreen().scale
            self.updateConstraintsIfNeeded()
        }
    }
    
    @IBOutlet var xname: UILabel!
    @IBOutlet var xdescription: UILabel!
    
    func setContentDetail(item: FloorplanAreaItem) {
        xname.text = item.xname
        xdescription.text = item.xdescription
        
    }
}
