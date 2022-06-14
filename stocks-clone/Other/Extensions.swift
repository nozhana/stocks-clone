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
    /// Width of a view
    var w: CGFloat {
        frame.width
    }
    
    /// Height of a view
    var h: CGFloat {
        frame.height
    }
    
    /// Leftmost x of the view e.g. left
    var l: CGFloat {
        frame.minX
    }
    
    /// Rightmost x of the view e.g. right
    var r: CGFloat {
        frame.maxX
    }
    
    /// Topmost y of the view e.g. top
    var t: CGFloat {
        frame.minY
    }
    
    /// Bottommost y of the view e.g. bottom
    var b: CGFloat {
        frame.maxY
    }
}

// MARK: - Add Subviews

extension UIView {
    /// Adds multiple subviews to a view
    /// - Parameter views: Subviews to add
    func addSubviews (_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}

// MARK: - TimeInterval Shorthands

extension TimeInterval {
    /// Number of seconds in a day
    internal static var secondsPerDay: Double {
        60 * 60 * 24
    }
    
    /// Number of seconds in an hour
    internal static var secondsPerHour: Double {
        60 * 60
    }
    
    /// Number of seconds in a minute
    internal static var secondsPerMinute: Double {
        60
    }
    
    /// Convert number of days to a `TimeInterval`
    /// - Parameter n: Number of days
    /// - Returns: A `TimeInterval`
    public static func days(_ n: Double) -> TimeInterval {
        n * secondsPerDay
    }
    
    /// Convert number of hours to a `TimeInterval`
    /// - Parameter n: Number of hours
    /// - Returns: A `TimeInterval`
    public static func hours(_ n: Double) -> TimeInterval {
        n * secondsPerHour
    }
    
    /// Convert number of months to a `TimeInterval`
    /// - Parameter n: Number of months
    /// - Returns: A `TimeInterval`
    public static func months(_ n: Double) -> TimeInterval {
        n * secondsPerDay * 30
    }
}

// MARK: - ISO8601 & Pretty Date Formatter

extension DateFormatter {
    /// A formatter for dates in "YYYY-MM-dd" format (ISO8601)
    static let iso8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    /// A formatter for dates in "MMM dd YYYY" format (e.g. Jun 25 1997)
    static let prettyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

// MARK: - String from UNIX Time

extension String {
    /// Returns an ISO8601 formatted date in string format from a `TimeInterval`
    /// - Parameter timeInterval: UNIX TimeInterval to stringify (TimeInterval since 1970)
    /// - Returns: A string in "YYYY-MM-dd" format
    static func iso8601DateString(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.iso8601DateFormatter.string(from: date)
    }
    
    /// Returns an ISO8601 formatted date in string format from a `Date`
    /// - Parameter date: Date object to stringify
    /// - Returns: A string in "YYYY-MM-dd" format
    static func iso8601DateString(from date: Date) -> String {
        return DateFormatter.iso8601DateFormatter.string(from: date)
    }
    
    /// Returns a *pretty* formatted date in string format from a `TimeInterval`
    /// - Parameter timeInterval: UNIX TimeInterval to stringify (TimeInterval since 1970)
    /// - Returns: A string in "MMM dd YYYY" format
    static func prettyDateString(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
    
    /// Returns a *pretty* formatted date in string format from a `Date`
    /// - Parameter date: Date object to stringify
    /// - Returns: A string in "MMM dd YYYY" format
    static func prettyDateString(from date: Date) -> String {
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
}

// MARK: - setImage in ImageView

extension UIImageView {
    /// Sets an image within a `UIImageView` from a given URL
    /// - Parameter url: URL to download image from
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
    /// Rounds a double to a specified point
    /// - Parameter precision: Number of fractional digits to round to (after the dot)
    /// - Returns: A rounded double
    func rounded(to precision: Int) -> Double {
        let divisor = pow(10.0, Double(precision))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - Decimal & Percent Number Formatter

extension NumberFormatter {
    /// A formatter for decimal numbers with 2 fractional digits
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    /// A formatter for percentile numbers with 2 fractional digits
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
    /// Turns a double into a string with max. 2 fractional digits
    /// - Parameter double: Double to stringify
    /// - Returns: String from rounded double
    static func decimalFormatted(from double: Double) -> String {
        NumberFormatter.decimalFormatter.string(from: NSNumber(value: double)) ?? "\(double)"
    }
    
    /// Turns a double into a string with max. 2 fractional digits preceding with a "+" sign if the number is positive
    /// - Parameter double: Double to stringify
    /// - Returns: String from signed rounded double
    static func changeFormatted(from double: Double) -> String {
        if double < 0 {
            return .decimalFormatted(from: double)
        } else {
            return "+" + .decimalFormatted(from: double)
        }
    }
    
    /// Turns a double into a percentile number with max. 2 fractional digits and then stringifies it, preceding it with a "+" sign if the number is positive
    /// - Parameter double: Double to percentify -> stringify
    /// - Returns: String from signed percentile rounded double
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
    /// Makes the font serif or returns itself if unavailable
    var serif: UIFont {
        guard let serif = fontDescriptor.withDesign(.serif) else { return self }
        return .init(descriptor: serif, size: 0.0)
    }
    
    /// Makes the font condensed or returns itself if unavailable
    var condensed: UIFont {
        guard let condensed = fontDescriptor.withSymbolicTraits(.traitCondensed) else { return self }
        return .init(descriptor: condensed, size: 0.0)
    }
}

// MARK: - PaddingLabel: UILabel

/// A label of type `UILabel` with paddings and rounded corners.
class PaddingLabel: UILabel {
    /// Top padding for ``PaddingLabel``
    var topInset: CGFloat
    /// Left padding for ``PaddingLabel``
    var leftInset: CGFloat
    /// Bottom padding for ``PaddingLabel``
    var bottomInset: CGFloat
    /// Right padding for ``PaddingLabel``
    var rightInset: CGFloat
    
    /// Initializes the ``PaddingLabel`` with given insets(padding)
    /// - Parameters:
    ///   - top: Top padding
    ///   - left: Left padding
    ///   - bottom: Bottom padding
    ///   - right: Right padding
    required init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        topInset = top
        leftInset = left
        bottomInset = bottom
        rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for PaddingLabel")
    }
    
    /// Draws the text inside the label. Overriden to implement given paddings.
    /// - Parameter rect: Label frame as `CGRect`
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    /// Called to implement `sizeToFit()`. Overriden to accommodate paddings.
    /// - Parameter size: A `CGSize`
    /// - Returns: ``intrinsicContentSize``
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
    
    /// Gets size of the content + paddings.
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
    
    /// Label frame within its own coordinate system. Overriden to update `preferredMaxLayoutWidth` to accommodate left/right insets.
    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

// MARK: - Notification

extension Notification.Name {
    /// A notification that is broadcast when the user adds a stock to the watchlist.
    static let didAddToWatchlist = Notification.Name("didAddToWatchList")
}
