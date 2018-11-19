// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
internal enum Localization {
  /// Add category
  internal static let addCategoryTitle = Localization.tr("Localizable", "ADD_CATEGORY_TITLE")
  /// Add movie
  internal static let addMovieTitle = Localization.tr("Localizable", "ADD_MOVIE_TITLE")
  /// Camera
  internal static let camera = Localization.tr("Localizable", "CAMERA")
  /// Cancel
  internal static let cancel = Localization.tr("Localizable", "CANCEL")
  /// Category
  internal static let category = Localization.tr("Localizable", "CATEGORY")
  /// Delete
  internal static let delete = Localization.tr("Localizable", "DELETE")
  /// Really wants to delete %@?
  internal static func deleteMovieConfirm(_ p1: String) -> String {
    return Localization.tr("Localizable", "DELETE_MOVIE_CONFIRM", p1)
  }
  /// Edit movie
  internal static let editMovieTitle = Localization.tr("Localizable", "EDIT_MOVIE_TITLE")
  /// Empty response
  internal static let emptyResponse = Localization.tr("Localizable", "EMPTY_RESPONSE")
  /// Error
  internal static let error = Localization.tr("Localizable", "ERROR")
  /// Fail parsing data
  internal static let failParse = Localization.tr("Localizable", "FAIL_PARSE")
  /// Watch it now!
  internal static let notificationAnswerOk = Localization.tr("Localizable", "NOTIFICATION_ANSWER_OK")
  /// You need to enable notifications in order to be reminded of a watching a movie
  internal static let notificationDenied = Localization.tr("Localizable", "NOTIFICATION_DENIED")
  /// Time to watch %@
  internal static func notificationMessage(_ p1: String) -> String {
    return Localization.tr("Localizable", "NOTIFICATION_MESSAGE", p1)
  }
  /// Movie reminder 📽
  internal static let notificationTitle = Localization.tr("Localizable", "NOTIFICATION_TITLE")
  /// OK
  internal static let ok = Localization.tr("Localizable", "OK")
  /// Galery
  internal static let photoSourceGallery = Localization.tr("Localizable", "PHOTO_SOURCE_GALLERY")
  /// Choose the source
  internal static let photoSourceMessage = Localization.tr("Localizable", "PHOTO_SOURCE_MESSAGE")
  /// Reminder
  internal static let reminder = Localization.tr("Localizable", "REMINDER")
  /// Resource not found
  internal static let resourceNotFound = Localization.tr("Localizable", "RESOURCE_NOT_FOUND")
  /// 😢
  internal static let sad = Localization.tr("Localizable", "SAD")
  /// Settings
  internal static let settings = Localization.tr("Localizable", "SETTINGS")
}
// swiftlint:enable identifier_name line_length type_body_length

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
