//
//  NewsData.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 02.01.2021.
//

import Foundation

struct NewsData: Decodable {
    let status: String?
    let articles: [Articles]
}

struct Articles: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let url: String?
}


