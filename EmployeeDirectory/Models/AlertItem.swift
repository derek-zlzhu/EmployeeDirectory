//
//  AlertItem.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct AlertItem: Identifiable, Sendable {
  let id = UUID()
  let title: String
  let message: String
}

struct AlertContext {
  static let invalidURL = AlertItem(title: "Server Error", message: "There was an issue connecting to the server.")
  static let invalidData = AlertItem(title: "Server Error", message: "The data received from the server was invalid.")
  static let invalidResponse = AlertItem(title: "Server Error", message: "Invalid response from the server.")
  static let localCacheCleared = AlertItem(title: "Info", message: "Local cache cleared.")
}
