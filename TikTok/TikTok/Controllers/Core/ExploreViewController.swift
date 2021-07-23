//
//  ExploreViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit

class ExploreViewController: UIViewController {
    
    // MARK: - Properties
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    private var collectionView: UICollectionView?
    private var sections = [ExploreSection]()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    // MARK: - Helper Function
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureModels() {
        var cells = [ExploreCell]()
        for _ in 0...1000 {
            let cell = ExploreCell.banner(
                viewModel: ExplorBannerViewModel(
                    image: nil,
                    title: "Foo",
                    handler: {
                        
                    }))
            cells.append(cell)
        }
        // banner
        sections.append(
            ExploreSection(type: .banners,
                           cells: cells
            )
        )
        
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(
                ExploreCell.post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                    
                })))
        }
        
        // trending posts
        sections.append(
            ExploreSection(type: .trendingPosts,
                           cells: posts
            )
        )
        // users
        sections.append(
            ExploreSection(type: .users,
                           cells: [
                            .user(viewModel: ExplorUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                           })),
                            .user(viewModel: ExplorUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                           })),
                            .user(viewModel: ExplorUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                           })),
                            .user(viewModel: ExplorUserViewModel(profilePictureURL: nil, username: "", followerCount: 0, handler: {
                        
                           })),
                           ]
            )
        )
        // trending hashtags
        sections.append(
            ExploreSection(type: .trendingHashtags,
                           cells: [
                            .hashtag(viewModel: ExplorHashtagViewModel(text: "for you", icon: nil, count: 1, handler: {
                                
                            })),
                            .hashtag(viewModel: ExplorHashtagViewModel(text: "for you", icon: nil, count: 1, handler: {
                                
                            })),
                            .hashtag(viewModel: ExplorHashtagViewModel(text: "for you", icon: nil, count: 1, handler: {
                                
                            })),
                            .hashtag(viewModel: ExplorHashtagViewModel(text: "for you", icon: nil, count: 1, handler: {
                                
                            }))
                           ]
            )
        )
        // recommended
        sections.append(
            ExploreSection(type: .recommended,
                           cells: [
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           }))
                           ]
            )
        )
        // popular
        sections.append(
            ExploreSection(type: .popular,
                           cells: [
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           }))
                           ]
            )
        )
        // new
        sections.append(
            ExploreSection(type: .new,
                           cells: [
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           })),
                            .post(viewModel: ExplorPostViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                           }))
                           ]
            )
        )
        
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    // MARK: layout
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType {
        
        // MARK: .banners
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .absolute(200)),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return section
            return sectionLayout
      
        // MARK: .users
        case .users:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                   heightDimension: .absolute(200)),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return section
            return sectionLayout
            
        // MARK: .trendingHashtags
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(60)),
                subitems: [item]
            )
            
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            
            // Return section
            return sectionLayout
            
        // MARK: .trendingPosts .new .recommended
        case .trendingPosts, .new, .recommended:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100),
                                                   heightDimension: .absolute(240)),
                subitem: item,
                count: 2
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(240)),
                subitems: [verticalGroup])
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            // Return section
            return sectionLayout
            
        // MARK: .popular
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            // Return section
            return sectionLayout
        }
        
    }
}

// MARK: - UISearchBarDelegate

extension ExploreViewController: UISearchBarDelegate {
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}
