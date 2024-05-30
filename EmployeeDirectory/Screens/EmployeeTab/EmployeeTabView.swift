//
//  ContentView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct EmployeeTabView: View {

  @StateObject private var viewModel = EmployeeTabViewModel()

  var body: some View {
    TabView {
      if viewModel.shouldLoadMainTab {
        EmployeeListView().tabItem { Label("Employees", systemImage: "person.3.fill") }
        SettingsView().tabItem { Label("Settings", systemImage: "gear") }
      }
    }
    .fullScreenCover(isPresented: $viewModel.shouldLoadOnboarding) {
      OnboardingView(viewModel: viewModel)
    }
    .task {
      viewModel.initProperyValueFromDefaults()
    }
  }
}

#Preview {
  EmployeeTabView()
}
