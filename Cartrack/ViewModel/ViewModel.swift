//
//  ViewModel.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import MapKit
protocol ViewModelDelegate: class {
    func onSuccess()
    func onFailure(error: Error?)
}
class BaseViewModel: NSObject {
    //MARK: Properties
    weak var delegate: ViewModelDelegate?
    var oldData: Data?
    var dataList = [PersonFoldingCellModel]()
    var personList = [Person]() {
        didSet {
            grenerateCellData()
        }
    }
    func grenerateCellData() {
        var list = [PersonFoldingCellModel]()
        for person in personList {
            let pin = MKPointAnnotation()
            pin.coordinate = person.address.geo.coordinate()
            let contentTo = PersonFoldingCellModel(title: person.username,
                                                   pin: pin,
                                                   texts: [PersonFoldingCellModel.getAttibute(subtext: "Name"),
                                                         PersonFoldingCellModel.getAttibute(text: person.name),
                                                         PersonFoldingCellModel.getAttibute(subtext: "Phone"),
                                                         PersonFoldingCellModel.getAttibute(text: person.phone),
                                                         PersonFoldingCellModel.getAttibute(subtext: "Email"),
                                                         PersonFoldingCellModel.getAttibute(text: person.email),
                                                         PersonFoldingCellModel.getAttibute(subtext: "Website"),
                                                         PersonFoldingCellModel.getAttibute(text: person.website),
                                                         PersonFoldingCellModel.getAttibute(subtext: "Address"),
                                                         PersonFoldingCellModel.getAttibute(text: person.address.getFullAddress()),
                                                         PersonFoldingCellModel.getAttibute(subtext: "Company"),
                                                         PersonFoldingCellModel.getAttibute(text: person.company.name)])
            list.append(contentTo)
        }
        self.dataList = list
    }
    
    init(_ delegate: ViewModelDelegate? = nil) {
        super.init()
        self.delegate = delegate
    }
    func loadData() {
        personList.removeAll()
        DispatchQueue.global(qos: .background).async {
            RequestManager.shared.downloadURL("https://jsonplaceholder.typicode.com/users", newDownload: true, completion: { [unowned self](data, error) in
                DispatchQueue.main.async { [unowned self] in
                    if let data = data {
                        if let jsonResult = try? JSONDecoder().decode(DataModel.self, from: data) {
                            self.personList = jsonResult
                            self.delegate?.onSuccess()
                        }
                    } else if let data = self.oldData {
                        if let jsonResult = try? JSONDecoder().decode(DataModel.self, from: data) {
                            self.personList = jsonResult
                            self.delegate?.onSuccess()
                        }
                    } else {
                        self.delegate?.onFailure(error: error)
                    }
                }
            }) {  [unowned self] (oldData) in
                self.oldData = oldData
            }
        }
    }
}
