//
//  MockProtocol.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
protocol MockProtocol {
    func fetchMockData(_ completion: @escaping (Bool) -> Void)
    func processData(_ jsonResult: AnyObject?, completion: @escaping (Bool) -> Void)
}
