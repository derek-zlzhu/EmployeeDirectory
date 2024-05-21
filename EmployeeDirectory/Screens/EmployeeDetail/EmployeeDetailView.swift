//
//  EmployeeDetailView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct EmployeeDetailView: View {

  @StateObject var viewModel = EmployeeDetailViewModel()

  let employee: Employee

  var body: some View {
    ScrollView(.vertical) {

        VStack(alignment: .leading, spacing: 30) {

          EmployeeProfileImageView(viewModel: viewModel)
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)

          VStack(alignment: .leading, spacing: 10) {
            KeyValueItemView(itemKey: Text("Name:"), itemValue: Text(viewModel.employeeName))
            KeyValueItemView(itemKey: Text("Team:"), itemValue: Text(viewModel.employeeTeam))
            KeyValueItemView(itemKey: Text("Position:"), itemValue: Text(viewModel.employeePosition))
            KeyValueItemView(itemKey: Text("Bio:"), itemValue: Text(viewModel.employeeBio))
          }
          .padding(.horizontal, 30)

          Spacer()
        }
        .onAppear() {
          viewModel.setEmployee(employee: employee)
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
}

fileprivate struct EmployeeProfileImageView: View {

  @ObservedObject var viewModel: EmployeeDetailViewModel
  @State var profileImage: UIImage = ImageManager.placeholder

  var body: some View {
    GeometryReader { geometry in
      Image(uiImage: profileImage)
        .resizable()
        .scaledToFill()
        .frame(width: geometry.size.width, height: geometry.size.width)
        .clipped()
        .cornerRadius(16)
        .foregroundColor(Color(UIColor.lightGray))
        .onReceive(viewModel.$image) { image in
          self.profileImage = image
        }
        .task {
          await viewModel.loadImage(for: viewModel.employeeLargeImageUrl)
        }
        .overlay {
          if viewModel.loading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .gray))
              .scaleEffect(2)
              .offset(y: -40)
          }
        }
    }
  }
}

#Preview {
  EmployeeDetailView(employee: Employee.sharedPreview)
}
