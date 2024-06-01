//
//  View+Ext.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-19.
//

import SwiftUI

extension View {

  func brandTextStyle() -> some View {
    modifier(TextModifier())
  }

  func debug() -> Self {
    print(Mirror(reflecting: self).subjectType)
    return self
  }
}
