//
//  PhysicsCategory.swift
//  CandyJump
//
//  Created by Lu Gao on 2018-03-28.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Player               : UInt32 = 0b1
    static let NormalPlatform       : UInt32 = 0b10
    static let BouncePlatform       : UInt32 = 0b11
    static let BreakPlatform        : UInt32 = 0b100
}

enum PlatformType {
    static let Normal = 0
    static let Bounce = 1
    static let Break = 2
}

enum Character {
    static let Male = 0
    static let Female = 1
    static let Soldier = 2
    static let Adventurer = 3
    static let Zombie = 4
}
