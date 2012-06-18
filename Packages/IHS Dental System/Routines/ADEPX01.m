ADEPX01 ;IHS/HQW/MJL - REPORTS  [ 03/24/1999   8:35 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
CALIF ;CALIFORNIA REPORT
 S ^TMP("ADEP",ADEU,0)="CALIFORNIA REPORT "_DT
 ;KEY: ^TMP(,,ADELOE)="FV (Indian)^FV (Non-Indian)^RV (Indian)^RV (Non-Indian)^SVC (Indian)^SVC (Non-Indian)^SM (Indian)^SM (Non-Indian)^BA^CA"
 ;Put beginning and ending dates in calling option since this
 ;code in this routine could be called either interactively or
 ;non-interactively by scheduled option
 ;
 S ADEBD="2801001.00",ADEND=DT_.99
 S ADEFV=$O(^AUTTADA("B","0000",0))
 S ADERV=$O(^AUTTADA("B","0190",0))
 S ADEBA=$O(^AUTTADA("B",9130,0))
 S ADECA=$O(^AUTTADA("B",9140,0))
 S ADEPTC=$O(^AUTTADA("B",9990,0))
 S ADEVS=ADEFV_U_ADERV_U_ADEBA_U_ADECA
 S ADEGB="^TMP(""ADEP"",ADEU,ADELOE)"
 S ADEX=ADEBD
 F  S ADEX=$O(^ADEPCD("AC",ADEX)) Q:'+ADEX  Q:ADEX>ADEND  D
 . S ADEY=0
 . F  S ADEY=$O(^ADEPCD("AC",ADEX,ADEY)) Q:'+ADEY  D
 . . Q:'$D(^ADEPCD(ADEY,0))
 . . S ADENOD=^ADEPCD(ADEY,0)
 . . ;INDIAN (1) OR NON-INDIAN (0) ?
 . . S ADEIND=1
 . . S ADELOE=$P(ADENOD,U,3)
 . . Q:$P(ADENOD,U,9)'="d"
 . . Q:'$D(^ADEPCD(ADEY,"ADA"))
 . . S ADEZ=0
 . . F  S ADEZ=$O(^ADEPCD(ADEY,"ADA",ADEZ)) Q:'+ADEZ  D
 . . . S ADENOD=^ADEPCD(ADEY,"ADA",ADEZ,0)
 . . . I ADEVS[$P(ADENOD,U) D  Q
 . . . . I ADECP=ADERV S $P(@ADEGB,U,4-ADEIND)=$P(@ADEGB,U,4-ADEIND)+1 Q
 . . . . I ADECP=ADEFV S $P(@ADEGB,U,2-ADEIND)=$P(@ADEGB,U,2-ADEIND)+1 Q
 . . . . I ADECP=ADEBA S $P(@ADEGB,U,9)=$P(@ADEGB,U,9)+1 Q
 . . . . I ADECP=ADECA S $P(@ADEGB,U,10)=$P(@ADEGB,U,10)+1 Q
 . . . I $P(ADENOD,U,5)]"" Q  ;Unreportable
 . . . ;CHECK LEVEL OF SERVICE, SM
 . . . S ADENOD=^AUTTADA(+ADENOD,0)
 . . . I $P(ADENOD,U,5)<1!($P(ADENOD,U,5)>8) Q
 . . . S $P(@ADEGB,U,6-ADEIND)=$P(@ADEGB,U,6-ADEIND)+$P(ADENOD,U,4)
 . . . S $P(@ADEGB,U,8-ADEIND)=$P(@ADEGB,U,8-ADEIND)+1
