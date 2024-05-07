//
//  PaginationModal.swift
//  SasboApp
//
//  Created by Abhishek Agarwal on 14/08/21.
//  Copyright © 2021 Deepak. All rights reserved.
//

import Foundation
import UIKit

struct PaginationModal {
    var totalPages: Int = 1
    var pageNumber: Int = 1
    var totalRecords: Int = 0
    var pageSize: CGFloat = 10.0
    var isLoadMore = true
}

extension PaginationModal {
    mutating func parsePaginationDetail(paginationDict: [String: Any]) {
        self.pageNumber = paginationDict[Constants.ServerKey.pageNumber] as? Int ?? 1
        self.totalPages = paginationDict[Constants.ServerKey.maxPages] as? Int ?? 1
        self.totalRecords = paginationDict[Constants.ServerKey.totalRecords] as? Int ?? 0
    }
}
