//
//  PlaylistViewController.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 28/12/2023.
//

import UIKit

class PlaylistViewController: UIViewController {
    let playlist: Playlist
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
    
    init(playlist: Playlist){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        
        collectionView.register(DetailHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderCollectionReusableView.identifier)
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        ApiManagers.shared.getPlayListDetail(for: playlist.id) {  [weak self] result in
            if let result = result {
                self?.tracks = result.tracks.items.compactMap({ $0.track })
                self?.data = result.tracks.items.compactMap({
                    return SongCellModel(
                        name: $0.track.name,
                        subName: $0.track.artists.first?.name ?? "-",
                        imageUrl: URL(string: $0.track.album?.images.first?.url ?? ""))
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
    
    
    @objc private func didTapShare() {
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func playAllMusic(){
        PlayAudioManager.shared.playAudioTrack(from: self, tracks: tracks)
    }
    
}


extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            let detailHeaderModel = DetailHeaderModel(imageLink: playlist.images.first?.url ?? "" , name: playlist.name, description: playlist.description)
            headerView.configure(data: detailHeaderModel)
            headerView.playMusic = playAllMusic
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        PlayAudioManager.shared.playAudioTrack(from: self, tracks: [track])
    }
    
}
