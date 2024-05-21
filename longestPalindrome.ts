function longestPalindrome(s: string): string {
  let i = 0;
  let maxLeft = 0;
  let maxRight = 0;
  while (i < s.length - 1) {
    let left = i;
    let right = i;

    while (right < s.length && s[right + 1] === s[right]) {
      right++;
    }
    while (left > 0 && right < s.length && s[left - 1] === s[right + 1]) {
      left--;
      right++;
    }

    if (right - left > maxRight - maxLeft) {
      maxRight = right;
      maxLeft = left;
    }

    i++;
  }

  return s.substring(maxLeft, maxRight + 1);
};