//
//  EmployeeListViewModelTests.swift
//  EmployeeDirectoryTests
//
//  Created by Derek Zhu on 2024-05-15.
//

import XCTest
import Combine
@testable import EmployeeDirectory

final class EmployeeListViewModelTests: XCTestCase {

  private var sut: EmployeeListViewModel!
  private var cancellables = Set<AnyCancellable>()

  override func setUp() {
    sut = EmployeeListViewModel(employeeService: MockEmployeeService())
  }

  override func tearDown() {
    sut = nil
  }

  @MainActor
  func testFetchEmployeesSuccess() {
    let sut = EmployeeListViewModel(employeeService: MockEmployeeService())
    let expectationSuccess = self.expectation(description: "Fetch Employees Success")

    sut.$employees
      .dropFirst()
      .sink(receiveValue: { employees in
        XCTAssertEqual(employees.count, 3)
        XCTAssertEqual(employees[0].fullName, Employee.sharedPreview.fullName)
        XCTAssertEqual(employees[1].fullName, MockEmployeeService.janeDoe.fullName)
        XCTAssertEqual(employees[2].fullName, MockEmployeeService.johnSmith.fullName)

        expectationSuccess.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationSuccess], timeout: 1)
  }

  @MainActor
  func testFetchEmployeesInvalideUrl() {
    let sut1 = EmployeeListViewModel(employeeService: MockEmployeeInvalidURLService())
    let expectationInvalidURL = self.expectation(description: "Fetch Employees invalide Url")

    sut1.$alertItem
      .dropFirst()
      .sink(receiveValue: { item in
        XCTAssertEqual(item!.title, AlertContext.invalidURL.title)

        expectationInvalidURL.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationInvalidURL], timeout: 1)
  }

  @MainActor
  func testFetchEmployeesInvalideData() {
    let sut2 = EmployeeListViewModel(employeeService: MockEmployeeInvalidDataService())
    let expectationInvalidData = self.expectation(description: "Fetch Employees invalide Data")

    sut2.$alertItem
      .dropFirst()
      .sink(receiveValue: { item in
        XCTAssertEqual(item!.title, AlertContext.invalidData.title)

        expectationInvalidData.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationInvalidData], timeout: 1)
  }

  @MainActor
  func testFetchEmployeesInvalideResponse() {
    let sut3 = EmployeeListViewModel(employeeService: MockEmployeeInvalidResponseService())
    let expectationInvalidResponse = self.expectation(description: "Fetch Employees invalide Response")

    sut3.$alertItem
      .dropFirst()
      .sink(receiveValue: { item in
        XCTAssertEqual(item!.title, AlertContext.invalidResponse.title)

        expectationInvalidResponse.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationInvalidResponse], timeout: 1)
  }

  @MainActor
  func testFetchEmployeesGeneralFail() {
    let sut4 = EmployeeListViewModel(employeeService: MockEmployeeGeneralErrorService())
    let expectationFail = self.expectation(description: "Fetch Employees General Fail")

    sut4.$alertItem
      .dropFirst()
      .sink(receiveValue: { item in
        XCTAssertEqual(item!.title, AlertContext.invalidResponse.title)

        expectationFail.fulfill()
      })
      .store(in: &cancellables)

    wait(for: [expectationFail], timeout: 1)
  }

  @MainActor
  func testFilterNothingEmployees() {
    let expectationSuccess = self.expectation(description: "Filter Nothing Employees")

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.sut.textToSearch = ""

      XCTAssertEqual(self?.sut.filteredEmployees.count, 3)
      XCTAssertEqual(self?.sut.filteredEmployees[0].fullName, Employee.sharedPreview.fullName)

      expectationSuccess.fulfill()
    }

    wait(for: [expectationSuccess], timeout: 1)
  }

  @MainActor
  func testFilterOutEmployees() {
    let expectationSuccess = self.expectation(description: "Filter Out Employees")

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.sut.textToSearch = "c"

      XCTAssertEqual(self?.sut.filteredEmployees.count, 0)

      expectationSuccess.fulfill()
    }

    wait(for: [expectationSuccess], timeout: 1)
  }

  @MainActor
  func testFilterIncludeEmployees() {
    let expectationSuccess = self.expectation(description: "Filter Include Employees")

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.sut.textToSearch = "john"

      XCTAssertEqual(self?.sut.filteredEmployees.count, 2)

      expectationSuccess.fulfill()
    }

    wait(for: [expectationSuccess], timeout: 1)
  }
}
