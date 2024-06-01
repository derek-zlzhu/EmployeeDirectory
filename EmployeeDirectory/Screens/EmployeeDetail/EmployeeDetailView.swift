//
//  EmployeeDetailView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct EmployeeDetailView: View {

  @StateObject private var viewModel = EmployeeDetailViewModel()

  let employee: Employee

  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: 30) {
        employeeProfileImageView
        employeeInfoViews
        Spacer()
      }
      .task() {
        await viewModel.setup(employee: employee)
      }
      .offset(y: -44)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(viewModel.employeeName)
            .foregroundColor(.primary)
            .fontWeight(.bold)
        }
      }
    }
  }

  var employeeProfileImageView: some View {
    GeometryReader { geometry in
      Image(uiImage: viewModel.image)
        .resizable()
        .scaledToFill()
        .frame(width: geometry.size.width, height: geometry.size.width)
        .clipped()
        .cornerRadius(16)
        .foregroundColor(Color(UIColor.lightGray))
        .overlay {
          if viewModel.loading {
            loadingProgressView
          }
        }
    }
    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
  }

  var employeeInfoViews: some View {
    VStack(alignment: .leading, spacing: 10) {
      KeyValueItemView(itemKey: Text("Name:"), itemValue: Text(viewModel.employeeName))
      KeyValueItemView(itemKey: Text("Team:"), itemValue: Text(viewModel.employeeTeam))
      KeyValueItemView(itemKey: Text("Position:"), itemValue: Text(viewModel.employeePosition))
      KeyValueItemView(itemKey: Text("Bio:"), itemValue: Text(viewModel.employeeBio))
    }
    .padding(.horizontal, 30)
  }

  var loadingProgressView: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .gray))
      .scaleEffect(2)
      .offset(y: -40)
  }
}

#Preview {
  EmployeeDetailView(employee: Employee.sharedPreview)
}
