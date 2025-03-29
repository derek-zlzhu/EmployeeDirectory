//
//  RestfulService.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-17.
//

import Foundation

protocol RestfulService {
  func requestRestfulJson<T: Decodable>(url: URL?) async throws -> T
}

extension RestfulService {

  func requestRestfulJson<T: Decodable>(url: URL?) async throws -> T {
    guard let url = url else {
      throw EDError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval = TimeInterval(await ConfigsManager.shared.appConfig.requestTimeout)

    let (data, _) = try await URLSession.shared.data(for: request)
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      let result = try decoder.decode(T.self, from: data)
      return result
    } catch {
      throw EDError.invalidData
    }
  }
}
