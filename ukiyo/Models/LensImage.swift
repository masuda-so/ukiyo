import Foundation
import SwiftData
import UIKit

/// The origin of the image shown as the primary image in a journal entry.
nonisolated enum LensImageProvenance: String, Codable, Sendable {
  case importedPhoto
  case imagePlayground
}

/// A captioned image persisted by SwiftData.
@Model
final class LensImage {
  var caption: String
  @Attribute(.externalStorage) var imageData: Data
  /// Retains the selected photo separately when `imageData` is AI-generated.
  @Attribute(.externalStorage) var sourceImageData: Data?
  /// Optional so stores created before Image Playground support migrate as imported photos.
  var provenanceRawValue: String?
  var createdAt: Date

  init(
    caption: String = "",
    imageData: Data,
    sourceImageData: Data? = nil,
    provenance: LensImageProvenance = .importedPhoto,
    createdAt: Date = .now
  ) {
    self.caption = caption
    self.imageData = imageData
    self.sourceImageData = sourceImageData
    self.provenanceRawValue = provenance.rawValue
    self.createdAt = createdAt
  }

  var provenance: LensImageProvenance {
    guard let provenanceRawValue else {
      return .importedPhoto
    }
    return LensImageProvenance(rawValue: provenanceRawValue) ?? .importedPhoto
  }

  var isAIGenerated: Bool {
    provenance == .imagePlayground
  }

  var image: UIImage? {
    UIImage(data: imageData)
  }

  var sourceImage: UIImage? {
    sourceImageData.flatMap(UIImage.init(data:))
  }
}
