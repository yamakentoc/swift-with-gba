final class Drawer {
    // VRAMの開始アドレス
    private let drawPointer = UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!
    
    init() {
        // Bitmapモードを指定する
        // IO Register領域の0x04000000はdisplay control register（DISPCNT）
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000000)!
        // Bimap Modeのモード3を指定
        let displayMode3: UInt16 = 0x3
        // 背景レイヤー(BG2)をしてい
        let enableBackground2: UInt16 = 0x400
        // pointeeで0x4000000に直接値（0x403）を書き込む
        displayControl.pointee = displayMode3 | enableBackground2
    }
    
    /// 描画する
    /// - Parameters:
    ///   - drawStartPosition: 描画開始位置
    ///   - px: 描画するpx数
    func draw(drawStartPosition: Int, px: Int) {
        // drawPointerをdrawStartPosition分だけ進めて、新たな描画開始位置を取得する
        let targetPointer = drawPointer.advanced(by: drawStartPosition)
        let red = rgb555(red: 31, green: 0, blue: 0)
        // 赤色を指定したpx分描画する
        targetPointer.update(repeating: red, count: px)
    }
        
    // RGBの各値（0-31の範囲）を入力としてRGB555形式の16ビット値を返す
    func rgb555(red: UInt8, green: UInt8, blue: UInt8) -> UInt16 {
        // RGB値が0から31の範囲内に収まるように調整
        let clampedRed = min(red, 31)
        let clampedGreen = min(green, 31)
        let clampedBlue = min(blue, 31)
        // RGB555形式に変換
        let rgb555Value = UInt16(clampedRed) | (UInt16(clampedGreen) << 5) | (UInt16(clampedBlue) << 10)
        return rgb555Value
    }
}
