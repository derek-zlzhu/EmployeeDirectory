//
//  EmployeeTabViewModelTests.swift
//  EmployeeDirectoryTests
//
//  Created by Derek Zhu on 2024-05-15.
//

import XCTest
import Combine
@testable import EmployeeDirectory

final class EmployeeTabViewModelTests: XCTestCase {

  private var sut: EmployeeTabViewModel!
  private var cancellables = Set<AnyCancellable>()

  override func setUp() {
    UserDefaults.standard.removeObject(forKey: "seenOnboarding")
    sut = EmployeeTabViewModel()
  }

  override func tearDown() {
    sut = nil
  }

  @MainActor
  func testShouldLoadOnboardingBeforeUpdate() {
    let expectationSuccess = self.expectation(description: "Should Load Onboarding Before Update")
    sut.$shouldLoadOnboarding
      .dropFirst()
      .sink(receiveValue: { l in
        XCTAssertEqual(l, true)
        expectationSuccess.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationSuccess], timeout: 1)
  }

  @MainActor
  func testShouldLoadMainTabBeforeUpdate() {
    let expectationSuccess = self.expectation(description: "Should Load Main Tab Before Update")
    sut.$shouldLoadMainTab
      .dropFirst()
      .sink(receiveValue: { l in
        XCTAssertEqual(l, false)
        expectationSuccess.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationSuccess], timeout: 1)
  }

  @MainActor 
  func testShouldLoadOnboardingAfterUpdate() {
    sut.showedOnboarding()
    XCTAssertEqual(sut.shouldLoadOnboarding, false)
  }

  @MainActor
  func testShouldLoadMainTabAfterUpdate() {
    sut.showedOnboarding()
    XCTAssertEqual(sut.shouldLoadMainTab, true)
  }
}
