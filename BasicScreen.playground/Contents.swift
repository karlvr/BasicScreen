//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let bs = BasicScreenView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
PlaygroundPage.current.liveView = bs

bs.backgroundColor = UIColor.blue
bs.print("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.draw("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.draw("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.draw("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.draw("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.draw("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.draw("abcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyzabcdefghhijklmnopqrstuvwxyz")
//bs.locate(x: 0, y: 0)
//bs.draw("Karl\nis\ncool")

bs.print("Alien's square along")
//let a = bs.input()
//print("Alien's square up")
//let b = bs.input()



let x = sqrt(5)

func rnd(_ max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
}

public func rnd() -> Double {
    return Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
}

let y = rnd(10)
rnd()

for i in 1...6 {
    bs.print("hi")
}

