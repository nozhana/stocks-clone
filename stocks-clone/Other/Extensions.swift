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
