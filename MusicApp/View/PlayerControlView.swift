//
//  PlayerControlView.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 04/01/2024.
//

import UIKit

class PlayerControlView: UIStackView {

    private let containLabelView:UIView = {
        let stackView = UIView()
        return stackView
    }()
    
    private let musicNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let singerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rewindSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let containControllButtonView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
         button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium))
         button.setImage(image, for: .normal)
         return button
     }()
     
     private let nextButton: UIButton = {
        let button = UIButton()
         button.tintColor = .label
         let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium))
         button.setImage(image, for: .normal)
         return button
     }()
     
     private let playPauseButton: UIButton = {
        let button = UIButton()
         button.tintColor = .label
         let image = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .bold))
         button.setImage(image, for: .normal)
         return button
     }()
    
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fillEqually
        
        addArrangedSubview(containLabelView)
        containLabelView.addSubview(musicNameLabel)
        containLabelView.addSubview(singerNameLabel)
        addArrangedSubview(rewindSlider)
        addArrangedSubview(containControllButtonView)
        containControllButtonView.addArrangedSubview(backButton)
        containControllButtonView.addArrangedSubview(playPauseButton)
        containControllButtonView.addArrangedSubview(nextButton)
        addArrangedSubview(volumeSlider)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            singerNameLabel.bottomAnchor.constraint(equalTo: containLabelView.bottomAnchor),
            singerNameLabel.leadingAnchor.constraint(equalTo: containLabelView.leadingAnchor),
            musicNameLabel.leadingAnchor.constraint(equalTo: containLabelView.leadingAnchor),
            musicNameLabel.bottomAnchor.constraint(equalTo: singerNameLabel.topAnchor,constant: -5)
        ])
    }
}
