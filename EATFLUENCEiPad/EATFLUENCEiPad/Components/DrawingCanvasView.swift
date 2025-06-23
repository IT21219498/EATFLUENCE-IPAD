import SwiftUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.backgroundColor = UIColor.systemBackground  // Matches theme
        canvasView.layer.cornerRadius = 12
        canvasView.clipsToBounds = true
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
