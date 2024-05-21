//
//  SettingsView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct SettingsView: View {
  
  @StateObject var viewModel = SettingsViewModel()

  var body: some View {
    NavigationView {
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: 20) {
          KeyValueItemView(itemKey: Text("Display Name: "), itemValue: Text(viewModel.displayName))
          KeyValueItemView(itemKey: Text("Bundle Identifier: "), itemValue: Text(viewModel.bundleIdentifier))
          KeyValueItemView(itemKey: Text("Bundle Version: "), itemValue: Text(viewModel.bundleVersion))
          KeyValueItemView(itemKey: Text("Creator Name: "), itemValue: Text(viewModel.creatorName))

          Spacer()
        }
        .padding(.horizontal, 22)
      }
      .padding(.top, 22)
      .navigationTitle("Settings")
    }
    .navigationViewStyle(.stack)
  }
}

#Preview {
  SettingsView()
}
