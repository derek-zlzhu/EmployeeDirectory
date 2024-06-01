//
//  EmployeeListCell.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import SwiftUI

struct EmployeeListCell: View {

  let employee: Employee

  @StateObject private var viewModel = EmployeeListCellViewModel()

  var body: some View {
    HStack(spacing: 10) {
      Image(uiImage: viewModel.image)
        .resizable()
        .scaledToFill()
        .frame(width: 90, height: 90)
        .cornerRadius(8)
        .clipped()
        .foregroundColor(Color(UIColor.lightGray))
        .task {
          await viewModel.setup(employee: employee)
        }

      VStack(alignment: .leading, spacing: 5) {
        Text(viewModel.employeeName)
          .font(.title2)
          .fontWeight(.medium)

        Text(viewModel.employeeTeam)
          .foregroundColor(.secondary)
          .fontWeight(.semibold)
      }
    }
  }
}

#Preview {
  EmployeeListCell(employee: Employee.sharedPreview)
}
