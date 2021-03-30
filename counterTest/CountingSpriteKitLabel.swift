//
//  CountingSpriteKitLabel.swift
//  counterTest
//
//  Created by 🐨 on 30/03/2021.
//  Copyright © 2021 rHockWorks. All rights reserved.
//
// Original code by Brian Advent
// YouTube tutorial : https://www.youtube.com/watch?v=Wz6-IQV_qDw
//
//
// FOLLOWING ALONG WITH MR. ADVENT'S CODE FROM HIS VIDEO TUTORIAL FROM 4TH DECEMBER, 2016,
// I DECIDED TO MAKE HIS CODE A LITTLE MORE SWIFT LIKE, AND A LOT SAFER.
// I ALSO NEEDED TO MAKE IT WORK WITH A SPRITE KIT LABEL NODE.
// THIS CODE ALSO ALLOWS FOR UNITS TO BE USED AFTER THE NUMBER e.g. "22kg" / "48.5Ib" (nb. THIS CODE WILL NOT CONVERT BETWEEN UNITS HOWEVER)
//
// THIS CODE MAY BE USED IN A COMMERCIAL APPLICATION IF DESIRED.
//

import Foundation
import SpriteKit



class CountingSpriteKitLabel: SKLabelNode {
    
    enum CounterAnimationType: CaseIterable {
        
        case
        none,
        linear,     // f(x) = x
        easeIn,     // f(x) = x^3
        easeOut     // f(x) = (1-x)^3
    }

    enum CounterType: String, CaseIterable {
        
        case
        none,
        decimal = "%.2f",   //TW0 DECIMAL PLACES
        whole   = "%.0f"    //WHOLE NUMBERS
    }
    
    enum Units: String {
        
        case
        none    = "",
        perCent = "%",
        kilo    = "kg",
        pound   = "Lb"
    }

    var counterVelocity : Float         = 3.0
    var startNumber     : Float         = 0.0
    var finishNumber    : Float         = 0.0
    var progress        : TimeInterval  = 0.0
    var duration        : TimeInterval  = 0.0
    var lastUpdate      : TimeInterval  = 0.0
    var units           : Units         = .none
    
    var timer = Timer()
    
    private var counterType             : CounterType           = .none
    private var counterAnimationType    : CounterAnimationType  = .none
    
    var currentCounterValue: Float {
                                        if progress >= duration {
                                            return finishNumber
                                        }
        
                                    let percentage  = Float(progress / duration)
                                    let update      = updateCounter(withValue: percentage)
                                    
                                    return startNumber + (update * (finishNumber - startNumber))    //SLOW TO START / FINISH ANIMATION
                                    }
    
    func countValue(from startTime              : Float,
                    to finishTime               : Float,
                    forDuration durationTime    : TimeInterval,
                    withAnimation animationType : CounterAnimationType,
                    withCounterType counterType : CounterType,
                    usingUnits unit             : Units) {
        
        
        self.startNumber            = startTime
        self.finishNumber           = finishTime
        self.duration               = durationTime
        self.counterType            = counterType
        self.counterAnimationType   = animationType
        self.units                  = unit
        self.progress               = 0
        self.lastUpdate             = Date.timeIntervalSinceReferenceDate
    
        
        invalidateTimer()
        
        if duration == 0 { updateText(withValue: finishNumber, units: units) }
        
        timer = Timer.scheduledTimer(timeInterval   : 0.01,
                                     target         : self,
                                     selector       : #selector(CountingSpriteKitLabel.updateValue),
                                     userInfo       : nil,
                                     repeats        : true)
    }

    private func updateText(withValue: Float, units: Units) {
                
        for counterType in CounterType.allCases {
            switch counterType {
            case .decimal   : text = String(format: CounterType.decimal.rawValue, withValue)
            case .whole     : text = String(format: CounterType.whole.rawValue, withValue) + units.rawValue
            default         : break
            }
        }
    }
    
    @objc func updateValue() {
        
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if progress >= duration {
            
            invalidateTimer()
            progress = duration
        }
        
        updateText(withValue: currentCounterValue, units: units)
    }
    
    private func invalidateTimer() {
        
        timer.invalidate()
    }

    private func updateCounter(withValue counterValue: Float) -> Float {
        
        var returnValue: Float = 0.0
        
        for counterAnimation in CounterAnimationType.allCases {
            switch counterAnimation {
            case .linear    : returnValue = counterValue
            case .easeIn    : returnValue = powf(counterValue, counterVelocity)
            case .easeOut   : returnValue = 1.0 - powf(1.0 - counterValue, counterVelocity)
            default         : break
            }
        }
        return returnValue
    }
}




func spriteKitLabelTest() {

    let spriteLabel = CountingSpriteKitLabel()

    spriteLabel.position = CGPoint(x: 100, y: 100)
    //addChild(spriteLabel)
    
    spriteLabel.countValue(from             : 0,
                           to               : 9999,
                           forDuration      : 5,
                           withAnimation    : .easeOut,
                           withCounterType  : .whole,
                           usingUnits       : .perCent)
}
