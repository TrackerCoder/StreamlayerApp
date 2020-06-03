//
//  ViewController.swift
//  StreamlayerApp
//
//  Created by Tracker on 27.05.2020.
//  Copyright © 2020 Tracker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StreamLayer
import SnapKit
import AVKit

class StreamViewController: UIViewController {
    
    // MARK: view elements

    private let videoPlayer = SLRVideoPlayer()
    
    /// needs to fix issue whith player layout
    private lazy var avPlayerController: AVPlayerViewController? = {
        let vc = videoPlayer.children.first { (view) -> Bool in
            return view is AVPlayerViewController
        }
        return vc as? AVPlayerViewController
    }()
    
    private let overlayView = UIView()

    private lazy var overlayViewController = StreamLayer.createOverlay(
      overlayView,
      overlayDelegate: self
    )

    private var streamListViewController = StreamListViewController()
    
    private var informationView = InformationView()
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let streamListViewModel = StreamListViewModel()
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// uses after setOrientation(frameSize:) called
    private var currentWidth: CGFloat!
    
    private var currentOrientation: OrientationState = .vertical
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOrientation(frameSize: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setOrientation(frameSize: size)
    }
    
    // MARK: Bindings
    private func setupBindings() {
        streamListViewModel.videoDataList.bind { [weak self] videoData in
            self?.streamListViewController.reload(data: videoData)
        }.disposed(by: disposeBag)
        
        streamListViewModel.currentVideo.bind { [weak self] currentVideo in
            if let currentVideo = currentVideo {
                self?.informationView.set(title: currentVideo.title)
                self?.videoPlayer.setNewStreamURL(withURL: currentVideo.videoId, providerType: .youtube)
            }
        }.disposed(by: disposeBag)
        
        informationView.shareDidTapped = {
            let text = "Share text"
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: [])
            self.present(activityVC, animated: true, completion: nil)
        }
        
        streamListViewController.streamDidSelect = { video in
            self.streamListViewModel.didSelect(video: video)
        }
    }
    
    // MARK: Layout
    private func setOrientation(frameSize size: CGSize) {
        currentOrientation = size.width > size.height ? .horizontal : .vertical
        currentWidth = size.width
        
        switch currentOrientation {
        case .horizontal:
            informationView.removeFromSuperview()
            streamListViewController.view.removeFromSuperview()
            setupLanscapeLayout()
        case .vertical:
            view.insertSubview(streamListViewController.view, at: 0)
            view.insertSubview(informationView, at: 0)
            setupPortraitLayout()
        }
    }
    
    private func setupView() {
        // assign video player
        videoPlayer.willMove(toParent: self)
        addChild(videoPlayer)
        view.addSubview(videoPlayer.view)
        videoPlayer.didMove(toParent: self)

        // fix bug with SLRVideoPlayer
        avPlayerController?.view.snp.makeConstraints {
            $0.edges.equalTo(videoPlayer.view)
        }
        
        // assign StreamLayer's overlayView
        view.addSubview(overlayView)
        overlayView.isUserInteractionEnabled = false
        
        overlayViewController.willMove(toParent: self)
        addChild(overlayViewController)
        view.addSubview(overlayViewController.view)
        overlayViewController.didMove(toParent: self)
        
        streamListViewController.willMove(toParent: self)
        addChild(streamListViewController)
        view.insertSubview(streamListViewController.view, at: 0)
        streamListViewController.didMove(toParent: self)
        
        view.backgroundColor = .black
    }
    
    private func setupLanscapeLayout() {
        videoPlayer.view.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayView.snp.remakeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(500)
        }
        
        overlayViewController.view.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupPortraitLayout() {
        let safeArea = view.safeAreaLayoutGuide

        videoPlayer.view.snp.remakeConstraints {
            $0.left.right.top.equalTo(safeArea)
            $0.height.equalTo(currentWidth * 200/343)
        }
    
        overlayView.snp.remakeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(videoPlayer.view.snp.bottom).offset(-40)
        }
        
        overlayViewController.view.snp.remakeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(videoPlayer.view.snp.bottom).offset(-40)
        }
        
        informationView.snp.remakeConstraints {
            $0.left.right.equalTo(safeArea)
            $0.top.equalTo(videoPlayer.view.snp.bottom)
            $0.height.equalTo(60)
        }
        
        streamListViewController.view.snp.remakeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(informationView.snp.bottom)
        }
        
    }

}

extension StreamViewController: SLROverlayDelegate {
    func requestAudioDucking() {}
    
    func disableAudioDucking() {}
    
    func prepareAudioSession(for type: SLRAudioSessionType) {}
    
    func disableAudioSession(for type: SLRAudioSessionType) {}
    
    func shareInviteMessage() -> String {
        return "shareInviteMessage"
    }
    
    func waveMessage() -> String {
        return "waveMessage"
    }
    
    func overlayOpened() {
        overlayView.isUserInteractionEnabled = true
    }
    
    func overlayClosed() {
        overlayView.isUserInteractionEnabled = false
    }
    
}
