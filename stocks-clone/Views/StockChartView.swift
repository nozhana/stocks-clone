//
//  StockChartView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/19/22.
//

import Charts
import UIKit

class StockChartView: UIView {
    
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
        let fillColor: UIColor
    }
    
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        return chartView
    }()

//    MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chartView.frame = bounds
    }
    
//    MARK: - Public
    
    /// Reset the chart view
    func reset() {
        chartView.data = nil
    }
    
    func configure(with chartViewModel: ViewModel) {
        var chartDataEntries: [ChartDataEntry] = []
        for (index, closePrice) in chartViewModel.data.enumerated() {
            chartDataEntries.append(.init(
                x: Double(index),
                y: closePrice
            ))
        }
        
        chartView.rightAxis.enabled = chartViewModel.showAxis
        chartView.legend.enabled = chartViewModel.showLegend
        
        let dataSet = LineChartDataSet(entries: chartDataEntries, label: "30 Days")
        dataSet.fillColor = chartViewModel.fillColor
        dataSet.drawIconsEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }

}
