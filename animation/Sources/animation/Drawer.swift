final class Drawer {
    private let drawPointer = UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!
    let vcount = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000006)!
    
    init() {
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000000)!
        let displayMode3: UInt16 = 0x3
        let enableBackground2: UInt16 = 0x400
        displayControl.pointee = displayMode3 | enableBackground2
    }
    
    func waitForVsync() {
        while vcount.pointee >= 160 {}
        while vcount.pointee < 160 {}
    }

    func draw(drawStartPosition: Int, px: Int) {
        let targetPointer = drawPointer.advanced(by: drawStartPosition)
        let red = rgb555(red: 31, green: 0, blue: 0)
        targetPointer.update(repeating: red, count: px)
    }
    
    func clear() {
        let targetPointer = drawPointer.advanced(by: 0)
        let black = rgb555(red: 0, green: 0, blue: 0)
        targetPointer.update(repeating: black, count: 240*160)
    }
        
    func rgb555(red: UInt8, green: UInt8, blue: UInt8) -> UInt16 {
        let red = min(red, 31)
        let green = min(green, 31)
        let blue = min(blue, 31)
        let rgb555Value = UInt16(red) | (UInt16(green) << 5) | (UInt16(blue) << 10)
        return rgb555Value
    }
}
