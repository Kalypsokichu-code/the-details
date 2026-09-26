# 01 · The heart pop

In 72pt you save a font by double-tapping it. A heart pops up in the middle of the screen, and the phone taps twice.

## What it does

**Two taps.** A hard tap when the heart appears, then a softer, duller one about a tenth of a second later. The heart grows a little too big and settles back, and the second tap lands on the settle. The system haptic presets have fixed shapes, so this one is a custom Core Haptics pattern, timed to the animation.

**It starts and ends invisible.** The heart has nothing to rest on, so it can't get stuck on screen, and coming back to the feed never replays an old one. It plays only when a new save happens.

**It only shows for a real save.** Double-tap only ever saves. Doing it again on a saved font shows the heart again instead of undoing the save. If the save can't happen, for example at the free limit, there's no heart and you get the upgrade screen instead.

**Reduce Motion.** With Reduce Motion on, the heart doesn't play. The save, the taps and the sound still happen.

**Text size.** The heart is sized with Dynamic Type, so it grows with your text size.

**Settings.** The Haptics switch in Settings turns the taps off. The sound follows the phone's silent switch.

## Adding it to your app

1. **Put the heart over your content as an overlay, driven by a counter.** Each time the counter changes, the heart plays once. [`HeartPop.swift`](Sample/HeartPop.swift) uses a `keyframeAnimator` whose first and last keyframes are both invisible:

    ```swift
    KeyframeTrack(\.opacity) {
        CubicKeyframe(1, duration: 0.15)   // appear
        LinearKeyframe(1, duration: 0.15)  // hold
        CubicKeyframe(0, duration: 0.32)   // fade out completely
    }
    ```

    A `phaseAnimator` stays on its last phase, which would leave the heart on screen.

2. **Build the two taps as a Core Haptics pattern.** Two transient events: a strong, sharp one at 0, and a weaker, duller one a little later. See [`TwoTaps.swift`](Sample/TwoTaps.swift):

    ```swift
    try CHHapticPattern(events: [
        tap(intensity: 1, sharpness: 0.6, at: 0),
        tap(intensity: Float(secondStrength), sharpness: 0.3, at: gap),
    ], parameters: [])
    ```

3. **Fire both from the save, and only after it succeeds.** Bump the counter and play the pattern in the same place, so the heart and the taps start together:

    ```swift
    private func save() {
        // Return before this line if the save didn't happen.
        saves += 1
        player.play { try TwoTaps.pattern(gap: gap, secondStrength: secondStrength) }
    }
    ```

4. **Gate the heart on Reduce Motion, not the taps.** The sample pins the animator's trigger to a constant when Reduce Motion is on, so the heart never plays but the save still gives feedback.

5. **Tune the gap on a phone, with the heart playing.** The right gap depends on your animation. [`HeartPopSketch.swift`](Sample/HeartPopSketch.swift) has sliders for this.

[`HapticPlayer.swift`](Sample/HapticPlayer.swift) is the minimum Core Haptics code to play a pattern. In a shipping app, start the engine before you need it, and handle the system stopping or resetting it.

## Try this

Run `HeartPopSketch` on an iPhone (the Simulator doesn't play haptics). Set the gap to 0 and double-tap: it feels like one heavy tap. Push it past 250 ms and it feels like two separate things. Somewhere in between, the second tap starts to feel like part of the heart's bounce.

The numbers in the sample are for the sample. They aren't the app's.
