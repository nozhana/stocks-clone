//
//  HapticsManager.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/1/22.
//

import Foundation
import UIKit

/// An object that manages the haptics throughout the application.
final class HapticsManager {
    /// Singleton of `HapticsManager`
    static let shared = HapticsManager ()
    
    /// The default implementation of this initializer does nothing.
    private init() {}
    
//    MARK: - Public
    
    /// Plays a haptic when the user selects an item. **TODO**
    public func vibrateForSelection () {
//        TODO: Vibrate lightly for a selection tap interaction
    }
    
//    TODO: Vibrate for typing
}
