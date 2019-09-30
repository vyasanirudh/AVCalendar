//
//  HapticFeedbackGenerator.swift
//  AVCalendarSample
//
//  Created by Anirudh on 30/09/19.
//  Copyright © 2019 Postagic. All rights reserved.
//

import UIKit

public protocol HapticFeedback {
    func generateFeedback()
}

extension UIControl: HapticFeedback { }

public extension HapticFeedback where Self: UIControl {
    func generateFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}
