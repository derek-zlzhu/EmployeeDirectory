//
//  SettingsViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

  @Published private(set) var displayName: String = "Not Specified"
  @Published private(set) var bundleIdentifier: String = ""
  @Published private(set) var bundleVersion: String = ""
  @Published private(set) var creatorName: String = ""

  @Published var alertItem: AlertItem?
  
  func retriveBundleInfos() {
    if let name = readFromInfoDictionary(withKey: "CFBundleDisplayName") {
      displayName = name
    }

    if let version = readFromInfoDictionary(withKey: "CFBundleShortVersionString") {
      bundleVersion = version
    }

    bundleIdentifier = Bundle.main.bundleIdentifier!
    creatorName = "Derek Zhu"
  }

  private func readFromInfoDictionary(withKey key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
  }

  func resetLocalCache() {
    UserDefaults.standard.removeObject(forKey: kSeenOnboardingKey)
    UserDefaults.standard.synchronize()

    ImageManager.shared.resetCache()

    alertItem = AlertContext.localCacheCleared
  }

  private let kSeenOnboardingKey = "seenOnboarding"
}


extension SettingsViewModel {
  static let sharedPreview = SettingsViewModel()
}
