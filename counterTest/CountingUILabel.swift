//
//  CountingLabel.swift
//  counterTest
//
//  Created by 🐨 on 30/03/2021.
//  Copyright © 2021 rHockWorks. All rights reserved.
//
// Original code by Brian Advent
// YouTube tutorial : https://www.youtube.com/watch?v=Wz6-IQV_qDw
//
// I HAVE UPDATED THIS CODE TO WORK WITH A SPRITE KIT LABEL NODE : "CountingSpriteKitLabel"
// I AM UPLOADING THIS BECAUSE THE DOWNLOAD LINK IS MISSING, SO IT'S JUST A COURTECY.
// THIS ORIGINAL CODE BELONGS TO BRIAN ADVENT, NOT MYSELF.
//

import UIKit

class CountingUILabel: UILabel {

    let counterVelocity: Float = 3.0
    
    enum CounterAnimationType {
        
        case linear
        case easeIn
        case easeOut
    }
    
    enum CounterType {
        
        case integer
        case float
    }
    
    
    var startNumber: Float = 0.0
    var endNumber: Float = 0.0

    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    
    var timer: Timer?
    
    var counterType: CounterType!
    var counterAnimationType: CounterAnimationType!
    
    
    var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
    }
    
    
    func count(fromValue: Float, to toValue: Float, withDuration duration: TimeInterval, andAnimationType animationType: CounterAnimationType, andCountingType counterType: CounterType) {
        
        
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterType = counterType
        self.counterAnimationType = animationType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
    
        
        invalidateTimer()
        
        if duration == 0 {
            
            updateText(value: toValue)
            return
        }
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CountingUILabel.updateValue), userInfo: nil, repeats: true)
    
    }
    
    
    
    @objc func updateValue() {
        
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        
        updateText(value: currentCounterValue)
    }
    
    
    func updateText(value: Float) {
        
        switch counterType! {
        case .integer:
            self.text = "\(Int(value))"
        case .float:
            self.text = String(format: "%.2f", value)
        }
    }
    
    
    func updateCounter(counterValue: Float) -> Float {
        
        switch counterAnimationType! {
        case .linear:
            return counterValue
        case .easeIn :
            return powf(counterValue, counterVelocity)
        case .easeOut :
            return 1.0 - powf(1.0 - counterValue, counterVelocity)
        }
    }
    
    
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
}
