//
//  SegueHandlerType.swift
//  Selection
//
//  Created by April on 3/23/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import Foundation
import UIKit

protocol SegueHandlerType{
    associatedtype SegueIdentifier : RawRepresentable
}

extension SegueHandlerType where Self : UIViewController, SegueIdentifier.RawValue == String {
    func performSegueWithIdentifier(segueIdentifier : SegueIdentifier, sender : AnyObject) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else{
                fatalError("Invalid segue Identifier \(segue.identifier)")
        }
        
        return segueIdentifier
    }
}
