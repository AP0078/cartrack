//
//  CountryListViewController.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import SnapKit
protocol CountrySelectionDelegate: class {
    func selectedCountry(_ country: Country, viewController: UIViewController)
}
class CountryListViewController: UIViewController {
    var countryList = [Country]()
    var shownIndexPath = [IndexPath]()
    weak var delegate: CountrySelectionDelegate?
    @IBOutlet weak var navigationContainer: UIView! {
        didSet {
            navigationContainer.addSubview(navigationControl)
            navigationControl.snp.makeConstraints { (make) -> Void in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(44)
                make.bottom.equalTo(-5)
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(CountrySelectionCell.nib, forCellWithReuseIdentifier: CountrySelectionCell.reuseIdentifier)
        }
    }
    lazy var navigationControl: CustomNavBarControl = {
        let nav = CustomNavBarControl.viewFromNib()
        nav.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        return nav
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        self.navigationControl.navigationBarTitle.title = "Select country"
        self.navigationControl.navigationBarTitle.tintColor = .black
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationContainer.roundCorners([.topLeft, .topRight], radius: 10.0)
    }
    func setupBackButton() {
        self.navigationControl.navigationLeftButton.image = #imageLiteral(resourceName: "blue-close")
        self.navigationControl.navigationLeftButton.tintColor = UIColor.black
        self.navigationControl.navigationLeftButton.target = self
        self.navigationControl.navigationLeftButton.action = #selector(self.closeAction)
    }
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func preferWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 45) / 4
    }
    var mainViewSafeAreaWidth: CGFloat {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            if let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.left,
                topPadding > 0 {
                return self.view.frame.width - (topPadding * 2)
            }
        }
        return self.view.frame.width
    }
}
extension CountryListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.countryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountrySelectionCell.reuseIdentifier, for: indexPath) as!  CountrySelectionCell
        cell.seperatorView.isHidden = false
        if indexPath.row == 0 {
            cell.seperatorView.isHidden = true
        }
        let country = countryList[indexPath.row]
        cell.titleLabel.text = country.name
        cell.iconImage.image = UIImage(named: country.flag ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Animate cell while loading
        if self.shownIndexPath.contains(indexPath) == false {
            self.shownIndexPath.append(indexPath)
            cell.transform = CGAffineTransform(translationX: 0, y: 95.0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(1.0)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }
}
extension CountryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let country = self.countryList[indexPath.row]
        self.delegate?.selectedCountry(country, viewController: self)
        print("Cell click")
    }
}
// MARK:- UICollectioViewDelegateFlowLayout methods
extension CountryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mainViewSafeAreaWidth, height: CountrySelectionCell.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    @objc(collectionView:layout:minimumLineSpacingForSectionAtIndex:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}
