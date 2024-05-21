//
//  AlertItem.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

internal struct AlertItem: Identifiable {

  let id = UUID()
  let title: Text
  let message: Text
  let dismissButton: Alert.Button

  init(
    title: Text = Text("Error"), 
    message: Text = Text("Something is running unexpected. Please try again sometime later."),
    dismissButton: Alert.Button = .default(Text("OK"))
  ) {
    self.title = title
    self.message = message
    self.dismissButton = dismissButton
  }
}

internal struct AlertContext {

  // MARK: - Network Alerts

  static let invalidURL = AlertItem(title: Text("Server Error"), message: Text("There was an issue connecting to the server."))

  static let invalidData = AlertItem(title: Text("Server Error"), message: Text("The data received from the server was invalid."))

  static let invalidResponse = AlertItem(title: Text("Server Error"), message: Text("Invalid response from the server."))
}
