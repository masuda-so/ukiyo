import Foundation
import SwiftData
import UIKit

/// A captioned image persisted by SwiftData.
@Model
final class LensImage {
  var caption: String
  @Attribute(.externalStorage) var imageData: Data
  var createdAt: Date

  init(
    caption: String = "",
    imageData: Data,
    createdAt: Date = .now
  ) {
    self.caption = caption
    self.imageData = imageData
    self.createdAt = createdAt
  }

  var image: UIImage? {
    UIImage(data: imageData)
  }
}
