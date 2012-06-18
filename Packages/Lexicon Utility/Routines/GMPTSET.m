GMPTSET ; VA/SLC/KER Setup Appl/User Defaults for Look-up ; 05-15-96
 ;;2.0;LEXICON UTILITY;;Sep 23, 1996
 ;
 ; Replaces Clinical Lexicon Utility v 1.0 GMPTSET and re-directs
 ; call to Lexicon Utility v 2.0 LEXSET
 Q
CONFIG(LEXNS,LEXSS) ;  Redirect
 D CONFIG^LEXSET($G(LEXNS),$G(LEXSS)) Q
