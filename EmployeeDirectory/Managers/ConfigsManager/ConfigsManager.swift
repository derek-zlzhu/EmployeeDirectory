//
//  ConfigsManager.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import Foundation

public class ConfigsManager {

  static let shared = ConfigsManager()

  private init() {}

  lazy var appConfig: AppConfigs = {
    var config = AppConfigs()

    if let settings = contentsOfFile(plistName: kAppSettingsPListFileNameKey) {
      if let apiServiceUrl: String = settings.object(forKey: kAppSettingsApiServiceUrlKey) as? String,
         let memoryCacheCountSetting: Int = settings.object(forKey: kAppSettingsImageMemoryCacheCountKey) as? Int,
         let fileCacheSizeSetting: Int = settings.object(forKey: kAppSettingsImageFileCacheSizeKey) as? Int,
         let timeout: Double = settings.object(forKey: kAppSettingsRequestTimeoutKey) as? Double {
        config = AppConfigs(
          apiServiceUrl: apiServiceUrl,
          imageMemoryCacheCount: memoryCacheCountSetting,
          imageFileCacheSize: fileCacheSizeSetting,
          requestTimeout: timeout)
      }
    }

    return config
  }()

  // MARK: - Help methods -

  private let kAppSettingsPListFileNameKey          = "Settings"

  private let kAppSettingsApiServiceUrlKey          = "ApiServiceUrl"
  private let kAppSettingsImageMemoryCacheCountKey  = "ImageMemoryCacheCount"
  private let kAppSettingsImageFileCacheSizeKey     = "ImageFileCacheSize"
  private let kAppSettingsRequestTimeoutKey         = "RequestTimeout"

  private func contentsOfFile(plistName: String) -> NSDictionary? {
    guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
      return [:]
    }

    return NSDictionary(contentsOfFile: plistPath) ?? [:]
  }
}
