//
//  TextModifier.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-19.
//

import SwiftUI

struct TextModifier: ViewModifier {

  func body(content: Content) -> some View {
    content
      .font(.subheadline)
      .foregroundColor(.primary)
      .background(Color(.systemGray6))
  }
}
