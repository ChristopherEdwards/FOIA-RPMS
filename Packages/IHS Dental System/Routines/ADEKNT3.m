ADEKNT3 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
FILE ;EP
 ;For each objective-agegroup in ^TMP($J,"CTR",
 ; Create unique entry by concatenating YEAR.QUARTER.OBJECTIVE.AGEGROUP
 ; Test whether an entry by that name already exists
 ;  If not, create it
 ; Populate the entry with values from ^TMP($J,"CTR",
 ;
 N ADENOD,ADEIEN,ADEGRP,ADE01
 L +^ADEKNT:$S($D(DTIME):DTIME,1:300) Q:'$T
 S ADEIEN=0
 F  S ADEIEN=$O(^TMP($J,"CTR",ADEIEN)) Q:'+ADEIEN  D
 . S ADEGRP=0
 . F  S ADEGRP=$O(^TMP($J,"CTR",ADEIEN,ADEGRP)) Q:ADEGRP'?1N.E  D
 . . D ENTRY(ADEIEN,ADEGRP,"")
 . . S ADELOE=""
 . . F  S ADELOE=$O(^TMP($J,"CTR",ADEIEN,ADEGRP,ADELOE)) Q:'+ADELOE  D
 . . . D ENTRY(ADEIEN,ADEGRP,ADELOE)
 . . . Q
 . . Q
 . Q
 L -^ADEKNT:DTIME
 Q
 ;
ENTRY(ADEIEN,ADEGRP,ADELOE)  ;EP
 N ADE01,ADENOD
 S ADE01=$P(ADEPER,U)_"."_ADEIEN_"."_ADEGRP
 I +ADELOE D
 . S ADE01=ADE01_"."_ADELOE
 . S ADENOD=^TMP($J,"CTR",ADEIEN,ADEGRP,ADELOE)
 E  S ADENOD=^TMP($J,"CTR",ADEIEN,ADEGRP)
 I '$D(^ADEKNT("B",ADE01)) D
 . S DIC="^ADEKNT("
 . S DIC(0)="LZ"
 . S X=ADE01
 . K DD,DO
 . D FILE^DICN
 S DA=$O(^ADEKNT("B",ADE01,0))
 ;FHL 9/9/98 B:'+DA  ;***remove after testing
 S ADEYR=$P(ADE01,".")
 ;beginning Y2K fix
 ;S ADEYR=$S(ADEYR<81:20,1:19)_ADEYR ;OK, So I'm optimistic!
 ;end Y2K fix block
 S DR=".02///"_$P(ADENOD,U)_";.03///"_$P(ADENOD,U,2)
 S DR=DR_";.04///"_$P(ADENOD,U,3)_";.05///"_ADEYR
 S DR=DR_";.06///"_$P(ADE01,".",2)_";.07///`"_ADEIEN
 S DR=DR_";.09///"_$P(ADEGRP,":",2)
 S:+ADELOE DR=DR_";.11///`"_ADELOE
 S DR=DR_";.08///"_$P(ADEGRP,":")
 S DIE="^ADEKNT("
 D ^DIE
 Q
 ;
BULL(ADEBUL)       ;EP - Sends Bulletin
 ; ADEBUL=1 Complete
 ; ADEBUL=0 Abend
 ;
 S XMB=$S(ADEBUL:"ADEK-COMPLETE",1:"ADEK-ABEND")
 S XMDUZ="DENTAL PACKAGE"
 S XMB(1)="UNKNOWN"
 S:$D(ADEYQ) XMB(1)=+ADEYQ
 I ADEBUL D
 . S XMB(2)=$$MIN(ADE("STARTTIME"),$H)
 . S XMB(2)=$S(+XMB(2):+XMB(2)_" Hours",1:"")_$S(+$P(XMB(2),U,2):$P(XMB(2),U,2)_" Minutes",1:"")
 D ^XMB
 Q
 ;
ERR ;EP - Error trap
 ;Log error info
 I $D(^%ZOSF("ERRTN")) D @^%ZOSF("ERRTN")
 ;Send error bulletin
 D BULL(0)
 ;go end
 G END^ADEKNT
 ;
MIN(ADEX1,ADEX2)   ;EP
 ;Returns number of HOURS^MINUTES between ADEX1 and ADEX2
 ;where ADEX1 < ADEX2 and both are in $H format
 N ADEMIN
 ;
 I $P(ADEX1,",")=$P(ADEX2,",") D
 . S ADEMIN=$P(ADEX2,",",2)-$P(ADEX1,",",2)
 ;
 E  D
 . S ADEMIN=86400-$P(ADEX1,",",2)
 . S ADEMIN=ADEMIN+$P(ADEX2,",",2)
 . S ADEMIN=ADEMIN+(86400*($P(ADEX2,",")-$P(ADEX1,",")-1))
 ;
 S ADEMIN=$FN(ADEMIN/60,"",0)
 S ADEMIN=(ADEMIN\60)_U_(ADEMIN#60)
 Q ADEMIN
 ;
ADDMIN(ADENOW,ADEMIN)        ;EP
 ;Returns $H value resulting from addition of
 ;ADEMIN minutes to ADENOW where ADENOW is a time
 ;in $H format.
 ;
 N ADEH,ADEM,ADEP
 S ADEMIN=ADEMIN*60
 S ADEH=$P(ADENOW,",")
 S ADEM=$P(ADENOW,",",2)
 I (ADEM+ADEMIN)'>86400 Q ADEH_","_(ADEM+ADEMIN)
 S ADEP=ADEM+ADEMIN
 S ADEH=ADEH+(ADEP\86400)
 S ADEM=(ADEP#86400)
 Q ADEH_","_ADEM
