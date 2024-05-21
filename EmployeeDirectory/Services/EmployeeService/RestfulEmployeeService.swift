//
//  RestfulEmployeeService.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-17.
//

import Foundation

struct RestfulEmployeeService: RestfulService, EmployeeService {

  func fetchEmployees() async throws -> [Employee] {
    let url = URL(string: ConfigsManager.shared.appConfig.apiServiceUrl)
    let employeeResponse: EmployeeResponse = try await requestRestfulJson(url: url)

    return employeeResponse.employees
  }
}
