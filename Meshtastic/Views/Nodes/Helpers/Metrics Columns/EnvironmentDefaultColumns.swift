//
//  EnvironmentDefaultColumns.swift
//  Meshtastic
//
//  Created by Jake Bordens on 12/10/24.
//

import Charts
import Foundation
import SwiftUI

// This is the default configuration used by the EnvironmentMetricsLog view for the table
extension MetricsColumnList {
	static var environmentDefaultColumns: MetricsColumnList {
		MetricsColumnList(columns: [
			// Temperature Series Configuration
			MetricsTableColumn(
				keyPath: \.temperature,
				name: "Temperature",
				abbreviatedName: "Temp",
				minWidth: 30, maxWidth: 45,
				tableBody: { _, temp in
					Text(temp.formattedTemperature())
				}),

			// Relative Humidity Series Configuration
			MetricsTableColumn(
				keyPath: \.relativeHumidity,
				name: "Relative Humidity",
				abbreviatedName: "Hum",
				minWidth: 30, maxWidth: 45,
				tableBody: { _, humidity in
					Text("\(String(format: "%.0f", humidity))%")
				}),

			// Barometric Pressure Series Configuration
			MetricsTableColumn(
				keyPath: \.barometricPressure,
				name: "Barometric Pressure",
				abbreviatedName: "Bar",
				minWidth: 30, maxWidth: 50,
				tableBody: { _, pressure in
					if (UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac) {
						Text("\(String(format: "%.1f hPa", pressure))")
					} else {
						Text("\(String(format: "%.1f", pressure))")
					}
				}),

			// Indoor Air Quality Series Configuration
			MetricsTableColumn(
				keyPath: \.iaq,
				name: "Indoor Air Quality",
				abbreviatedName: "IAQ",
				minWidth: 30, maxWidth: 50,
				tableBody: { _, iaq in
					IndoorAirQuality(iaq: Int(iaq), displayMode: .dot)
				}),

			// Wind Direction Series Configuration
			MetricsTableColumn(
				keyPath: \.windDirection,
				name: "Wind Direction",
				abbreviatedName: "Dir",
				minWidth: 30, maxWidth: 40,
				visible: false,
				tableBody: { _, wind in
					HStack(spacing: 1.0) {
						// debug data: let wind = Double.random(in: 0..<360.0)
						let wind = Double(wind)
						Image(systemName: "location.north")
							.imageScale(.small)
							.scaleEffect(0.9, anchor: .center)
							.rotationEffect(.degrees(wind))
							.foregroundStyle(.blue)
						if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.userInterfaceIdiom == .mac {
							Text(cardinalValue(from: wind))
						} else {
							Text(abbreviatedCardinalValue(from: wind))
						}
					}
				}),

			// Wind Speed Series Configuration
			MetricsTableColumn(
				keyPath: \.windSpeed,
				name: "Wind Speed",
				abbreviatedName: "Wind",
				minWidth: 30, maxWidth: 60,
				visible: false,
				tableBody: { _, speed in
					let windSpeed = Measurement(
						value: Double(speed), unit: UnitSpeed.kilometersPerHour)
					Text(
						windSpeed.formatted(
							.measurement(
								width: .abbreviated,
								numberFormatStyle: .number.precision(
									.fractionLength(0))))
					)
				}),

			// Timestamp Series Configuration -- for use in table only
			MetricsTableColumn(
				keyPath: \.time,
				name: "Timestamp",
				abbreviatedName: "Time",
				minWidth: 140.0, maxWidth: 2000.0,
				tableBody: { _, time in
					let localeDateFormat = DateFormatter.dateFormat(
						fromTemplate: "yyMMddjmma", options: 0,
						locale: Locale.current)
					let dateFormatString =
						(localeDateFormat ?? "MM/dd/YY j:mma")
						.replacingOccurrences(of: ",", with: "")
					Text(
						time?.formattedDate(format: dateFormatString)
							?? "unknown.age".localized
					)
				})
		])
	}
}
