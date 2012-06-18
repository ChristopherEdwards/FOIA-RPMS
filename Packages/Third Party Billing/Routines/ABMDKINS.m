ABMDKINS ; IHS/ASDST/DMJ - Keyword Lookup Maintenance for INSURER File ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
KEYW ;OLD EP for adding keywords
 S DIE="^AICDKWLC("
 S DA=$O(^AICDKWLC("B","INSURERS","")) I 'DA W *7,"-- No INSURER subfile in KEYWORD LOOKUP CONTROL file",! Q
 S DR="1"
 W !! D ^ABMDDIE K DR
 Q
 ;
REPL ;EP
 S DIE="^AICDKWLC("
 S DA=$O(^AICDKWLC("B","INSURERS","")) I 'DA W *7,"-- No INSURER subfile in KEYWORD LOOKUP CONTROL file",! Q
 S DR="2"
 W !! D ^ABMDDIE K DR
 Q
 ;
FREQ S DIE="^AICDKWLC("
 S DA=$O(^AICDKWLC("B","INSURERS","")) I 'DA W *7,"-- No INSURER subfile in KEYWORD LOOKUP CONTROL file",! Q
 S DR="1"
 W !! D ^ABMDDIE K DR
 Q
