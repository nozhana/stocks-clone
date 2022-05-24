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

// MARK: - TimeInterval Shorthands

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

// MARK: - ISO8601 & Pretty Date Formatter

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

// MARK: - String from UNIX Time

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

// MARK: - setImage in ImageView

extension UIImageView {
    func setImage(with url: URL?) {
        guard let url = url else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}

// MARK: - Rounding precision

extension Double {
    func rounded(to precision: Int) -> Double {
        let divisor = pow(10.0, Double(precision))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - Decimal & Percent Number Formatter

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

// MARK: - String from NumberFormatter

extension String {
    static func decimalFormatted(from double: Double) -> String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: double)) ?? "\(double)"
    }
    
    static func changeFormatted(from double: Double) -> String {
        if double < 0 {
            return .decimalFormatted(from: double)
        } else {
            return "+" + .decimalFormatted(from: double)
        }
    }
    
    static func changePercentFormatted(from double: Double) -> String {
        let percentFormatted = NumberFormatter.percentFormatter.string(from: NSNumber(value: double)) ?? "\(double)"
        if double < 0 {
            return percentFormatted
        } else {
            return "+" + percentFormatted
        }
    }
}

// MARK: - UIFont (Descriptors)

extension UIFont {
    var serif: UIFont {
        guard let serif = fontDescriptor.withDesign(.serif) else { return self }
        return .init(descriptor: serif, size: 0.0)
    }
    
    var condensed: UIFont {
        guard let condensed = fontDescriptor.withSymbolicTraits(.traitCondensed) else { return self }
        return .init(descriptor: condensed, size: 0.0)
    }
}
