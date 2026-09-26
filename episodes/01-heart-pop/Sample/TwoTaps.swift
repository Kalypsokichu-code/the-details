import CoreHaptics

/// The save haptic: a firm tap, then a lighter and duller one `gap` seconds later.
/// The values are for the sample, not the app's.
enum TwoTaps {
    static func pattern(gap: Double, secondStrength: Double) throws -> CHHapticPattern {
        try CHHapticPattern(events: [
            tap(intensity: 1, sharpness: 0.6, at: 0),
            tap(intensity: Float(secondStrength), sharpness: 0.3, at: gap),
        ], parameters: [])
    }

    private static func tap(intensity: Float, sharpness: Float, at time: TimeInterval) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            ],
            relativeTime: time
        )
    }
}
