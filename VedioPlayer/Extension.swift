//
//  Extension.swift
//  VedioPlayer
//
//  Created by 黃瀞萱 on 2023/7/19.
//

import Foundation

extension Int {

    func secondsToTimeStamp() -> String {
        let sec = (self % 3600) % 60
        let min = (self % 3600) / 60
        let hour = self / 3600
        let secString = sec >= 10 ? "\(sec)" : "0\(sec)"
        let minString = min >= 10 ? "\(min)" : "0\(min)"
        let hourString = hour == 0 ? "" : ((hour > 10) ? "" : "0\(hour)")
        
        var timeStamp = minString + ":" + secString
        if hourString != "" { timeStamp = hourString + ":" + timeStamp}

        return timeStamp
    }

}
