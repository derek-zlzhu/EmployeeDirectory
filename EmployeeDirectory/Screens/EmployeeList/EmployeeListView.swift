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
      ScrollView(.vertical) {
        if viewModel.employListIsEmpty {
          emptyView.task { await viewModel.fetchEmployees() }
        } else if viewModel.isLoading {
          loadingProgressView
        } else {
          listView
        }
      }
      .padding()
      .refreshable { await viewModel.refreshEmployees() }
      .navigationTitle("Employees")
    }
    .navigationViewStyle(.stack)
  }

  private var listView: some View {
    let columns = [ GridItem(.flexible(), alignment: .leading) ]

    return LazyVGrid(columns: columns, spacing: 20) {
      ForEach(viewModel.filteredEmployees) { employee in
        NavigationLink(destination: EmployeeDetailView(employee: employee)) {
          EmployeeListCell(employee: employee)
        }
      }
    }
    .searchable(text: $viewModel.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
  }

  private var emptyView: some View {
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

  private var loadingProgressView: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .gray))
      .scaleEffect(2)
      .offset(y: -40)
  }
}

#Preview {
  EmployeeListView()
}
