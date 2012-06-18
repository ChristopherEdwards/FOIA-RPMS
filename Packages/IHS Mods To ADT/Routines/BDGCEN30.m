BDGCEN30 ; IHS/ANMC/LJF - BED MOVEMENT LISTING ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
LOOP ; loop thru movements and sort
 NEW DGDT,DFN,IFN,SUB
 ;
 ; admissions, then transfers, then discharges
 F SUB="AMV1","AMV2","AMV3" D
 . S DGDT=BDGBD-.0001
 . F  S DGDT=$O(^DGPM(SUB,DGDT)) Q:'DGDT!(DGDT>BDGED)  D
 .. S DFN=0 F  S DFN=$O(^DGPM(SUB,DGDT,DFN)) Q:'DFN  D
 ... S IFN=0 F  S IFN=$O(^DGPM(SUB,DGDT,DFN,IFN)) Q:'IFN  D
 .... S X=+$P($G(^DGPM(IFN,0)),U,14)    ;pass admission ien
 .... D DATA(X,DGDT,DFN,SUB,IFN)
 Q
 ;
DATA(ADM,DATE,PAT,SUB,IFN) ; -- find data on entry and put into ^tmp
 NEW NAME,WARD,X,OLD,NEW,QUIT
 ;
 I BDGWD'="A" S QUIT=0 D  Q:QUIT
 . S NEW=$$GET1^DIQ(405,IFN,.06,"I")       ;new ward
 . S X=$$PRIORMVT^BDGF1(DATE,ADM,PAT)      ;last physical movement
 . I X S OLD=$$GET1^DIQ(405,X,.06,"I")     ;last ward
 . I SUB="AMV1",NEW'=BDGWD S QUIT=1        ;admission
 . I SUB="AMV3",OLD'=BDGWD S QUIT=1        ;discharge
 . I (NEW'=BDGWD)&(OLD'=BDGWD) S QUIT=1    ;transfers
 ;
 S NAME=$$GET1^DIQ(2,PAT,.01)              ;patient name
 S X=$$PRIORMVT^BDGF1(DATE,ADM,PAT)        ;last physical movement
 Q:'X  S WARD=$$GET1^DIQ(405,X,.06)        ;last ward
 S X=$$PRIORTXN^BDGF1(DATE,ADM,PAT) Q:'X   ;last service transfers ien
 ;
 ; if newborn
 I $$GET1^DIQ(405,X,.09)="NEWBORN" D  Q
 . ;
 . ;  and if death
 . I $$GET1^DIQ(405,IFN,.04)["DEATH" D  Q
 .. S ^TMP("BDGCEN31",$J,WARD,"NBDT",DATE,NAME,DFN)="" Q
 . ;
 . ; if ward transfer
 . I SUB="AMV2" D  Q
 .. ; if all wards selected
 .. I BDGWD="A" D  Q
 ... S ^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME,DFN)=""   ;transfer out
 ... S X=$$GET1^DIQ(405,IFN,.06)                       ;new ward
 ... S ^TMP("BDGCEN31",$J,X,"NBTI",DATE,NAME,DFN)=""   ;transfer in
 .. ;
 .. ; if just one ward selected
 .. I OLD=BDGWD S ^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME,DFN)=""
 .. S X=$$GET1^DIQ(405,IFN,.06)                               ;new ward
 .. I NEW=BDGWD S ^TMP("BDGCEN31",$J,X,"NBTI",DATE,NAME,DFN)=""
 . ;
 . ;  or other newborn transaction
 . S ^TMP("BDGCEN31",$J,WARD,"NB"_SUB,DATE,NAME,DFN)=""
 . ;
 ;
 ; else if other service
 ;  and if death
 I $$GET1^DIQ(405,IFN,.04)["DEATH" D  Q
 . S ^TMP("BDGCEN31",$J,WARD,"DT"_SUB,DATE,NAME,DFN)="" Q
 ;
 ; if ward transfer
 I SUB="AMV2" D  Q
 . ; if all wards selected
 . I BDGWD="A" D  Q
 .. S ^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME,DFN)=""   ;transfer out
 .. S X=$$GET1^DIQ(405,IFN,.06)                       ;new ward
 .. S ^TMP("BDGCEN31",$J,X,"TI",DATE,NAME,DFN)=""      ;transfer in
 . ;
 . ; if just one ward selected
 . I OLD=BDGWD S ^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME,DFN)=""
 . S X=$$GET1^DIQ(405,IFN,.06)                               ;new ward
 . I NEW=BDGWD S ^TMP("BDGCEN31",$J,X,"TI",DATE,NAME,DFN)=""
 ;
 ;  or other transaction
 S ^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME,DFN)=""
 Q
 ;
 ;
 ; Subscripts available for print routine:
 ; AMV1 = admission
 ; NBAMV1 = newborn admission
 ; AMV2 = transfer out
 ; NBAMV2 = newborn transfer out
 ; TI = transfer in
 ; NBTI = newborn transfer in
 ; AMV3 = discharge
 ; NBAMV2 = neborn discharge
 ; DT = death
 ; NBDT = newborn death
