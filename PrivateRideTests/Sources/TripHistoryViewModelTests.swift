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
    
    func testSearchTripsSuccess() {
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
        
        let expectation = expectation(description: "Search trips succeeds")
        
        // When
        viewModel.searchTrips()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertFalse(self.viewModel.trips.isEmpty)
            XCTAssertEqual(self.viewModel.trips.first?.origin, "A")
            XCTAssertEqual(self.viewModel.trips.first?.destination, "B")
            XCTAssertEqual(self.viewModel.trips.first?.value, "R$ 100,00")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchTripsFailure() {
        // Given
        viewModel.userId = "123"
        viewModel.selectedDriverID = 1
        
        mockServices.shouldFail = true
        
        let expectation = expectation(description: "Search trips fails")
        
        // When
        viewModel.searchTrips()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertTrue(self.viewModel.trips.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDriverFilterUpdatesTrips() {
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
        
        let expectation = expectation(description: "Filter trips by driver")
        
        // When
        viewModel.searchTrips()
        viewModel.selectedDriverID = 1
        viewModel.searchTrips()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertEqual(self.viewModel.trips.count, 1)
            XCTAssertEqual(self.viewModel.trips.first?.origin, "A")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
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
    
    func testLoadingStateDuringSearchTrips() {
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
        
        let expectation = expectation(description: "Loading state updates correctly")
        
        // When
        XCTAssertFalse(viewModel.isLoading)
        viewModel.searchTrips()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.trips.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
