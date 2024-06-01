//
//  Employee.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

public struct Employee: Decodable {
  let uuid: String
  let fullName: String
  let phoneNumber: String?
  let emailAddress: String?
  let biography: String?
  let photoUrlSmall: String?
  let photoUrlLarge: String?
  let team: String?
  let employeeType: EmployeeType?
}

extension Employee: Identifiable {
  public var id: String { uuid }
}

extension Employee {
  static let sharedPreview = Employee(
    uuid: UUID().uuidString, 
    fullName: "John Doe",
    phoneNumber: "123-456-7890",
    emailAddress: "john.doe@squareup.com", 
    biography: "Designer on the Services team, working on the Appointments iOS and Android apps.",
    photoUrlSmall: "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/small.jpg",
    photoUrlLarge: "https://s3.amazonaws.com/sq-mobile-interview/photos/077c1707-4199-415c-86b5-a29afe4e29e3/large.jpg",
    team: "Retail", 
    employeeType: .contractor
  )
}

public struct EmployeeResponse: Decodable {
  let employees: [Employee]
}
