//
//  UIImageView+Extension.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/11/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageCacheWithUrl(imageUrl: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        if let good_avatar = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: good_avatar) { (data: Data?, response: URLResponse?, error: Error?) in
                guard error == nil else { return }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: imageUrl as AnyObject)
                        self.image = downloadedImage
                    }
                }
            }.resume()
        }
    }
}
