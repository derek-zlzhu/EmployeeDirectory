//
//  EmployeeListView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct EmployeeListView: View {

  @StateObject private var viewModel = EmployeeListViewModel()

  var body: some View {
    content
      .alert(item: $viewModel.alertItem) { alertItem in
        Alert(title: alertItem.title,
              message: alertItem.message,
              dismissButton: alertItem.dismissButton)
      }
  }

  private var content: some View {
    NavigationView {
      if viewModel.listIsEmpty {
        emptyView.task { await viewModel.fetchEmployees() }
      } else {
        listView
      }
    }
    .navigationViewStyle(.stack)
  }

  private var listView: some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.filteredEmployees) { employee in
          NavigationLink(destination: EmployeeDetailView(employee: employee)) {
            EmployeeListCell(employee: employee).padding(.horizontal)
          }
        }
      }
    }
    .refreshable { await viewModel.refreshEmployees() }
    .searchable(text: $viewModel.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
    .navigationTitle("Employees")
  }

  private var emptyView: some View {
    ScrollView(.vertical) {
      VStack(alignment: .center, spacing: 30) {
        if viewModel.isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            .scaleEffect(2)
            .padding()
        } else {
          Image("emptyList")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)

          Text("There's no employee data available at the moment, please make sure network is connected and try again later.")
            .font(.title3)
            .foregroundColor(.secondary)
        }
      }
      .padding(30)
    }
    .refreshable { await viewModel.refreshEmployees() }
    .searchable(text: $viewModel.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
    .navigationTitle("Employees")
  }
}

#Preview {
  EmployeeListView()
}
