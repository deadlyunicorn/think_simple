import "dart:math";

extension StringDifferenceComparison on String {
  bool isNoticablyDifferentThan(String textToCompareTo) {
    int characterDifference = (length - textToCompareTo.length).abs();

    if (characterDifference > 16) {
      return true;
    } else {
      int minLength = min(length, textToCompareTo.length);
      if (minLength + characterDifference <= 16) return false;

      return length < 8000
          ? simpleComparison(
              minLength,
              characterDifference,
              textToCompareTo,
            )
          : advancedProbabilisticComparison(
              minLength,
              textToCompareTo,
              characterDifference,
            );
    }
  }

  bool simpleComparison(
    int minLength,
    int characterDifference,
    String textToCompareTo,
  ) {
    for (int i = 1; i <= minLength && characterDifference <= 16; i++) {
      final int currentIndex = minLength - i;
      if (textToCompareTo[currentIndex] != this[currentIndex]) {
        characterDifference++;
      }
    }
    return characterDifference > 16;
  }

  bool advancedProbabilisticComparison(
    int minLength,
    String textToCompareTo,
    int characterDifference,
  ) {
    final int charactersPerChunk = (0.08 * minLength).ceil();

    for (int i = 0; minLength % charactersPerChunk != 0; i++) {
      final int currentIndex = minLength - 1 - i;
      if (textToCompareTo[currentIndex] != this[currentIndex]) {
        characterDifference++;
      }
      minLength--;
      if (minLength < i) {
        return characterDifference > 16;
      }
    }
    final int chunks = minLength ~/ charactersPerChunk;

    //? We compare only a fraction of the characters of each chunk
    //? To make this better
    //? we could continue reading on the same and nearby chunks
    //? if we found a difference.
    for (int currentCharacterOfChunk = 1;
        currentCharacterOfChunk <= min(charactersPerChunk, 64);
        currentCharacterOfChunk++) {
      for (int currentChunk = 1; currentChunk <= chunks; currentChunk++) {
        final int currentIndex = (chunks - currentChunk) * charactersPerChunk +
            (charactersPerChunk - currentCharacterOfChunk);
        if (textToCompareTo[currentIndex] != this[currentIndex]) {
          characterDifference++;
          if (characterDifference > 16) return true;
        }
      }
    }
    return false;
  }
}
