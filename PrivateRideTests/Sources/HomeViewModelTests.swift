//
//  HomeViewModelTests.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 12/12/24.
//

import Factory
import XCTest
@testable import PrivateRide

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockServices: MockHomeServices!
    var mockCoordinator: MockHomeCoordinator!
    
    override func setUp() {
        super.setUp()
        mockServices = MockHomeServices()
        mockCoordinator = MockHomeCoordinator(navigationController: .init())
        viewModel = HomeViewModel(
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
    
    func testSwapAddresses() {
        // Given
        viewModel.currentAddress = "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031"
        viewModel.dropOffAddress = "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"
        
        let expectation = expectation(description: "Addresses swapped")
        
        // When
        viewModel.swapAddresses()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertEqual(self.viewModel.currentAddress, "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200")
            XCTAssertEqual(self.viewModel.dropOffAddress, "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchRideSuccess() {
        // Given
        viewModel.userId = "123"
        viewModel.currentAddress = "Origin Address"
        viewModel.dropOffAddress = "Destination Address"
        
        mockServices.mockEstimateRideResponse = RouteResponse(
            origin: .init(latitude: 10.0, longitude: 20.0),
            destination: .init(latitude: 30.0, longitude: 40.0),
            distance: 10000,
            duration: 1200,
            options: [],
            routeResponse: nil
        )
        
        let expectation = expectation(description: "Search ride succeeds")
        
        // When
        viewModel.searchRide()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertNotNil(self.viewModel.routesObject)
            XCTAssertFalse(self.viewModel.isAddressEditable)
            XCTAssertTrue(self.viewModel.isBottomSheetVisible)
            XCTAssertEqual(self.mockServices.lastEstimateRideRequest?.id, "123")
            XCTAssertEqual(self.mockServices.lastEstimateRideRequest?.origin, "Origin Address")
            XCTAssertEqual(self.mockServices.lastEstimateRideRequest?.destination, "Destination Address")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSearchRideFailure() {
        // Given
        viewModel.userId = "123"
        viewModel.currentAddress = "Origin Address"
        viewModel.dropOffAddress = "Destination Address"
        
        mockServices.shouldFail = true
        
        let expectation = expectation(description: "Search ride fails")
        
        // When
        viewModel.searchRide()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertNil(self.viewModel.routesObject)
            XCTAssertTrue(self.viewModel.isAddressEditable)
            XCTAssertFalse(self.viewModel.isBottomSheetVisible)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testCancelTrip() {
        // Given
        viewModel.isBottomSheetVisible = true
        viewModel.isAddressEditable = false
        
        let expectation = expectation(description: "Trip cancelled")
        
        // When
        viewModel.cancelTrip()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertFalse(self.viewModel.isBottomSheetVisible)
            XCTAssertTrue(self.viewModel.isAddressEditable)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
    }
    
    func testNavigateToTripsHistory() {
        // When
        viewModel.navigateToTripsHistory()
        
        // Then
        XCTAssertTrue(mockCoordinator.didNavigateToTripsHistory)
    }
    
    func testFormValidationFailure() {
        // Given
        viewModel.userId = ""
        viewModel.currentAddress = ""
        viewModel.dropOffAddress = ""
        
        // When
        viewModel.validateForm()
        
        // Then
        XCTAssertFalse(viewModel.isButtonEnabled)
    }
    
    func testFormValidationSuccess() {
        // Given
        viewModel.userId = "123"
        viewModel.currentAddress = "Origin Address"
        viewModel.dropOffAddress = "Destination Address"
        
        // When
        viewModel.validateForm()
        
        // Then
        XCTAssertTrue(viewModel.isButtonEnabled)
    }
    
    func testLoadingStateDuringSearchRide() {
        // Given
        viewModel.userId = "123"
        viewModel.currentAddress = "Origin Address"
        viewModel.dropOffAddress = "Destination Address"
        mockServices.mockEstimateRideResponse = RouteResponse(
            origin: .init(latitude: 10.0, longitude: 20.0),
            destination: .init(latitude: 30.0, longitude: 40.0),
            distance: 10000,
            duration: 1200,
            options: [],
            routeResponse: nil
        )
        
        let expectation = expectation(description: "Loading state updated")
        
        // When
        viewModel.searchRide()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.routesObject)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testCancelTripResetsState() {
        // Given
        viewModel.isBottomSheetVisible = true
        viewModel.isAddressEditable = false
        viewModel.routesObject = RouteResponse(
            origin: .init(latitude: 10.0, longitude: 20.0),
            destination: .init(latitude: 30.0, longitude: 40.0),
            distance: 10000,
            duration: 1200,
            options: [],
            routeResponse: nil
        )
        
        let expectation = expectation(description: "State reset after trip cancel")
        
        // When
        viewModel.cancelTrip()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            // Then
            XCTAssertFalse(self.viewModel.isBottomSheetVisible)
            XCTAssertTrue(self.viewModel.isAddressEditable)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
