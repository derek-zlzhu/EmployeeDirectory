//
//  EmployeeListViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation

final class EmployeeListViewModel: ObservableObject {

  let employeeService: EmployeeService

  @Published private(set) var employees: [Employee] = []
  @Published private(set) var isLoading = true

  @Published var textToSearch = ""
  @Published var alertItem: AlertItem?

  private var loaded = false

  init(
    employeeService: EmployeeService = RestfulEmployeeService()
  ) {
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

  var employListIsEmpty: Bool {
    employees.isEmpty
  }

  @MainActor
  func fetchEmployees() async {
    if loaded { return }

    textToSearch = ""
    isLoading = true

    do {
      employees = try await employeeService.fetchEmployees()
      isLoading = false
      loaded = true
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
      loaded = true
    }
  }

  @MainActor
  func refreshEmployees() async {
    loaded = false
    await fetchEmployees()
  }
}
