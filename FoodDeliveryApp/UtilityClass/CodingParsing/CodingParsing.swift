//
//  CodingParsing.swift
//  SasboApp
//
//  Created by Abhishek Agarwal on 14/08/21.
//  Copyright © 2021 Deepak. All rights reserved.
//

import Foundation

func convertJSONToModal<T: Decodable>(_ object: Any) throws -> T {
     let data = try JSONSerialization.data(withJSONObject: object, options: [])
     return try JSONDecoder().decode(T.self, from: data)
}
