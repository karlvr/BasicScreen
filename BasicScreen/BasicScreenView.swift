//
//  BasicScreen.swift
//  BasicScreen
//
//  Created by Karl von Randow on 4/03/17.
//  Copyright © 2017 XK72. All rights reserved.
//

import UIKit

private struct Cursor {
    let x: Int
    let y: Int
}

public class BasicScreenView : UIView, BasicScreenProtocol {

    var bitmapContext: CGContext?
    private var cursor = Cursor(x: 0, y: 0)
    var font: UIFont {
        didSet {
            updatedFont()
        }
    }
    var advance: CGFloat
    var leading: CGFloat
    var color = UIColor.yellow
    var showCursor = false {
        didSet {
            if showCursor {
                inputText = ""

                cursorTimer?.invalidate()
                cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
                    self.showingCursor = !self.showingCursor
                }
            } else {
                hideCursor()

                cursorTimer?.invalidate()
                cursorTimer = nil
            }
        }
    }
    private var width: Int
    private var height: Int
    private var cursorTimer: Timer?
    private var showingCursor = false {
        didSet {
            updateCursor()
        }
    }
    private var inputCompletion: ((String) -> ())?
    internal var inputText: String?

    override public init(frame: CGRect) {
        advance = 10
        leading = 1
        font = UIFont(name: "Menlo-Bold", size: 24)!
        width = 0
        height = 0

        super.init(frame: frame)

        updatedFont()
        recreateBitmapContext()
    }

    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        recreateBitmapContext()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()

        if let image = bitmapContext?.makeImage() {
            ctx?.draw(image, in: bounds)
        }
    }

    public func locate(_ x: Int, _ y: Int) {
        cursor = Cursor(x: x, y: y)
    }

    public func print(_ string: String) {
        print(string, newline: true)
    }

    public func print(_ string: String, newline: Bool) {
        guard let ctx = bitmapContext else {
            fatalError("No bitmapContext")
        }

        hideCursor()

        UIGraphicsPushContext(ctx)

        let att = attributes()

        for c in string.characters {
            let s = "\(c)" as NSString
            if s == "\n" {
                newLine()
                continue
            }

            let p = point(for: cursor)
            ctx.clear(CGRect(x: p.x, y: p.y, width: advance, height: leading))
            s.draw(at: p, withAttributes: att)
            advanceCursor()
        }

        UIGraphicsPopContext()

        setNeedsDisplay()

        if newline {
            newLine()
        }
    }

    public func cls() {
        hideCursor()

        let scale = UIScreen.main.scale
        let r = CGRect(x: 0, y: 0, width: bounds.size.width * scale, height: bounds.size.height * scale)
        bitmapContext?.clear(r)

        cursor = Cursor(x: 0, y: 0)
        setNeedsDisplay()
    }

    public func input(_ completion: @escaping (String) -> ()) {
        becomeFirstResponder()
        showCursor = true
        inputCompletion = completion
    }

    internal func inputComplete(string: String) {
        if let c = inputCompletion {
            inputCompletion = nil
            showCursor = false
            c(string)
        } else {
            fatalError("inputComplete called without a callback")
        }
    }

    public func del() {
        if cursor.x > 0 {
            hideCursor()

            cursor = Cursor(x: cursor.x - 1, y: cursor.y)

            let p = point(for: cursor)
            bitmapContext?.clear(CGRect(x: p.x, y: p.y, width: advance, height: leading))
            setNeedsDisplay()
        }
    }

    private func updatedFont() {
        let size = ("M" as NSString).size(attributes: attributes())
        advance = ceil(size.width)
        leading = ceil(size.height)
    }

    private func advanceCursor() {
        hideCursor()

        let x = cursor.x + 1
        if x >= width {
            cursor = Cursor(x: 0, y: cursor.y + 1)
        } else {
            cursor = Cursor(x: x, y: cursor.y)
        }
    }

    private func newLine() {
        hideCursor()

        let y = cursor.y + 1

        if y >= height {
            cursor = Cursor(x: 0, y: height - 1)
            scroll()
        } else {
            cursor = Cursor(x: 0, y: y)
        }
    }

    private func updateCursor() {
        guard let ctx = bitmapContext else {
            return
        }

        let p = point(for: cursor)
//        if showingCursor {
            ctx.setBlendMode(.xor)
            ctx.setFillColor(color.cgColor)
            ctx.fill(CGRect(x: p.x, y: p.y, width: advance, height: leading))
            setNeedsDisplay()
//        } else {
//
//        }
    }

    private func hideCursor() {
        if showingCursor {
            showingCursor = false
        }
    }

    private func scroll() {
        if let image = bitmapContext?.makeImage() {
            let scale = UIScreen.main.scale

            let r = CGRect(x: 0, y: 0, width: bounds.size.width * scale, height: bounds.size.height * scale)
            bitmapContext?.clear(r)
            bitmapContext?.draw(image, in: CGRect(x: 0, y: -leading, width: r.size.width, height: r.size.height))
        }
    }

    private func point(for cursor: Cursor) -> CGPoint {
        return CGPoint(x: CGFloat(cursor.x) * advance, y: CGFloat(cursor.y) * leading)
    }

    private func attributes() -> [String: Any]? {
        var attributes: [String: Any] = [:]
        attributes[NSFontAttributeName] = font
        attributes[NSForegroundColorAttributeName] = color
        return attributes
    }

    private func recreateBitmapContext() {
        let size = bounds.size
        let scale = UIScreen.main.scale
        let space = CGColorSpaceCreateDeviceRGB()

        let width = Int(size.width * scale)
        let height = Int(size.height * scale)

        if let existing = bitmapContext {
            if existing.width == width && existing.height == height {
                return
            }
        }

        if width == 0 || height == 0 {
            return
        }

        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue + CGBitmapInfo.byteOrder32Little.rawValue

        guard let ctx = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: space, bitmapInfo: bitmapInfo) else {
            fatalError("Couldn't create CGContext")
        }

        let r = CGRect(x: 0, y: 0, width: width, height: height)
        ctx.clear(r)

        //ctx.setFillColor(UIColor.orange.cgColor)
        //ctx.fill(CGRect(x: 0, y: 0, width: 50, height: 50))

        bitmapContext = ctx

        cursor = Cursor(x: 0, y: 0)
        self.width = Int(CGFloat(width) / advance)
        self.height = Int(CGFloat(height) / leading)
    }
    
    public var autocapitalizationType: UITextAutocapitalizationType = .none
    public var autocorrectionType: UITextAutocorrectionType = .no

}

extension BasicScreenView: UIKeyInput {

    public var hasText: Bool {
        get {
            if let inputText = inputText {
                return inputText.startIndex != inputText.endIndex
            } else {
                return false
            }
        }
    }

    public func insertText(_ text: String) {
        guard showCursor else {
            return
        }

        if text == "\n" {
            inputComplete(string: inputText!)
        } else {
            inputText = inputText! + text
        }
        print(text, newline: false)
    }

    public func deleteBackward() {
        guard showCursor else {
            return
        }

        inputText = inputText!.substring(to: inputText!.index(before: inputText!.endIndex))
        del()
    }
}
