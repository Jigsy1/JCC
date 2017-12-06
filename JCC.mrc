; Japanese Character Cipher - Proof of Concept by Jigsy.
;
; How to use:
; -----------
; //msg $chan $jcc.encode(Hello!)
; //msg $chan $jcc.encode(Hello!).strict
; /var %t = This, is a line with $!characters mIRC %doesn't really like. | //msg $chan $jcc.encode(%t)
; //msg $chan $jcc.decode(償禮幇 凉杞釧 櫛禪滲 峻狛桶哩悸傳鳩檜裡 曉峨嶺焙祐蕪廟鮫結)
;

alias jcc.decode {
  ; $jcc.decode(text)

  var %0 = $jcc.order
  var %1 = 0
  var %2
  while (%1 < $len($1-)) {
    inc %1
    if (($asc($mid($1-,%1,1)) == 32) || ($asc($mid($1-,%1,1)) == 160)) { var %2 = %2 $+ $chr(160) }
    ; `-> Use $chr(160) to emulate spaces since $chr(32) doesn't work.
    if ($mid($1-,%1,1) == X) { var %2 = %2 $+ 1,8? }
    ; `-> Convert any erroneous characters (X) into a ? w/ black text on a yellow background.
    else {
      if ($read($jcc.file, w, $+(*,$mid($1-,%1,1),*))) { var %2 = %2 $+ $mid(%0,$gettok($v1,1,61),1) }
      ; `-> Otherwise, find the character in the file and convert it. E.g. 醉 => 77 => m
    }
  }
  return %2
  ; `-> Return the output.
}
alias jcc.encode {
  ; $jcc.encode(text)[.strict]

  var %0 = $jcc.order
  var %1 = 0
  var %2, %3, %4, %5, %6
  while (%1 < $len($1-)) {
    inc %1
    if ($poscs(%0,$mid($1-,%1,1))) {
      ; `-> Check the character via the acceptable characters as defined above. (This is using the case-sensitive $pos identifier.)
      var %4 = $v1
      ; `-> Convert the character to a number. E.g. ! = 1, " = 2, ... | = 92, etc.
      var %5 = $removecs($readini($jcc.file, Keys, %4),%3)
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
      ; `-> Use $chr(160) to emulate spaces since $chr(32) doesn't work. Also set the last character to $null.
      else {
        if ($prop == strict) { return }
        ; `-> If the strict property is used, and an invalid character is found, terminate.
        else { var %2 = %2 $+ X, %3 = $null }
        ; `-> Otherwise, change the value to an X. E.g. As you can see, £ isn't part of the %0 variable above. So you either need to write pounds as part of the string, or it'll get changed to X.
        ;     I do wonder if all the unused characters that look the same like Katakana ロ and Kanji 口 (mouth) could be used instead?
        ;     Oh, and set the last character to $null.
      }
    }
  }
  return %2
  ; `-> Return the output.
}
alias -l jcc.file { return $qt($scriptdirJCC.ini) }
; `-> If the file is in a different folder or whatever, change this.
alias -l jcc.order { return $readini($jcc.file, n, Order, Chars) }
; `-> The only acceptable characters that can be encoded. If you would like to add more like ö or £, for example, you can, but the *.ini file will need updating to reflect this.
;     So if you add ö onto the end of the [Order]->Chars=...}~, you will need to add 95=<some characters go here> to the *.ini file.

; EOF
