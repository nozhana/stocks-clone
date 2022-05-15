//
//  Extensions.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/8/22.
//

import Foundation
import UIKit

// MARK: - Framing

extension UIView {
    var w: CGFloat {
        frame.width
    }
    
    var h: CGFloat {
        frame.height
    }
    
    var l: CGFloat {
        frame.minX
    }
    
    var r: CGFloat {
        frame.maxX
    }
    
    var t: CGFloat {
        frame.minY
    }
    
    var b: CGFloat {
        frame.maxY
    }
}

// MARK: - Add Subviews

extension UIView {
    func addSubviews (_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}

// MARK: - Time Interval

extension TimeInterval {
    internal static var secondsPerDay: Double {
        60 * 60 * 24
    }
    
    internal static var secondsPerHour: Double {
        60 * 60
    }
    
    internal static var secondsPerMinute: Double {
        60
    }
    
    public static func days(_ n: Double) -> TimeInterval {
        n * secondsPerDay
    }
    
    public static func hours(_ n: Double) -> TimeInterval {
        n * secondsPerHour
    }
    
    public static func months(_ n: Double) -> TimeInterval {
        n * secondsPerDay * 30
    }
}

// MARK: - DateFormatter

extension DateFormatter {
    static let iso8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static let prettyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

// MARK: - String

extension String {
    static func iso8601DateString(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.iso8601DateFormatter.string(from: date)
    }
    
    static func iso8601DateString(from date: Date) -> String {
        return DateFormatter.iso8601DateFormatter.string(from: date)
    }
    
    static func prettyDateString(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
    
    static func prettyDateString(from date: Date) -> String {
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
}

