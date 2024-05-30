//
//  EmployeeListCellViewModelTests.swift
//  EmployeeDirectoryTests
//
//  Created by Derek Zhu on 2024-05-30.
//

import XCTest
import Combine
@testable import EmployeeDirectory

final class EmployeeListCellViewModelTests: XCTestCase {

  private var sut: EmployeeListCellViewModel!
  private var cancellables = Set<AnyCancellable>()

  override func setUp() {
    sut = EmployeeListCellViewModel()
  }

  override func tearDown() {
    sut = nil
  }

  func testNSetupTwice() async {
    await sut.setup(employee: Employee.sharedPreview)
    await sut.setup(employee: Employee.sharedPreview)
    XCTAssertEqual(sut.employeeName, "John Doe")
  }

  func testNameEqual() async {
    await sut.setup(employee: Employee.sharedPreview)
    XCTAssertEqual(sut.employeeName, "John Doe")
  }

  func testNameEqualEmpty() {
    XCTAssertEqual(sut.employeeName, "")
  }

  func testTeamEqual() async {
    await sut.setup(employee: Employee.sharedPreview)
    XCTAssertEqual(sut.employeeTeam, "Retail")
  }

  func testTeamEqualEmpty() {
    XCTAssertEqual(sut.employeeTeam, "")
  }

  func testImagePlaceHolder() {
    XCTAssertEqual(sut.image, ImageManager.placeholder)
  }

  @MainActor
  func testLoadedImageSuccess() async {
    await sut.setup(employee: Employee.sharedPreview)

    let expectationSuccess = self.expectation(description: "Publishes image update success")
    sut.$image
      .dropFirst()
      .sink(receiveValue: { image in
        XCTAssertNotEqual(image, ImageManager.placeholder)
        expectationSuccess.fulfill()
      })
      .store(in: &cancellables)

    await sut.loadSmallImage()

    await fulfillment(of: [expectationSuccess], timeout: 5)
  }

  @MainActor
  func testLoadedImageFail() async {
    let expectationSuccess = self.expectation(description: "Publishes image update success")
    sut.$image
      .sink(receiveValue: { image in
        XCTAssertEqual(image, ImageManager.placeholder)
        expectationSuccess.fulfill()
      })
      .store(in: &cancellables)

    await sut.loadSmallImage()

    await fulfillment(of: [expectationSuccess], timeout: 5)
  }
}
