//
//  VideoService.swift
//  StreamlayerApp
//
//  Created by Tracker on 29.05.2020.
//

import Foundation

protocol VideoService {
    func fetchVideoData() -> [VideoData]
}

class VideoServiceImp: VideoService {
    
    static let shared = VideoServiceImp()
    private init() {}
    
    func fetchVideoData() -> [VideoData] {
        let video1 = VideoData(title: "Helios Deep Music Radio",
                               duration: "2:17",
                               videoId: "Bu8RvJ9R02M")
        
        let video2 = VideoData(title: "lofi hip hop radio",
                               duration: "3:38",
                               videoId: "IjMESxJdWkg")
        
        let video3 = VideoData(title: "NCM 24/7 Live Stream",
                               duration: "3:47",
                               videoId: "Oxj2EAr256Y")
        
        return [video1, video2, video3]
    }
    
}
