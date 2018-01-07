//
//  ViewController.swift
//  BasicScreen
//
//  Created by Karl von Randow on 4/03/17.
//  Copyright © 2017 XK72. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var basicScreen: BasicScreenView!

    override func viewDidLoad() {
        super.viewDidLoad()

        basicScreen = BasicScreenView(frame: view.bounds)
        basicScreen.backgroundColor = UIColor.blue
        view.addSubview(basicScreen)

        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
        basicScreen.locate(0, 0)
        basicScreen.print("Karl\nis\ncool")
        
        
        
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        basicScreen.becomeFirstResponder()

        
        basicScreen.input { (string) in
            print("got input: \(string)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

