//
//  StockChartView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/19/22.
//

import UIKit

class StockChartView: UIView {
    
    struct ViewModel {
        let data: [CandleStick]
        let showLegend: Bool
        let showAxis: Bool
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Reset the chart view
    func reset() {
        
    }
    
    func configure(with viewModel: ViewModel) {
        
    }

}
