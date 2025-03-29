//
//  MockEmployeeService.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-17.
//

import Foundation

struct MockEmployeeService: EmployeeServiceType {

  func fetchEmployees() async throws -> [Employee] {
    let employees: [Employee] = [
      Employee.sharedPreview,
      MockEmployeeService.janeDoe,
      MockEmployeeService.johnSmith
    ]

    return employees
  }

  static let janeDoe = Employee(
    uuid: UUID().uuidString,
    fullName: "Jane Doe",
    phoneNumber: "456-789-0123",
    emailAddress: "jane.doe@squareup.com",
    biography: "Designer on the Services team, working on the Appointments iOS and Android apps.",
    photoUrlSmall: "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/small.jpg",
    photoUrlLarge: "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/large.jpg",
    team: "Retail",
    employeeType: .contractor)

  static let johnSmith = Employee(
    uuid: UUID().uuidString,
    fullName: "John Smith",
    phoneNumber: "456-789-0123",
    emailAddress: "jane.doe@squareup.com",
    biography: "Designer on the Services team, working on the Appointments iOS and Android apps.",
    photoUrlSmall: "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/small.jpg",
    photoUrlLarge: "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/large.jpg",
    team: "Retail",
    employeeType: .contractor)
}

struct MockEmployeeInvalidURLService: EmployeeServiceType {
  func fetchEmployees() async throws -> [Employee] {
    throw EDError.invalidURL
  }
}

struct MockEmployeeInvalidDataService: EmployeeServiceType {
  func fetchEmployees() async throws -> [Employee] {
    throw EDError.invalidData
  }
}

struct MockEmployeeInvalidResponseService: EmployeeServiceType {
  func fetchEmployees() async throws -> [Employee] {
    throw EDError.invalidResponse
  }
}

extension String: @retroactive Error {}
struct MockEmployeeGeneralErrorService: EmployeeServiceType {
  func fetchEmployees() async throws -> [Employee] {
    throw "General Error"
  }
}
