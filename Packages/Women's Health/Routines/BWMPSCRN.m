BWMPSCRN ;IHS/CIA/PLS - Contains logic for Mammography Project lookup screens ;03-Sep-2003 20:12;PLS
 ;;2.0;WOMEN'S HEALTH;**9**;03-Apr-2003 08:09
 ;=================================================================
LOC(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
PBPROC(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
BRSTCHG(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
HMEDS(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
ANALOC(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
EXMTYPE(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
PROCPERF(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
RADASSM(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ;
RADREC(FLD,IEN) ;
 Q $$FIND(FLD,$G(IEN,Y))
 ; Returns binary flag indicating inclusion/exclusion from the pick list
FIND(FIELD,ITEM) ;
 N FLDS
 Q:+$P($G(^BWMPRESP(ITEM,0)),U,4)=1 0  ; Item has been inactivated
 S FLDS=$P($G(^BWMPRESP(ITEM,0)),U,2)
 S FLDS="|"_FLDS
 Q FLDS[("|"_FIELD)
