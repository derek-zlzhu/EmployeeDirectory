//
//  EmployeeListCellViewModel.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-30.
//

import Foundation
import UIKit.UIImage

final class EmployeeListCellViewModel: ObservableObject {

  @Published private(set) var image: UIImage = ImageManager.placeholder

  var employeeName: String { employee?.fullName ?? "" }
  var employeeTeam: String { employee?.team ?? "" }

  private var employee: Employee?
  private var initialized = false

  @MainActor
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
        await updateImage(image: downloadedImage)
      }
    } catch { }
  }

  @MainActor
  private func updateImage(image: UIImage) {
    self.image = image
  }
}
