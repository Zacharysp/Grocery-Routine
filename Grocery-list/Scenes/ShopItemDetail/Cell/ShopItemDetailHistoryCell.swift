//
//  ShopItemDetailHistoryCell.swift
//  Grocery-list
//
//  Created by Dongjie Zhang on 7/5/22.
//

import UIKit
import Stevia
import Charts

final class ShopItemDetailHistoryCell: UICollectionViewCell {
    
    static let id = "ShopItemDetailHistoryCellId"
    
    lazy var historyButton = UIButton()
    lazy var lineChartView = LineChartView()
    
    private lazy var titleLabel = UILabel()
    private lazy var container = UIView()
    private lazy var viewAllLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addViews()
        setUpViews()
    }
    
    func set(itemDetail: ShopItemDetailHistory, themeColor: UIColor?) {
        titleLabel.text = itemDetail.type.title()
        setUpChart(data: itemDetail.prices, color: themeColor)
        
        historyButton.tintColor = themeColor
    }
    
    private func addViews() {
        contentView.subviews(
            titleLabel,
            container.subviews(
                lineChartView,
                viewAllLabel,
                historyButton
            )
        )
        
        titleLabel
            .top(2)
            .fillHorizontally(padding: 2)
            .height(20)
        
        container
            .fillHorizontally(padding: 2)
            .bottom(2)
        container.Top == titleLabel.Bottom + 2
        
        lineChartView
            .top(.gap)
            .fillHorizontally(padding: .gap)
            .height(120)
        
        viewAllLabel
            .left(.gap)
            .bottom(.gap)
        viewAllLabel.Top == lineChartView.Bottom + .gap
        
        historyButton
            .right(.gap)
            .size(20)
        historyButton.CenterY == viewAllLabel.CenterY
        historyButton.Left == viewAllLabel.Right + .gap
    }
    
    private func setUpViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryText
        
        container.backgroundColor = .gray.withAlphaComponent(0.2)
        container.layer.cornerRadius = .cornerRadius
        container.layer.masksToBounds = true
        
        viewAllLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        viewAllLabel.textColor = .secondaryText
        viewAllLabel.textAlignment = .right
        viewAllLabel.text = LocalizedString.ItemDetail.viewAll
        
        historyButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        
        lineChartView.backgroundColor = .clear
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.isUserInteractionEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.noDataText = LocalizedString.ItemDetail.noData
    }
    
    private func setUpChart(data: [Float], color: UIColor?) {
        guard data.count > 1 else { return }
        let dataEntries: [ChartDataEntry] = data.enumerated().map { (index, number) in
            return ChartDataEntry(x: Double(index), y: Double(number))
        }
        
        let dateSet = LineChartDataSet(entries: dataEntries)
        dateSet.drawCirclesEnabled = false
        dateSet.mode = .cubicBezier
        dateSet.lineWidth = 2
        dateSet.valueFormatter = ChartValueFormmater()
        
        if let color = color {
            dateSet.setColor(color)
            let gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
            let colorLocations:[CGFloat] = [1.0, 0.0]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: gradientColors,
                                      locations: colorLocations)
            dateSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0) // Set the Gradient
            dateSet.drawFilledEnabled = true // Draw the Gradient
        }
        
        lineChartView.data = LineChartData(dataSet: dateSet)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class ChartValueFormmater: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.2f", value)
    }
}
