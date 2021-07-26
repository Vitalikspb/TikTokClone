//
//  CameraViewController.swift
//  TikTok
//
//  Created by VITALIY SVIRIDOV on 22.07.2021.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    // Capture Session
    var captureSession = AVCaptureSession()
    
    // Capture Device
    var captureDevice: AVCaptureDevice?
    
    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var previewLayer: AVPlayerLayer?
    var recordedVideoURL: URL?
    private let cameraView: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cameraView)
        view.backgroundColor = .systemBackground
        
        setUpCamera()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton))
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(x: (view.width - size) / 2,
                                    y: view.height - view.safeAreaInsets.bottom - size - 5,
                                    width: size,
                                    height: size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Selectors
    
    @objc private func didTapCloseButton() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
    
    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            recordButton.toggle(for: .notRecording)
            captureOutput.stopRecording()
        } else {
            guard var url = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).first else { return }
            url.appendPathComponent("video.mov")
            
            recordButton.toggle(for: .recording)
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url,
                                         recordingDelegate: self)
        }
    }
    
    @objc func didTapNext() {
        // Push caption controller
        
    }
    
    // MARK: - Helper Functions
    
    
    
    func setUpCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
            }
        }
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        // Update session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        // Configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        // Enable caemra start
        captureSession.startRunning()
    }
 
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        guard error == nil else {
            let alert = UIAlertController(title: "Woops", message: "Something went wrong when recording your video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        recordedVideoURL = outputFileURL
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next", style: .done, target: self, action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        
        guard let previewLayer = previewLayer else { return }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        
        previewLayer.player?.play()
    }
}
