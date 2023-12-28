//
//  RecommendedTrackCollectionViewCell.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 26/12/2023.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let containStackView: UIStackView = {
        let containStackView = UIStackView()
        containStackView.axis = .horizontal
        containStackView.spacing = 10
        return containStackView
    }()
    
    private let albumImageView: UIImageView = {
       let albumImageView = UIImageView()
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        return albumImageView
    }()
    private let containLabelStackView: UIStackView = {
        let containLabelStackView = UIStackView()
        containLabelStackView.axis = .vertical
        containLabelStackView.distribution = .fillEqually
        return containLabelStackView
    }()
    
    private let trackNameLabel: UILabel = {
        let trackNameLabel = UILabel()
        trackNameLabel.font = .systemFont(ofSize: 18, weight: .regular)
        return trackNameLabel
    }()
    
    private let artisNameLabel: UILabel = {
        let artisNameLabel = UILabel()
        artisNameLabel.font = .systemFont(ofSize: 18, weight: .thin)
        return artisNameLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(containStackView)
        containStackView.addArrangedSubview(albumImageView)
        containStackView.addArrangedSubview(containLabelStackView)
        containLabelStackView.addArrangedSubview(trackNameLabel)
        containLabelStackView.addArrangedSubview(artisNameLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containStackView.frame = contentView.bounds
        NSLayoutConstraint.activate([
            albumImageView.widthAnchor.constraint(equalToConstant: containStackView.height)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        trackNameLabel.text = nil
        artisNameLabel.text = nil
    }
    
    func configure(data : RecommendedTrackCellModel){
        albumImageView.sd_setImage(with: data.artworkURL, completed: nil)
        trackNameLabel.text = data.name
        artisNameLabel.text = data.artistName
    }
}
