//
//  EmployeeListViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

@MainActor
final class EmployeeListViewModel: ObservableObject {

  let employeeService: EmployeeServiceType

  @Published private(set) var employees: [Employee] = []
  @Published private(set) var isLoading = false

  @Published var textToSearch = ""
  @Published var alertItem: AlertItem?

  init(employeeService: EmployeeServiceType = EmployeeService()) {
    self.employeeService = employeeService
  }

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

  var listIsEmpty: Bool {
    employees.isEmpty
  }

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

  func refreshEmployees() async {
    await fetchEmployees()
  }
}
