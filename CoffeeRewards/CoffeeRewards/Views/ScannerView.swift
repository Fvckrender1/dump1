import SwiftUI
import AVFoundation

struct ScannerView: View {
    @EnvironmentObject var rewardsManager: RewardsManager
    @StateObject private var scanner = QRCodeScanner()
    @State private var showingResult = false
    @State private var resultMessage = ""
    @State private var resultPoints = 0
    @State private var isSuccess = false

    var body: some View {
        NavigationView {
            ZStack {
                QRScannerViewRepresentable(scanner: scanner)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Scan QR Code")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Point your camera at the QR code\non your receipt")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)

                        if let error = scanner.error {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(8)
                        }
                    }
                    .padding(24)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(16)
                    .padding()

                    Spacer()
                }

                // Scanning frame overlay
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 250, height: 250)
                    .overlay(
                        VStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.green)
                                    .frame(width: 30, height: 5)
                                Spacer()
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.green)
                                    .frame(width: 30, height: 5)
                            }
                            Spacer()
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.green)
                                    .frame(width: 30, height: 5)
                                Spacer()
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.green)
                                    .frame(width: 30, height: 5)
                            }
                        }
                        .padding(8)
                    )
            }
            .navigationTitle("Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                scanner.startScanning()
            }
            .onDisappear {
                scanner.stopScanning()
            }
            .onChange(of: scanner.scannedCode) { newValue in
                if let code = newValue {
                    handleScannedCode(code)
                }
            }
            .alert("Scan Result", isPresented: $showingResult) {
                Button("OK") {
                    scanner.scannedCode = nil
                    scanner.startScanning()
                }
            } message: {
                Text(resultMessage)
            }
        }
    }

    private func handleScannedCode(_ code: String) {
        let result = rewardsManager.processQRCode(code)
        isSuccess = result.success
        resultPoints = result.points
        resultMessage = result.message
        showingResult = true
    }
}

struct QRScannerViewRepresentable: UIViewRepresentable {
    @ObservedObject var scanner: QRCodeScanner

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black

        scanner.setupScanner { previewLayer in
            guard let previewLayer = previewLayer else { return }
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = scanner.previewLayer {
            DispatchQueue.main.async {
                previewLayer.frame = uiView.bounds
            }
        }
    }
}
