//
//  TelemetryConfig.swift
//  Meshtastic Apple
//
//  Copyright (c) Garth Vander Houwen 6/13/22.
//
import SwiftUI

enum SensorTypes: Int, CaseIterable, Identifiable {

	/// No external telemetry sensor explicitly set
	case notSet = 0

	/// Moderate accuracy temperature
	case dht11 = 1

	/// High accuracy temperature
	case ds18B20 = 2

	/// Moderate accuracy temperature and humidity
	case dht12 = 3

	/// Moderate accuracy temperature and humidity
	case dht21 = 4

	/// Moderate accuracy temperature and humidity
	case dht22 = 5

	/// High accuracy temperature, pressure, humidity
	case bme280 = 6

	/// High accuracy temperature, pressure, humidity, and air resistance
	case bme680 = 7

	/// Very high accuracy temperature
	case mcp9808 = 8

	/// Moderate accuracy temperature and humidity
	case shtc3 = 9

	/// Moderate accuracy current and voltage
	case ina260 = 10

	/// Moderate accuracy current and voltage
	case ina219 = 11

	var id: Int { self.rawValue }
	var description: String {
		get {
			switch self {
			
			case .notSet:
				return "Not Set"
			case .dht11:
				return "DHT11 - Temperature"
			case .ds18B20:
				return "DS18B20 - Temperature"
			case .dht12:
				return "DHT12 - Temperature & humidity"
			case .dht21:
				return "DHT21 - Temperature & humidity"
			case .dht22:
				return "DHT22 - Temperature & humidity"
			case .bme280:
				return "BME280 - Temp, pressure & humidity"
			case .bme680:
				return "BME680 - Temp, pressure, humidity & air resistance"
			case .mcp9808:
				return "MCP9808 - Temperature"
			case .shtc3:
				return "SHTC3 - Temperature & humidity"
			case .ina260:
				return "INA260 - Current & voltage"
			case .ina219:
				return "INA219 - Current & voltage"
			}
		}
	}
}

// Default of 0 is off
enum ErrorRecoveryIntervals: Int, CaseIterable, Identifiable {

	case off = 0
	case fifteenSeconds = 15
	case thirtySeconds = 30
	case oneMinute = 60
	case fiveMinutes = 300
	case tenMinutes = 600
	case fifteenMinutes = 900
	case thirtyMinutes = 1800
	case oneHour = 3600

	var id: Int { self.rawValue }
	var description: String {
		get {
			switch self {
			case .off:
				return "Unset"
			case .fifteenSeconds:
				return "Fifteen Seconds"
			case .thirtySeconds:
				return "Thirty Seconds"
			case .oneMinute:
				return "One Minute"
			case .fiveMinutes:
				return "Five Minutes"
			case .tenMinutes:
				return "Ten Minutes"
			case .fifteenMinutes:
				return "Fifteen Minutes"
			case .thirtyMinutes:
				return "Thirty Minutes"
			case .oneHour:
				return "One Hour"
			}
		}
	}
}

enum UpdateIntervals: Int, CaseIterable, Identifiable {

	case fifteenSeconds = 15
	case thirtySeconds = 30
	case oneMinute = 60
	case fiveMinutes = 300
	case tenMinutes = 600
	case fifteenMinutes = 0
	case thirtyMinutes = 1800
	case oneHour = 3600
	case twoHours = 7200
	case threeHours = 10800
	case fourHours = 14400
	case fiveHours = 18000
	case sixHours = 21600
	case twelveHours = 43200
	case eighteenHours = 64800
	case twentyFourHours = 86400

	var id: Int { self.rawValue }
	var description: String {
		get {
			switch self {
			case .fifteenSeconds:
				return "Fifteen Seconds"
			case .thirtySeconds:
				return "Thirty Seconds"
			case .oneMinute:
				return "One Minute"
			case .fiveMinutes:
				return "Five Minutes"
			case .tenMinutes:
				return "Ten Minutes"
			case .fifteenMinutes:
				return "Fifteen Minutes"
			case .thirtyMinutes:
				return "Thirty Minutes"
			case .oneHour:
				return "One Hour"
			case .twoHours:
				return "Two Hours"
			case .threeHours:
				return "Three Hours"
			case .fourHours:
				return "Four Hours"
			case .fiveHours:
				return "Five Hours"
			case .sixHours:
				return "Six Hours"
			case .twelveHours:
				return "Twelve Hours"
			case .eighteenHours:
				return "Eighteen Hours"
			case .twentyFourHours:
				return "Twenty Four Hours"
			}
		}
	}
}

struct TelemetryConfig: View {
	
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	
	@State var deviceUpdateInterval = 0
	@State var environmentUpdateInterval = 0
	
	@State var environmentMeasurementEnabled = false
	@State var environmentSensorType = 0
	@State var environmentScreenEnabled = false
	@State var environmentDisplayFahrenheit = false
	@State var environmentSensorPin = 0
	@State var environmentRecoveryInterval = 0
	@State var environmentReadErrorCountThreshold = 0
	
	var body: some View {
		
		VStack {

			Form {
				
				Section(header: Text("Update Intervals")) {
					
					Picker("Device Metrics", selection: $deviceUpdateInterval ) {
						ForEach(UpdateIntervals.allCases) { ui in
							Text(ui.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("How often device metrics are sent out over the mesh. Default is 15 minutes.")
						.font(.caption)
					
					Picker("Sensor Metrics", selection: $environmentUpdateInterval ) {
						ForEach(UpdateIntervals.allCases) { ui in
							Text(ui.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("How often sensor metrics are sent out over the mesh. Default is 15 minutes.")
						.font(.caption)
				}
				
				Section(header: Text("Sensor Options")) {
				
					Toggle(isOn: $environmentMeasurementEnabled) {

						Label("Enabled", systemImage: "chart.xyaxis.line")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))
					
					Picker("Sensor", selection: $environmentSensorType ) {
						ForEach(SensorTypes.allCases) { st in
							Text(st.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					
					Toggle(isOn: $environmentScreenEnabled) {

						Label("Show on device screen", systemImage: "display")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))

					Toggle(isOn: $environmentDisplayFahrenheit) {

						Label("Display Fahrenheit", systemImage: "thermometer")
					}
					.toggleStyle(SwitchToggleStyle(tint: .accentColor))

					Picker("GPIO Pin for sensor readings", selection: $environmentSensorPin) {
						ForEach(0..<40) {
							
							if $0 == 0 {
								
								Text("Unset")
								
							} else {
							
								Text("Pin \($0)")
							}
						}
					}
					.pickerStyle(DefaultPickerStyle())
				}
				
				Section(header: Text("Errors")) {
					
					Picker("Error Count Threshold", selection: $environmentReadErrorCountThreshold) {
						ForEach(0..<101) {
							
							if $0 == 0 {
								
								Text("Unset")
								
							} else if $0 % 5 == 0 {
								
								Text("\($0)")
							}
						}
					}
					.pickerStyle(DefaultPickerStyle())
					Text("Sometimes sensor reads can fail. If this happens, we will retry a configurable number of attempts, each attempt will be delayed by the minimum required refresh rate for that sensor")
						.font(.caption)
					
					Picker("Error Recovery Interval", selection: $environmentRecoveryInterval ) {
						ForEach(ErrorRecoveryIntervals.allCases) { eri in
							Text(eri.description)
						}
					}
					.pickerStyle(DefaultPickerStyle())
					
					Text("Sometimes we can end up with more failures than our error count threshold. In this case, we will stop trying to read from the sensor for a while. Wait this long until trying to read from the sensor again")
						.font(.caption)
				}
			}
			.navigationTitle("Telemetry Config")
			.navigationBarItems(trailing:

				ZStack {

				ConnectedDevice(bluetoothOn: bleManager.isSwitchedOn, deviceConnected: bleManager.connectedPeripheral != nil, name: (bleManager.connectedPeripheral != nil) ? bleManager.connectedPeripheral.shortName : "?????")
			})
			.onAppear {

				self.bleManager.context = context
			}
			.navigationViewStyle(StackNavigationViewStyle())
		}
	}
}
