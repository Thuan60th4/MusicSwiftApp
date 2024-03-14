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
    
    let optionsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    var menuAction: UIAction?{
        didSet{
            if let menuAction = menuAction {
                let menu = UIMenu(title: "", children: [menuAction])
                self.optionsButton.menu = menu
            }
        }
    }
    
    var addToPlaylist: (() -> Void)?{
        didSet{
            self.menuAction = UIAction(title: "Add to a Playlist", image: UIImage(systemName: "text.badge.plus")) { [weak self] _ in
                self?.addToPlaylist?()
            }
            
        }
    }
    var removeFromPlaylist: (() -> Void)?{
        didSet{
            self.menuAction = UIAction(title: "Remove from Playlist",image: UIImage(systemName: "minus.circle"), attributes: .destructive) {[weak self] _ in
                self?.removeFromPlaylist?()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(containStackView)
        containStackView.addArrangedSubview(imageView)
        containStackView.addArrangedSubview(containLabelStackView)
        containLabelStackView.addArrangedSubview(label)
        containLabelStackView.addArrangedSubview(subLabel)
        containStackView.addArrangedSubview(optionsButton)
                
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containStackView.frame = bounds
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: containStackView.height),
            optionsButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func prepareForReuse() {
        imageView.image = nil
        label.text = nil
        subLabel.text = nil
    }
    
    func configure(data : SongCellModel){
        imageView.sd_setImage(with: data.imageUrl,placeholderImage: UIImage(systemName: "photo"), completed: nil)
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
    
    let songView = SongViewCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(songView)
        songView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        songView.prepareForReuse()
    }
    
    func configure(data : SongCellModel){
        songView.configure(data: data)
    }
    
}


class SongTableViewCell: UITableViewCell {
    static let identifier = "SongTableViewCell"
    
    let songView = SongViewCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(songView)
        songView.optionsButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
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
