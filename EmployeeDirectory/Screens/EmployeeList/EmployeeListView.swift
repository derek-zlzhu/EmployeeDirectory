//
//  EmployeeListView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct EmployeeListView: View {

  @StateObject var viewModel = EmployeeListViewModel()

  var body: some View {
    if viewModel.isLoading {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
        .scaleEffect(2)
        .offset(y: -40)
    } else {
      content
        .alert(item: $viewModel.alertItem) { alertItem in
          Alert(title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton)
        }
    }
  }

  var content: some View {
    NavigationView {
      if viewModel.employees.isEmpty {
        emptyView
      } else {
        listView
      }
    }
    .navigationViewStyle(.stack)
  }

  var emptyView: some View {
    VStack(alignment: .center, spacing: 30) {
      Image("emptyList")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)

      Text("There's no employee data available at the moment, please make sure network is connected and try again later.")
        .font(.title3)
        .foregroundColor(.secondary)

      Spacer()
    }
    .padding(30)
  }

  var listView: some View {
    List(viewModel.filteredEmployees) { employee in
      NavigationLink(destination: EmployeeDetailView(employee: employee)) {
        EmployeeListCell(employee: employee)
      }
    }
    .refreshable {
      await viewModel.fetchEmployees()
    }
    .navigationTitle("Employees")
    .searchable(text: $viewModel.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
  }
}

#Preview {
  EmployeeListView()
}