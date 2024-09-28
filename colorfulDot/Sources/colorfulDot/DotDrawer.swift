final class DotDrawer {
    let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000000)!
    let drawPointer = UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!
    // Vカウントレジスタへのポインタ（垂直同期用）
    let vcount = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000006)!
    
    init() {
        let MODE_3: UInt16 = 0x3//0x0003
        let BG2_ENABLE: UInt16 = 0x400//0x0400
        displayControl.pointee = MODE_3 | BG2_ENABLE
    }
    
    // 垂直同期を待つ
    func waitForVsync() {
        while vcount.pointee >= 160 {}
        while vcount.pointee < 160 {}
    }
    
    func mode3PutPixel(x: Int, y: Int, color: UInt16) {
        drawPointer.advanced(by: y * 240 + x).pointee = color
    }
    
    func rgb555(red: Int, green: Int, blue: Int) -> UInt16 {
        let red = min(max(red, 0), 31)
        let green = min(max(green, 0), 31)
        let blue = min(max(blue, 0), 31)
        let rgb555Value = UInt16(red) | (UInt16(green) << 5) | (UInt16(blue) << 10)
        return rgb555Value
    }
}
