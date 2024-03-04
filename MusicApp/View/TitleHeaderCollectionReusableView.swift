//
//  TitleHeaderCollectionReusableView.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 03/01/2024.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    var title: String?{
        didSet {
            self.titleLabel.text = title
        }
    }
    let titleLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 10, y: 0, width: width - 20, height: height)
    }
}
