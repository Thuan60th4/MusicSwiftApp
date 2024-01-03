//
//  Extension.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 23/12/2023.
//

import Foundation
import UIKit


extension UIView{
    var width : CGFloat{
        return frame.size.width
    }
    var height : CGFloat{
        return frame.size.height
    }
    var top : CGFloat{
        return frame.origin.y
    }
    var bottom : CGFloat{
        return top + height
    }
    var left : CGFloat{
        return frame.origin.x
    }
    var right : CGFloat{
        return left + width
    }
}

extension String {
    func longDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let date = inputFormatter.date(from: self)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        return outputFormatter.string(from: date ?? Date())
    }
}
