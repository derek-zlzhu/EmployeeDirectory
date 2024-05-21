//
//  EmployeeListCell.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import SwiftUI

struct EmployeeListCell: View {

  let employee: Employee

  var body: some View {
    HStack(spacing: 10) {
      AsyncImage(url: URL(string: employee.photoUrlSmall!)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 90, height: 90)
          .cornerRadius(8)
      } placeholder: {
        Image(uiImage: ImageManager.placeholder)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 90, height: 90)
          .cornerRadius(8)
      }
      .padding(.vertical, 8)

      VStack(alignment: .leading, spacing: 5) {
        Text(employee.fullName)
          .font(.title2)
          .fontWeight(.medium)

        Text(employee.team)
          .foregroundColor(.secondary)
          .fontWeight(.semibold)
      }
    }
  }
}

#Preview {
  EmployeeListCell(employee: Employee.sharedPreview)
}
