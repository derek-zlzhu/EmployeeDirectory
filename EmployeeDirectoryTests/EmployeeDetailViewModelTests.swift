//
//  EmployeeDetailViewModelTests.swift
//  EmployeeDirectoryTests
//
//  Created by Derek Zhu on 2024-05-16.
//

import XCTest
import Combine
@testable import EmployeeDirectory

final class EmployeeDetailViewModelTests: XCTestCase {

  private var sut: EmployeeDetailViewModel!
  private var cancellables = Set<AnyCancellable>()

  override func setUp() {
    sut = EmployeeDetailViewModel()
  }

  override func tearDown() {
    sut = nil
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

  func testPositionEqual() async {
    await sut.setup(employee: Employee.sharedPreview)
    XCTAssertEqual(sut.employeePosition, "Contractor")
  }

  func testPositionEqualEmpty() {
    XCTAssertEqual(sut.employeePosition, "")
  }

  func testBioEqual() async {
    await sut.setup(employee: Employee.sharedPreview)
    XCTAssertEqual(sut.employeeBio, "Designer on the Services team, working on the Appointments iOS and Android apps.")
  }

  func testBioEqualEmpty() {
    XCTAssertEqual(sut.employeeBio, "")
  }

  func testImageUrlEqual() async {
    await sut.setup(employee: Employee.sharedPreview)
    XCTAssertEqual(sut.employeeLargeImageUrl, "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/large.jpg")
  }

  func testImageUrlEqualEmpty() {
    XCTAssertEqual(sut.employeeLargeImageUrl, "")
  }

  func testImagePlaceHolder() {
    XCTAssertEqual(sut.image, ImageManager.placeholder)
  }

  @MainActor
  func testLoadedImageSuccess() {
    let expectationSuccess = self.expectation(description: "Publishes image update success")
    sut.$image
      .dropFirst()
      .sink(receiveValue: { image in
        XCTAssertNotEqual(image, ImageManager.placeholder)
        expectationSuccess.fulfill()
      })
      .store(in: &cancellables)

    Task{ await sut.loadImage(for: Employee.sharedPreview.photoUrlLarge) }

    wait(for: [expectationSuccess], timeout: 5)
  }

  @MainActor
  func testLoadedImageFailForNil() {
    let expectationFail = self.expectation(description: "Load Image Fail For Nil")
    sut.$loading
      .sink(receiveValue: { loading in
        XCTAssertEqual(loading, false)

        expectationFail.fulfill()
      })
      .store(in: &cancellables)

    Task { [sut] in
      if let sut = sut {
        await sut.loadImage(for: nil)
      }
    }

    wait(for: [expectationFail], timeout: 1)
  }
}
