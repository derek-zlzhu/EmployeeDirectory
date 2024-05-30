//
//  ImageManager.swift
//  EmployeeDirectory
//
//  Created by Derek Zhu on 2024-05-15.
//

import Foundation
import UIKit.UIImage

final internal class ImageManager {

  static let shared = ImageManager()
  static let placeholder: UIImage = UIImage(named: "placeholder")!

  private var cache: ImageCache
  private init() {
    self.cache = ImageMemoryFileCache()
  }

  func getImage(from url: String) async throws -> UIImage? {
    guard let nsurl = NSURL(string: url) else {
      throw EDError.invalidURL
    }

    if let image = cache.getImage(from: nsurl) {
      return image
    }

    do {
      if let image = try await downloadImage(from: nsurl as URL) {
        cache.cacheImage(for: nsurl, image: image)
        return image
      } else {
        throw EDError.invalidData
      }
    } catch {
      throw EDError.invalidResponse
    }
  }

  func resetCache() {
    cache.resetCache()
  }

  private func downloadImage(from url: URL) async throws -> UIImage? {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let image = UIImage(data: data) else { return nil }

      return image
    } catch {
      throw EDError.invalidData
    }
  }
}

/// Image Cache support configable memory and disk file sizes
fileprivate class ImageMemoryFileCache: NSObject, ImageCache {

  func getImage(from url: NSURL) -> UIImage? {

    var image = ImageMemoryCache.shared.getImage(forKey: url)
    if image == nil {
      image = ImageFileCache.shared.getImage(forKey: url)
      if let image = image {
        ImageMemoryCache.shared.cacheImage(forKey: url, image: image)
      }
    }

    return image
  }

  func cacheImage(for url: NSURL, image: UIImage) {
    ImageMemoryCache.shared.cacheImage(forKey: url, image: image)
    ImageFileCache.shared.cacheImage(forKey: url, image: image)
  }

  func resetCache() {
    ImageMemoryCache.shared.resetCache()
    ImageFileCache.shared.resetCache()
  }
}

/// Image cache using NSCache LRU memory cache
fileprivate class ImageMemoryCache {

  static let shared = ImageMemoryCache(ConfigsManager.shared.appConfig.imageMemoryCacheCount)

  private var cache: NSCache<NSURL, UIImage>

  private init(_ countLimit: Int) {
    self.cache = NSCache<NSURL, UIImage>()
    self.cache.countLimit = countLimit
  }

  func getImage(forKey: NSURL) -> UIImage? {
    return cache.object(forKey: forKey) as UIImage?
  }

  func cacheImage(forKey: NSURL, image: UIImage) {
    cache.setObject(image, forKey: forKey)
  }

  func resetCache() {
    cache.removeAllObjects()
  }
}

/// Image cache using disk files
fileprivate class ImageFileCache {

  static let shared = ImageFileCache(maximumCacheSize: ConfigsManager.shared.appConfig.imageFileCacheSize)

  private let maximumCacheSize: Int
  private let cacheOnDiskQueue: DispatchQueue
  private let fileManager: FileManager

  private var imageCacheDirectory: URL {
    fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("ImageCache")
  }

  private init(maximumCacheSize: Int, fileManager: FileManager = .default) {
    self.maximumCacheSize = maximumCacheSize
    self.fileManager = fileManager

    self.cacheOnDiskQueue = DispatchQueue(label: "Cache On Disk Queue", qos: .utility)

    createImageCacheDirectory()
    updateCacheOnDisk()
  }

  func getImage(forKey: NSURL) -> UIImage? {
    guard let urlString = forKey.absoluteString else {
      return nil
    }

    return UIImage(contentsOfFile: locationOnDisk(for: urlString).path)
  }

  func cacheImage(forKey: NSURL, image: UIImage) {
    guard let data = image.pngData(), let urlString = forKey.absoluteString else {
      return
    }

    cacheOnDiskQueue.async { [weak self] in
      self?.writeImageToDisk(data, for: urlString)
    }
  }

  func resetCache() {
    do {
      let contents = try fileManager.contentsOfDirectory(at: imageCacheDirectory, includingPropertiesForKeys: [])
      let _ = try contents.compactMap { url in
        try FileManager.default.removeItem(at: url)
      }
    } catch { }
  }

  private func createImageCacheDirectory() {
    do {
      try fileManager.createDirectory(at: imageCacheDirectory, withIntermediateDirectories: true)
    } catch {
      print("Unable to Create Image Cache Directory")
    }
  }

  private func writeImageToDisk(_ data: Data, for key: String) {
    do {
      try data.write(to: locationOnDisk(for: key))
      updateCacheOnDisk()
    } catch {
      print("Unable to Write Image to Disk \(error)")
    }
  }

  private func updateCacheOnDisk() {
    do {
      let resourceKeys: [URLResourceKey] = [.creationDateKey, .totalFileAllocatedSizeKey]
      let contents = try fileManager.contentsOfDirectory(at: imageCacheDirectory,
                                                         includingPropertiesForKeys: resourceKeys,
                                                         options: [])

      var files = try contents.compactMap { url -> File? in

        let resources = try url.resourceValues(forKeys: Set(resourceKeys))

        guard let createdAt = resources.creationDate, let size = resources.totalFileAllocatedSize else {
          return nil
        }

        return File(url: url, size: size, createdAt: createdAt)
      }.sorted { $0.createdAt < $1.createdAt }

      // Calculate Cache Size
      var cacheSize = files.reduce(0) { result, cachedImage -> Int in
          result + cachedImage.size
      }

      while cacheSize > maximumCacheSize {
        if files.isEmpty {
            break
        }

        // Remove Oldest Cached Image
        let oldestCachedImage = files.removeFirst()
        try FileManager.default.removeItem(at: oldestCachedImage.url)

        // Update Cache Size
        cacheSize -= oldestCachedImage.size
      }
    } catch {
      print("Unable to Update Cache on Disk \(error)")
    }
  }

  private func locationOnDisk(for urlString: String) -> URL {
    let fileName = Data(urlString.utf8).base64EncodedString().replacingOccurrences(of: "/", with: "")
    return imageCacheDirectory.appendingPathComponent(fileName)
  }

  private struct CachedImage {
    let url: URL
    let data: Data
  }

  private struct File {
    let url: URL
    let size: Int
    let createdAt: Date
  }
}
