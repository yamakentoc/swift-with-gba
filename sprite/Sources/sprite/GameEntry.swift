@main
struct GameEntry {
    static func main() {
        let playerSprite = PlayerSprite()
        playerSprite.initialize()
        // モードの設定
        SetMode(DCNT_OBJ | DCNT_OBJ_1D | DCNT_MODE0)
        
        while true {
            vid_vsync()
            key_poll()
            // 十字キーの入力に基づいてスプライトを移動
            playerSprite.move(
                x: 2 * key_tri_horz(), // 水平方向の入力
                y: 2 * key_tri_vert()    // 垂直方向の入力
            )
        }
    }
}
