; Japanese Character Cipher - Proof of Concept by Jigsy.
;
; How to use:
; -----------
; //msg $chan $jcc(Hello!)
; //msg $chan $jcc(Hello!).strict
; //var %t = This is a line, with $characters mIRC %doesn't really like. | //msg $chan $jcc(%t)
;
; Note:
; -----
; This only supports encrypting the text as of 05/12/2017.
; The only way to decrypt a string is finding each character one-by-one in the ini file and then converting the line number to a character.
; I will try and get around to writing a decoding identifier at some point.

alias jcc {
  ; $jcc(text)[.strict]

  var %file = $qt($scriptdirJCC.ini)
  ; `-> If the file is in a different folder or whatever, change this.
  var %0 = !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
  ; `-> The only acceptable characters that can be encoded. If you would like to add more like, for example, ö or £ you can, but the *.ini file will need updating to reflect this.
  var %1 = 0
  var %2, %3, %4, %5, %6
  while (%1 < $len($1-)) {
    inc %1
    if ($poscs(%0,$mid($1-,%1,1))) {
      ; `-> Check the character via the acceptable characters as defined above. (This is using the case-sensitive $pos identifier.)
      var %4 = $v1
      ; `-> Convert the character to a number. E.g. ! = 1, " = 2, ... | = 92, etc.
      var %5 = $removecs($readini(%file, Keys, %4),%3)
      ; `-> Get all the Japanese characters we can use, minus the one we used last. (Won't matter if %3 is $null here.)
      var %6 = $mid(%5,$rand(1,$len(%5)),1)
      ; `-> Now get a random character from the ones we can use.
      var %2 = %2 $+ %6
      ; `-> And then add it to the output string.
      var %3 = %6
      ; `-> Set the last character to the new character.
      ;     This reason for this is to make sure the character can never be used again in succession. For example, Grrr => 貌よ一よ is acceptable, whilst Grrr => 貌よよよ is not.
      ;     Having the same character after a space as the last character before a space is also acceptable. E.g. Grrr r => 貌よ一よ よ
    }
    else {
      if ($asc($mid($1-,%1,1)) == 32) { var %2 = %2 $+ $chr(160), %3 = $null }
      ; `-> Use $chr(160) to emulate spaces since $chr(32) doesn't work. Also set the last character as a null value.
      else {
        if ($prop == strict) { return }
        ; `-> If the strict property is used, and an invalid character is found, terminate.
        else { var %2 = %2 $+ X, %3 = $null }
        ; `-> Otherwise, change the value to an X. E.g. As you can see, £ isn't part of the %0 variable above. So you either need to write pounds as part of the string, or it'll get changed to X.
        ;     I do wonder if all the unused characters that look the same like Katakana ロ and Kanji 口 (mouth) could be used instead?
      }
    }
  }
  return %2
  ; `-> Return the output.
}

; EOF