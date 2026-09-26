import SwiftUI

/// Double-tap the specimen to save it: the heart pops and you get two taps. The
/// sliders change the second tap while you try it. Needs a real iPhone.
struct HeartPopSketch: View {
    @State private var saves = 0
    @State private var gap = 0.14
    @State private var secondStrength = 0.45
    @State private var player = HapticPlayer()
    @ScaledMetric(relativeTo: .largeTitle) private var specimenSize = 140.0

    var body: some View {
        VStack(spacing: 24) {
            Text("Aa")
                .font(.system(size: specimenSize, weight: .black, design: .serif))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                // A gesture rather than a Button, because it needs a tap count.
                .onTapGesture(count: 2, perform: save)
                .overlay { HeartPop(trigger: saves) }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Specimen")
                .accessibilityHint("Saves the font")
                .accessibilityAddTraits(.isButton)
                .accessibilityAction(.default, save)

            VStack(alignment: .leading) {
                Text("Gap between taps: \(gap * 1000, format: .number.precision(.fractionLength(0))) ms")
                Slider(value: $gap, in: 0...0.3) { Text("Gap between taps") }
                Text("Second tap: \(secondStrength, format: .percent.precision(.fractionLength(0)))")
                Slider(value: $secondStrength, in: 0...1) { Text("Second tap strength") }
            }
            .font(.callout)
        }
        .padding()
    }

    private func save() {
        // In a real app, return before this line if the save didn't happen.
        saves += 1
        player.play { try TwoTaps.pattern(gap: gap, secondStrength: secondStrength) }
    }
}

#Preview {
    HeartPopSketch()
}
