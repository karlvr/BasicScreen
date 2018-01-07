//
//  BasicScreen.swift
//  BasicScreen
//
//  Created by Karl von Randow on 4/03/17.
//  Copyright © 2017 XK72. All rights reserved.
//

import UIKit

public class BasicScreenViewController : UIViewController {

    public let basicScreen: BasicScreenView
    public var ready: (() -> ())?
    private var readyDebouncer: Debouncer!

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        basicScreen = BasicScreenView(frame: .zero)
        basicScreen.backgroundColor = UIColor.blue
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        readyDebouncer = Debouncer(delay: 0.1, callback: { [unowned self] in
            if let ready = self.ready {
                ready()
            }
        })
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.view = basicScreen
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /* We must debounce here as sometimes viewDidAppear is called twice in Swift Playgrounds */
        readyDebouncer.call()
    }

}

class Debouncer: NSObject {
    var callback: (() -> ())
    var delay: Double
    weak var timer: Timer?

    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }

    @objc func fireNow() {
        self.callback()
    }
}
