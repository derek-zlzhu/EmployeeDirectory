//
//  SettingsViewModelTests.swift
//  EmployeeDirectoryTests
//
//  Created by Derek Zhu on 2024-05-15.
//

import XCTest
@testable import EmployeeDirectory

@MainActor
final class SettingsViewModelTests: XCTestCase {

  private var sut: SettingsViewModel!

  override func setUp() {
    sut = SettingsViewModel.sharedPreview
    sut.retriveBundleInfos()
  }

  override func tearDown() {
    sut = nil
  }

  func testDisplayName() {
    XCTAssertEqual(sut.displayName, "Employee Directory")
  }

  func testBundleIdentifier() {
    XCTAssertEqual(sut.bundleIdentifier, "com.jbrothers.EmployeeDirectory")
  }

  func testBundleVersion() {
    XCTAssertEqual(sut.bundleVersion, "1.0")
  }

  func testCreatorName() {
    XCTAssertEqual(sut.creatorName, "Derek Zhu")
  }

  func testResetCache() {
    sut.resetLocalCache()

    let seenOnbarding = UserDefaults.standard.bool(forKey: "seenOnboarding")
    XCTAssertEqual(seenOnbarding, false)
  }

}
