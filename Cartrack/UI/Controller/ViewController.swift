//
//  ViewController.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
            // make your class the delegate of the pan gesture
            panGesture.delegate = self
            // add the gesture to the mapView
            mapView.addGestureRecognizer(panGesture)
        }
    }
    @IBOutlet weak var collectionBotton: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(PersonFoldingCell.nib, forCellWithReuseIdentifier: PersonFoldingCell.reuseIdentifier)
        }
    }
    var viewModel: BaseViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(self.logoutAction(sender:)))
        self.viewModel = BaseViewModel(self)
        self.viewModel.loadData()
    }
    @objc func logoutAction(sender: UIBarButtonItem ) {
        // handling code
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            hideCollectionView()
            // do something here
        }
    }
    fileprivate func hideCollectionView() {
        UIView.animate(withDuration: 1) {
            self.collectionBotton.constant = 300
            self.view.layoutIfNeeded()
        }
    }
    fileprivate func showCollectionView() {
        UIView.animate(withDuration: 1) {
            self.collectionBotton.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonFoldingCell.reuseIdentifier, for: indexPath) as!  PersonFoldingCell
        let data = self.viewModel.dataList[indexPath.row]
        cell.titleLabel.text = data.title
        cell.contentLabel.attributedText = data.content
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        print("Cell click")
    }
}
// MARK:- UICollectioViewDelegateFlowLayout methods
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mainViewSafeAreaWidth, height: PersonFoldingCell.height)
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

extension ViewController: ViewModelDelegate {
    func onSuccess() {
        self.collectionView.reloadData()
        for data in self.viewModel.dataList {
            mapView.addAnnotation(data.pin)
        }
        if let data = self.viewModel.dataList.first {
            let coordinate = data.pin.coordinate
            self.mapView.selectAnnotation(data.pin, animated: true)
            self.mapView.setCenter(coordinate, animated: true)
        }
    }
    func onFailure(error: Error?) {
        self.collectionView.reloadData()
    }
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for data in self.viewModel.dataList {
            if let coordinate = view.annotation?.coordinate, coordinate.latitude == data.pin.coordinate.latitude, coordinate.longitude == data.pin.coordinate.longitude {
                if let index = self.viewModel.dataList.lastIndex(of: data) {
                    collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: false)
                    break
                }
            }
        }
        self.showCollectionView()
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideCollectionView()
    }
}
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / self.mainViewSafeAreaWidth))
        
        if 0..<self.viewModel.dataList.count ~= index {
            let data = self.viewModel.dataList[index]
            let coordinate = data.pin.coordinate
            self.mapView.selectAnnotation(data.pin, animated: false)
            self.mapView.setCenter(coordinate, animated: true)
        }
        
    }
}
