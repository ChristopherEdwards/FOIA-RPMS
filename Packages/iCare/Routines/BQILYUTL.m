BQILYUTL ;PRXM/HC/ALA-Layout Template Utilities ; 04 Jun 2007  4:03 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
DEF(OWNR,TYPE) ;EP - Get the IEN of the default layout template
 ; Input
 ;   TYPE - Type of default
 ;   OWNR - User
 ;
 NEW IEN,MIEN
 S IEN=0,MIEN=""
 F  S IEN=$O(^BQICARE(OWNR,15,"C",TYPE,IEN)) Q:'IEN  D
 . I $P(^BQICARE(OWNR,15,IEN,0),U,3)'="Y" Q
 . S MIEN=IEN
 Q MIEN
 ;
TPN(OWNR,TEMPL) ;EP - Get the IEN of the template
 Q $O(^BQICARE(OWNR,15,"B",TEMPL,""))
