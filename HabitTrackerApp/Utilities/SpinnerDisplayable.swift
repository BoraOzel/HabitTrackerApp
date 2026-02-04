//
//  SpinnerDisplayable.swift
//  HabitTrackerApp
//
//  Created by Bora Özel on 4/2/26.
//

import UIKit
import Lottie

protocol SpinnerDisplayable: AnyObject {
    func showProgress()
    func removeProgress()
}

private let overlayViewTag = 999

extension SpinnerDisplayable where Self: UIViewController {
    func showProgress() {
        DispatchQueue.main.async {
            guard self.view.viewWithTag(overlayViewTag) == nil
            else {
                return
            }
            let overlayView = UIView(frame: self.view.bounds)
            overlayView.autoresizingMask = [.flexibleWidth,
                                            .flexibleHeight]
            overlayView.tag = overlayViewTag
            overlayView.backgroundColor = .clear
            self.view.addSubview(overlayView)
            NSLayoutConstraint.activate([overlayView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                         overlayView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                         overlayView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                         overlayView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(blurView)
            NSLayoutConstraint.activate([blurView.topAnchor.constraint(equalTo: overlayView.topAnchor),
                                         blurView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),
                                         blurView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
                                         blurView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor)])
            let animationView = LottieAnimationView(name: "Loading-Motion")
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.play()
            NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalToConstant: 114),
                                         animationView.heightAnchor.constraint(equalToConstant: 104)])
            let messageLabel = UILabel()
            messageLabel.text = "Loading..."
            messageLabel.textColor = .black
            messageLabel.font = UIFont.systemFont(ofSize: 18)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            let stackView = UIStackView(arrangedSubviews: [animationView,
                                                           messageLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(stackView)
            NSLayoutConstraint.activate([stackView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                                         stackView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor,
                                                                            constant: -40)])
            overlayView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                overlayView.alpha = 1
            }
            self.view.isUserInteractionEnabled = false
        }
    }
    func removeProgress() {
        DispatchQueue.main.async {
            if let overlayView = self.view.viewWithTag(overlayViewTag) {
                UIView.animate(withDuration: 0.25,
                               animations: {
                    overlayView.alpha = 0
                }) { _ in
                    overlayView.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
}

