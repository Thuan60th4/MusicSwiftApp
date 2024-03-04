//
//  RecommendedTrackCollectionViewCell.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 26/12/2023.
//

import UIKit

class SongViewCell: UIView {
    
    private let containStackView: UIStackView = {
        let containStackView = UIStackView()
        containStackView.axis = .horizontal
        containStackView.spacing = 10
        containStackView.isLayoutMarginsRelativeArrangement = true
        return containStackView
    }()
    
     private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let containLabelStackView: UIStackView = {
        let containLabelStackView = UIStackView()
        containLabelStackView.axis = .vertical
        containLabelStackView.distribution = .fillEqually
        return containLabelStackView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let subLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.font = .systemFont(ofSize: 18, weight: .thin)
        return subLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(containStackView)
        containStackView.addArrangedSubview(imageView)
        containStackView.addArrangedSubview(containLabelStackView)
        containLabelStackView.addArrangedSubview(label)
        containLabelStackView.addArrangedSubview(subLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containStackView.frame = bounds
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: containStackView.height)
        ])
        
    }
    
    func prepareForReuse() {
        imageView.image = nil
        label.text = nil
        subLabel.text = nil
    }
    
    func configure(data : SongCellModel){
        if data.imageUrl != nil {
            imageView.sd_setImage(with: data.imageUrl,placeholderImage: UIImage(systemName: "photo"), completed: nil)
        }
        else{
            imageView.isHidden = true
            containStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        label.text = data.name
        if data.subName != nil {
            subLabel.text = data.subName
        }
        else {
            subLabel.isHidden = true
        }
    }
}

class SongCollectionViewCell: UICollectionViewCell {
    static let identifier = "SongCollectionViewCell"
    
    let view = SongViewCell()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        view.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
    }
    
    func configure(data : SongCellModel){
        view.configure(data: data)
    }
    
}


class SongTableViewCell: UITableViewCell {
    static let identifier = "SongTableViewCell"
    
    let songView = SongViewCell()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(songView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        songView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        songView.prepareForReuse()
    }
    
    func configure(data : SongCellModel){
        songView.configure(data: data)
    }
    
}
