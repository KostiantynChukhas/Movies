//
//  DateFormatter+extension.swift
//  Movies
//
//  Created by Konstantin Chukhas on 16.10.2023.
//

import UIKit

extension DateFormatter {
    
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
      //2022-10-04T12:23:30.310Z
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
