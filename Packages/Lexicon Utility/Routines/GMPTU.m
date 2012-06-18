GMPTU ; VA/SLC/KER Miscellaneous Lexicon Utilities      ; 05-15-96
 ;;2.0;LEXICON UTILITY;;Sep 23, 1996
 ;
 ; Replaces Clinical Lexicon Utility v 1.0 GMPTU and re-directs
 ; call to Lexicon Utility v 2.0 LEXU
 ; 
ICDONE(LEX) ; Return one ICD code for an expression - LEX=IEN
 S LEX=$$ICDONE^LEXU(+($G(LEX))) Q LEX
ICD(LEX) ; Return all ICD codes for an expression - LEX=IEN
 S LEX=$$ICD^LEXU(+($G(LEX))) Q LEX
