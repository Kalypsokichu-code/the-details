import SwiftUI

/// A heart that pops over whatever it overlays, then disappears.
/// Plays once every time `trigger` changes.
struct HeartPop: View {
    let trigger: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .largeTitle) private var size = 88.0

    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: size))
            .foregroundStyle(.pink.gradient)
            .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            // Under Reduce Motion the trigger is pinned, so the heart never plays.
            // The save, the haptic and any sound belong to the caller and still happen.
            .keyframeAnimator(initialValue: Pop(), trigger: reduceMotion ? -1 : trigger) { heart, pop in
                heart
                    .scaleEffect(pop.scale)
                    .opacity(pop.opacity)
            } keyframes: { _ in
                // Demo values. Tune them on a device, with the haptic playing.
                KeyframeTrack(\.scale) {
                    SpringKeyframe(1, duration: 0.25, spring: Spring(duration: 0.25, bounce: 0.45))
                    CubicKeyframe(1.12, duration: 0.35)
                }
                KeyframeTrack(\.opacity) {
                    CubicKeyframe(1, duration: 0.15)
                    LinearKeyframe(1, duration: 0.15)
                    CubicKeyframe(0, duration: 0.32)
                }
            }
    }

    /// Starts invisible and the tracks end invisible, so the heart can never linger
    /// on screen, and coming back to the view never replays an old pop.
    private struct Pop {
        var scale = 0.5
        var opacity = 0.0
    }
}
