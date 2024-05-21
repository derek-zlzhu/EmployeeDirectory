//
//  EmployeeService.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-17.
//

import Foundation

protocol EmployeeService {
  func fetchEmployees() async throws -> [Employee]
}
