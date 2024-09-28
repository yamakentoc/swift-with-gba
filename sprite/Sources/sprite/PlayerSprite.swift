enum Mem {
    // PAL RAM：スプライトのパレットを設定する領域
    static let spritePalette = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
    // VRAM：スプライト用のタイルデータを格納する領域
    static let tileData = UnsafeMutablePointer<CHARBLOCK>(bitPattern: 0x06000000)!
    // OAM：スプライトの設定をする領域。位置や大きさなどの描画について記述
    static let oam = UnsafeMutablePointer<OBJ_ATTR>(bitPattern: 0x07000000)!
}

final class PlayerSprite {
    private let spriteBuffer = UnsafeMutablePointer<OBJ_ATTR>.allocate(capacity: 128)
    private var posX: Int32 = 0
    private var posY: Int32 = 0

    func initialize() {
        // スプライトのタイルデータをVRAMに書き込む
        withUnsafePointer(to: appleLogoTiles) { tilePointer in
            tilePointer.withMemoryRebound(to: CHARBLOCK.self, capacity: 1) { tileBlock in
                Mem.tileData[4] = tileBlock.pointee
            }
        }
        // パレットデータをスプライト用PAL RAMに書き込む
        withUnsafePointer(to: appleLogoPal) { palettePointer in
            palettePointer.withMemoryRebound(to: UInt16.self, capacity: 256) { paletteBlock in
                Mem.spritePalette.update(from: paletteBlock, count: 256)
            }
        }
        // OAM初期化
        oam_init(spriteBuffer, 128)
        // スプライトの設定
        obj_set_attr(&spriteBuffer[0], .init(ATTR0_SQUARE), .init(ATTR1_SIZE_32), ATTR2_PALBANK(0))
        spriteBuffer[0].attr2 = ATTR2_BUILD(0, 0, 0)
    }
    
    func ATTR2_BUILD(_ id: UInt16, _ pb: UInt16, _ prio: UInt16) -> UInt16 {
        (id & 0x3FF) | ((pb & 15) << 12) | ((prio & 3) << 10)
    }

    func ATTR2_PALBANK(_ n: UInt16) -> UInt16 {
        n << 12
    }
    
    func move(x: Int32, y: Int32) {
        posX += x
        posY += y
        // スプライトの位置を更新
        obj_set_pos(&spriteBuffer[0], posX, posY)
        // OAMに書き込む
        Mem.oam.update(from: &spriteBuffer[0], count: 2)
    }
}
