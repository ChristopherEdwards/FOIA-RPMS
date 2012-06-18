ABSPOSHU ;IHS/SD/lwj - various miscellaneous 5.1 utilities [ 09/04/2002  10:17 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;
 ;--------------------------------------------------------------
 ; Because of SAC routine size limitations, many utilities 
 ; had to be split off into their own individual routines to
 ; avoid the limitation.
 ;
 ;
CLNDATA ;EP   NCPDP 5.1   Called from ABSPOSH5
 ; Remove the leading and trailing blanks in each of the fields
 ; that is to be written to the ^ABSPR global.
 ;
 N NEXT,MEDN
 ; 
 S NEXT=0
 F  D  Q:'NEXT
 .S NEXT=$O(FDATA(NEXT)) Q:'NEXT
 .S FDATA(NEXT)=$$CLIP^ABSPOSU9($G(FDATA(NEXT)))
 S MEDN=""
 F  D  Q:MEDN=""
 .S MEDN=$O(FDATA("M",MEDN))
 .Q:MEDN=""
 .S NEXT=0
 .F  D  Q:'+NEXT
 ..S NEXT=$O(FDATA("M",MEDN,NEXT))
 ..Q:'+NEXT
 ..S FDATA("M",MEDN,NEXT)=$$CLIP^ABSPOSU9($G(FDATA("M",MEDN,NEXT)))
 ;
 Q
