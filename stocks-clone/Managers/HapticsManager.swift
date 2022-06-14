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
    /// Singleton of ``HapticsManager``
    static let shared = HapticsManager()
    
    /// The default implementation of this initializer does nothing.
    private init() {}
    
//    MARK: - Public
    
    /// Plays a slight haptic when the user selects an item.
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// Plays a slight haptic for a given notification type.
    /// - Parameter type: type to vibrate for. either `success`, `warning`, or `error`.
    public func vibrateForNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// Plays a slight haptic for an impact style.
    /// - Parameter style: Impact style to vibrate for. either `light`, `medium`, `heavy`, `soft` or `rigid`.
    public func vibrateForImpact(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}
