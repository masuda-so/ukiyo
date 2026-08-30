import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Downsamples and encodes imported image data before display and persistence.
nonisolated enum ImagePreparation {
  /// A synchronous image-preparation operation executed away from the caller's actor.
  typealias Operation = @Sendable (Data) throws -> Data

  /// Downsamples image data away from the caller's actor.
  static func preparedImageData(from data: Data) async throws -> Data {
    try await preparedImageData(from: data, using: prepareImageData)
  }

  /// Executes a preparation operation with cancellation propagated to its detached task.
  static func preparedImageData(
    from data: Data,
    using operation: @escaping Operation
  ) async throws -> Data {
    let task = Task.detached(priority: .userInitiated) {
      try Task.checkCancellation()
      let preparedData = try operation(data)
      try Task.checkCancellation()
      return preparedData
    }

    return try await withTaskCancellationHandler {
      try await task.value
    } onCancel: {
      task.cancel()
    }
  }

  private static func prepareImageData(from data: Data) throws -> Data {
    guard
      let source = CGImageSourceCreateWithData(data as CFData, nil),
      CGImageSourceGetCount(source) > 0
    else {
      throw ImagePreparationError.invalidImage
    }

    let options: [CFString: Any] = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: 1_600,
    ]
    guard
      let thumbnail = CGImageSourceCreateThumbnailAtIndex(
        source,
        0,
        options as CFDictionary
      )
    else {
      throw ImagePreparationError.imagePreparationFailed
    }

    let encodedData = NSMutableData()
    guard
      let destination = CGImageDestinationCreateWithData(
        encodedData,
        UTType.jpeg.identifier as CFString,
        1,
        nil
      )
    else {
      throw ImagePreparationError.imagePreparationFailed
    }

    let properties: [CFString: Any] = [
      kCGImageDestinationLossyCompressionQuality: 0.82
    ]
    CGImageDestinationAddImage(destination, thumbnail, properties as CFDictionary)
    guard CGImageDestinationFinalize(destination) else {
      throw ImagePreparationError.imagePreparationFailed
    }
    return encodedData as Data
  }
}

private enum ImagePreparationError: Error {
  case invalidImage
  case imagePreparationFailed
}
