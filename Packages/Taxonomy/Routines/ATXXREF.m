ATXXREF ;GDIT/HSCD/ALA-Taxonomy Cross-reference ; 07 Aug 2015  2:38 PM
 ;;5.1;TAXONOMY;**13**;FEB 4, 1997;Build 13
 ;
BUILDAC ;EP
 ;called to initially build AC index
 NEW TAXARR
 S TAXARR=$NA(^ATXAX(DA,21,"AC"))
 D BLDTAX^ATXAPI($P(^ATXAX(DA,0),U),.TAXARR,DA)
 Q
ICDTX(F) ;EP
 NEW %
 S %=$P($G(^ATXAX(F,0)),U,15)
 I %=80 Q 1
 I %=81 Q 1
 I %=80.1 Q 1
 Q 0
 ;
SETAC ;EP - called from cross reference
 ;set this multiple into the "AC"
 ;build the list and then merge it into the AC
 NEW TAXARR,ATXL,ATXH,CODE
 K ^ATXAX(DA(1),21,"AC")
 S TAXARR=$NA(^ATXAX(DA(1),21,"AC"))
 D BLDTAX^ATXAPI($P(^ATXAX(DA(1),0),U),.TAXARR,DA(1))
 Q
KILLAC2 ;EP - called from xref on value multiple to kill entries out of AC
 ;this is overkill but have to deal with @ of the .02 and changing of the .02
 ;FIRST KILL OFF ALL IN THE OLD .01 THROUGH OLD .02 VALUE RANGE
 NEW TAXARR,ATXL,ATXH
 S TAXARR="TAXARR"
 S ATXL=$$STRIP^XLFSTR($P(^ATXAX(DA(1),21,DA,0),U,1))
 S ATXH=$$STRIP^XLFSTR(X)
 D LST^ATXAPI($P(^ATXAX(DA(1),21,DA,0),U,3),$P(^ATXAX(DA(1),0),U,15),ATXL_"-"_ATXH,"","TAXARR")
 S ATXL=0 F  S ATXL=$O(TAXARR(ATXL)) Q:ATXL'=+ATXL  K ^ATXAX(DA(1),21,"AC",ATXL)
 ;NOW RESET WHAT IS IN THE .01 VALUE THROUGH .02
 K TAXARR
 S ATXL=$$STRIP^XLFSTR($P(^ATXAX(DA(1),21,DA,0),U,1))
 S ATXH=$$STRIP^XLFSTR($P(^ATXAX(DA(1),21,DA,0),U,2)) I ATXH="" S ATXH=ATXL
 D LST^ATXAPI($P(^ATXAX(DA(1),21,DA,0),U,3),$P(^ATXAX(DA(1),0),U,15),ATXL_"-"_ATXH,"","TAXARR")
 S ATXL=0 F  S ATXL=$O(TAXARR(ATXL)) Q:ATXL'=+ATXL  S ^ATXAX(DA(1),21,"AC",ATXL)=""
 Q
KILLAC1 ;
 ;this is overkill but have to deal with @ of the .01 and changing of the .01
 ;FIRST KILL OFF ALL IN THE old .01 THROUGH OLD .02 VALUE RANGE
 ;if it is a change it will get taken care of in the set xref logic
 ;if it is a delete of the multiple "@" at the .01 then all entries for this range will be gone
 NEW TAXARR,ATXL,ATXH
 S TAXARR="TAXARR"
 S ATXL=X
 S ATXH=$$STRIP^XLFSTR($P(^ATXAX(DA(1),21,DA,0),U,2))
 D LST^ATXAPI($P(^ATXAX(DA(1),21,DA,0),U,3),$P(^ATXAX(DA(1),0),U,15),ATXL_"-"_ATXH,"","TAXARR")
 S ATXL=0 F  S ATXL=$O(TAXARR(ATXL)) Q:ATXL'=+ATXL  K ^ATXAX(DA(1),21,"AC",ATXL)
 Q
