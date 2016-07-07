//
//  ProjectCell.swift
//  Selection
//
//  Created by April on 6/8/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class ProjectCell: CiaCell {

    @IBOutlet var ProjectNmLbl: UILabel!
    @IBOutlet var PM1Lbl: UILabel!
    @IBOutlet var PM2Lbl: UILabel!
    @IBOutlet var StatusLbl: UILabel!
    
    func setDetail(item: ProjectItemObj)  {
        ProjectNmLbl.text = item.nproject ?? ""
        PM1Lbl.text = item.pm1 ?? ""
        PM2Lbl.text = item.pm2 ?? ""
        StatusLbl.text = item.status ?? ""
             StatusLbl.text = item.idfloorplan ?? ""
    }
}
