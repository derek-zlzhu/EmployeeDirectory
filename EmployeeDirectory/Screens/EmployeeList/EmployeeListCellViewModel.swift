//
//  EmployeeListCellViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-30.
//

import Foundation
import UIKit.UIImage

@MainActor
final class EmployeeListCellViewModel: ObservableObject {

  @Published private(set) var image: UIImage = ImageManager.placeholder

  var employeeName: String { employee?.fullName ?? "" }
  var employeeTeam: String { employee?.team ?? "" }

  private var employee: Employee?
  private var initialized = false

  func setup(employee: Employee) async {
    if initialized { return }

    self.employee = employee
    await loadSmallImage()

    initialized = true
  }

  func loadSmallImage() async {
    guard let urlString = employee?.photoUrlSmall else { return }

    do {
      let downloadedImage = try await ImageManager.shared.getImage(from: urlString)
      if let downloadedImage = downloadedImage {
        updateImage(image: downloadedImage)
      }
    } catch { }
  }

  private func updateImage(image: UIImage) {
    self.image = image
  }
}
