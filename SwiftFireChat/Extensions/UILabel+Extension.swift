//
//  UILabel+Extension.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/15/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let labelCache: NSCache = NSCache<AnyObject, AnyObject>()

extension UILabel {
    func setCechedNameFor(id: String) {
        self.text = nil
    
        if let cachedName = labelCache.object(forKey: id as AnyObject) as? String {
            self.text = cachedName
            return
        }
        
        let ref = Database.database().reference().child("users").child(id)
        ref.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                if let name = dict["name"] {
                    labelCache.setObject(name, forKey: id as AnyObject)
                    if let nameString = name as? String {
                        self.text = nameString
                    }
                }
            }
        }, withCancel: nil)
    }
}
