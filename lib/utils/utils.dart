class Utils {
  static int countCommonCharacters(String s1, String s2) {
    Map<String, int> charFrequencies = {};
    int matches = 0;
    //make each character a key in the char index and set it to zero
    s1.split('').toList().forEach((char) => charFrequencies[char] = 0);
    s2.split('').toList().forEach((char) {
      if (charFrequencies[char] != null) return;
      if (charFrequencies[char]! < 1) {
        matches++;
      }
    });
    return matches;
  }
}
