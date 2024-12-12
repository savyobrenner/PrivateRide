//
//  TripHistoryViewModelTests.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Factory
import XCTest
@testable import PrivateRide

final class TripHistoryViewModelTests: XCTestCase {
    var viewModel: TripHistoryViewModel!
    var mockServices: MockTripHistoryServices!
    var mockCoordinator: MockTripHistoryCoordinator!
    
    override func setUp() {
        super.setUp()
        mockServices = MockTripHistoryServices()
        mockCoordinator = MockTripHistoryCoordinator(navigationController: .init())
        viewModel = TripHistoryViewModel(
            coordinator: mockCoordinator,
            services: mockServices,
            analytics: Container.shared.analyticsCollector()
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockServices = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    func testSearchTripsSuccess() async {
        // Given
        viewModel.userId = "123"
        viewModel.selectedDriverID = 1
        
        mockServices.mockTripsResponse = TripHistoryResponse(
            customerId: "123",
            rides: [
                .init(
                    id: 1,
                    date: "2024-12-12T12:00:00",
                    origin: "A",
                    destination: "B",
                    distance: 10000,
                    duration: "20 min",
                    driver: .init(id: 1, name: "John Doe"),
                    value: 100.0
                )
            ]
        )
        
        // When
        viewModel.searchTrips()
        
        // Then
        XCTAssertFalse(viewModel.trips.isEmpty)
        XCTAssertEqual(viewModel.trips.first?.origin, "A")
        XCTAssertEqual(viewModel.trips.first?.destination, "B")
        XCTAssertEqual(viewModel.trips.first?.value, "R$ 100,00") // Formatação esperada
    }
    
    func testSearchTripsFailure() async {
        // Given
        viewModel.userId = "123"
        viewModel.selectedDriverID = 1
        
        mockServices.shouldFail = true
        
        // When
        viewModel.searchTrips()
        
        // Then
        XCTAssertTrue(viewModel.trips.isEmpty)
    }
    
    func testDriverFilterUpdatesTrips() async {
        // Given
        viewModel.userId = "123"
        viewModel.selectedDriverID = 1
        
        mockServices.mockTripsResponse = TripHistoryResponse(
            customerId: "123",
            rides: [
                .init(
                    id: 1,
                    date: "2024-12-12T12:00:00",
                    origin: "A",
                    destination: "B",
                    distance: 10000,
                    duration: "20 min",
                    driver: .init(id: 1, name: "John Doe"),
                    value: 100.0
                ),
                .init(
                    id: 2,
                    date: "2024-12-13T14:00:00",
                    origin: "X",
                    destination: "Y",
                    distance: 20000,
                    duration: "40 min",
                    driver: .init(id: 2, name: "Jane Doe"),
                    value: 200.0
                )
            ]
        )
        
        // When
        viewModel.searchTrips()
        viewModel.selectedDriverID = 1
        viewModel.searchTrips()
        
        // Then
        XCTAssertEqual(viewModel.trips.count, 1) // Apenas 1 viagem deve corresponder ao filtro
        XCTAssertEqual(viewModel.trips.first?.origin, "A")
    }
    
    func testValidateFormFailure() {
        // Given
        viewModel.userId = ""
        viewModel.selectedDriverID = nil
        
        // When
        viewModel.validateFields()
        
        // Then
        XCTAssertFalse(viewModel.isButtonEnabled)
    }
    
    func testValidateFormSuccess() {
        // Given
        viewModel.userId = "123"
        viewModel.selectedDriverID = 1
        
        // When
        viewModel.validateFields()
        
        // Then
        XCTAssertTrue(viewModel.isButtonEnabled)
    }
    
    func testLoadingStateDuringSearchTrips() async {
        // Given
        viewModel.userId = "123"
        viewModel.selectedDriverID = 1
        mockServices.mockTripsResponse = TripHistoryResponse(
            customerId: "123",
            rides: [
                .init(
                    id: 1,
                    date: "2024-12-12T12:00:00",
                    origin: "A",
                    destination: "B",
                    distance: 10000,
                    duration: "20 min",
                    driver: .init(id: 1, name: "John Doe"),
                    value: 100.0
                )
            ]
        )
        
        // When
        XCTAssertFalse(viewModel.isLoading)
        viewModel.searchTrips()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.trips.isEmpty)
    }
}
