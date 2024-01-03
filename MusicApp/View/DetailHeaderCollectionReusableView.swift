//
//  PlaylistHeaderCollectionReusableView.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 01/01/2024.
//

import UIKit

class DetailHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    var playMusic: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/1.8
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width-20, height: 44)
        playAllButton.frame = CGRect(x: width-80, y: height-80, width: 60, height: 60)
        
        //sizeThatFit to get actually size of when full text
        let heightDescriptionLabel = height-nameLabel.bottom-10
        let descriptionLabelSize = descriptionLabel.sizeThatFits(CGSize(width: playAllButton.left-20, height: heightDescriptionLabel))
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: playAllButton.left-20, height: min(descriptionLabelSize.height,heightDescriptionLabel))
        //SizeToFit to resize label smaller if label.text has few text but it can exceed height if it has much text
    }
    
    @objc func playBtnPressed(){
        self.playMusic?()
    }
    
    func configure(data : DetailHeaderModel){
        imageView.sd_setImage(with: URL(string: data.imageLink), completed: nil)
        nameLabel.text = data.name
        descriptionLabel.text = data.description
    }
    
}
