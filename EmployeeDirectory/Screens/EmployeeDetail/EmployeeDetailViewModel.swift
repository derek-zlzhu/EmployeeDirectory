//
//  EmployeeDetailViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-14.
//

import Foundation
import UIKit.UIImage

final class EmployeeDetailViewModel: ObservableObject {

  @Published var image: UIImage = ImageManager.placeholder
  @Published var loading: Bool = false

  var employee: Employee?

  func setEmployee(employee: Employee) {
    self.employee = employee
  }

  var employeeName: String { employee?.fullName ?? "" }
  var employeeTeam: String { employee?.team ?? "" }
  var employeePosition: String { employee?.employeeType.position ?? "" }
  var employeeBio: String { employee?.biography ?? "" }
  var employeeLargeImageUrl: String { employee?.photoUrlLarge ?? "" }

  @MainActor
  func loadImage(for urlString: String?) async {
    guard let urlString = urlString else { return }

    loading = true
    do {
      let downloadedImage = try await ImageManager.shared.getImage(from: urlString)
      if let downloadedImage = downloadedImage {
        image = downloadedImage
        loading = false
      }
    } catch {
      loading = false
    }
  }


}
