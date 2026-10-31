import Foundation
import CoreGraphics
import CoreText
import ImageIO

/* ============================================================
   Word Playground - icon generator
   Draws the app icon and exports every size needed:
     - 1024  master (kept for reference)
     - 512   Play Console store icon
     - 432   adaptive-icon foreground / background / monochrome
     - 48/72/96/144/192  legacy launcher PNGs (mdpi..xxxhdpi)

   Design: two bold letter tiles (W + P) strung on a rope that
   runs corner-to-corner - a playground rope with letter tiles,
   which also reads as the game's linked word-chains. A gold star
   and a couple of sparkles finish the playful look.
   ============================================================ */

let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!

func makeContext(_ size: Int) -> CGContext {
    CGContext(data: nil, width: size, height: size, bitsPerComponent: 8,
              bytesPerRow: 0, space: sRGB,
              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
}

func savePNG(_ ctx: CGContext, _ path: String) {
    guard let img = ctx.makeImage() else { fatalError("makeImage failed") }
    let url = URL(fileURLWithPath: path) as CFURL
    guard let dest = CGImageDestinationCreateWithURL(url, "public.png" as CFString, 1, nil)
    else { fatalError("dest failed for \(path)") }
    CGImageDestinationAddImage(dest, img, nil)
    CGImageDestinationFinalize(dest)
}

/* deep indigo brand gradient, like the app's night background */
func drawBackground(_ ctx: CGContext, _ size: CGFloat) {
    let colors = [
        CGColor(colorSpace: sRGB, components: [0.169, 0.114, 0.369, 1.0])!, // 2B1D5E
        CGColor(colorSpace: sRGB, components: [0.078, 0.059, 0.200, 1.0])!  // 140F33
    ] as CFArray
    let grad = CGGradient(colorsSpace: sRGB, colors: colors, locations: [0, 1])!
    ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: size), end: CGPoint(x: size, y: 0), options: [])
}

/* bold centered letter; punch=true knocks it out (for monochrome layer) */
func drawLetter(_ ctx: CGContext, _ letter: String, size: CGFloat, color: CGColor, center: CGPoint, punch: Bool = false) {
    let font = CTFontCreateWithName("HelveticaNeue-Bold" as CFString, size, nil)
    let attrs: [CFString: Any] = [
        kCTFontAttributeName: font,
        kCTForegroundColorAttributeName: color
    ]
    guard let attrString = CFAttributedStringCreate(nil, letter as CFString, attrs as CFDictionary)
    else { return }
    let line = CTLineCreateWithAttributedString(attrString)
    let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
    ctx.saveGState()
    if punch { ctx.setBlendMode(.clear) }
    ctx.textPosition = CGPoint(x: center.x - bounds.width / 2 - bounds.minX,
                               y: center.y - bounds.height / 2 - bounds.minY)
    CTLineDraw(line, ctx)
    ctx.restoreGState()
}

/* 5-point star polygon */
func drawStar(_ ctx: CGContext, center: CGPoint, radius: CGFloat, color: CGColor) {
    let inner = radius * 0.42
    var points: [CGPoint] = []
    for i in 0..<10 {
        let ang = (CGFloat(i) * .pi / 5) - .pi / 2
        let r = i % 2 == 0 ? radius : inner
        points.append(CGPoint(x: center.x + r * cos(ang), y: center.y + r * sin(ang)))
    }
    ctx.beginPath()
    ctx.move(to: points[0])
    for p in points.dropFirst() { ctx.addLine(to: p) }
    ctx.closePath()
    ctx.setFillColor(color)
    ctx.fillPath()
}

/* rounded game tile with a 3D base edge, like the in-game tiles */
func drawTile(_ ctx: CGContext, center: CGPoint, size: CGFloat, radius: CGFloat,
              color: CGColor, shadow: CGColor, mono: Bool) {
    let w = size
    let rect = CGRect(x: center.x - w / 2, y: center.y - w / 2, width: w, height: w)
    let shRect = rect.offsetBy(dx: 0, dy: -w * 0.045)
    // base edge
    ctx.addPath(CGPath(roundedRect: shRect, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.setFillColor(mono ? shadow : shadow)
    ctx.fillPath()
    // tile
    ctx.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
    ctx.setFillColor(color)
    ctx.fillPath()
}

/* Art is drawn in a 1024x1024 master coordinate system centered at (0,0). */
func drawArt(_ ctx: CGContext, artScale: CGFloat, mono: Bool) {
    ctx.saveGState()

    let white = CGColor(colorSpace: sRGB, components: [1, 1, 1, 1])!
    let white70 = CGColor(colorSpace: sRGB, components: [1, 1, 1, 0.7])!
    let orange = mono ? white : CGColor(colorSpace: sRGB, components: [1.0, 0.541, 0.239, 1.0])! // FF8A3D
    let orangeD = mono ? white : CGColor(colorSpace: sRGB, components: [0.851, 0.435, 0.122, 1.0])!
    let pink = mono ? white : CGColor(colorSpace: sRGB, components: [1.0, 0.369, 0.471, 1.0])!  // FF5E78
    let pinkD = mono ? white : CGColor(colorSpace: sRGB, components: [0.839, 0.227, 0.361, 1.0])!
    let gold = mono ? white : CGColor(colorSpace: sRGB, components: [1.0, 0.831, 0.278, 1.0])!  // FFD447
    let teal = mono ? white70 : CGColor(colorSpace: sRGB, components: [0.310, 0.639, 0.639, 1.0])! // 4FA3A3

    let S = artScale

    // ---- rope: runs corner to corner, tiles threaded on it like beads ----
    ctx.setLineWidth(46 * S)
    ctx.setLineCap(.round)
    ctx.setStrokeColor(teal)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: -430 * S, y: -430 * S))
    ctx.addLine(to: CGPoint(x: 450 * S, y: 450 * S))
    ctx.strokePath()

    // ---- W tile (hero, bottom-left) ----
    let wC = CGPoint(x: -160 * S, y: -160 * S)
    drawTile(ctx, center: wC, size: 380 * S, radius: 84 * S, color: orange, shadow: orangeD, mono: mono)
    drawLetter(ctx, "W", size: 235 * S, color: white, center: wC, punch: mono)

    // ---- P tile (top-right, overlapping the rope) ----
    let pC = CGPoint(x: 190 * S, y: 190 * S)
    drawTile(ctx, center: pC, size: 300 * S, radius: 66 * S, color: pink, shadow: pinkD, mono: mono)
    drawLetter(ctx, "P", size: 185 * S, color: white, center: pC, punch: mono)

    // ---- gold star + sparkles ----
    drawStar(ctx, center: CGPoint(x: -252 * S, y: 228 * S), radius: 62 * S, color: gold)
    for (sp, r) in [(CGPoint(x: 300 * S, y: -66 * S), 15.0), (CGPoint(x: 66 * S, y: -296 * S), 12.0)] {
        ctx.beginPath()
        ctx.addArc(center: sp, radius: CGFloat(r) * S, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        ctx.setFillColor(mono ? white70 : white)
        ctx.fillPath()
    }

    ctx.restoreGState()
}

/* Render one icon PNG. */
func render(size: Int, artScale: CGFloat, bg: Bool, mono: Bool, out: String) {
    let ctx = makeContext(size)
    let s = CGFloat(size)
    if bg { drawBackground(ctx, s) }
    ctx.translateBy(x: s / 2, y: s / 2)
    ctx.scaleBy(x: s / 1024, y: s / 1024)
    drawArt(ctx, artScale: artScale, mono: mono)
    savePNG(ctx, out)
    print("wrote \(out)")
}

let args = CommandLine.arguments
guard args.count == 2 else {
    print("usage: swift make-icons.swift <project-root>")
    exit(1)
}
let root = args[1]
let tools = root + "/tools"
let store = root + "/store-listing"
let res = root + "/android/app/src/main/res"

/* master + Play Console store icon */
render(size: 1024, artScale: 0.92, bg: true, mono: false, out: tools + "/icon-master-1024.png")
render(size: 512,  artScale: 0.92, bg: true, mono: false, out: store + "/icon-512.png")

/* adaptive icon layers (432px canvas; bold but inside the mask circle) */
render(size: 432, artScale: 0.72, bg: false, mono: false, out: res + "/mipmap-xxxhdpi/ic_launcher_foreground.png")
render(size: 432, artScale: 0.72, bg: true,  mono: false, out: res + "/mipmap-xxxhdpi/ic_launcher_background.png")
render(size: 432, artScale: 0.72, bg: false, mono: true,  out: res + "/mipmap-xxxhdpi/ic_launcher_monochrome.png")

/* legacy launcher icons */
let sizes = [("mdpi", 48), ("hdpi", 72), ("xhdpi", 96), ("xxhdpi", 144), ("xxxhdpi", 192)]
for (dpi, px) in sizes {
    render(size: px, artScale: 0.92, bg: true, mono: false, out: res + "/mipmap-\(dpi)/ic_launcher.png")
    render(size: px, artScale: 0.92, bg: true, mono: false, out: res + "/mipmap-\(dpi)/ic_launcher_round.png")
}