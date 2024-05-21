//
//  AppConfigs.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import Foundation

public class AppConfigs {

  // MARK: - App Setting from plist -

  private(set) var apiServiceUrl: String
  private(set) var imageMemoryCacheCount: Int
  private(set) var imageFileCacheSize: Int
  private(set) var requestTimeout: Double

  public init(
    apiServiceUrl: String       = "https://s3.amazonaws.com/sq-mobile-interview/employees.json",
    imageMemoryCacheCount: Int  = 10,
    imageFileCacheSize: Int     = 536870912,  // 1024 * 1024 * 512
    requestTimeout: Double      = 30          // 30 seconds
  ) {
    self.apiServiceUrl          = apiServiceUrl
    self.imageMemoryCacheCount  = imageMemoryCacheCount
    self.imageFileCacheSize     = imageFileCacheSize
    self.requestTimeout         = requestTimeout
  }
}
