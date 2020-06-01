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

enum OverlayViewControllerState {
    case closed
    case opened
}

class StreamListViewController: UIViewController {
    
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

    private var tableView: UITableView = {
        return UITableView()
    }()
    
    private var informationView: InformationView = {
        return InformationView()
    }()
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    
    private let streamListViewModel = StreamListViewModel()
    
    private var displayManager: StreamListDisplayManager?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// uses after setOrientation(frameSize:) called
    private var currentWidth: CGFloat!
    private var currentOrientation: OrientationState!
    
    private var overlayViewControllerState: OverlayViewControllerState = .closed

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplayManager()
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
            self?.displayManager?.reload(data: videoData)
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
        
    }
    
    private func setupDisplayManager() {
        displayManager = StreamListDisplayManager(tableView: tableView)
        displayManager?.delegate = self
    }
    
    // MARK: Layout
    private func setOrientation(frameSize size: CGSize) {
        currentOrientation = size.width > size.height ? .horizontal : .vertical
        currentWidth = size.width
        
        switch currentOrientation {
        case .horizontal:
            informationView.removeFromSuperview()
            tableView.removeFromSuperview()
            setupLanscapeLayout()
        default:
            view.insertSubview(tableView, at: 0)
            view.insertSubview(informationView, at: 0)
            setupPortraitLayout()
        }
    }
    
    private func setupView() {
        // video player
        videoPlayer.willMove(toParent: self)
        addChild(videoPlayer)
        view.addSubview(videoPlayer.view)
        videoPlayer.didMove(toParent: self)

        avPlayerController?.view.snp.makeConstraints {
            $0.edges.equalTo(videoPlayer.view)
        }
        
        // assign StreamLayer's overlayView
        view.addSubview(overlayView)
        overlayViewController.willMove(toParent: self)
        addChild(overlayViewController)
        view.addSubview(overlayViewController.view)
        overlayViewController.didMove(toParent: self)

        view.backgroundColor = .black
    }
    
    private func setupLanscapeLayout() {
        videoPlayer.view.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
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
            $0.left.bottom.right.equalTo(safeArea)
            if overlayViewControllerState == .opened {
                $0.top.equalTo(videoPlayer.view.snp.bottom).offset(45) // залезает на текст, поэтому оффсет
            } else {
                $0.height.equalTo(100)
            }
        }
        
        overlayViewController.view.snp.remakeConstraints {
            $0.left.right.bottom.equalTo(safeArea)
            if overlayViewControllerState == .opened {
                $0.top.equalTo(videoPlayer.view.snp.bottom).offset(45) // залезает на текст, поэтому оффсет
            } else {
                $0.height.equalTo(100)
            }
        }
        
        informationView.snp.remakeConstraints {
            $0.left.right.equalTo(safeArea)
            $0.top.equalTo(videoPlayer.view.snp.bottom)
            $0.height.equalTo(60)
        }
        
        tableView.snp.remakeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(informationView.snp.bottom)
        }
    }
    
}

extension StreamListViewController: StreamListDisplayManagerDelegate {
    func tableView(didSelect video: VideoData) {
        streamListViewModel.didSelect(video: video)
    }
}

extension StreamListViewController: SLROverlayDelegate {
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
    
//    ОverlayView отображается над tableView.
//    Чтобы небыло проблем с userIntaraction меняю размеры overlayView в момент открытия/закрытия
    func overlayOpened() {
        overlayViewControllerState = .opened
        if currentOrientation == .vertical {
            let safeArea = view.safeAreaLayoutGuide

            overlayView.snp.remakeConstraints {
                $0.left.bottom.right.equalTo(safeArea)
                $0.top.equalTo(videoPlayer.view.snp.bottom).offset(45) // залезает на текст, поэтому оффсет
            }
            
            overlayViewController.view.snp.remakeConstraints {
                $0.left.right.bottom.equalTo(safeArea)
                $0.top.equalTo(videoPlayer.view.snp.bottom).offset(45) // залезает на текст, поэтому оффсет
            }
        }
    }
    
    func overlayClosed() {
        overlayViewControllerState = .closed
        if currentOrientation == .vertical {
            let safeArea = view.safeAreaLayoutGuide

            overlayView.snp.remakeConstraints {
                $0.left.bottom.right.equalTo(safeArea)
                $0.height.equalTo(100)
            }
            
            overlayViewController.view.snp.remakeConstraints {
                $0.left.right.bottom.equalTo(safeArea)
                $0.height.equalTo(100)
            }
        }
    }
    
    
}
