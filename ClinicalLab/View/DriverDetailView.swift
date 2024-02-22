//
//  DriverDetailView.swift
//  ClinicalLab
//
//  Created by Vaibhav Rajani on 2/12/24.
//

import SwiftUI
import MapKit

struct DriverDetailView: View {
    @StateObject var viewModel = DriverDetailViewModel()
    let routeNo: Int
    @Environment(\.presentationMode) var presentationMode  // Access the presentation mode
    
    @State private var driverLocation = CLLocationCoordinate2D(latitude: 39.9526, longitude: -75.1652)
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.routeDetails, id: \.route.routeNo) { routeDetail in
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(routeDetail.customer, id: \.customerId) { customer in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(customer.customerName ?? "").bold()
                                Text("\(customer.streetAddress ?? ""), \(customer.city ?? ""), \(customer.state ?? "") \(customer.zip ?? "")")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(customer.specimensCollected ?? 0)")
                                Text(customer.pickUpTime ?? "")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(customer.collectionStatus ?? "")
                            }
                            .frame(width: 110)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(customer.customerId ?? 0)")
                            }
                            .frame(width: 80)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
                Divider()
            }
            
            Spacer()
            
            if let location = viewModel.driverLocation {
                MapView(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.log))
                    .frame(height: 400)
                    .cornerRadius(8)
            } else {
                Text("Loading Driver Location....")
                    .frame(height: 400)
                    .cornerRadius(8)
            }
        }
        .toolbarBackground(Color.customPink, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        // .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchRouteDetail(routeNo: routeNo)
        }
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 15)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotations = uiView.annotations
        uiView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
    }
}



