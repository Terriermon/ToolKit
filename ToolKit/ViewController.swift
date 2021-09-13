//
//  ViewController.swift
//  ToolKit
//
//  Created by chenxiaolin on 2021/9/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testAttributeText()
    }
}

extension ViewController {
    func testAttributeText() {
        let str = "测试: 首行缩进"
        let attrStr: AttributedText = "\(str, .firstLineHeadIndent(20)) \("红色文字", .color(.red)) \("黄色\(12)号文字", .color(.yellow), .font(UIFont.systemFont(ofSize: 12))), \(100), \(120, .color(.blue)) , test: \("test", attributes: [.foregroundColor :UIColor.purple]), \(1.06, .color(.yellow)), \(UIColor.black, .color(.black))，，，、\(wrap:"测试\("嵌套", .color(.blue))", .color(.white), .underline(.white, .single))"
        
        let username = "AliGator"
        
        let str22: AttributedText = """
          Hello \(username, .color(.red)), isn't this \("cool", .color(.blue), .oblique, .underline(.purple, .single))?

          \(wrap: """
            \(" Merry Xmas! ", .font(.systemFont(ofSize: 36)), .color(.red), .backgroundColor(.yellow))
            \(10086)
            """, .alignment(.center))

          Go there to \("learn more about String Interpolation", .link("https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md"), .underline(.blue, .single))!
          """
        
        
        let label = UILabel()
        label.attributedText = attrStr.attributedText
        label.frame = CGRect(x: 10, y: 80, width: 100, height: 300)
        label.numberOfLines = 0
        view.addSubview(label)
        view.backgroundColor = .green
    }

}



