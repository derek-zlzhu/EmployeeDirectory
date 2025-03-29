//
//  EmployeeTabViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-19.
//

import Foundation

@MainActor
final class EmployeeTabViewModel: ObservableObject {

  @Published private(set) var shouldLoadMainTab = false
  @Published var shouldLoadOnboarding = false

  func initProperyValueFromDefaults() {
    let seenOnbarding = UserDefaults.standard.bool(forKey: kSeenOnboardingKey)

    shouldLoadOnboarding = !seenOnbarding
    self.shouldLoadMainTab    = seenOnbarding
  }

  func hideOnboardingView() {
    UserDefaults.standard.set(true, forKey: kSeenOnboardingKey)
    UserDefaults.standard.synchronize()

    shouldLoadOnboarding = false
    shouldLoadMainTab    = true
  }

  private let kSeenOnboardingKey = "seenOnboarding"
}
