@main
struct GameEntry {
    static func main() {
        let dotDrawer = DotDrawer()
        while true {
            //  垂直同期を待つ
            dotDrawer.waitForVsync()
            // 白いドットを斜めに描画
            for i in 0..<20 {
                dotDrawer.mode3PutPixel(x: 5 + i, y: 5 + i, color: dotDrawer.rgb555(red: 31, green: 31, blue: 31))
            }
            // 赤、緑、青、白のドットを横に描画
            for i in 0..<32 {
                dotDrawer.mode3PutPixel(x: 20 + i * 2, y: 50, color: dotDrawer.rgb555(red: i, green: 0, blue: 0))     // 赤のグラデーション
                dotDrawer.mode3PutPixel(x: 20 + i * 2, y: 60, color: dotDrawer.rgb555(red: 0, green: i, blue: 0))     // 緑のグラデーション
                dotDrawer.mode3PutPixel(x: 20 + i * 2, y: 70, color: dotDrawer.rgb555(red: 0, green: 0, blue: i))     // 青のグラデーション
                dotDrawer.mode3PutPixel(x: 20 + i * 2, y: 80, color: dotDrawer.rgb555(red: i, green: i, blue: i))     // 白のグラデーション
            }
        }
    }
}

