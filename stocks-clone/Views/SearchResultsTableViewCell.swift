//
//  SearchResultsTableViewCell.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/2/22.
//

import UIKit

/// A `UITableViewCell` for a search result
final class SearchResultsTableViewCell: UITableViewCell {
    /// SearchResultsTableViewCell reuse identifier
    static let identifier = "SearchResultsTableViewCell"
    
    /// Initializes a SearchResultsTableViewCell with a subtitle style
    /// - Parameters:
    ///   - style: `CellStyle` is subtitle
    ///   - reuseIdentifier: ``identifier``
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
