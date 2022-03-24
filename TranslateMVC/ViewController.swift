//
//  ViewController.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/19.
//

import UIKit
import Vision
import WebKit
import MLKitTranslate
import MLKit
import Alamofire
import SwiftSoup
import RealmSwift


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    var url: URL? = UserDefaults.standard.url(forKey: "currentUrl") ?? URL(string: "https://www.google.com")!
    var indicator: UIActivityIndicatorView!
    var webView: WKWebView!
    var translatedView: UIImageView!
    var sourceText: String = "none"
    var swipeConstraint: NSLayoutConstraint?
    let goBackButton: UIButton  = UIButton()
    let goForwardButton: UIButton = UIButton()
    var addBookmarkButton: UIButton!
    var screenshotButton: UIButton!
    var iconUrlString: String? = UserDefaults.standard.string(forKey: "iconUrlString") ?? "www.noicon.com"
    var searchBar: UIButton!
    let stackView: UIStackView = UIStackView()
    let bookmarkDB = BookmarkDB.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUIElements()
        self.layout()
    }
    
    func setupUIElements() {
        self.setupWebView()
        self.setupActivityIndicatorView()
        self.setupPanGesture()
        self.setupToolbar()
        self.setupGoBackButton()
        self.setupGoForwardButton()
        self.setupSearchBar()
        self.setupAddBookmarkButton()
        self.setupScreenshotButton()
        self.setupTranslatedView()
    }
    
    func setupWebView() {
        self.webView = WKWebView()
        //
        let req: URLRequest = URLRequest(url: self.url!)
        self.webView.load(req)
        // 얘네도 BookmarkVC에서 설정하고 오니깐 상관없지 않나?
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
//        어차피 첫 화면이 BookmarkVC라 상관없음.
//        UserDefaults.standard.set(self.url, forKey: "currentUrl")
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
    }
    
    func setupActivityIndicatorView() {
        self.indicator = UIActivityIndicatorView()
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.webView.addSubview(self.indicator)
    }
    
    func setupPanGesture() {
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(_:)))
        panGesture.delegate = self
        self.webView.addGestureRecognizer(panGesture)
    }
    
    func setupToolbar() { //
        self.stackView.backgroundColor = .systemGray6
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.stackView)
    }
    
    func setupGoBackButton() { //
        self.goBackButton.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        self.goBackButton.isEnabled = false
        self.goBackButton.addTarget(self, action: #selector(self.touchUpGoBackButton(_:)), for: .touchUpInside)
        self.goBackButton.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addSubview(self.goBackButton) // 어차피 제약조건 다 설정했으니깐, self.view에 넣으면 안되나?
    }
    
    func setupGoForwardButton() { //
        self.goForwardButton.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        self.goForwardButton.isEnabled = false
        self.goForwardButton.addTarget(self, action: #selector(self.touchUpGoForwardButton(_:)), for: .touchUpInside)
        self.goForwardButton.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addSubview(self.goForwardButton)
    }
    
    func setupSearchBar() { //
        self.searchBar = UIButton()
        self.searchBar.setTitle(self.url?.absoluteString, for: .normal)
        self.searchBar.setTitleColor(.black, for: .normal)
        self.searchBar.backgroundColor = .white
        self.searchBar.layer.cornerRadius = 10
        self.searchBar.titleLabel?.font = .systemFont(ofSize: 12)
        self.searchBar.addTarget(self, action: #selector(touchDownSearchBar(_:)), for: .touchDown)
        self.searchBar.addTarget(self, action: #selector(touchUpSearchBar(_:)), for: .touchUpInside)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addSubview(self.searchBar)
    }
    
    func setupAddBookmarkButton() { //
        self.addBookmarkButton = UIButton()
        self.addBookmarkButton.setImage(UIImage(systemName: "book"), for: .normal)
        self.addBookmarkButton.addTarget(self, action: #selector(self.touchUpAddBookmarkButton(_:)), for: .touchUpInside)
        self.addBookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addSubview(self.addBookmarkButton)
    }
    
    func setupScreenshotButton() { //
        self.screenshotButton = UIButton()
        // 스크린샷 찍었으면 버튼을 사라지게 만들어야함.
//        self.screenshotButton.tag = 47
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .default)
        let image = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)
        self.screenshotButton.setImage(image, for: .normal)
        self.screenshotButton.addTarget(self, action: #selector(self.touchUpScreenshotButton(_:)), for: .touchUpInside)
        self.screenshotButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.screenshotButton)
    }
    
    func setupTranslatedView() {
        self.translatedView = UIImageView()
        self.translatedView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.translatedView)
    }
    
    func layout() {
        self.layoutWebView()
        self.layoutActivityIndicatorView()
        self.layoutToolbar()
        self.layoutGoBackButton()
        self.layoutGoForwardButton()
        self.layoutSearchBar()
        self.layoutAddBookmarkButton()
        self.layoutScreenshotButton()
        self.layoutTranslatedView()
    }
    
    func layoutWebView() { //
        self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.swipeConstraint = NSLayoutConstraint(item: self.view.keyboardLayoutGuide, attribute: .top, relatedBy: .equal, toItem: self.webView, attribute: .bottom, multiplier: 1, constant: 55)
        self.swipeConstraint?.isActive = true
        // constant를 변수로 설정하여, 스크롤을 위로 할 때는 검색창이 보이게 하고, 아래로 할 때는 안 보이게 하자. --> constant가 아니라 아예 Constraint를 변수로 설정해서 변경해줘야함.
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func layoutActivityIndicatorView() {
        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func layoutToolbar() { //
        self.stackView.topAnchor.constraint(equalTo: self.webView.bottomAnchor).isActive = true
        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let stackViewTopBorder: UIView = UIView()
        stackViewTopBorder.backgroundColor = .lightGray
        stackViewTopBorder.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addSubview(stackViewTopBorder)
        stackViewTopBorder.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        stackViewTopBorder.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 1).isActive = true
        stackViewTopBorder.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
        stackViewTopBorder.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor).isActive = true
        
        let stackViewBottomBorder: UIView = UIView()
        stackViewBottomBorder.backgroundColor = .lightGray
        stackViewBottomBorder.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addSubview(stackViewBottomBorder)
        self.stackView.bottomAnchor.constraint(equalTo: stackViewBottomBorder.topAnchor, constant: 1).isActive = true
        stackViewBottomBorder.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
        stackViewBottomBorder.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
        stackViewBottomBorder.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor).isActive = true
    }
    
    func layoutGoBackButton() { //
        self.goBackButton.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        self.goBackButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
        self.goBackButton.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor).isActive = true
        self.goBackButton.trailingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 30).isActive = true
    }
    
    func layoutGoForwardButton() { //
        self.goForwardButton.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        self.goForwardButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
        self.goForwardButton.leadingAnchor.constraint(equalTo: self.goBackButton.trailingAnchor).isActive = true
        self.goForwardButton.trailingAnchor.constraint(equalTo: self.goBackButton.trailingAnchor, constant: 30).isActive = true
    }
    
    func layoutSearchBar() { //
        self.searchBar.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 10).isActive = true
        self.searchBar.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.goForwardButton.trailingAnchor).isActive = true
        self.addBookmarkButton.leadingAnchor.constraint(equalTo: self.searchBar.trailingAnchor, constant: 10).isActive = true
    }
    
    func layoutAddBookmarkButton() { //
        self.addBookmarkButton.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        self.addBookmarkButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.addBookmarkButton.trailingAnchor, constant: 10).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.addBookmarkButton.leadingAnchor, constant: 30).isActive = true
    }
    
    func layoutScreenshotButton() { //
        self.webView.bottomAnchor.constraint(equalTo: self.screenshotButton.centerYAnchor, constant: 25).isActive = true
        self.screenshotButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    func layoutTranslatedView() {
        self.translatedView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.translatedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.translatedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.translatedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("tapped")
        self.translatedView.isHidden = true
        self.screenshotButton.isHidden = false
        self.removeTranslatedView()
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func takeScreenshot() -> UIImage {
        let imageSize = UIScreen.main.bounds.size as CGSize
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {return UIImage()}
        if let window = self.view.window {
            // so we must first apply the layer's geometry to the graphics context
            context.saveGState()
            // Center the context around the window's anchor point
            context.translateBy(x: window.center.x, y: window.center.y)
            // Apply the window's transform about the anchor point
            context.concatenate(window.transform)
            // Offset by the portion of the bounds left of and above the anchor point
            context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            // Render the layer hierarchy to the current context
            window.layer.render(in: context)
            // Restore the context
            context.restoreGState()
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return UIImage()}
        UIGraphicsEndImageContext()
        return image
    }
    
    func getScreenshotImage() -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let filePath = paths.first?.appendingPathComponent("CurrentScreen.jpeg") {
            do {
                let imageData: Data = try Data(contentsOf: filePath)
                return UIImage(data: imageData)
            }
            catch {
                print("error")
            }
        }
        return nil
    }
    
    func textRecognizer(screenshotImage: UIImage) {
        // When using Korean script recognition SDK
        let koreanOptions = KoreanTextRecognizerOptions()
        let koreanTextRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)

        let image = VisionImage(image: screenshotImage)
        image.orientation = screenshotImage.imageOrientation
        
        koreanTextRecognizer.process(image) { [self] result, error in
            guard error == nil, let result = result else { return }
            // Recognized text
            for block in result.blocks {
                let blockText = block.text
                let splited = blockText.components(separatedBy: .newlines)
                let newText = splited.joined(separator: " ")
                
                let frame = CGRect(x: block.frame.origin.x / screenshotImage.size.width * self.view.frame.maxX, y: block.frame.origin.y / screenshotImage.size.height * self.view.frame.maxY, width: block.frame.width / screenshotImage.size.width * self.view.frame.width, height: block.frame.height / screenshotImage.size.width * self.view.frame.height)
                
                let label = UITextView(frame: frame)
                
                OperationQueue.main.addOperation {
                    self.sourceText = newText
                    self.getGoogleTranslatedText { text in
                        label.text = text
                    }
                }
                
                label.backgroundColor = .white
                label.isScrollEnabled = false
                self.translatedView.addSubview(label)
            }
        }
    }
    
    func getGoogleTranslatedText(success: @escaping (_ text: String) -> ()) {
        // Create an Korean-English translator:
        let options = TranslatorOptions(sourceLanguage: .korean, targetLanguage: .english)
        let koreanEnglishTranslator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        koreanEnglishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            // Model downloaded successfully. Okay to start translating.
            print("Model downloaded successfully")
        }
        koreanEnglishTranslator.translate(self.sourceText) { translatedText, error in
            guard error == nil, let translatedText = translatedText else { return }
            // Translation succeeded.
            print("translated Succeed")
            success(translatedText)
        }
    }
    
    func removeTranslatedView() {
        for translatedView in self.translatedView.subviews where translatedView is UITextView {
            translatedView.removeFromSuperview()
        }
    }
    
    @objc func touchUpGoBackButton(_ sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @objc func touchUpGoForwardButton(_ sender: UIBarButtonItem) {
        self.webView.goForward()
    }
    
    @objc func touchDownSearchBar(_ sender: UIButton) {
        sender.backgroundColor = .systemGray4
    }
    
    @objc func touchUpSearchBar(_ sender: UIButton) {
        sender.backgroundColor = .white
        print("touch up search bar")
        self.present(BookmarkViewController(), animated: true, completion: nil)
    }
    
    func setupAddBookmarkAlertController() -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: "Add Bookmark?", message: nil, preferredStyle: .alert)
        let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .default) { action in
            print("bookmark added")
            guard let textFields = alertController.textFields else { return }
            guard let textField = textFields.first else { return }
            if let text = textField.text {
//                let bookmark: Bookmark = Bookmark(title: text, urlString: self.url!.absoluteString, iconUrlString: self.iconUrlString!)
                let bookmark: Bookmark = Bookmark(title: text, urlString: self.url!.absoluteString, iconUrlString: UserDefaults.standard.string(forKey: "iconUrlString")!)
                self.bookmarkDB.updataData(data: bookmark)
            }
        }
        saveAction.isEnabled = false
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancelled")
        }ㅇ
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { textField in
            textField.placeholder = "Title"
            textField.addTarget(self, action: #selector(self.bookmarkTextFieldDidChange(_:)), for: .allEditingEvents)
        }
        alertController.preferredAction = saveAction
        
        return alertController
    }
    
    @objc func touchUpAddBookmarkButton(_ sender: UIBarButtonItem) {
        print("add bookmark")
        
        let alertController = self.setupAddBookmarkAlertController()
        self.present(alertController, animated: true)
    }
    
    @objc func bookmarkTextFieldDidChange(_ sender: UITextField) {
        let alertController: UIAlertController = self.presentedViewController as! UIAlertController
        guard let preferredAction = alertController.preferredAction else { return }
        if sender.text!.count > 0 {
            preferredAction.isEnabled = true
        } else {
            preferredAction.isEnabled = false
        }
    }
    
    @objc func touchUpScreenshotButton(_ sender: UIButton) {
        self.screenshotButton.isHidden = true
        let image = self.takeScreenshot()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let filePath = paths.first?.appendingPathComponent("CurrentScreen.jpeg") {
            do {
                try image.jpegData(compressionQuality: 1)?.write(to: filePath, options: .atomic)
            }
            catch {
                print("error")
            }
        }
        self.translatedView.isHidden = false
        self.translatedView.image = self.getScreenshotImage()
        self.textRecognizer(screenshotImage: self.translatedView.image!)
    }
    
    @objc func panAction(_ gestureRecognizer: UIPanGestureRecognizer) {
        let trans = gestureRecognizer.translation(in: self.view)
        if trans.y > 30 {
            print("up")
            // show searchBar
            self.swipeConstraint?.constant = 55
        } else if trans.y < -30 {
            print("down")
            // hide searchBar
            self.swipeConstraint?.constant = 0
            self.searchBar.resignFirstResponder()
        }
    }
}

extension ViewController: WKNavigationDelegate {
    // 로드 시작
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    //로드 종료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        self.searchBar.setTitle(self.webView.url?.absoluteString, for: .normal)
        
        let req = self.webView.url!
        DispatchQueue.global().async {
            AF.request(req).responseString { (response) in
                guard let html = response.value else { return }
                do {
                    let doc = try SwiftSoup.parse(html)
                    let elements: Elements = try doc.select("head").select("link")
                    var hasIcon: [Bool] = []
                    for elem in elements {
                        do {
                            let rel = try elem.getElementsByAttributeValueStarting("rel", "apple-touch-icon")
                            // naver가 갑자기 apple-touch-icon-precomposed라는 것만 남아서, apple-touch-icon이 없어 오류가 났음. -> 둘 다 커버 할 수 있게 apple-touch-icon으로 시작하는 애들을 추출.
                            
                            for r in rel {
                                let iconString = try r.attr("href")
                                UserDefaults.standard.set(iconString, forKey: "iconUrlString")
                                hasIcon.append(true)
                                break
                            }
                        }
                    }
                    if hasIcon.isEmpty {
                        print("no icon")
                        UserDefaults.standard.set(nil, forKey: "iconUrlString")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
        
    }
    // 로드 도중 오류?
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        print("error loading website")
    }
    //로드 시작 중 오류?
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        print("error loading website")
        let alertController: UIAlertController = UIAlertController(title: "Could not find the server", message: nil, preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.searchBar.setTitle(webView.url?.absoluteString, for: .normal)
        self.goBackButton.isEnabled = webView.canGoBack
        self.goBackButton.tintColor = webView.canGoBack ? .systemBlue : .gray
        self.goForwardButton.isEnabled = webView.canGoForward
        self.goForwardButton.tintColor = webView.canGoForward ? .systemBlue : .gray
    }
}

extension ViewController: WKUIDelegate {
    // this handles target=_blank links by opening them in the same view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }
}
