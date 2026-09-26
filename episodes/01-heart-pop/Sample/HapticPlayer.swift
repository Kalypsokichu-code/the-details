import CoreHaptics

/// Just enough Core Haptics to play a pattern, for the sketch. It starts the engine
/// on the tap itself, which blocks for a moment the first time; a shipping app should
/// start it earlier, and handle the system stopping or resetting it.
@MainActor
final class HapticPlayer {
    private var engine: CHHapticEngine?

    func play(_ makePattern: () throws -> CHHapticPattern) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            let engine = try self.engine ?? CHHapticEngine()
            self.engine = engine
            try engine.start()
            try engine.makePlayer(with: makePattern()).start(atTime: CHHapticTimeImmediate)
        } catch {
            // Haptics are extra. If one can't play, drop the engine and build a fresh
            // one next time.
            self.engine = nil
        }
    }
}
