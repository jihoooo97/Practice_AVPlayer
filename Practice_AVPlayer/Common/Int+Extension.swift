//
//  Int+Extension.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/9/24.
//

public extension Int {
    
    var secondsDigitInt: Int { self % 60 }
    var miniuteDigitInt: Int { self / 60 }
    
}
