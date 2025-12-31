//
//  MapView.swift
//  Snowline
//
//  Created by Tufan Cakir on 31.12.25.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {

    @State private var center = CLLocationCoordinate2D(
        latitude: 52.5200,
        longitude: 13.4050
    )

    @State private var camera: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: 52.5200,
                longitude: 13.4050
            ),
            distance: 900,
            heading: 0,
            pitch: 0
        )
    )

    @State private var is3D = false
    @State private var style: MapStyle = .hybrid
    @State private var locationManager = CLLocationManager()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            Map(position: $camera) {
                UserAnnotation()
            }
            .mapStyle(style)
            .mapControls {
                MapCompass()
                MapScaleView()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .ignoresSafeArea()
            controlPanel
        }
        .onAppear { locationManager.requestWhenInUseAuthorization() }
    }

    // MARK: - Control Panel

    private var controlPanel: some View {
        VStack(spacing: 14) {

            MapButton(icon: "location.fill") { centerOnUser() }

            Divider()

            MapButton(icon: is3D ? "cube.transparent.fill" : "cube") {
                toggle3D()
            }

            MapButton(icon: "globe.europe.africa.fill") { style = .standard }
            MapButton(icon: "map.fill") { style = .hybrid }
            MapButton(icon: "antenna.radiowaves.left.and.right") {
                style = .imagery
            }
        }
        .padding()
        .fixedSize()
    }

    // MARK: - Camera Logic

    private func rebuildCamera(animated: Bool = true) {
        let cam = MapCamera(
            centerCoordinate: center,
            distance: is3D ? 650 : 1000,
            heading: 0,
            pitch: is3D ? 70 : 0
        )

        animated
            ? withAnimation(.spring()) { camera = .camera(cam) }
            : (camera = .camera(cam))
    }

    private func toggle3D() {
        is3D.toggle()
        rebuildCamera()
    }

    private func centerOnUser() {
        if let loc = locationManager.location {
            center = loc.coordinate
            rebuildCamera()
        }
    }
}

#Preview {
    MapView()
        .environmentObject(ThemeManager())
}
