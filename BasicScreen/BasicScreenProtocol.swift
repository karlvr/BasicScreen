//
//  BasicScreen.swift
//  BasicScreen
//
//  Created by Karl von Randow on 4/03/17.
//  Copyright © 2017 XK72. All rights reserved.
//

public protocol BasicScreenProtocol {

    func locate(_ x: Int, _ y: Int)

    func print(_ string: String)
    func print(_ string: String, newline: Bool)

    func cls()

    func input(_ completion: @escaping (String) -> ())

}
