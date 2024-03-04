//
//  AlbumViewController.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 28/12/2023.
//

import UIKit

class AlbumViewController: UIViewController {
    
    let album : Album
    var data : [SongCellModel] = []
    var tracks : [AudioTrack] = []
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)]
        return section
    }))
    
    init(album: Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(DetailHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderCollectionReusableView.identifier)
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        ApiManagers.shared.getAlbumDetail(for: album.id) { [weak self] result in
            if let result = result {
                self?.tracks = result.tracks.items
                self?.data = result.tracks.items.compactMap({
                    return SongCellModel(
                        name: $0.name,
                        subName: $0.artists.first?.name ?? "-",
                        imageUrl: nil)
                })
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func playAllMusic(){
        let tracksWithAlbum : [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlayAudioManager.shared.playAudioTrack(from: self, tracks: tracksWithAlbum)
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCollectionViewCell.identifier, for: indexPath) as! SongCollectionViewCell
        cell.configure(data: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderCollectionReusableView.identifier, for: indexPath) as! DetailHeaderCollectionReusableView
            let detailHeaderModel = DetailHeaderModel(imageLink: album.images.first?.url ?? "" , name: album.name, description: "Release Date: \(album.release_date.longDate())")
            headerView.configure(data: detailHeaderModel)
            headerView.playMusic = playAllMusic
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = tracks[indexPath.row]
        track.album = self.album
        PlayAudioManager.shared.playAudioTrack(from: self, tracks: [track])
    }
    
}
