import SwiftUI

extension CGSize {
    func aspectFit(_ to: CGSize) -> CGSize {
        let scaleX = to.width / self.width
        let sacleY = to.height / self.height
        
        let aspectRatio = min(scaleX, sacleY)
        return .init(width: aspectRatio * width, height: aspectRatio * height)
    }
}
