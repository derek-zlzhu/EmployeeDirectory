//
//  ImageCache.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import UIKit.UIImage

protocol ImageCache: AnyObject {
  func getImage(from url: NSURL) -> UIImage?
  func cacheImage(for url: NSURL, image: UIImage)
}
