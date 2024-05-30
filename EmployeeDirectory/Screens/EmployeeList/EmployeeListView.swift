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
    content
      .task {
        await viewModel.fetchEmployees()
      }
      .alert(item: $viewModel.alertItem) { alertItem in
        Alert(title: alertItem.title,
              message: alertItem.message,
              dismissButton: alertItem.dismissButton)
      }
  }

  var content: some View {
    NavigationView {
      if viewModel.isLoading {
        loadingProgressView
      } else if viewModel.employListIsEmpty {
        emptyView
      } else {
        listView
      }
    }
    .navigationViewStyle(.stack)
  }

  var listView: some View {
    List(viewModel.filteredEmployees) { employee in
      NavigationLink(destination: EmployeeDetailView(employee: employee)) {
        EmployeeListCell(employee: employee)
      }
    }
    .refreshable {
      await viewModel.refreshEmployees()
    }
    .searchable(text: $viewModel.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
    .navigationTitle("Employees")
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
    .navigationTitle("Employees")
  }

  var loadingProgressView: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .gray))
      .scaleEffect(2)
      .offset(y: -40)
      .navigationTitle("Employees")
  }
}

#Preview {
  EmployeeListView()
}
