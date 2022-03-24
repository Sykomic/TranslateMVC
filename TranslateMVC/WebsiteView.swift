////
////  WebsiteView.swift
////  TranslateMVC
////
////  Created by 최대식 on 2022/03/21.
////
//
//import Foundation
//import UIKit
//
//class WebsiteView: UIView {
//
//    func setupUIElements() {
//        self.setupWebView()
//        self.setupActivityIndicatorView()
//        self.setupPanGesture()
//        self.setupToolbar()
//        self.setupGoBackButton()
//        self.setupGoForwardButton()
//        self.setupSearchBar()
//        self.setupAddBookmarkButton()
//        self.setupScreenshotButton()
//        self.setupTranslatedView()
//    }
//
//    func setupWebView() {
//        self.webView = WKWebView()
//        //
//        let req: URLRequest = URLRequest(url: self.url!)
//        self.webView.load(req)
//        // 얘네도 BookmarkVC에서 설정하고 오니깐 상관없지 않나?
//        self.webView.navigationDelegate = self
//        self.webView.uiDelegate = self
////        어차피 첫 화면이 BookmarkVC라 상관없음.
////        UserDefaults.standard.set(self.url, forKey: "currentUrl")
//        self.webView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(webView)
//    }
//
//    func setupActivityIndicatorView() {
//        self.indicator = UIActivityIndicatorView()
//        self.indicator.translatesAutoresizingMaskIntoConstraints = false
//        self.webView.addSubview(self.indicator)
//    }
//
//    func setupPanGesture() {
//        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
//        panGesture.delegate = self
//        self.webView.addGestureRecognizer(panGesture)
//    }
//
//    func setupToolbar() { //
//        self.stackView.backgroundColor = .systemGray6
//        self.stackView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.stackView)
//    }
//
//    func setupGoBackButton() { //
//        self.goBackButton.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
//        self.goBackButton.isEnabled = false
//        self.goBackButton.addTarget(self, action: #selector(self.touchUpGoBackButton(_:)), for: .touchUpInside)
//        self.goBackButton.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.addSubview(self.goBackButton) // 어차피 제약조건 다 설정했으니깐, self.view에 넣으면 안되나?
//    }
//
//    func setupGoForwardButton() { //
//        self.goForwardButton.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
//        self.goForwardButton.isEnabled = false
//        self.goForwardButton.addTarget(self, action: #selector(self.touchUpGoForwardButton(_:)), for: .touchUpInside)
//        self.goForwardButton.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.addSubview(self.goForwardButton)
//    }
//
//    func setupSearchBar() { //
//        self.searchBar = UIButton()
//        self.searchBar.setTitle(self.url?.absoluteString, for: .normal)
//        self.searchBar.setTitleColor(.black, for: .normal)
//        self.searchBar.backgroundColor = .white
//        self.searchBar.layer.cornerRadius = 10
//        self.searchBar.titleLabel?.font = .systemFont(ofSize: 12)
//        self.searchBar.addTarget(self, action: #selector(touchDownSearchBar(_:)), for: .touchDown)
//        self.searchBar.addTarget(self, action: #selector(touchUpSearchBar(_:)), for: .touchUpInside)
//        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.addSubview(self.searchBar)
//    }
//
//    func setupAddBookmarkButton() { //
//        self.addBookmarkButton = UIButton()
//        self.addBookmarkButton.setImage(UIImage(systemName: "book"), for: .normal)
//        self.addBookmarkButton.addTarget(self, action: #selector(self.touchUpAddBookmarkButton(_:)), for: .touchUpInside)
//        self.addBookmarkButton.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.addSubview(self.addBookmarkButton)
//    }
//
//    func setupScreenshotButton() { //
//        self.screenshotButton = UIButton()
//        // 스크린샷 찍었으면 버튼을 사라지게 만들어야함.
////        self.screenshotButton.tag = 47
//        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .default)
//        let image = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)
//        self.screenshotButton.setImage(image, for: .normal)
//        self.screenshotButton.addTarget(self, action: #selector(self.touchUpScreenshotButton(_:)), for: .touchUpInside)
//        self.screenshotButton.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.screenshotButton)
//    }
//
//    func setupTranslatedView() {
//        self.translatedView = UIImageView()
//        self.translatedView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.translatedView)
//    }
//
//    func layout() {
//        self.layoutWebView()
//        self.layoutActivityIndicatorView()
//        self.layoutToolbar()
//        self.layoutGoBackButton()
//        self.layoutGoForwardButton()
//        self.layoutSearchBar()
//        self.layoutAddBookmarkButton()
//        self.layoutScreenshotButton()
//        self.layoutTranslatedView()
//    }
//
//    func layoutWebView() { //
//        self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
//        self.swipeConstraint = NSLayoutConstraint(item: self.view.keyboardLayoutGuide, attribute: .top, relatedBy: .equal, toItem: self.webView, attribute: .bottom, multiplier: 1, constant: 55)
//        self.swipeConstraint?.isActive = true
//        // constant를 변수로 설정하여, 스크롤을 위로 할 때는 검색창이 보이게 하고, 아래로 할 때는 안 보이게 하자. --> constant가 아니라 아예 Constraint를 변수로 설정해서 변경해줘야함.
//        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        self.webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//    }
//
//    func layoutActivityIndicatorView() {
//        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//    }
//
//    func layoutToolbar() { //
//        self.stackView.topAnchor.constraint(equalTo: self.webView.bottomAnchor).isActive = true
//        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
//        self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//
//        let stackViewTopBorder: UIView = UIView()
//        stackViewTopBorder.backgroundColor = .lightGray
//        stackViewTopBorder.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.addSubview(stackViewTopBorder)
//        stackViewTopBorder.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
//        stackViewTopBorder.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 1).isActive = true
//        stackViewTopBorder.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
//        stackViewTopBorder.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor).isActive = true
//
//        let stackViewBottomBorder: UIView = UIView()
//        stackViewBottomBorder.backgroundColor = .lightGray
//        stackViewBottomBorder.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.addSubview(stackViewBottomBorder)
//        self.stackView.bottomAnchor.constraint(equalTo: stackViewBottomBorder.topAnchor, constant: 1).isActive = true
//        stackViewBottomBorder.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
//        stackViewBottomBorder.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
//        stackViewBottomBorder.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor).isActive = true
//    }
//
//    func layoutGoBackButton() { //
//        self.goBackButton.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
//        self.goBackButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
//        self.goBackButton.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
//        self.goBackButton.trailingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 30).isActive = true
//    }
//
//    func layoutGoForwardButton() { //
//        self.goForwardButton.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
//        self.goForwardButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
//        self.goForwardButton.leadingAnchor.constraint(equalTo: self.goBackButton.trailingAnchor).isActive = true
//        self.goForwardButton.trailingAnchor.constraint(equalTo: self.goBackButton.trailingAnchor, constant: 30).isActive = true
//    }
//
//    func layoutSearchBar() { //
//        self.searchBar.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 10).isActive = true
//        self.searchBar.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
//        self.searchBar.leadingAnchor.constraint(equalTo: self.goForwardButton.trailingAnchor).isActive = true
//        self.addBookmarkButton.leadingAnchor.constraint(equalTo: self.searchBar.trailingAnchor, constant: 10).isActive = true
//    }
//
//    func layoutAddBookmarkButton() { //
//        self.addBookmarkButton.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
//        self.addBookmarkButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
//        self.stackView.trailingAnchor.constraint(equalTo: self.addBookmarkButton.trailingAnchor, constant: 10).isActive = true
//        self.stackView.trailingAnchor.constraint(equalTo: self.addBookmarkButton.leadingAnchor, constant: 30).isActive = true
//    }
//
//    func layoutScreenshotButton() { //
//        self.webView.bottomAnchor.constraint(equalTo: self.screenshotButton.centerYAnchor, constant: 25).isActive = true
//        self.screenshotButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//    }
//
//    func layoutTranslatedView() {
//        self.translatedView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.translatedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        self.translatedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        self.translatedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//    }
//}




//func removeTranslatedView() {
//    for translatedView in self.translatedView.subviews where translatedView is UITextView {
//        translatedView.removeFromSuperview()
//    }
//}
