/*
See THIRD_PARTY_NOTICES.md for this sample's licensing information.

This file retains the photo-selection portion of Apple's ProfileModel sample.
*/

import CoreTransferable
import Combine
import PhotosUI
import SwiftUI

/// Holds the selected photo and the state of its asynchronous transfer.
@MainActor
final class ProfileModel: ObservableObject {
  /// The completion used by the Photos picker transfer boundary.
  typealias ImageLoadCompletion = @Sendable (Result<ProfileImage?, any Error>) -> Void

  /// Loads the selected item while preserving the sample's `Progress` contract.
  typealias ImageLoader =
    @MainActor (
      PhotosPickerItem,
      @escaping ImageLoadCompletion
    ) -> Progress

  /// The display state for the selected profile image.
  enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(any Error)
  }

  /// An error that occurs when transferred image data can't create a platform image.
  enum TransferError: Error {
    case importFailed
  }

  /// A display image imported from the system photo picker.
  struct ProfileImage: Transferable {
    let image: Image

    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in
        #if canImport(AppKit)
          guard let nsImage = NSImage(data: data) else {
            throw TransferError.importFailed
          }
          let image = Image(nsImage: nsImage)
          return ProfileImage(image: image)
        #elseif canImport(UIKit)
          guard let uiImage = UIImage(data: data) else {
            throw TransferError.importFailed
          }
          let image = Image(uiImage: uiImage)
          return ProfileImage(image: image)
        #else
          throw TransferError.importFailed
        #endif
      }
    }
  }

  @Published private(set) var imageState: ImageState = .empty

  private let imageLoader: ImageLoader
  private var imageLoadProgress: Progress?

  /// Creates a model that loads images with PhotosPickerItem by default.
  init(
    imageLoader: @escaping ImageLoader = { imageSelection, completion in
      imageSelection.loadTransferable(
        type: ProfileImage.self,
        completionHandler: completion
      )
    }
  ) {
    self.imageLoader = imageLoader
  }

  @Published var imageSelection: PhotosPickerItem? {
    didSet {
      imageLoadProgress?.cancel()
      imageLoadProgress = nil

      if let imageSelection {
        let progress = loadTransferable(from: imageSelection)
        imageLoadProgress = progress
        imageState = .loading(progress)
      } else {
        imageState = .empty
      }
    }
  }

  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    imageLoader(imageSelection) { result in
      DispatchQueue.main.async {
        guard imageSelection == self.imageSelection else {
          print("Failed to get the selected item.")
          return
        }
        self.imageLoadProgress = nil
        switch result {
        case .success(let profileImage?):
          self.imageState = .success(profileImage.image)
        case .success(nil):
          self.imageState = .empty
        case .failure(let error):
          self.imageState = .failure(error)
        }
      }
    }
  }
}
