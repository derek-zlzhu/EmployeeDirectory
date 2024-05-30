//
//  EmployeeTabViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-19.
//

import Foundation

final class EmployeeTabViewModel: ObservableObject {

  @Published private(set) var shouldLoadMainTab = false
  @Published var shouldLoadOnboarding = false

  func initProperyValueFromDefaults() {
    let seenOnbarding = UserDefaults.standard.bool(forKey: kSeenOnboardingKey)

    DispatchQueue.main.async { [weak self] in
      self?.shouldLoadOnboarding = !seenOnbarding
      self?.shouldLoadMainTab    = seenOnbarding
    }
  }

  @MainActor
  func hideOnboardingView() {
    UserDefaults.standard.set(true, forKey: kSeenOnboardingKey)
    UserDefaults.standard.synchronize()

    shouldLoadOnboarding = false
    shouldLoadMainTab    = true
  }

  private let kSeenOnboardingKey = "seenOnboarding"
}
