//
//  OnboardingView.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import SwiftUI

struct OnboardingView: View {

  @ObservedObject var viewModel: EmployeeTabViewModel

  var body: some View {
    NavigationView {
      VStack(spacing: 22) {
        Spacer()

        Text("Welcome to our Employee Directory app")
          .brandTextStyle()

        Button {
          viewModel.showedOnboarding()
        } label: {
          Text("Get Started")
        }

        Spacer()
      }
      .navigationTitle("Onboarding")
    }
  }
}

#Preview {
  OnboardingView(viewModel: EmployeeTabViewModel())
}
