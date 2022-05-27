//
//  StockDetailsViewController.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 4/30/22.
//

import UIKit

class StockDetailsViewController: UIViewController {
    
//    MARK: - Properties
    
    private let symbol: String
    private let companyName: String
    private var candleSticks: [CandleStick]
    
//    MARK: - Init
    
    init(
        symbol: String,
        companyName: String,
        candleSticks: [CandleStick] = []
    ) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleSticks = candleSticks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        TODO: Show View
//        TODO: Financial Data
//        TODO: Show Chart
//        TODO: News
    }

}
