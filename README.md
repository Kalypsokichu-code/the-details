# The Details

Notes on small parts of [72pt](https://apps.apple.com/app/id6759483127), my font app for iPhone and Mac, one part at a time. Each one goes with a post on LinkedIn and comes with a small SwiftUI sample you can run.

## Episodes

| # | Episode | Sample |
|---|---|---|
| 01 | [The heart pop](episodes/01-heart-pop): the double-tap save, its heart and its two-tap haptic | A heart pop with a two-tap Core Haptics pattern, and sliders to retime the second tap |

More to come.

## Running the samples

Open `Package.swift` in Xcode 26, pick a sample file, and use its `#Preview`. You need iOS 26 or macOS 26 and Swift 6.2. Haptics only play on an iPhone, not in the Simulator or on a Mac. `swift build` in this folder checks that everything compiles.

## About the samples

I wrote them for this repo; they aren't taken from the app. The app's versions do more and use different values.
