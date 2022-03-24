//
//  BookmarkViewController.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/19.
//


import UIKit
import SwiftSoup
import Alamofire
import RealmSwift

class BookmarkViewController: UIViewController, UIGestureRecognizerDelegate {
    // 얘네는 var가 나은가 let이 나은가? let이 나은거 같은데 사람들은 보통 var 쓰던데...
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchBar: UISearchBar = UISearchBar()
    var bookmarks: Results<Bookmark>?
    let bookmarkDB = BookmarkDB.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.bookmarks = self.bookmarkDB.requestData()
        print(self.bookmarks)
        self.setupUIElements()
        self.layout()
//        searchBar.becomeFirstResponder() --> 키보드가 올라오는데, 첫 화면이 북마크뷰컨트롤러일 경우 북마크를 눌러서 이동했을때, 서치바 터치가 안 먹는 오류가 발생.
    }
    
    func setupUIElements() {
        self.setupCollectionView()
        self.setupSearchBar()
    }
    
    func setupCollectionView() {
        self.collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
//        self.collectionView.register(BookmarkCell.self, forCellWithReuseIdentifier: BookmarkCell.identifier)
//        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        self.collectionView.register(BookmarkCell.self, forCellWithReuseIdentifier: "bookmarkCell")
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setupLongPressGesture(on: self.collectionView)
        self.view.addSubview(self.collectionView)
    }
    
    func setupSearchBar() {
        self.searchBar.placeholder = "Search or enter website name"
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.backgroundColor = UIColor(red: 209 / 255, green: 212 / 255, blue: 218 / 255, alpha: 1)
        self.searchBar.autocapitalizationType = .none
        self.searchBar.keyboardType = .webSearch
        self.searchBar.autocorrectionType = .no
        self.searchBar.searchTextField.backgroundColor = .white
        self.searchBar.searchTextField.font = .systemFont(ofSize: 12)
        self.selectAllTextInSearchBar()
        if let currentUrl = UserDefaults.standard.url(forKey: "currentUrl") {
            self.searchBar.searchTextField.text = currentUrl.absoluteString
        }
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
    }
    
    func selectAllTextInSearchBar() {
        self.searchBar.searchTextField.becomeFirstResponder()
        let textField: UISearchTextField = self.searchBar.searchTextField
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func layout() {
        self.layoutCollectionView()
        self.layoutSearchBar()
        self.view.layoutIfNeeded()
    }
    
    func layoutCollectionView() {
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func layoutSearchBar() {
        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func setupLongPressGesture(on view: UIView) {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        view.addGestureRecognizer(longPressGesture)
    }
    
    func setupAlertController(deleteAt: IndexPath) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: "Delete Bookmark?", message: nil, preferredStyle: .alert)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            guard let bookmark = self.bookmarks?[deleteAt.item] else { return }
            self.bookmarkDB.deleteData(data: bookmark)
            self.collectionView.deleteItems(at: [deleteAt])
            self.collectionView.reloadData()
            print("deleted bookmark")
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancelled")
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = deleteAction
        
        return alertController
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: self.collectionView)
            guard let indexPath = self.collectionView.indexPathForItem(at: point) else { return }
            let alertController = self.setupAlertController(deleteAt: indexPath)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BookmarkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCell {
            guard let bookmark = self.bookmarks?[indexPath.item] else { return UICollectionViewCell() }
            cell.title.text = bookmark.title
            if bookmark.iconUrlString != nil {
                do {
                    let url: URL? = URL(string: bookmark.iconUrlString)
                    let data: Data = try Data(contentsOf: url!)
                    cell.icon.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            } else {
                cell.icon.image = UIImage(systemName: "book.fill")
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookmarks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.title.text = "Bookmarks"
            return sectionHeader
        } else {
            return UICollectionReusableView() // no footer
        }
    }
}

extension BookmarkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 북마크 셀이 눌려지면, 그 주소로 이동해야함.
        guard let bookmark = self.bookmarks?[indexPath.item] else { return }
        let url = URL(string: bookmark.urlString)!
        UserDefaults.standard.set(url, forKey: "currentUrl")
        if self.presentingViewController != nil {
            let vc: ViewController = self.presentingViewController as! ViewController
            self.dismiss(animated: true) {
                vc.searchBar.setTitle(url.absoluteString, for: .normal)
                vc.url = url
                let req = URLRequest(url: url)
                vc.webView.load(req)
            }
        } else {
            let vc: ViewController = ViewController()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
        
        self.collectionView.reloadData()
    }
}

extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = min(0.2 * self.view.frame.width, 0.2 * self.view.frame.height)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
}

extension BookmarkViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let textField: UISearchTextField = searchBar.searchTextField
        searchBar.searchTextField.becomeFirstResponder()
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        guard let text = searchBar.text else { return }
        searchBar.resignFirstResponder()
        let urlString: String = Verification.urlFormat(urlString: text)
        let url: URL = URL(string: urlString)!
        UserDefaults.standard.set(url, forKey: "currentUrl")
        let req = URLRequest(url: url)
        
        if self.presentingViewController != nil {
            let vc: ViewController = self.presentingViewController as! ViewController
            self.dismiss(animated: true) {
                vc.url = url
                vc.webView.load(req)
            }
        } else {
            let vc: ViewController = ViewController()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
    }
}
