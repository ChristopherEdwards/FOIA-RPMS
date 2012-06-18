BZXLRSER ;IHS/PIMC/JLG - AZ HEALTH DEPT REPORT [ 10/09/2002  1:08 PM ]
 ;;1.0;Special local routine for reportable diseases
 ;This is designed to replace DWLRSER1
 ;It uses file 1966360 as the table of files to report
 ;It calls BZXLRSEP as the routine to do the actual printing
 ;
 S DIR("A")="Enter start date"
 S DIR(0)="D^:"_DT_":EPX"
 D ^DIR
 I $D(DIRUT) D  Q
 .K DIR,DIRUT,DTOUT,DUOUT
 S BZXSDT=Y
 S BZXVDT=Y-.5
GETEND S DIR("A")="Enter end date"
 S DIR(0)="D^:"_DT_":EPX"
 D ^DIR
 I $D(DIRUT) D  Q
 .K DIR,DIRUT,DTOUT,DUOUT,BZXVDT
 S BZXENDT=Y
 I BZXENDT<BZXVDT D  G GETEND
 .W !,"End date cannot be before start date.  Try again."
 S %ZIS="Q"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 .S ZTRTN="LP^BZXLRSER"
 .S ZTSAVE("BZX*")="" 
 .S ZTDESC="Reportable diseases"
 .D ^%ZTLOAD
 .K ZTSAVE,ZTDESC,ZTRTN,IO("Q")
 ;
LP ;Start looping through tests
 K ^TMP($J)
 U IO
 ;BZXVDT is both the verification date and the order date
 ;In effect we only look at the verification date
 F  S BZXVDT=$O(^LRO(69,BZXVDT)) Q:'BZXVDT!(BZXVDT>BZXENDT)  D
 .S LOC=""
 .F  S LOC=$O(^LRO(69,BZXVDT,1,"AN",LOC)) Q:LOC=""  D
 ..S LRDFN=""
 ..F  S LRDFN=$O(^LRO(69,BZXVDT,1,"AN",LOC,LRDFN)) Q:'LRDFN  D
 ...S LRIDT=9999999-BZXVDT-.5 
 ...S X1=BZXVDT
 ...S X2=-545
 ...D C^%DTC
 ...S LRIDTLM=9999999-X
 ...F  S LRIDT=$O(^LRO(69,BZXVDT,1,"AN",LOC,LRDFN,LRIDT)) Q:'LRIDT!(LRIDT>LRIDTLM)  D
 ....Q:'$D(^LR(LRDFN,"CH",LRIDT,0))
 ....S X=$P(^LR(LRDFN,"CH",LRIDT,0),U,3)\1
 ....Q:X'=BZXVDT
 ....S D0=0
 ....F  S D0=$O(^BZXRPTDS(D0)) Q:'D0  D
 .....S BZXTPTR=$P(^BZXRPTDS(D0,0),U,1)
 .....S BZXTYPE=$P(@(U_$P(^LAB(60,BZXTPTR,0),U,12)_"0)"),U,2)
 .....S BZXDLOC=$P(^LAB(60,BZXTPTR,0),U,5)
 .....Q:'$D(^LR(LRDFN,"CH",LRIDT,$P(BZXDLOC,";",2)))
 .....S BZXRES=$P(^LR(LRDFN,"CH",LRIDT,$P(BZXDLOC,";",2)),U,1)
 .....S BZXFLD=$P(^LAB(60,BZXTPTR,0),U,12)
 .....S BZXRAWRS=BZXRES
 .....S TRANS=$G(^BZXRPTDS(D0,2))
 .....I $L(TRANS) D
 ......S Y=BZXRES
 ......K X
 ......X TRANS
 ......Q:'$D(X)
 ......S BZXRES=X
 .....I $E(BZXTYPE,1)="N" D
 ......S COND=$P(^BZXRPTDS(D0,0),U,4)
 ......I COND="EQ" S COND="="
 ......S VALUE=$P(^BZXRPTDS(D0,0),U,3)
 ......I $E(BZXRES,1)=">" S BZXRES=$P(BZXRES,">",2)+1
 ......S BZXRES=+BZXRES
 ......I @(BZXRES_COND_VALUE) D STORE
 .....E  I BZXTYPE="S" D
 ......;What the values stand for in the set
 ......S BZXSTNFR=$P(@(U_BZXFLD_"0)"),U,3)
 ......F I=1:1 S Y=$P(BZXSTNFR,";",I) Q:Y=""  D
 .......I $P(Y,":",1)=BZXRAWRS S BZXRAWRS=$P(Y,":",2)
 ......S D1=0
 ......F  S D1=$O(^BZXRPTDS(D0,1,D1)) Q:'D1  D
 .......S VALUE=$P(^BZXRPTDS(D0,1,D1,0),U,1)
 .......I BZXRES=VALUE D STORE
 .....E  I $E(BZXTYPE,1)="F" D
 ......S D1=0
 ......F  S D1=$O(^BZXRPTDS(D0,4,D1)) Q:'D1  D
 .......S COND=$P(^BZXRPTDS(D0,4,D1,0),U,2)
 .......S COND=$S(COND="C":"[",1:"=")
 .......S VALUE=$P(^BZXRPTDS(D0,4,D1,0),U,1)
 .......I BZXRES'=+BZXRES S BZXRES=""""_BZXRES_""""
 .......I @(BZXRES_COND_VALUE) D STORE
 D ^BZXLRSEP
 K ^TMP($J)
 D ^%ZISC
 Q
 ;
STORE ;Store data for printing
 K BZXCOMM,BZXCMIN
 S BZXFILE=$P(^LR(LRDFN,0),U,2)
 S DFN=$P(^LR(LRDFN,0),U,3)
 S PATNAM=$S(BZXFILE=2:$P(^DPT(DFN,0),U,1),BZXFILE=67:"*"_$P(^LRT(67,DFN,0),U,1),1:"UNK")
 S IENS=DFN_","
 S SEX=$$GET1^DIQ(BZXFILE,IENS,.02)
 S DOB=$$GET1^DIQ(BZXFILE,IENS,.03)
 Q:BZXFILE=67.3
 I BZXFILE=67 D
 .S ID=$P(^LRT(67,DFN,0),U,9)
 .S (STREET,CITY,STATE,ZIP,PHONE,BZXCOMM,BZXCMIN)=""
 E  I BZXFILE=2 D  
 .S ID=$$HRN^AUPNPAT(DFN,DUZ(2))
 .S Y=^DPT(DFN,.11)
 .S STREET=$P(Y,U,1)
 .S CITY=$P(Y,U,4)
 .S ZIP=$P(Y,U,6)
 .S IENS=DFN_","
 .S STATE=$$GET1^DIQ(2,IENS,.115)
 .S PHONE=$$GET1^DIQ(2,IENS,.131)
 .S BZXCOMM=$$COMMRES^AUPNPAT(DFN,"E")
 .S BZXCMIN=$$COMMRES^AUPNPAT(DFN,"I")
 .I 'BZXCMIN D
 ..S BZXXCOMM=$P(^AUPNPAT(DFN,11),U,18)
 ..Q:BZXCOMM=""
 ..S BZXCMIN=$O(^AUTTCOM("B",BZXCOMM,""))
 I BZXCMIN,$D(BZXGR),'$D(^BZXGRHR("B",BZXCMIN)) Q
 I $D(BZXGR),'BZXCMIN Q
 S ^TMP($J,D0,LRDFN,LRIDT)=PATNAM_U_ID_U_DOB_U_SEX_U_PHONE_U_STREET_U_CITY_U_STATE_U_ZIP_U_BZXCOMM_U_BZXRAWRS
 Q
