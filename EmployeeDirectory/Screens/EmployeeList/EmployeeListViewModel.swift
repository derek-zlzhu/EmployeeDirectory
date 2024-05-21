//
//  EmployeeListViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

final class EmployeeListViewModel: ObservableObject {

  let employeeService: EmployeeService

  @Published var employees: [Employee] = []
  @Published var textToSearch = ""

  @Published var alertItem: AlertItem?
  @Published var isLoading = false

  var filteredEmployees: [Employee] {
    if textToSearch.isEmpty {
      return employees
    }

    return employees.filter { employee in
      textToSearch.split(separator: " ").allSatisfy { string in
        employee.fullName.lowercased().contains(string.lowercased())
      }
    }
  }

  init(
    employeeService: EmployeeService = RestfulEmployeeService()
  ) {
    self.employeeService = employeeService
    Task { await fetchEmployees() }
  }

  @MainActor
  func fetchEmployees() async {
    textToSearch = ""
    isLoading = true

    do {
      employees = try await employeeService.fetchEmployees()
      isLoading = false
    } catch {
      if let edError = error as? EDError {
        switch edError {
          case .invalidURL:
            alertItem = AlertContext.invalidURL
          case .invalidResponse:
            alertItem = AlertContext.invalidResponse
          case .invalidData:
            alertItem = AlertContext.invalidData
        }
      } else {
        alertItem = AlertContext.invalidResponse
      }
      isLoading = false
    }
  }
}
