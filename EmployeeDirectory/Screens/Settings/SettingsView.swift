//
//  SettingsView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct SettingsView: View {
  
  @StateObject private var viewModel = SettingsViewModel()

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Bundle Info: ")) {
          KeyValueItemView(itemKey: Text("Display Name: "), itemValue: Text(viewModel.displayName))
          KeyValueItemView(itemKey: Text("Bundle Identifier: "), itemValue: Text(viewModel.bundleIdentifier))
          KeyValueItemView(itemKey: Text("Bundle Version: "), itemValue: Text(viewModel.bundleVersion))
        }

        Section(header: Text("Creator: ")) {
          KeyValueItemView(itemKey: Text("Creator Name: "), itemValue: Text(viewModel.creatorName))
        }

        Section {
          resetCacheView
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Settings")
    }
    .navigationViewStyle(.stack)
    .task {
      viewModel.retriveBundleInfos()
    }
  }

  var resetCacheView: some View {
    Button {
      viewModel.resetLocalCache()
    } label: {
      Text("Reset local cache")
    }
    .alert(item: $viewModel.alertItem) { alertItem in
      Alert(title: alertItem.title,
            message: alertItem.message,
            dismissButton: alertItem.dismissButton)
    }
  }
}

#Preview {
  SettingsView()
}
