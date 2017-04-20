//
//  BeaconNotificationsManager.swift
//  CoolestProjects
//
//  Created by Valentino Gattuso on 18/04/2017.
//  Copyright © 2017 coderdojo. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconNotificationsManager: NSObject {

    static let sharedInstance = BeaconNotificationsManager()

    private override init() {
        super.init()
        beaconManager.delegate = self
    }

    func requestAuthorization() {
        beaconManager.requestAlwaysAuthorization()
    }

    fileprivate func registerBeaconsForMonitoring() {
        coolestProjectsService.getRegions { (virtualRegions, error) in
            if let virtualRegions = virtualRegions {
                self.registerVirtualBeaconRegions(virtualRegions)
            } else if let error = error {
                print("Cannot fetch regions: \(error)")
            }
        }
    }

    fileprivate func registerVirtualBeaconRegions(_ virtualRegions: [CPARegion]) {
        let beaconRegions = Set(virtualRegions.flatMap { $0.allCLBeaconRegions() })
        let beaconRegionsToBeRemoved = currentlyMonitoredRegions.subtracting(beaconRegions)
        let beaconRegionsToBeAdded = beaconRegions.subtracting(currentlyMonitoredRegions)

        beaconRegionsToBeRemoved.forEach { (region) in
            print("Stop monitoring beacon \(region.identifier)")
            beaconManager.stopMonitoring(for: region)
        }

        beaconRegionsToBeAdded.forEach { (region) in
            print("Start monitoring beacon \(region.identifier)")
            beaconManager.startMonitoring(for: region)
        }
    }

    fileprivate var currentlyMonitoredRegions: Set<CLBeaconRegion> {
        get {
            return Set(beaconManager.monitoredRegions.flatMap { $0 as? CLBeaconRegion})
        }
    }

    fileprivate let beaconManager = ESTBeaconManager()
    fileprivate let coolestProjectsService = CPAFirebaseDefaultService()
}

extension BeaconNotificationsManager: ESTBeaconManagerDelegate {

    func beaconManager(_ manager: Any, didStartMonitoringFor region: CLBeaconRegion) {
        print("Did start monitoring for region \(region)")
    }

    func beaconManager(_ manager: Any, monitoringDidFailFor region: CLBeaconRegion?, withError error: Error) {
        print("Monitoring failed for region: \(region?.identifier ?? "(unknown)"). The error was: \(error).")
    }

    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("Did enter region \(region).")
    }

    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Did exit region \(region).")
    }

    func beaconManager(_ manager: Any, didChange status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            print("Location Services are disabled for this app.")
        } else if status == .authorizedAlways {
            registerBeaconsForMonitoring()
        }
    }

}

extension CPARegion {

    func allCLBeaconRegions() -> [CLBeaconRegion] {
        return beacons
            .map { $0.toCLBeaconRegion() }
            .flatMap { $0 }
    }
}

extension CPABeacon {

    func toCLBeaconRegion() -> CLBeaconRegion? {
        guard let proximityUUID = UUID(uuidString: uuid) else {
            return nil
        }

        return CLBeaconRegion(
            proximityUUID: proximityUUID,
            major: CLBeaconMajorValue(major.int16Value),
            minor: CLBeaconMajorValue(minor.int16Value),
            identifier: name)
    }
}

