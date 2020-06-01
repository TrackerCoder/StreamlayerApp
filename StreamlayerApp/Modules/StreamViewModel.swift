//
//  StreamListViewModel.swift
//  StreamlayerApp
//
//  Created by Tracker on 29.05.2020.
//

import Foundation
import RxSwift
import RxCocoa

class StreamListViewModel {
    
    let videoService: VideoService = VideoServiceImp.shared
        
    var videoDataList: BehaviorSubject<[VideoData]>
    var currentVideo: BehaviorSubject<VideoData?>
    
    init() {
        let list = self.videoService.fetchVideoData()
        videoDataList = BehaviorSubject<[VideoData]>(value: list)
        currentVideo = BehaviorSubject<VideoData?>(value: list.first)
    }
    
    func didSelect(video: VideoData) {
        let current = try? currentVideo.value()
        guard video.videoId != current?.videoId else { return }
        currentVideo.onNext(video)
    }
    
}
