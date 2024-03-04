//
//  ActionLabelPlaceholderView.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 04/03/2024.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton()
}

class ActionLabelPlaceholderView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    let button: UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
        button.frame = CGRect(x: 0, y: label.bottom-5, width: width, height: 40)
    }
    
    @objc func buttonDidTap(){
        delegate?.actionLabelViewDidTapButton()
    }
    
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
}
