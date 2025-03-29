//
//  EmployeeService.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-17.
//

import Foundation

struct EmployeeService: RestfulService, EmployeeServiceType {

  func fetchEmployees() async throws -> [Employee] {
    let url = URL(string: await ConfigsManager.shared.appConfig.apiServiceUrl)
    let employeeResponse: EmployeeResponse = try await requestRestfulJson(url: url)

    return employeeResponse.employees
  }
}
