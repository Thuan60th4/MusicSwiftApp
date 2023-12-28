//
//  FeaturedPlaylistCollectionViewCell.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 26/12/2023.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playListImageView: UIImageView = {
        let playListImageView = UIImageView()
        playListImageView.contentMode = .scaleAspectFill
        return playListImageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        contentView.addSubview(playListImageView)
        addGradient()
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playListImageView.frame = contentView.bounds
        NSLayoutConstraint.activate([
            playlistNameLabel.widthAnchor.constraint(equalToConstant: contentView.width - 10),
            playlistNameLabel.bottomAnchor.constraint(equalTo: creatorNameLabel.topAnchor,constant: -5),
            playlistNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            creatorNameLabel.widthAnchor.constraint(equalToConstant: contentView.width - 10),
            creatorNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            creatorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playListImageView.image = nil
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
    }
    func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.frame = bounds
        contentView.layer.addSublayer(gradientLayer)
    }
    
    func configure(data : FeaturedPlaylistCellModel){
        playListImageView.sd_setImage(with: data.artworkURL, completed: nil)
        playlistNameLabel.text = data.name
        creatorNameLabel.text = data.creatorName
    }
}
