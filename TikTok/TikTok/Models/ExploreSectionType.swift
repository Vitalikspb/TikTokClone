//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 23.07.2021.
//

import Foundation

enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case users
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
        case .banners: return "Featured"
        case .trendingPosts: return "Trending Posts"
        case .users: return "Popular Creators"
        case .trendingHashtags: return "Hashtags"
        case .recommended: return "Recommended"
        case .popular: return "Popular"
        case .new: return "recently Posted"
        }
    }
}
