//
//  HomeViewController.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 23/12/2023.
//

import UIKit

enum sectionType {
    case newReleases(data : [NewReleasesCellModel])
    case featuredPlaylists(data : [FeaturedPlaylistCellModel])
    case recommendedTracks(data : [SongCellModel])
    
    var title: String {
        switch self {
            case .newReleases:
                return "New Released Albums"
            case .featuredPlaylists:
                return "Featured Playlists"
            case .recommendedTracks:
                return "Recommended"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }))
    }()
    
    private var sections: [sectionType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UILabel()
        title.text = "Spotify"
        title.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
        
        let albumBtn = UIBarButtonItem(image: UIImage(systemName: "music.note.list"), style: .plain, target: self, action: #selector(navigateToMyLibrary))
        let logoutBtn = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logout))

        navigationItem.rightBarButtonItems = [logoutBtn,albumBtn]
        navigationController?.navigationBar.tintColor = title.textColor
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    //MARK: - Configure collectionview
    func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.identifier)
        
    }
    
    //MARK: - Create layout collection view
    static func createSectionLayout(section : Int) ->  NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let supplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)]
        
        switch section {
            case 0:
                //group
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)),
                    subitem: item,
                    count: 3)
                //group là horizontal thì subitem sẽ cố gắng chiếm toàn bộ chiều ngang bất kể set là gì
                //như th verticalGroup thì mặc định chiều ngang của nó sẽ là toàn bộ chiều ngang (như kiểu th nào cũg flex:1 ấy) của horizontal rồi, chúng ta chỉ đc set chiều còn lại
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.8),
                        heightDimension: .absolute(350)),
                    subitem: verticalGroup,
                    count: 1)
                
                //section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = supplementaryItems
                return section
                
            case 1:
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)),
                    subitem: item,
                    count: 2)
                verticalGroup.interItemSpacing = .fixed(10)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.35),
                        heightDimension: .fractionalWidth(0.7)),
                    subitem: verticalGroup,
                    count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = supplementaryItems
                return section
                
            default:
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(75)),
                    subitem: item,
                    count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = supplementaryItems
                return section
        }
        
    }
    
    //MARK: - Fetch api
    private func fetchData(){
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendationsPlayList: RecommendationsResponse?
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        ApiManagers.shared.getNewReleases { newReleaseData in
            defer{
                group.leave()
            }
            if let newReleaseData = newReleaseData {
                newReleases = newReleaseData
            }
        }
        
        ApiManagers.shared.getFeaturedPlaylists { featuredPlaylistsData in
            defer{
                group.leave()
            }
            if let featuredPlaylistData = featuredPlaylistsData {
                featuredPlaylist = featuredPlaylistData
            }
        }
        
        ApiManagers.shared.getRecommendedGenres { recommendedGenresData in
            guard let recommendedGenresData = recommendedGenresData else {return}
            var genres: Set<String> = []
            while genres.count < 5 {
                if let genre = recommendedGenresData.genres.randomElement(){
                    genres.insert(genre)
                }
            }
            ApiManagers.shared.getRecommendations(genres: genres) { recommendationsPlayListData in
                defer{
                    group.leave()
                }
                if let recommendationsPlayListData = recommendationsPlayListData {
                    recommendationsPlayList = recommendationsPlayListData
                }
            }
            
        }
        
        group.notify(queue: .global()) {
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items else {
                      return
                  }
            self.configureModels(newAlbums: newAlbums,
                                 playlists: playlists,
                                 tracks: recommendationsPlayList?.tracks ?? [])
        }
    }
    
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks

        sections.append(.newReleases(data: newAlbums.compactMap({
            return NewReleasesCellModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "N/A")
        })))
        sections.append(.featuredPlaylists(data: playlists.compactMap({
            return FeaturedPlaylistCellModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                creatorName: $0.owner.display_name)
        })))
        sections.append(.recommendedTracks(data: tracks.compactMap({
            return SongCellModel(
                name: $0.name,
                subName: $0.artists.first?.name ?? "-",
                imageUrl: URL(string: $0.album?.images.first?.url ?? ""))
        })))
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    //MARK: - CollectionView Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            case .newReleases(let data):
                return data.count
            case .featuredPlaylists(let data):
                return data.count
            case .recommendedTracks(let data):
                return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            case .newReleases(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as! NewReleaseCollectionViewCell
                cell.configure(data: data[indexPath.row])
                return cell
            case .featuredPlaylists(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as! FeaturedPlaylistCollectionViewCell
                cell.configure(data: data[indexPath.row])
                return cell
            case .recommendedTracks(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCollectionViewCell.identifier, for: indexPath) as! SongCollectionViewCell
                cell.configure(data: data[indexPath.row])
                cell.songView.addToPlaylist = { [weak self] in
                    self?.addSongToPlaylist(songIndexPath: indexPath)
                }
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as! TitleHeaderCollectionReusableView
            headerView.title = sections[indexPath.section].title
            return headerView
        }
        return UICollectionReusableView()
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let type = sections[indexPath.section]
        switch type {
            case .newReleases:
                let albumData = newAlbums[indexPath.row]
                let albumView = AlbumViewController(album: albumData)
                navigationController?.pushViewController(albumView, animated: true)
                break
            case .featuredPlaylists:
                let playlistData = playlists[indexPath.row]
                let playlistView = PlaylistViewController(playlist: playlistData)
                navigationController?.pushViewController(playlistView, animated: true)
                break
            case .recommendedTracks:
                let track = tracks[indexPath.row]
                PlayAudioManager.shared.playAudioTrack(from: self, tracks: [track])
                break
        }
    }
    
    //MARK: - Action
    @objc func navigateToMyLibrary(){
        navigationController?.pushViewController(LibraryViewController(), animated: true)
    }
    
    @objc func logout(){
        let authView = AuthViewController()
        authView.modalPresentationStyle = .fullScreen
        present(authView, animated: true)
        AuthManager.shared.removeToken()
    }
    
    func addSongToPlaylist(songIndexPath: IndexPath){
        let libraryPlaylistView = MyPlaylistViewController()
        libraryPlaylistView.selectionHandler = { playlist in
            ApiManagers.shared.addTrackToPlaylist(track: self.tracks[songIndexPath.row], playlist: playlist) { isSuccess in
            }
        }
        libraryPlaylistView.title = "Select Playlist"
        present(UINavigationController(rootViewController: libraryPlaylistView),
                      animated: true, completion: nil)
    }
}
