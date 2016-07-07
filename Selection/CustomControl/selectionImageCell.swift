//
//  selectionImageCell.swift
//  Selection
//
//  Created by April on 3/14/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

class selectionImageCell: UICollectionViewCell {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var upc: UILabel!
    @IBOutlet var name: myUILabel!{
        didSet{
            name.verticalAlignment = VerticalAlignmentTop
        }
    }
    @IBOutlet var pic: UIImageView!{
        didSet{
        self.layer.borderColor = CConstants.BorderColor.CGColor
            self.layer.borderWidth = 1.0
//            pic.backgroundColor = CConstants.BorderColor
        }
    }
    
    
}
