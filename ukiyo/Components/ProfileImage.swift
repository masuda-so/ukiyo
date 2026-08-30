/*
See THIRD_PARTY_NOTICES.md for this sample's licensing information.

This view is the ProfileImage view from Apple's Photos picker sample, formatted
with this repository's swift-format configuration.
*/

import SwiftUI

/// Displays the current state of the photo selected through PhotosPicker.
struct ProfileImage: View {
  let imageState: ProfileModel.ImageState

  var body: some View {
    switch imageState {
    case .success(let image):
      image.resizable()
    case .loading:
      ProgressView()
    case .empty:
      Image(systemName: "person.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)
    case .failure:
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)
    }
  }
}
