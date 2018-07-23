//
//  PlayerViewController.swift
//  ASPVideoPlayer
//
//  Created by Andrei-Sergiu Pițiș on 09/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ASPVideoPlayer
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!

    let firstLocalVideoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")
    let secondLocalVideoURL = Bundle.main.url(forResource: "video2", withExtension: "mp4")

    let firstNetworkURL = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
    let secondNetworkURL = URL(string: "http://www.easy-fit.ae/wp-content/uploads/2014/09/WebsiteLoop.mp4")

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstAsset = AVURLAsset(url: firstLocalVideoURL!)
        let secondAsset = AVURLAsset(url: secondLocalVideoURL!)
        let thirdAsset = AVURLAsset(url: firstNetworkURL!)
        let fourthAsset = AVURLAsset(url: secondNetworkURL!)
        //        videoPlayer.videoURLs = [firstLocalVideoURL!, secondLocalVideoURL!, firstNetworkURL!, secondNetworkURL!]
        videoPlayer.videoAssets = [firstAsset, secondAsset, thirdAsset, fourthAsset]
//        videoPlayer.configuration = ASPVideoPlayer.Configuration(videoGravity: .aspectFit, shouldLoop: true, startPlayingWhenReady: true, controlsInitiallyHidden: true, allowBackgroundPlay: true)

        videoPlayer.resizeClosure = { [unowned self] isExpanded in
            self.isExpanded = isExpanded
            self.rotate()
        }
        
        videoPlayer.videoPlayerControls.playPauseButtonHidden = true
        videoPlayer.videoPlayerControls.resizeButtonHidden = true
        videoPlayer.videoPlayerControls.progressSliderHidden = true

        videoPlayer.delegate = self
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    var isExpanded: Bool = false
    var previousConstraints: [NSLayoutConstraint] = []

    func rotate() {
        let views: [String:Any] = ["videoPlayer": videoPlayer]

        if isExpanded == false {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.containerView.removeConstraints(self.videoPlayer.constraints)
                self.view.addSubview(self.videoPlayer)

                let padding = (self.view.bounds.height - self.view.bounds.width) / 2.0

                self.videoPlayer.transform = CGAffineTransform(rotationAngle: .pi / 2.0)

                var bottomPadding: CGFloat = 0

                if #available(iOS 11.0, *) {
                    if self.view.safeAreaInsets != .zero {
                        bottomPadding = self.view.safeAreaInsets.bottom
                    }
                }

                let metrics: [String:Any] = ["padding":padding, "negativePadding":-(padding - bottomPadding)]

                var constraints: [NSLayoutConstraint] = []
                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePadding)-[videoPlayer]-(negativePadding)-|", options: [], metrics: metrics, views: views))

                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[videoPlayer]-(padding)-|", options: [], metrics: metrics, views: views))

                self.view.addConstraints(constraints)
                self.view.layoutIfNeeded()

                self.previousConstraints = constraints
            }, completion: { finished in
                self.isExpanded = true
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.view.removeConstraints(self.previousConstraints)
                self.containerView.addSubview(self.videoPlayer)

                self.videoPlayer.transform = CGAffineTransform(rotationAngle: 0.0)

                var constraints: [NSLayoutConstraint] = []

                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoPlayer]|", options: [], metrics: nil, views: views))

                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoPlayer]|", options: [], metrics: nil, views: views))

                self.containerView.addConstraints(constraints)
                self.view.layoutIfNeeded()

                self.previousConstraints = constraints
            }, completion: { finished in
                self.isExpanded = false
            })
        }
    }
}

extension PlayerViewController: ASPVideoPlayerViewDelegate {
    func startedVideo() {
        print("Started video")
    }

    func stoppedVideo() {
        print("Stopped video")
    }

    func newVideo() {
        print("New Video")
    }

    func readyToPlayVideo() {
        print("Ready to play video")
    }

    func playingVideo(progress: Double) {
//        print("Playing: \(progress)")
    }

    func pausedVideo() {
        print("Paused Video")
    }

    func finishedVideo() {
        print("Finished Video")
    }

    func seekStarted() {
        print("Seek started")
    }

    func seekEnded() {
        print("Seek ended")
    }

    func error(error: Error) {
        print("Error: \(error)")
    }

    func willShowControls() {
        print("will show controls")
    }

    func didShowControls() {
        print("did show controls")
    }

    func willHideControls() {
        print("will hide controls")
    }

    func didHideControls() {
        print("did hide controls")
    }
}
