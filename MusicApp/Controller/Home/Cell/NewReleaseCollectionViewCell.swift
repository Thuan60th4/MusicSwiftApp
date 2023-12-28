//
//  NewReleaseCollectionViewCell.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 26/12/2023.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    private let containStackView: UIStackView = {
        let containStackView = UIStackView()
        containStackView.axis = .horizontal
        containStackView.spacing = 10
        containStackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        containStackView.isLayoutMarginsRelativeArrangement = true
        return containStackView
    }()
    
    private let albumImageView: UIImageView = {
       let albumImageView = UIImageView()
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.layer.cornerRadius = 9
        albumImageView.clipsToBounds = true
        return albumImageView
    }()
    private let containLabelStackView: UIStackView = {
        let containLabelStackView = UIStackView()
        containLabelStackView.axis = .vertical
        containLabelStackView.distribution = .fillEqually
        return containLabelStackView
    }()
    
    private let albumNameLabel: UILabel = {
        let albumNameLabel = UILabel()
        albumNameLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        return albumNameLabel
    }()
    
    private let artisNameLabel: UILabel = {
        let artisNameLabel = UILabel()
        artisNameLabel.font = .systemFont(ofSize: 15, weight: .thin)
        return artisNameLabel
    }()
    
    private let numOfTrackLabel: UILabel = {
        let numOfTrackLabel = UILabel()
        numOfTrackLabel.font = .systemFont(ofSize: 15, weight: .light)
        return numOfTrackLabel
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 9
        contentView.addSubview(containStackView)
        containStackView.addArrangedSubview(albumImageView)
        containStackView.addArrangedSubview(containLabelStackView)
        containLabelStackView.addArrangedSubview(albumNameLabel)
        containLabelStackView.addArrangedSubview(artisNameLabel)
        containLabelStackView.addArrangedSubview(numOfTrackLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containStackView.frame = contentView.bounds
        NSLayoutConstraint.activate([
            albumImageView.widthAnchor.constraint(equalToConstant: containStackView.height - 10)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        albumNameLabel.text = nil
        artisNameLabel.text = nil
        numOfTrackLabel.text = nil
    }
    
    func configure(data : NewReleasesCellModel){
        albumImageView.sd_setImage(with: data.artworkURL, completed: nil)
        albumNameLabel.text = data.name
        artisNameLabel.text = data.artistName
        numOfTrackLabel.text = "Tracks: \(data.numberOfTracks)"
    }
    
}
