//
//  LibraryViewController.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 29/02/2024.
//

import UIKit

class LibraryViewController: UIViewController {

    lazy var myPlaylistViewController = MyPlaylistViewController()
    lazy var myAlbumViewController = MyAlbumViewController()
    
    lazy var toggleView = LibraryToggleView()
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(toggleView)
        toggleView.delegate = self
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width*2, height: 0)
        addSubViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 55)
        scrollView.frame = CGRect(
            x: 0,
            y: toggleView.bottom + 5,
            width: view.width,
            height: view.height-toggleView.bottom)

    }
    
    private func addSubViewController(){
        
        //Muốn kéo đc scrollView thì ta buộc phải làm cho nó lớn hơn size của màn hình hoặc set background hay gì đó cho scrollView
        self.addChild(myPlaylistViewController)
        scrollView.addSubview(myPlaylistViewController.view)
        myPlaylistViewController.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        myPlaylistViewController.didMove(toParent: self)
        
        self.addChild(myAlbumViewController)
        scrollView.addSubview(myAlbumViewController.view)
        myAlbumViewController.view.frame = CGRect(x: view.width, y: 0, width: 0, height: 0)
        myAlbumViewController.didMove(toParent: self)

    }
        
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > view.width - 100 {
            toggleView.updatePositionIndicator(tap: .album)
        }
        else{
            toggleView.updatePositionIndicator(tap: .playlist)
        }
    }
}

extension LibraryViewController: LibraryToggleViewTap {
    func libraryToggleViewTapPlaylist() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewTapAlbum() {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
}
