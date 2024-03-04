//
//  LibraryToggleView.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 03/03/2024.
//

import UIKit

//Them anyobject để dùg vs weak
protocol LibraryToggleViewTap: AnyObject{
    func libraryToggleViewTapPlaylist()
    
    func libraryToggleViewTapAlbum()
}

class LibraryToggleView: UIView {
    
    weak var delegate: LibraryToggleViewTap?
    
    enum State {
        case playlist
        case album
    }

    let playlistBtn: UIButton = {
       let button = UIButton()
        button.setTitle("Playlist", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    let albumBtn: UIButton = {
       let button = UIButton()
        button.setTitle("Album", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    let indicatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 9
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistBtn)
        addSubview(albumBtn)
        addSubview(indicatorView)
        
        playlistBtn.addTarget(self, action: #selector(playlistBtnTap), for: .touchUpInside)
        albumBtn.addTarget(self, action: #selector(albumBtnTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        albumBtn.frame = CGRect(x: playlistBtn.right, y: 0, width: 100, height: 50)
        indicatorView.frame = CGRect(x: 0, y: playlistBtn.bottom, width: 100, height: 4)
    }
    
    //MARK: - Action
    @objc func playlistBtnTap(){
//        updatePositionIndicator(tap: .playlist)
        delegate?.libraryToggleViewTapPlaylist()
    }
    
    @objc func albumBtnTap(){
//        updatePositionIndicator(tap: .album)
        delegate?.libraryToggleViewTapAlbum()
    }
    
    func updatePositionIndicator(tap: State){
        UIView.animate(withDuration: 0.2) {
            switch tap {
                case .playlist:
                    self.indicatorView.frame.origin.x = 0
                case .album:
                    self.indicatorView.frame.origin.x = self.albumBtn.left
            }
        }
    }

}
