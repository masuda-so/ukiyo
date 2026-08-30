import CoreTransferable
import Foundation
import ImageIO
import PhotosUI
import SwiftData
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import XCTest

@testable import ukiyo

final class UkiyoFoundationTests: XCTestCase {
  @MainActor
  func testProductIdentityMatchesBundleConvention() {
    let product = ProductDefinition.ukiyo

    XCTAssertEqual(product.identifier, "ukiyo")
    XCTAssertEqual(product.bundleIdentifier, "llc.ether.\(product.identifier)")
    XCTAssertEqual(
      UkiyoCommerceCatalog.dailyPassProductID,
      "\(product.bundleIdentifier).pro.daily"
    )
    XCTAssertEqual(
      UkiyoCommerceCatalog.monthlyProductID,
      "\(product.bundleIdentifier).pro.monthly"
    )
    XCTAssertEqual(
      UkiyoCommerceCatalog.yearlyProductID,
      "\(product.bundleIdentifier).pro.yearly"
    )
    XCTAssertEqual(
      UkiyoCommerceCatalog.catalog.nonRenewingDurations[UkiyoCommerceCatalog.dailyPassProductID],
      24 * 60 * 60
    )
    XCTAssertEqual(product.name, "Ukiyo")
    XCTAssertFalse(product.tagline.isEmpty)
    XCTAssertEqual(
      product.privacyPolicyURL.absoluteString,
      "https://ether-llc.com/apps/ukiyo/privacy/"
    )
    XCTAssertEqual(
      product.termsOfUseURL.absoluteString,
      "https://ether-llc.com/apps/ukiyo/terms/"
    )
  }

  @MainActor
  func testApplicationSectionsRemainDistinct() {
    let sections: Set<AppSection> = [.lens, .assistant, .pro, .settings]

    XCTAssertEqual(sections.count, 4)
  }

  @MainActor
  func testLegalURLsMatchPublishedRoutesAndLocale() {
    let product = ProductDefinition.ukiyo
    let base = "https://ether-llc.com/apps/\(product.identifier)"
    let urls = [
      (product.privacyPolicyURL, "privacy"),
      (product.termsOfUseURL, "terms"),
      (product.supportURL, "support"),
    ]

    for (url, route) in urls {
      XCTAssertEqual(url.absoluteString, "\(base)/\(route)/")
      XCTAssertEqual(
        product.localizedLegalURL(url, for: Locale(identifier: "en_US")),
        url
      )

      let japaneseURL = product.localizedLegalURL(
        url,
        for: Locale(identifier: "ja_JP")
      )
      XCTAssertEqual(
        japaneseURL.absoluteString,
        "https://ether-llc.com/ja/apps/\(product.identifier)/\(route)/"
      )
      XCTAssertEqual(
        product.localizedLegalURL(japaneseURL, for: Locale(identifier: "ja_JP")),
        japaneseURL
      )
    }
  }

  @MainActor
  func testDailyPassControlsProAccessAtExpiration() {
    let expiration = Date(timeIntervalSince1970: 100_000)
    let entitlements = EntitlementSnapshot(
      activeProductIDs: [UkiyoCommerceCatalog.dailyPassProductID],
      expirationDates: [UkiyoCommerceCatalog.dailyPassProductID: expiration]
    )

    XCTAssertTrue(
      entitlements.hasPremiumAccess(
        in: UkiyoCommerceCatalog.catalog,
        at: expiration.addingTimeInterval(-1)
      )
    )
    XCTAssertFalse(
      entitlements.hasPremiumAccess(in: UkiyoCommerceCatalog.catalog, at: expiration)
    )
  }

  @MainActor
  func testAppEnvironmentUsesInjectedDateForDailyPassAccess() {
    let expiration = Date(timeIntervalSince1970: 100_000)
    let entitlements = EntitlementSnapshot(
      activeProductIDs: [UkiyoCommerceCatalog.dailyPassProductID],
      expirationDates: [UkiyoCommerceCatalog.dailyPassProductID: expiration]
    )
    let environmentBeforeExpiration = AppEnvironment(
      aiClient: UnavailableAIClient(reason: .modelNotReady),
      subscriptionClient: PreviewSubscriptionClient(),
      currentDate: { expiration.addingTimeInterval(-1) }
    )
    environmentBeforeExpiration.entitlements = entitlements
    XCTAssertTrue(environmentBeforeExpiration.isPremium)
    XCTAssertTrue(
      environmentBeforeExpiration.isProductActive(UkiyoCommerceCatalog.dailyPassProductID)
    )

    let environmentAtExpiration = AppEnvironment(
      aiClient: UnavailableAIClient(reason: .modelNotReady),
      subscriptionClient: PreviewSubscriptionClient(),
      currentDate: { expiration }
    )
    environmentAtExpiration.entitlements = entitlements
    XCTAssertFalse(environmentAtExpiration.isPremium)
    XCTAssertFalse(
      environmentAtExpiration.isProductActive(UkiyoCommerceCatalog.dailyPassProductID)
    )
  }

  func testExpirationDelayUsesInjectedCurrentDate() {
    let currentDate = Date(timeIntervalSince1970: 1_000)

    XCTAssertEqual(
      AppEnvironment.expirationDelay(
        until: currentDate.addingTimeInterval(60),
        from: currentDate
      ),
      .seconds(60)
    )
    XCTAssertEqual(
      AppEnvironment.expirationDelay(
        until: currentDate.addingTimeInterval(-1),
        from: currentDate
      ),
      .zero
    )
  }

  @MainActor
  func testOfficialProfileModelStartsWithNoSelection() {
    let viewModel = ProfileModel()

    XCTAssertNil(viewModel.imageSelection)
    guard case .empty = viewModel.imageState else {
      return XCTFail("Expected the official photo-selection model to start empty.")
    }
  }

  @MainActor
  func testProfileModelAppliesSuccessfulTransfer() async {
    let resultImage = Image(uiImage: solidImage(color: .systemOrange))
    let model = ProfileModel { _, completion in
      completion(.success(ProfileModel.ProfileImage(image: resultImage)))
      return Progress(totalUnitCount: 1)
    }

    model.imageSelection = PhotosPickerItem(itemIdentifier: "success")
    await drainMainQueue()

    guard case .success = model.imageState else {
      return XCTFail("Expected a successful profile-image state.")
    }
  }

  @MainActor
  func testProfileModelAppliesNilTransfer() async {
    let model = ProfileModel { _, completion in
      completion(.success(nil))
      return Progress(totalUnitCount: 1)
    }

    model.imageSelection = PhotosPickerItem(itemIdentifier: "nil")
    await drainMainQueue()

    guard case .empty = model.imageState else {
      return XCTFail("Expected a nil transfer to restore the empty state.")
    }
  }

  @MainActor
  func testProfileModelAppliesFailedTransfer() async {
    let model = ProfileModel { _, completion in
      completion(.failure(ProfileModelTestError.failed))
      return Progress(totalUnitCount: 1)
    }

    model.imageSelection = PhotosPickerItem(itemIdentifier: "failure")
    await drainMainQueue()

    guard case .failure = model.imageState else {
      return XCTFail("Expected a failed profile-image state.")
    }
  }

  @MainActor
  func testProfileModelIgnoresAStaleSelectionResult() async {
    var completions: [String: ProfileModel.ImageLoadCompletion] = [:]
    let model = ProfileModel { imageSelection, completion in
      completions[imageSelection.itemIdentifier ?? ""] = completion
      return Progress(totalUnitCount: 1)
    }
    let staleSelection = PhotosPickerItem(itemIdentifier: "stale")
    let currentSelection = PhotosPickerItem(itemIdentifier: "current")
    let result = ProfileModel.ProfileImage(
      image: Image(uiImage: solidImage(color: .systemBlue))
    )

    model.imageSelection = staleSelection
    model.imageSelection = currentSelection
    completions["stale"]?(.success(result))
    await drainMainQueue()

    guard case .loading = model.imageState else {
      return XCTFail("Expected the current selection to remain loading.")
    }

    completions["current"]?(.success(result))
    await drainMainQueue()
    guard case .success = model.imageState else {
      return XCTFail("Expected the current selection result to be applied.")
    }
  }

  @MainActor
  func testProfileModelCancelsSupersededAndClearedLoads() {
    var progressByIdentifier: [String: Progress] = [:]
    let model = ProfileModel { imageSelection, _ in
      let progress = Progress(totalUnitCount: 1)
      progressByIdentifier[imageSelection.itemIdentifier ?? ""] = progress
      return progress
    }

    model.imageSelection = PhotosPickerItem(itemIdentifier: "first")
    model.imageSelection = PhotosPickerItem(itemIdentifier: "second")

    XCTAssertTrue(progressByIdentifier["first"]?.isCancelled == true)
    XCTAssertFalse(progressByIdentifier["second"]?.isCancelled == true)

    model.imageSelection = nil

    XCTAssertTrue(progressByIdentifier["second"]?.isCancelled == true)
  }

  @MainActor
  func testProfileImageRendersEveryRetainedStateBranch() {
    let states: [ProfileModel.ImageState] = [
      .empty,
      .loading(Progress(totalUnitCount: 1)),
      .success(Image(uiImage: solidImage(color: .systemGreen))),
      .failure(ProfileModelTestError.failed),
    ]

    for state in states {
      let renderer = ImageRenderer(
        content: ProfileImage(imageState: state)
          .frame(width: 80, height: 80)
          .background(.black)
      )
      XCTAssertNotNil(renderer.uiImage)
    }
  }

  @MainActor
  func testProfileImageTransferRepresentationImportsImageData() async throws {
    let imageData = try XCTUnwrap(
      solidImage(color: .systemPurple).pngData()
    )
    let provider = imageProvider(data: imageData)

    let imported: ProfileModel.ProfileImage = try await withCheckedThrowingContinuation {
      continuation in
      _ = provider.loadTransferable(type: ProfileModel.ProfileImage.self) { result in
        continuation.resume(with: result)
      }
    }

    _ = imported.image
  }

  @MainActor
  func testProfileImageTransferRepresentationRejectsInvalidImageData() async {
    let provider = imageProvider(data: Data([0x00]))

    do {
      let _: ProfileModel.ProfileImage = try await withCheckedThrowingContinuation {
        continuation in
        _ = provider.loadTransferable(type: ProfileModel.ProfileImage.self) { result in
          continuation.resume(with: result)
        }
      }
      XCTFail("Expected invalid image data to fail transfer.")
    } catch {
      XCTAssertFalse(String(describing: error).isEmpty)
    }
  }

  @MainActor
  func testDataContainerCreatesEditsAndDeletesImage() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let image = LensImage(caption: "Morning", imageData: Data([0x00]))

    dataContainer.context.insert(image)
    try dataContainer.context.save()
    let saved = try XCTUnwrap(
      dataContainer.context.fetch(FetchDescriptor<LensImage>()).first
    )
    saved.caption = "Evening"
    try dataContainer.context.save()
    XCTAssertEqual(
      try dataContainer.context.fetch(FetchDescriptor<LensImage>()).first?.caption,
      "Evening"
    )

    dataContainer.context.delete(saved)
    try dataContainer.context.save()
    XCTAssertTrue(try dataContainer.context.fetch(FetchDescriptor<LensImage>()).isEmpty)
  }

  @MainActor
  func testFailedTransactionDiscardsPendingImage() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)

    XCTAssertThrowsError(
      try dataContainer.context.performTransactionOrRollback {
        dataContainer.context.insert(LensImage(caption: "Unsaved", imageData: Data([0x00])))
        throw CocoaError(.fileWriteNoPermission)
      }
    )

    XCTAssertTrue(try dataContainer.context.fetch(FetchDescriptor<LensImage>()).isEmpty)
  }

  @MainActor
  func testFailedEditRestoresPersistedImage() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let image = LensImage(caption: "Saved", imageData: Data([0x00]))
    dataContainer.context.insert(image)
    try dataContainer.context.save()

    XCTAssertThrowsError(
      try dataContainer.context.performTransactionOrRollback {
        image.caption = "Unsaved change"
        throw CocoaError(.fileWriteNoPermission)
      }
    )

    let saved = try XCTUnwrap(
      dataContainer.context.fetch(FetchDescriptor<LensImage>()).first
    )
    XCTAssertEqual(saved.caption, "Saved")
  }

  @MainActor
  func testFailedDeleteRestoresPersistedImage() throws {
    let dataContainer = DataContainer(isStoredInMemoryOnly: true)
    let image = LensImage(caption: "Saved", imageData: Data([0x00]))
    dataContainer.context.insert(image)
    try dataContainer.context.save()

    XCTAssertThrowsError(
      try dataContainer.context.performTransactionOrRollback {
        dataContainer.context.delete(image)
        throw CocoaError(.fileWriteNoPermission)
      }
    )

    XCTAssertEqual(try dataContainer.context.fetch(FetchDescriptor<LensImage>()).count, 1)
  }

  func testTransactionFailureTriggersRollback() {
    var didRollback = false

    XCTAssertThrowsError(
      try ModelContext.performTransactionOrRollback(
        transaction: { throw CocoaError(.fileWriteNoPermission) },
        rollback: { didRollback = true }
      )
    )
    XCTAssertTrue(didRollback)
  }

  @MainActor
  func testPhotoPreparationDownsamplesLargeImage() async throws {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 2_000, height: 1_000))
    let image = renderer.image { context in
      UIColor.systemBlue.setFill()
      context.fill(CGRect(x: 0, y: 0, width: 2_000, height: 1_000))
    }
    let sourceData = try XCTUnwrap(image.jpegData(compressionQuality: 1))

    let preparedData = try await ImagePreparation.preparedImageData(from: sourceData)
    let source = try XCTUnwrap(
      CGImageSourceCreateWithData(preparedData as CFData, nil)
    )
    let properties = try XCTUnwrap(
      CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
    )
    let imageType = try XCTUnwrap(CGImageSourceGetType(source))

    XCTAssertEqual(properties[kCGImagePropertyPixelWidth] as? Int, 1_600)
    XCTAssertEqual(properties[kCGImagePropertyPixelHeight] as? Int, 800)
    XCTAssertEqual(imageType as String, UTType.jpeg.identifier)
  }

  @MainActor
  func testPhotoPreparationRejectsInvalidData() async {
    do {
      _ = try await ImagePreparation.preparedImageData(from: Data([0x00]))
      XCTFail("Expected invalid image data to be rejected.")
    } catch {
      // The concrete error is intentionally private to the photo service.
    }
  }

  func testPhotoPreparationPropagatesCancellationToDetachedWork() async {
    let operationStarted = expectation(description: "Detached preparation starts")
    let task = Task {
      try await ImagePreparation.preparedImageData(from: Data([0x00])) { _ in
        operationStarted.fulfill()
        while !Task.isCancelled {
          Thread.sleep(forTimeInterval: 0.001)
        }
        try Task.checkCancellation()
        return Data()
      }
    }

    await fulfillment(of: [operationStarted], timeout: 1)
    task.cancel()

    do {
      _ = try await task.value
      XCTFail("Expected image preparation to be cancelled.")
    } catch is CancellationError {
      // Expected cancellation from the detached operation.
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  @MainActor
  private func solidImage(color: UIColor) -> UIImage {
    UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32)).image { context in
      color.setFill()
      context.fill(CGRect(x: 0, y: 0, width: 32, height: 32))
    }
  }

  private func imageProvider(data: Data) -> NSItemProvider {
    let provider = NSItemProvider()
    provider.registerDataRepresentation(
      forTypeIdentifier: UTType.image.identifier,
      visibility: .all
    ) { completion in
      completion(data, nil)
      return nil
    }
    return provider
  }

  @MainActor
  private func drainMainQueue() async {
    await withCheckedContinuation { continuation in
      DispatchQueue.main.async {
        continuation.resume()
      }
    }
  }
}

private enum ProfileModelTestError: Error {
  case failed
}
