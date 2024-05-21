//
//  SettingsViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

  @Published var displayName: String = "Not Specified"
  @Published var bundleIdentifier: String = ""
  @Published var bundleVersion: String = ""
  @Published var creatorName: String = ""

  init() {
    retriveBundleInfos()
  }

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
}


extension SettingsViewModel {
  static let sharedPreview = SettingsViewModel()
}
