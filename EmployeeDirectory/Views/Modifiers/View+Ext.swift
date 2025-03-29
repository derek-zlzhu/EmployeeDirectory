//
//  View+Ext.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-19.
//

import SwiftUI

private let rainbowDebugColors: [Color] = [
  .purple, .blue, .green, .yellow, .orange, .red, .pink
]

extension View {

  func brandTextStyle() -> some View {
    modifier(TextModifier())
  }

  func debug() -> Self {
    print(Mirror(reflecting: self).subjectType)
    return self
  }

  func rainbowDebug() -> some View {
    self.background(rainbowDebugColors.randomElement())
  }
}
