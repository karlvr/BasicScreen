//
//  BasicScreenView+Sync.swift
//  BasicScreen
//
//  Created by Karl von Randow on 7/03/17.
//  Copyright © 2017 XK72. All rights reserved.
//

import UIKit

extension BasicScreenView {

    public func input() -> String {
        if Thread.isMainThread {
            var result = ""
            var done = false
            input { string in
                result = string
                done = true
            }

            while !done {
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
            }
            return result
        } else {
            var result = ""
            let semaphore = DispatchSemaphore(value: 0)
            input { string in
                result = string
                semaphore.signal()
            }

            semaphore.wait()
            return result
        }
    }
    
}
