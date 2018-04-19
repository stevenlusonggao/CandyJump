//
//  UserDefaultManager.swift
//  CandyJump
//
//  Created by Marko Mihailovic on 2018-03-28.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import Foundation

class UserDefaultManager {
    
    static let manager = UserDefaultManager()
    
    private let fileName = "CandyJump.archive"
    let highScoreKey = "HighScore"
    let lastScoreKey = "LastScore"
    let lastCharacterKey = "Char"
    let accelKey = "Accel"
    private var highScore: Int?
    private var lastScore: Int?
    private var character: Int?
    private var usingAccel: Bool?
    
    // Define the path to the archive
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.appendingPathComponent(fileName) as String
    }

    // un-archive the data, load it into the Deck
    func loadAll(){
        let filePath = self.dataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            let data = NSMutableData(contentsOfFile: filePath)!
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            highScore = unarchiver.decodeObject(forKey: highScoreKey) as? Int
            lastScore = unarchiver.decodeObject(forKey: lastScoreKey) as? Int
            character = unarchiver.decodeObject(forKey: lastCharacterKey) as? Int
            usingAccel = unarchiver.decodeObject(forKey: accelKey) as? Bool
            unarchiver.finishDecoding()
        }
    }
    
    // archive the Deck into the file, you may need to save the “last used time” in this method
    func saveAll(){
        let filePath = self.dataFilePath()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lastScore, forKey: lastScoreKey)
        archiver.encode(highScore, forKey: highScoreKey)
        archiver.encode(character, forKey: lastCharacterKey)
        archiver.encode(usingAccel, forKey: accelKey)
        archiver.finishEncoding()
        data.write(toFile: filePath, atomically: true)
    }
    
    func setHighScore(newHighScore: Int) {
        highScore = newHighScore
    }
    
    func setLastScore(newLastScore: Int) {
        lastScore = newLastScore
    }
    
    func setCharacter(newCharacter: Int) {
        character = newCharacter
    }
    
    func setAccelerometer(isSet: Bool) {
        usingAccel = isSet
    }
    
    func getHighScore() -> Int {
        if (highScore == nil) {
            return 0
        }
        else {
            return highScore!
        }
    }
    
    func getLastScore() -> Int {
        if (lastScore == nil) {
            return 0
        }
        else {
            return lastScore!
        }
    }
    
    func getCharacter() -> Int {
        if (character == nil) {
            return Character.Male
        }
        else {
            return character!
        }
    }
    
    func getAccel() -> Bool {
        if (usingAccel == nil) {
            return false
        }
        else {
            return usingAccel!
        }
    }
    
    
    

}
