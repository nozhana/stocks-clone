//
//  StockChartView.swift
//  stocks-clone
//
//  Created by Nozhan Amiri on 5/19/22.
//

import Charts
import UIKit

/// View that displays the stock price chart.
class StockChartView: UIView {
    
    /// ViewModel that's used to configure the chart view.
    ///
    /// Comprises:
    /// - `data: [Double]`
    /// - `showLegend: Bool`
    /// - `showAxis: Bool`
    /// - `fillColor: UIColor`
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
        let fillColor: UIColor
    }
    
    /// `LineChartView` instance that displays the chart.
    ///
    /// Axes and legend are disabled by default.
    ///
    /// Independent x/y scaling is enabled.
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
    
    /// Initializes the chart view and adds the instance as subview.
    /// - Parameter frame: A `CGRect`
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Lays out the subview (chartView instance) and maximizes its frame.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        chartView.frame = bounds
    }
    
//    MARK: - Public
    
    /// Nils out the chartView data.
    func reset() {
        chartView.data = nil
    }
    
    /// Configures the chartView with its ViewModel.
    /// - Parameter chartViewModel: ``ViewModel`` to configure the chart with.
    func configure(with chartViewModel: ViewModel) {
        // Creates chart data entries with candle close prices.
        var chartDataEntries: [ChartDataEntry] = []
        for (index, closePrice) in chartViewModel.data.enumerated() {
            chartDataEntries.append(.init(
                x: Double(index),
                y: closePrice
            ))
        }
        
        chartView.rightAxis.enabled = chartViewModel.showAxis
        chartView.legend.enabled = chartViewModel.showLegend
        
        // Create a dataset with data entries from close prices.
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
