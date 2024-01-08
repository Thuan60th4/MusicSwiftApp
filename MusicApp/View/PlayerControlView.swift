//
//  PlayerControlView.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 04/01/2024.
//

import UIKit

protocol PlayControlViewDelegate {
    func playControlViewDidTapBackBtn()
    func playControlViewDidTapNextBtn()
    func playControlViewDidTapPlayPauseBtn(isPlaying: Bool)
    func volumeChangingSlider(didChangeVolumeValue: Float)
}

class PlayerControlView: UIStackView {
    
    var delegate: PlayControlViewDelegate?
    var isPlaying = true
    
    private let containLabelView:UIView = {
        let stackView = UIView()
        return stackView
    }()
    
    private let songNameLabel: UILabel = {
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
        containLabelView.addSubview(songNameLabel)
        containLabelView.addSubview(singerNameLabel)
        addArrangedSubview(rewindSlider)
        addArrangedSubview(containControllButtonView)
        containControllButtonView.addArrangedSubview(backButton)
        containControllButtonView.addArrangedSubview(playPauseButton)
        containControllButtonView.addArrangedSubview(nextButton)
        addArrangedSubview(volumeSlider)
        
        backButton.addTarget(self, action: #selector(didTapBackBtn), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseBtn), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextBtn), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didChangeVolume), for: .valueChanged)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            singerNameLabel.bottomAnchor.constraint(equalTo: containLabelView.bottomAnchor),
            singerNameLabel.leadingAnchor.constraint(equalTo: containLabelView.leadingAnchor),
            songNameLabel.leadingAnchor.constraint(equalTo: containLabelView.leadingAnchor),
            songNameLabel.bottomAnchor.constraint(equalTo: singerNameLabel.topAnchor,constant: -5)
        ])
    }
    
    @objc func didChangeVolume(sender: UISlider){
        delegate?.volumeChangingSlider(didChangeVolumeValue: sender.value)
    }
    
    @objc func didTapBackBtn(){
        delegate?.playControlViewDidTapBackBtn()
        
    }
    @objc func didTapNextBtn(){
        delegate?.playControlViewDidTapNextBtn()
    }
    @objc func didTapPlayPauseBtn(){
        delegate?.playControlViewDidTapPlayPauseBtn(isPlaying: isPlaying)
        isPlaying = !isPlaying
        
        let icon = UIImage(systemName: isPlaying ? "pause.fill" : "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        playPauseButton.setImage(icon, for: .normal)
    }
    
    func configureNamelabel(track: AudioTrack?){
        songNameLabel.text = track?.name
        singerNameLabel.text = track?.artists.first?.name
    }
    
}
