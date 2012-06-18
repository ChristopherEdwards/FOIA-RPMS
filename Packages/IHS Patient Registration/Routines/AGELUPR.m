AGELUPR ;IHS/ASDS/EFG - PRINT CMS FILE PROCESS LOG ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
START ;start
 NEW AGDA,DIC
 S DIC="^AGELUPLG(",DIC(0)="AEMQ"
 D ^DIC
 Q:+Y<0
 S AGDA=+Y
 D ^%ZIS
 Q:POP
 I IO'=IO(0) D QUE,HOME^%ZIS Q
 D PRINT,^%ZISC
 Q
QUE ;que to taskman
 S ZTRTN="PRINT^AGELUPR",ZTSAVE("AGDA")="",ZTDESC="Eligibility Upload Log"
 D ^%ZTLOAD
 I $G(ZTSK) W !,"Task # ",ZTSK," queued."
 Q
PRINT ;EP - From Taskman.  Print the report.
 NEW AGCAT,AGCNT,AGMVDF,AGPG,AGQUIT,AGRDT,DFN
 S (AGPG,AGQUIT)=0,AGCAT="ADDED",AGRDT=$P(^AGELUPLG(AGDA,0),U,1)
 D HDR
 S (AGCNT,DFN)=0
 F  S DFN=$O(^AGELUPLG(AGDA,1,DFN)) Q:'DFN  D ONE Q:AGQUIT
 Q:AGQUIT
 D END
 Q:AGQUIT
 S AGCAT="EDITED"
 D HDR
 S (AGCNT,DFN)=0
 F  S DFN=$O(^AGELUPLG(AGDA,2,DFN)) Q:'DFN  D ONE Q:AGQUIT
 Q:AGQUIT
 D END
 Q:AGQUIT
 W @IOF
 Q
ONE ;print one patient
 W !,$P(^DPT(DFN,0),U,1),?40 S Y=$P(^(0),U,9) X ^DD(2,.09,2) W Y
 S AGCNT=AGCNT+1
 I $Y+3>IOSL D
 . I $E(IOST)="C" S AGQUIT='$$DIR^XBDIR("E")
 . Q:AGQUIT
 . D HDR
 .Q
 Q
HDR ;EP - page header
 S AGPG=AGPG+1
 W @IOF,!,$$CJ^XLFSTR("ELIGIBILITY UPLOAD LOG",IOM),!,"Upload Run Date: ",$$FMTE^XLFDT(AGRDT,1),?70,"Page ",AGPG
 W !?11,"File: ",$$GET1^DIQ(9009062.02,AGDA,.03),"    #Records: ",$FN($$GET1^DIQ(9009062.02,AGDA,.04),","),!?7,"Template: ",$$GET1^DIQ(9009062.02,AGDA,.02),!,$$REPEAT^XLFSTR("=",80),!,"Patients ",AGCAT
 I AGPG=1 D:AGCAT="ADDED" HDR1
 W !,"Patient",?40,"Social Security Number",!,$$REPEAT^XLFSTR("-",30),?40,$$REPEAT^XLFSTR("-",22)
 Q
HDR1 ;
 W ?26,"Before",?45,"After",?63,"Added"
 W !,"MEDICARE ELIGIBLE file: ",$J($FN($$GET1^DIQ(9009062.02,AGDA,.06),","),8),"   ",$J($FN($$GET1^DIQ(9009062.02,AGDA,.07),","),8),"        = "
 W $J($FN($$GET1^DIQ(9009062.02,AGDA,.07)-$$GET1^DIQ(9009062.02,AGDA,.06),","),8)
 W !,"RAILROAD ELIGIBLE file: ",$J($FN($$GET1^DIQ(9009062.02,AGDA,.08),","),8),"   ",$J($FN($$GET1^DIQ(9009062.02,AGDA,.09),","),8),"        = "
 W $J($FN($$GET1^DIQ(9009062.02,AGDA,.09)-$$GET1^DIQ(9009062.02,AGDA,.08),","),8)
 W !,"MEDICAID ELIGIBLE file: ",$J($FN($$GET1^DIQ(9009062.02,AGDA,.11),","),8),"   ",$J($FN($$GET1^DIQ(9009062.02,AGDA,.12),","),8),"        = "
 W $J($FN($$GET1^DIQ(9009062.02,AGDA,.12)-$$GET1^DIQ(9009062.02,AGDA,.11),","),8)
 Q
END ;end of patients
 W !!,"TOTAL PATIENTS ",AGCAT,"  ",AGCNT
 I $E(IOST)="C" S AGQUIT='$$DIR^XBDIR("E")
 Q
TMPLT ;AG(V,N,S,P) = AG(value,name,subscript,piece)
 W !,"*** Print a template format ***",!
 NEW AG,DIC,Y
 S DIC="^AGELUP(",DIC(0)="AEMQ"
 D ^DIC
 Q:+Y<0
 S AG=+Y
 NEW DA,V,N,S,P
 S DA=0
 F  S DA=$O(^DD(9009062.01,DA)) Q:'DA  S S=$P(^(DA,0),U,4),P=$P(S,";",2),S=$P(S,";",1),V=$P($G(^AGELUP(AG,S)),U,P) I $L(V) S N=$P(^DD(9009062.01,DA,0),U,1),AG(V,N,S,P)=""
 S V=999
 F  S V=$O(AG(V)) Q:'$L(V)  S N=$O(AG(V,"")) W !,$J(N,20),":  ",V
 S V=0
 F  S V=$O(AG(V)) Q:'V  S N=$O(AG(V,"")) W !,$J(V,8),"  ",N
 Q
