@main
struct GameEntry {
    static func main() {
        let drawer = Drawer()
        let screenWidth = 240
        let screenHeight = 160
        while true {
            drawer.waitForVsync()
            for drawStartPosition in 0...(screenWidth * screenHeight) {
                drawer.draw(drawStartPosition: drawStartPosition, px: screenWidth)
            }
            drawer.clear()
        }
    }
}
