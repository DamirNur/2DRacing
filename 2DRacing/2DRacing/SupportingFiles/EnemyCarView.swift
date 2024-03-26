//
//  EnemyCarView.swift
//  2DRacing
//
//  Created by Damir Nuriev on 14.02.2024.
//

import UIKit

final class EnemyCarView: UIView {
    var isReadyToSpawn: Bool {
        guard let superview = superview else { return false }
        return frame.origin.y >= superview.frame.height
    }
    var ticksBeforeSpawn: UInt = .zero
}
