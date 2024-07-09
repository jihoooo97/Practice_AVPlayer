//
//  MediaConstants.swift
//  Practice_AVPlayer
//
//  Created by 유지호 on 7/9/24.
//

import Foundation

public enum MediaConstants {
    case soundHelix
    
    public var urlString: String {
        switch self {
        case .soundHelix: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
        }
    }
    
    public static func url(from media: MediaConstants) -> URL? {
        return URL(string: media.urlString)
    }
}
