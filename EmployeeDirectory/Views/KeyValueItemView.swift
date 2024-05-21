//
//  KeyValueItemView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import SwiftUI

internal struct KeyValueItemView: View {

  let itemKey: Text
  let itemValue: Text

  var body: some View {
    HStack(alignment: .top) {
      itemKey
        .font(.subheadline)
        .fontWeight(.semibold)

      itemValue
        .font(.subheadline)
        .fontWeight(.regular)

      Spacer()
    }
  }
}

#Preview {
  KeyValueItemView(itemKey: Text("Name"), itemValue: Text("John Doe"))
}
