import CoreTransferable
import Foundation
import UniformTypeIdentifiers

/// Carries prepared image data from a selected Photos item into Ukiyo's persistent model.
struct LensImageTransfer: Transferable {
  let data: Data

  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      LensImageTransfer(data: try await ImagePreparation.preparedImageData(from: data))
    }
  }
}
