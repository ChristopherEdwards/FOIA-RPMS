BEHOSPUT ;MSC/IND/DKM - Spell checker support ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**023001**;Mar 20, 2007
 ;=================================================================
 ; Screen entries for parameter BEHOSP SERVICE PLUGIN
SVCSCN(IEN) ;EP
 N CAT
 F CAT=0:0 S CAT=$O(^CIAVOBJ(19930.2,IEN,2,"B",CAT)) Q:'CAT  Q:$$UP^XLFSTR($G(^CIAVOBJ(19930.21,CAT,0)))["SPELLCHECK"
 Q ''CAT
