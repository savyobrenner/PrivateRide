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
        viewModel.currentAddress = "123 Main Street"
        viewModel.dropOffAddress = "456 Elm Street"
        
        // When
        viewModel.swapAddresses()
        
        // Then
        XCTAssertEqual(viewModel.currentAddress, "456 Elm Street")
        XCTAssertEqual(viewModel.dropOffAddress, "123 Main Street")
    }
    
    func testSearchRideSuccess() async {
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
        
        // When
        viewModel.searchRide()
        
        // Then
        XCTAssertNotNil(viewModel.routesObject)
        XCTAssertFalse(viewModel.isAddressEditable)
        XCTAssertTrue(viewModel.isBottomSheetVisible)
        XCTAssertEqual(mockServices.lastEstimateRideRequest?.id, "123")
        XCTAssertEqual(mockServices.lastEstimateRideRequest?.origin, "Origin Address")
        XCTAssertEqual(mockServices.lastEstimateRideRequest?.destination, "Destination Address")
    }
    
    func testSearchRideFailure() async {
        // Given
        viewModel.userId = "123"
        viewModel.currentAddress = "Origin Address"
        viewModel.dropOffAddress = "Destination Address"
        
        mockServices.shouldFail = true
        
        // When
        viewModel.searchRide()
        
        // Then
        XCTAssertNil(viewModel.routesObject)
        XCTAssertTrue(viewModel.isAddressEditable)
        XCTAssertFalse(viewModel.isBottomSheetVisible)
    }
    
    func testCancelTrip() {
        // Given
        viewModel.isBottomSheetVisible = true
        viewModel.isAddressEditable = false
        
        // When
        viewModel.cancelTrip()
        
        // Then
        XCTAssertFalse(viewModel.isBottomSheetVisible)
        XCTAssertTrue(viewModel.isAddressEditable)
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
    
    func testLoadingStateDuringSearchRide() async {
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
        
        // When
        XCTAssertFalse(viewModel.isLoading)
        viewModel.searchRide()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.routesObject)
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
        
        // When
        viewModel.cancelTrip()
        
        // Then
        XCTAssertFalse(viewModel.isBottomSheetVisible)
        XCTAssertTrue(viewModel.isAddressEditable)
        XCTAssertNil(viewModel.routesObject)
    }
}
