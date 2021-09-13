//
//  AttributedText.swift
//  ToolKit
//
//  Created by chenxiaolin on 2021/9/10.
//

import UIKit

struct AttributedText {
    let attributedText: NSAttributedString
}

extension AttributedText: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self.attributedText = NSAttributedString(string: value)
    }
}

extension AttributedText: CustomStringConvertible {
    var description: String {
        return String(describing: self.attributedText)
    }
}

extension AttributedText: ExpressibleByStringInterpolation {
    init(stringInterpolation: StringInterpolation) {
        self.attributedText = NSMutableAttributedString(attributedString: stringInterpolation.attributedText)
    }
    
    struct StringInterpolation: StringInterpolationProtocol {
        
        var attributedText = NSMutableAttributedString()
        
        init(literalCapacity: Int, interpolationCount: Int) { }
        
        func appendLiteral(_ literal: String) {
            let attr = NSAttributedString(string: literal)
            self.attributedText.append(attr)
        }
        /// "\(wrap:"测试\("嵌套", .color(.blue))", .color(.white), .oblique)" 外层的值会覆盖掉(或追加)内层的值
        func appendInterpolation(wrap string: AttributedText, _ styles: Style...) {
            var attrs: [NSAttributedString.Key: Any] = [:]
            styles.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
            let mas = NSMutableAttributedString(attributedString: string.attributedText)
            let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
            mas.addAttributes(attrs, range: fullRange)
            self.attributedText.append(mas)
        }
    }
}

// MARK: - 泛型T
extension AttributedText.StringInterpolation {
    /// \(UIColor.red)
    func appendInterpolation<T>(_ literal: T) {
        let attr = NSAttributedString(string: "\(literal)")
        self.attributedText.append(attr)
    }

    /// \(UIColor.red , attributes: [.foregroundColor: UIColor.red])
    func appendInterpolation<T>(_ literal: T, attributes: [NSAttributedString.Key: Any]) {
        let attr = NSAttributedString(string: "\(literal)", attributes: attributes)
        self.attributedText.append(attr)
    }

    /// \(UIColor,red, color: .red)
    func appendInterpolation<T>(_ literal: T, _ styles: AttributedText.Style...) {
        let attr = NSAttributedString(string: "\(literal)", attributes: styles.attributes())
        self.attributedText.append(attr)
    }
}

extension AttributedText.StringInterpolation {
    /// "\(image: UIImage(named: "example")!)"
    func appendInterpolation(image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image
        self.attributedText.append(NSAttributedString(attachment: attachment))
    }
}

extension AttributedText {
    struct Style {
        let attributes: [NSAttributedString.Key: Any]
        
        init(attributes: [NSAttributedString.Key: Any]) {
            self.attributes = attributes
        }
        
        static func attributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
            self.init(attributes: attributes)
        }
        
        static func font(_ font: UIFont) -> Style { attributes([.font: font]) }
        
        static func color(_ color: UIColor) -> Style { attributes([.foregroundColor: color]) }
        
        static func backgroundColor(_ backgroundColor: UIColor) -> Style { attributes([.backgroundColor: backgroundColor]) }
        
        static func link(_ link: String) -> Style { .link(URL(string: link)!)}
        
        static func link(_ link: URL) -> Style { attributes([.link: link])}
        
        static let oblique = Style.attributes([.obliqueness: 0.1])
        
        static func underline(_ color: UIColor, _ style: NSUnderlineStyle) -> Style {
            .attributes([.underlineColor: color, .underlineStyle: style.rawValue])
        }
        
        static func alignment(_ alignment: NSTextAlignment) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.alignment = alignment
            return attributes([.paragraphStyle: ps])
        }
        
        static func firstLineHeadIndent(_ headIndent: CGFloat) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.firstLineHeadIndent = headIndent
            return attributes([.paragraphStyle: ps])
        }
        
        static func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> Style {
            attributes([.paragraphStyle: paragraphStyle])
        }
    }
}

fileprivate extension Array where Element == AttributedText.Style {
    func attributes() -> [NSAttributedString.Key: Any] {
        var attrs = [NSAttributedString.Key: Any]()
        self.forEach{ attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        return attrs
    }
}

