# Ideograph Cipher
Ideograph Cipher (<i>formerly</i> Japanese Character Cipher) - Proof of Concept

I'm not really in the habit of rehashing things I've already written elsewhere; so a blog post I wrote <a href="https://jigsy1.blogspot.com/2017/12/my-attempt-at-creating-substitution.html">here</a> [jigsy1.blogspot.com] can explain this.

<h1>Decryption Challenges:</h1>

If you want to try decrypting some messages I wrote purely to see if they can be cracked, click these pastebin links:

1. <a href="https://pastebin.com/raw/frQ7SMZ3">1st implementation</a> - Straightforward. Uses a different key structure than the example, obviously. (EASY MODE)
2. <a href="https://pastebin.com/raw/QwN9NQrg">2nd implementation</a> - Spaces encoded. Uses a different key structure than the first implementation. (NORMAL MODE)
3. <a href="https://pastebin.com/raw/6A6rs43Y">3rd implementation</a> - Spaces encoded and null characters inserted into the string. Uses a different key structure than the other two implementations. (HARD MODE)
4. <a href="https://pastebin.com/raw/5LVTgCzE">Extended implementation</a> - Same settings as the third; but uses 27,622 ideographs. Obviously using a different key structure than the example implementation. (LUNATIC MODE)

<h1>Ideas:</h1>

1. <s>Wondering if spaces should also be encrypted.</s>
2. Wondering if invalid characters should use the "similar looking" characters. (ロ & 口, ニ & 二, etc.)
3. <s>Maybe a way of using similar looking characters as long as there's a way of checking the duplicates twice (E.g. ロ wasn't found, so it's probably the other one). The only problem with this is if someone writes down the ciphertext.</s>
4. <s>Null=ideographs - Basically characters that represent no value, but randomly added to a message purely to slow down decryption attacks. (Would be ignored during decoding.)</s>
5. Cyber-Wire on IRC suggested inserting fake spaces into the string if Space=... is true.
6.

<h1>Progress:</h1>

1. Added. Basically it checks to see if Space=... is in the .ini.
2.
3. This didn't seem to be an issue in mIRC. It could seem to tell the difference between へ (Hiragana) and ヘ (Katakana). The only issue that arises with this is, again, if somebody writes the message down onto a piece of paper (like whom, though?). Also the characters shouldn't be used for the same character, because of the whole doppelgänger problem.
4. Added. Basically it checks to see if Null=... is in the .ini.
5.
6. Erroneous character > X has been removed. Until I can come up with a way of sneakily converting an erroneous character > value > back to character, all messages are strict.

<h1>(Possible) Issues:</h1>
1. Encoding with Space= enabled, then changing the name to something like Spaces= and trying to decode the message will return something like "This!is!a!test." The same problem also happens with Null= being renamed. This shouldn't be an issue however as long as both parties have the exact same .ini structure.

<h1>Other Updates:</h1>
1. Found a <a href="https://archive.is/NhTlU">very large list</a> [rikai (archived)] of Ideographs (>20,000) and created another example key structure file now located in /extended/. (sqrt on IRC told me that a large majority of them are Chinese ideographs, so the cipher has been renamed.)
