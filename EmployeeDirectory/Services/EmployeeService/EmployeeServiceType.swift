//
//  EmployeeService.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-17.
//

import Foundation

protocol EmployeeServiceType: Sendable {
  func fetchEmployees() async throws -> [Employee]
}
