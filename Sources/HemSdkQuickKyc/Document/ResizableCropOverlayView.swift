//
//  File.swift
//  t5
//
//  Created by manas dutta on 22/12/25.
//

import UIKit

enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

class ResizableCropOverlayView: UIView {
    
    private let cornerSize: CGFloat = 20.0
    private var initialTouchPoint: CGPoint = CGPoint.zero
    private var initialFrame: CGRect = CGRect.zero
    private var resizingCorner: Corner?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear // Ensure the background is clear
        self.isUserInteractionEnabled = true // Allow user interactions
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Set up corner circles
        let corners = [CGPoint(x: 0, y: 0), CGPoint(x: rect.width - cornerSize, y: 0),
                       CGPoint(x: 0, y: rect.height - cornerSize), CGPoint(x: rect.width - cornerSize, y: rect.height - cornerSize)]
        
        for corner in corners {
            let path = UIBezierPath(ovalIn: CGRect(x: corner.x, y: corner.y, width: cornerSize, height: cornerSize))
            UIColor.blue.setFill()
            path.fill()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            initialTouchPoint = touch.location(in: self)
            initialFrame = self.frame
            
            // Determine if the touch is near a corner for resizing
            if let corner = identifyResizingCorner(touch: initialTouchPoint) {
                resizingCorner = corner
            } else {
                resizingCorner = nil // Not resizing, will move
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            if let corner = resizingCorner {
                resizeOverlay(corner: corner, currentPoint: currentPoint)
            } else {
                let dx = currentPoint.x - initialTouchPoint.x
                let dy = currentPoint.y - initialTouchPoint.y
                self.frame = initialFrame.offsetBy(dx: dx, dy: dy)
            }
        }
    }
    
    private func identifyResizingCorner(touch: CGPoint) -> Corner? {
        let increasedHitArea: CGFloat = 10.0 // Extra padding around the corners
        
        if CGRect(x: 0, y: 0, width: cornerSize + increasedHitArea, height: cornerSize + increasedHitArea).contains(touch) {
            return .topLeft
        } else if CGRect(x: self.frame.width - cornerSize - increasedHitArea, y: 0, width: cornerSize + increasedHitArea, height: cornerSize + increasedHitArea).contains(touch) {
            return .topRight
        } else if CGRect(x: 0, y: self.frame.height - cornerSize - increasedHitArea, width: cornerSize + increasedHitArea, height: cornerSize + increasedHitArea).contains(touch) {
            return .bottomLeft
        } else if CGRect(x: self.frame.width - cornerSize - increasedHitArea, y: self.frame.height - cornerSize - increasedHitArea, width: cornerSize + increasedHitArea, height: cornerSize + increasedHitArea).contains(touch) {
            return .bottomRight
        }
        return nil
    }
    
    private func resizeOverlay(corner: Corner, currentPoint: CGPoint) {
        var newFrame = initialFrame
        
        switch corner {
        case .topLeft:
            newFrame.origin.x = currentPoint.x
            newFrame.origin.y = currentPoint.y
            newFrame.size.width -= (initialFrame.origin.x - currentPoint.x)
            newFrame.size.height -= (initialFrame.origin.y - currentPoint.y)
            
        case .topRight:
            newFrame.origin.y = currentPoint.y
            newFrame.size.width = currentPoint.x - newFrame.origin.x
            newFrame.size.height -= (initialFrame.origin.y - currentPoint.y)
            
        case .bottomLeft:
            newFrame.origin.x = currentPoint.x
            newFrame.size.width -= (initialFrame.origin.x - currentPoint.x)
            newFrame.size.height = currentPoint.y - newFrame.origin.y
            
        case .bottomRight:
            newFrame.size.width = currentPoint.x - newFrame.origin.x
            newFrame.size.height = currentPoint.y - newFrame.origin.y
        }
        
        // Ensure the overlay does not go out of bounds
        newFrame = ensureFrameWithinBounds(newFrame: newFrame)
        self.frame = newFrame
        self.setNeedsDisplay() // Redraw to update corner positions
    }
    
    private func ensureFrameWithinBounds(newFrame: CGRect) -> CGRect {
        var frame = newFrame
        
        // Ensure x, y position is within bounds
        if frame.origin.x < 0 { frame.origin.x = 0 }
        if frame.origin.y < 0 { frame.origin.y = 0 }
        
        // Ensure width and height do not exceed superview bounds
        if let superview = self.superview {
            if frame.maxX > superview.bounds.width {
                frame.size.width = superview.bounds.width - frame.origin.x
            }
            if frame.maxY > superview.bounds.height {
                frame.size.height = superview.bounds.height - frame.origin.y
            }
        }
        // Ensure minimum size (to prevent the frame from disappearing)
        if frame.width < cornerSize * 2 {
            frame.size.width = cornerSize * 2
        }
        if frame.height < cornerSize * 2 {
            frame.size.height = cornerSize * 2
        }
        return frame
    }
}

