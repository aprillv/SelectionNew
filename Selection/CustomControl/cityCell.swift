//
//  cityCell.swift
//  Selection
//
//  Created by April on 7/7/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class cityCell: CiaCell {
    @IBOutlet var seperatorLineWidth : NSLayoutConstraint!{
        didSet{
            seperatorLineWidth.constant = 1.0 / UIScreen.mainScreen().scale
            self.updateConstraintsIfNeeded()
        }
    }
    
    @IBOutlet var cityno: UILabel!
    @IBOutlet var cityname: UILabel!
    @IBOutlet var statename: UILabel!
    
    func setContentDetail(item: cityItem) {
        cityno.text = item.idnumber
        cityname.text = item.cityname
        statename.text = item.state
    }
}
