LRRP1 ;DALOI/RWF/BA-PRINT THE DATA FOR INTERIM REPORTS ;December 16, 2010 1:45 PM
 ;;5.2;LAB SERVICE;**1004,1013,1016,1018,1025,1026,1027,1028,1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;**153,221,283,286,356,372**;NOV 01, 1997
 ;from LRRP, LRRP2, LRRP3
 ;
PRINT S:'$L($G(SEX)) SEX="M" S:'$L($G(DOB)) DOB="UNKNOWN"
 S LRAAO=0 F  S LRAAO=$O(^TMP("LR",$J,"TP",LRAAO)) Q:LRAAO<1  D ORDER Q:LRSTOP
 K ^TMP("LR",$J,"TP")
 Q
 ;
 ;
ORDER N LRCAN
 S LRCDT=0
 F  S LRCDT=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT)) Q:LRCDT<1  D
 . S LRCAN=0
 . I LRSS="CH" D
 . . S LRIDT=+^TMP("LR",$J,"TP",LRAAO,LRCDT,-2)
 . . F  S LRCAN=+$O(^LR(LRDFN,"CH",LRIDT,1,LRCAN)) Q:LRCAN<1  Q:$E($G(^(LRCAN,0)))="*"
 . D TEST Q:LRSTOP
 Q
 ;
 ;
 ; TEST
TESTORIG ; EP -- IHS/OIT/MKK LR*5.2*1027 - Begin TEST Original Code
 S LRIDT=+^TMP("LR",$J,"TP",LRAAO,LRCDT,-2)
 S LRSS=$P(^TMP("LR",$J,"TP",LRAAO),U,2)
 S LR0=$S($D(^(LRAAO,LRCDT))#2:^(LRCDT),1:""),LRTC=$P(LR0,U,12)
 I LRSS="MI" D  Q
 . S LRH=1 D:LRFOOT FOOT Q:LRSTOP
 . D EN1^LRMIPC
 . S LRHF=1,LRFOOT=0
 . K A,Z,LRH
 . S:LREND LREND=0,LRSTOP=1
 ;
 Q:'$G(LRCAN)&('$P(LR0,U,3))  D @$S(LRHF:"HDR",1:"CHECK") Q:LRSTOP
 S LRSPEC=+$P(LR0,U,5),X=$P(LR0,U,10) D DOC^LRX
 ;
 W !!,?7,"Provider: ",LRDOC
 W !,?7,"Specimen: ",$P(^LAB(61,LRSPEC,0),U)
 D ORU
 W !!,?30,"Specimen Collection Date: ",$$FMTE^XLFDT(LRCDT,"M")
 W !?5,"Test name",?30,"Result    units",?51,"Ref.   range",?66,"Site Code"
 S LRPO=0
 F  S LRPO=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO)) Q:LRPO'>0  S LRDATA=^(LRPO) D DATA Q:LRSTOP
 Q:LRSTOP
 ;
 I $D(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C")) D
 . W !,"Comment: " S LRCMNT=0
 . F  S LRCMNT=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) Q:LRCMNT<1  D  Q:LRSTOP
 . . W ^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)
 . . D CONT Q:LRSTOP
 . . W:$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) !?9
 Q:LRSTOP  D EQUALS^LRX
 W !?7,"KEY: ""L""=Abnormal low, ""H""=Abnormal high, ""*""=Critical value"
 S LRFOOT=1
 Q
 ; End -- Original TEST Code
 ;
TEST ; EP -- IHS/OIT/MKK - LR*5.2*1027 - IHS Modified TEST Code
 S LRIDT=+^TMP("LR",$J,"TP",LRAAO,LRCDT,-2)
 S LRSS=$P(^TMP("LR",$J,"TP",LRAAO),U,2)
 S LR0=$S($D(^(LRAAO,LRCDT))#2:^(LRCDT),1:""),LRTC=$P(LR0,U,12)
 I LRSS="MI" D  Q
 . S LRH=1 D:LRFOOT FOOT Q:LRSTOP
 . D EN1^LRMIPC
 . S LRHF=1,LRFOOT=0
 . K A,Z,LRH
 . S:LREND LREND=0,LRSTOP=1
 ;
 Q:'$G(LRCAN)&('$P(LR0,U,3))  D @$S(LRHF:"HDR",1:"CHECK") Q:LRSTOP
 ;
 I $P(XQY0,U)="LRRS"!($P(XQY0,U)="BLR LRRD BY MD")!($P(XQY0,U)="LRRS BY LOC")!($P(XQY0,U)="LRRD")!($P(XQY0,U)="LRRP2") D
 . I $$ADDON^BLRUTIL("LR*5.2*1013","BLRALAF",DUZ(2)) D ^BLRALAU
 ;
 S LRSPEC=+$P(LR0,U,5),X=$P(LR0,U,10) D DOC^LRX
 ;
 D ORU             ; Accession info
 ;
 W !,?5,"Provider: ",LRDOC
 D:'$G(BLRGUI) ESIGINFO^BLRUTIL3
 W !,?5,"Specimen:",$E($P(^LAB(61,LRSPEC,0),U),1,23)
 W ?42,"Spec Collect Date/Time:",$$FMTE^XLFDT(LRCDT,"2MZ")
 ;
 D COLHEADS
 ;
 S LRPO=0
 F  S LRPO=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO)) Q:LRPO'>0  S LRDATA=^(LRPO) D DATA Q:LRSTOP
 Q:LRSTOP
 ;
 I $D(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C")) D
 . W !,"Comment: " S LRCMNT=0
 . F  S LRCMNT=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) Q:LRCMNT<1  D  Q:LRSTOP
 . . W ^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)
 . . D CONT Q:LRSTOP
 . . W:$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) !?9
 Q:LRSTOP
 D BOTTOMPG
 Q
 ;
COLHEADS ; EP - IHS/OIT/MKK - LR*5.2*1027
 ; W !!,"Test name"
 ; W ?19,"Result    units"
 W !,?25,"Res",!
 W "Test name"
 W ?18,"Result"
 W ?25,"Flg"
 W ?29,"units"
 W ?43,"Ref.   range"
 W ?60,"Site"
 W ?66,"Result Dt/Time"
 Q
 ;
BOTTOMPG ; EP - IHS/OIT/MKK - LR*5.2*1027
 NEW STR
 W !,$TR($J("",IOM)," ","=")
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030 -- Add "Abnormal" & make two lines
 S STR="KEY: A=Abnormal          L=Abnormal Low          H=Abnormal High"
 W !,$$CJ^XLFSTR(STR,IOM)
 S STR="*=Critical value          TR=Therapeutic Range"
 W !,$$CJ^XLFSTR(STR,IOM)
 ; ----- END IHS/OIT/MKK - LR*5.2*1030 -- Add "Abnormal" & make two lines
 S LRFOOT=1
 Q
 ; End - IHS/OIT/MKK - LR*5.2*1027 - IHS Modified TEST Code
 ; 
 ; DATA
DATAORIG ; EP -- IHS/OIT/MKK LR*5.2*1027 - Begin DATA Original Code
 N LR63DATA
 ;
 S LRTSTS=+LRDATA,LRPC=$P(LRDATA,U,5),LRSUB=$P(LRDATA,U,6)
 S X=$P(LRDATA,U,7) Q:X=""
 S LR63DATA=$$TSTRES^LRRPU(LRDFN,LRSS,LRIDT,$P(LRDATA,U,10),LRTSTS)
 S LRLO=$P(LR63DATA,"^",3),LRHI=$P(LR63DATA,"^",4),LRREFS=$$EN^LRLRRVF(LRLO,LRHI),LRPLS=$P(LR63DATA,"^",6),LRTHER=$P(LR63DATA,"^",7)
 I LRPLS S LRPLS(LRPLS)=LRPLS
 ;
 W !?5,$S($L($P(LRDATA,U,2))>20:$P(LRDATA,U,3),1:$P(LRDATA,U,2))
 S X=$P(LR63DATA,"^")
 W ?27,@$S(LRPC="":"$J(X,LRCW)",1:LRPC)," ",$P(LR63DATA,"^",2)
 I $X>39 W !
 W ?40,$P(LR63DATA,U,5)
 I $X>50 W !
 W ?51,LRREFS K LRREFS
 ;
 I LRPLS'="" D
 . I $X>67 W !
 . W ?68,"[",LRPLS,"]"
 D CONT Q:LRSTOP
 ;
 I $O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,0))>0 D  Q:LRSTOP
 . S LRINTP=0
 . F  S LRINTP=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,LRINTP)) Q:LRINTP<1  W !?7,"Eval: ",^(LRINTP) D CONT Q:LRSTOP
 ;
 Q
 ; End -- Original DATA Code
 ;
DATA ; EP - Begin IHS/OIT/MKK - LR*5.2*1027 - IHS Modified DATA code
 N LR63DATA
 ;
 S LRTSTS=+LRDATA,LRPC=$P(LRDATA,U,5),LRSUB=$P(LRDATA,U,6)
 S X=$P(LRDATA,U,7) Q:X=""
 S LR63DATA=$$TSTRES^LRRPU(LRDFN,LRSS,LRIDT,$P(LRDATA,U,10),LRTSTS)
 S LRLO=$P(LR63DATA,"^",3),LRHI=$P(LR63DATA,"^",4),LRREFS=$$EN^LRLRRVF(LRLO,LRHI),LRPLS=$P(LR63DATA,"^",6),LRTHER=$P(LR63DATA,"^",7)
 I LRPLS S LRPLS(LRPLS)=LRPLS
 ;
 W !,$S($L($P(LRDATA,U,2))>15:$P(LRDATA,U,3),1:$P(LRDATA,U,2))
 S X=$P(LR63DATA,"^")
 ; W ?16,@$S(LRPC="":"$J(X,LRCW)",1:LRPC)," ",$P(LR63DATA,"^",2)
 W ?16,@$S(LRPC="":"$J(X,LRCW)",1:LRPC)
 W ?26,$P(LR63DATA,"^",2)
 W ?29,$P(LR63DATA,"^",5)
 I $G(LRREFS)["$S(" D MUMPRNGE(.LRREFS)
 W ?43,$E(LRREFS,1,15)  K LRREFS
 W ?55,$S(LRTHER:"(TR)",1:"")
 ;
 I LRPLS'="" W ?59,$J("["_LRPLS_"]",6)
 W ?66,$$GETCOMPD
 ;
 D CONT Q:LRSTOP
 ;
 I $O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,0))>0 D  Q:LRSTOP
 . S LRINTP=0
 . F  S LRINTP=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,LRINTP)) Q:LRINTP<1  W !?7,"Eval: ",^(LRINTP) D CONT Q:LRSTOP
 ;
 Q
 ;
MUMPRNGE(RANGE) ; EP -- MUMPS Code in Reference Range -- Evaluate and store
 NEW LOW,HIGH,RV1,RV2
 ;
 S LOW=$$TRIM^XLFSTR($P(RANGE,"-"),"LR"," ")
 S HIGH=$$TRIM^XLFSTR($P(RANGE,"-",2),"LR"," ")
 ;
 I $G(LOW)=""&($G(HIGH)="") S RANGE=" "  Q
 ;
 S RV1=$$MUMPEVAL(LOW)
 S RV2=$$MUMPEVAL(HIGH)
 ;
 I $G(RV1)=""&($G(RV2)="")  S RANGE=" "  Q
 ;
 S RANGE=RV1_" - "_RV2
 Q
 ;
MUMPEVAL(EVAL) ; EP
 NEW STR,WOT
 ;
 ; If no SELECT, just Return the string, BUT ... if the string contains punctuation, that means the
 ; reference range code has been mis-parsed.  Return NULL.
 I EVAL'["$S(" D  Q EVAL
 .  I EVAL["("!(EVAL["?")!(EVAL["<")!(EVAL[")")!(EVAL["&") S EVAL=""
 ;
 ; If there is an "(" in the string, but no ")", that means the reference range code is too complex
 ; and/or has been mis-parsed.  Return NULL.
 I EVAL'[")" Q ""
 ;
 S STR="WOT="_EVAL
 S @STR
 ;
 ; ANY punctuation in string means parsing failed.  Return NULL.
 I WOT["("!(WOT["?")!(WOT["<")!(WOT[")")!(WOT["&") S WOT=""
 ;
 Q WOT
 ;
GETCOMPD() ; EP -- Get Completion Date for test
 NEW LRAS,LRSS,STR
 NEW LRAA,LRAD,LRAN
 NEW COMPD,D3,LRAT,STR,TMPDT
 NEW LOG,VLABIEN
 ;
 S LRAS=$P(LR0,"^",6)
 I '$L(LRAS) Q " "
 ;
 ; If test still PENDING, there is no complete date -- return null
 S DATALN=+$P($P($G(^LAB(60,+$G(LRTSTS),0)),"^",5),";",2)
 I $$UP^XLFSTR($P($G(^LR(LRDFN,"CH",LRIDT,DATALN)),"^",1))["PEND" Q " "
 ;
 S (LRAA,LRAD,LRAN)=""
 I $$GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)<1 Q " "
 ;
 NEW TESTIEN
 S TESTIEN=+$P($G(LRDATA),"^",1)
 I TESTIEN<1 Q " "
 ;
 S COMPD=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TESTIEN,0)),"^",5)
 ;
 I +$G(COMPD)>2000000 Q $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; Completed date is null in Accession file; will try to get date
 ; from V-LAB file via the BLRTXLOG file
 S (VLABIEN,LOG)=0
 F  S LOG=$O(^BLRTXLOG("D",LRAS,LOG))  Q:LOG=""!(LOG'?.N)!(VLABIEN>0)  D
 . I $P($G(^BLRTXLOG(LOG,1)),"^",2)'="R" Q   ; STATUS is not RESULTED
 . I $P($G(^BLRTXLOG(LOG,0)),"^",6)'=TESTIEN Q    ; Wrong test
 . ;
 . S VLABIEN=$P($G(^BLRTXLOG(LOG,1)),"^",5)
 ;
 S COMPD=$P($G(^AUPNVLAB(+$G(VLABIEN),12)),"^",12)
 I +$G(COMPD)>2000000 Q $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; Still null. Try to find the test in the V LAB file and use test's
 ; Accession #, IEN, and Collection Date to match
 S VLABIEN=""
 F  S VLABIEN=$O(^AUPNVLAB("ALR0",LRAS,VLABIEN))  Q:+$G(VLABIEN)<1!($G(COMPD)'="")  D
 . I $P($G(^AUPNVLAB(VLABIEN,0)),"^")'=TESTIEN Q      ; If TEST doesn't match, skip
 . ; Collection Date/Time match only down to minutes, not seconds
 . I $E($P($G(^AUPNVLAB(VLABIEN,12)),"^",1),1,12)'=$E($P(LR0,"^"),1,12) Q
 . ;
 . S COMPD=$P($G(^AUPNVLAB(+$G(VLABIEN),12)),"^",12)
 ;
 I +$G(COMPD)>2000000 Q $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; If still null, use the Lab Data File's DATE REPORT COMPLETED Date
 ; that's stored in the LR0 variable
 S COMPD=$P(LR0,"^",3)
 I +$G(COMPD)>2000000 Q $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; All results dates checked and nothing found, so quit with null
 Q " "
 ;
 ; End - IHS/OIT/MKK - LR*5.2*1027 - IHS Modified DATA Code
 ;
CHECK I LRTC+11>(IOSL-$Y) D FOOT Q:LRSTOP  D HDR
 Q
 ;
 ; Begin CONT Original Code -- IHS/OIT/MKK LR*5.2*1027 
 ; CONT
CONTORIG I $Y+5>IOSL D FOOT Q:LRSTOP  D HDR W !?20,">> CONTINUATION OF ",$P(LR0,U,6)," <<",!
 Q   ; End CONT Original Code
 ;
CONT ; EP - Begin IHS/OIT/MKK - LR*5.2*1027 -- IHS Modified CONT code
 Q:($Y+5)<IOSL
 ;
 D BOTTOMPG
 D FOOT
 Q:LRSTOP
 ;
 D HDR
 W !!,$$CJ^XLFSTR(">> CONTINUATION OF "_$P(LR0,U,6)_" <<",IOM)
 D COLHEADS
 Q
 ; End IHS/OIT/MKK - LR*5.2*1027 -- IHS Modified CONT code
 ;
 ;
 ; BEGIN -- Origianl VA FOOT code -- IHS/OIT/MKK LR*5.2*1027 - 
 ; FOOT
FOOTORIG ;from LRRP, LRRP2, LRRP3
 Q:LRSTOP  F I=$Y:1:IOSL-4 W !
 I $E(IOST,1,2)'="C-" W !,PNM,?40,"  ",SSN,"  ",$$HTE^XLFDT($H,"M"),! Q
 W !,PNM,?25,"  ",SSN,"  ",$$HTE^XLFDT($H,"MP"),?59," PRESS '^' TO STOP "
 R X:DTIME S:X="" X=1 S:(".^"[X)!('$T) LRSTOP=1
 Q
 ; END -- Origianl VA FOOT code
 ;
 ; From LRRP, LRRP2, LRRP3
FOOT ;EP - Begin IHS/OIT/MKK - LR*5.2*1027 - IHS Modified FOOT Code
 Q:LRSTOP                              ; If stop, then quit
 Q:+$G(LREND)!(+$G(LRIDT)>+$G(LREDT))  ; Double check to stop -- IHS/OIT/MKK - LR*5.2*1030
 ;
 NEW LRIRAP,WOTERR
 ;
 S LRIRAP=$$GET1^DIQ(9009029,+$G(DUZ(2)),"INTERIM REPORT ADDRESS PAGE",,,"WOTERR")
 I $G(LRIRAP)="NO"!($G(LRIRAP)="")  D
 . NEW NUMSITES,WOTSITE
 . S (NUMSITES,WOTSITE)=0
 . F  S WOTSITE=$O(LRPLS(WOTSITE))  Q:WOTSITE=""  D
 .. S NUMSITES=NUMSITES+1
 .. I +$L($$NAME^XUAF4(WOTSITE))+$L($$PADD^XUAF4(WOTSITE))>IOM S NUMSITES=NUMSITES+1
 . W !
 . W:$Y'<(IOSL-(5+NUMSITES)) !
 . F I=$Y:1:(IOSL-(5+NUMSITES)) W !    ; Get to "bottom" of the page
 . D SITELIST^LRRP2                  ; Print sites & addresses
 ;
 ; Check again due to TRUE issues with the ELSE statement.
 I $G(LRIRAP)="YES" F I=$Y:1:(IOSL-4) W !     ; "Go to" bottom of the page
 ;
 I $E(IOST,1,2)'="C-" D  Q
 . NEW DONOTF                                    ; DO NOT FILE flag
 . S DONOTF=$$GET1^DIQ(9009029,+$G(DUZ(2))_",3","INTERIM REPORT DO NOT FILE")
 . I $G(DONOTF)["Y" W !,"INTERIM REPORT DO NOT FILE",?30,$E(PNM,1,23),"   HRCN:",HRCN,?70,LRDT0,!
 . I $G(DONOTF)'["Y" W PNM,"   HRCN:",HRCN,?70,LRDT0,!
 ;
 W !,$E(PNM,1,23),?28,HRCN,?40,LRDT0
 R ?60,"PRESS '^' TO STOP ",X:DTIME S:X="" X=1 S:(".^"[X)!('$T) LRSTOP=1
 Q
 ; End - IHS/OIT/MKK - LR*5.2*1027 - IHS Modified FOOT Code
 ;
 ; BEGIN -- Original VA HDR code -- IHS/OIT/MKK LR*5.2*1027 - 
 ; HDR
HDRORIG ; Add Printed at, page #, change age to dob 7/2002 cka 
 W:($G(LRJ02))!($G(LRJ0))!($E(IOST,1,2)="C-") @IOF
 S LRHF=0,LRJ02=1
 I '$D(LRPG) S LRPG=0
 S LRPG=LRPG+1
 I $E(IOST,1)="P" D
 .W !!!!
 .S X="CLINICAL LABORATORY REPORT"
 .W ?(80-$L(X)\2),X,!
 I $D(DUZ("AG")),$L(DUZ("AG")),"ARMYAFN"[DUZ("AG") D ^LRAIPRIV W !
 W "Printed at: ",?65,"page ",LRPG
 W !,$$NAME^XUAF4(DUZ(2))," (",DUZ(2),")"
 S X=$$PADD^XUAF4(DUZ(2))
 W !,$P(X,U)," ",$P(X,U,2),", ",$P(X,U,3)," ",$P(X,U,4)
 W !!,PNM,?44,"Report date: ",$$HTE^XLFDT($H,"M")
 W !?5,"SSN: ",SSN,"    SEX: ",SEX,"    DOB: ",$$FMTE^XLFDT(DOB),"    LOC: ",LROC
 Q
 ;
 ; END -- Original VA HDR code
 ;
HDR ; EP - Begin IHS/OIT/MKK - LR*5.2*1027 - IHS Modified HDR Code
 W:($G(LRJ02))!($G(LRJ0))!($E(IOST,1,2)="C-") @IOF
 S LRHF=0,LRJ02=1
 I '$D(LRPG) S LRPG=0
 S LRPG=LRPG+1
 I $E(IOST,1)="P" W !!!!,$$CJ^XLFSTR("CLINICAL LABORATORY REPORT",IOM),!
 I $D(DUZ("AG")),$L(DUZ("AG")),"ARMYAFN"[DUZ("AG") D ^LRAIPRIV W !
 W "Printed at: ",?65,"page ",LRPG     ; IHS/OIT/MKK - LR*5.2*1028
 D LABHDR^BLRUTIL2
 W !,PNM,?45,"Date/Time Printed: ",$$FMTE^XLFDT($$NOW^XLFDT,"2MZ")
 ;
 NEW AGE
 I +$P($G(^LR(LRDFN,0)),"^",2)=2 S DOB=$$DOB^AUPNPAT(+$P($G(^LR(LRDFN,0)),"^",3))   ; GIMC Correction
 I DOB>0 D
 . S AGE=$$UP^XLFSTR($$DATE^LRDAGE(DOB))    ; Age as of Today
 . S:AGE["YR" AGE=+AGE                      ; If Age in Years, get rid of "YR" string.
 ;
 W !?5,"HRCN:",HRCN
 ; W ?25,"SEX:",SEX
 ; W ?35,"DOB:",$S(DOB>0:$$FMTE^XLFDT(DOB),1:" ")
 ; W:+$G(AGE)>0 ?54,"CURRENT AGE:",AGE
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
 W ?20,"SEX:",SEX
 W ?27,"DOB:",$S(DOB>0:$$FMTE^XLFDT(DOB),1:" ")
 W:+$G(AGE)>0 ?45,"CURRENT AGE:",AGE
 NEW LOCIEN,LOCDESC
 S LOCIEN=+$P($P(LR0,"^",13),";")
 S LOCDESC=$P($G(^SC(LOCIEN,0)),"^")
 W:$L(LOCDESC)<1!($L(LOCDESC)>14) ?62,"LOC:",LROC
 W:$L(LOCDESC)>0&($L(LOCDESC)<15) ?62,"LOC:",LOCDESC
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 Q
 ; End - IHS/OIT/MKK - LR*5.2*1027 - IHS Modified HDR Code
 ;
ORU ; Display remote ordering info if available
 N LRX,IENS
 S LRX=$G(^LR(LRDFN,"CH",LRIDT,"ORU")),IENS=LRIDT_","_LRDFN_","
 D EN^DDIOL("Accession [UID]: "_$P(LR0,"^",6)_" ["_$P(LRX,"^")_"]","","!")
 I $P(LRX,"^",3) D
 . D EN^DDIOL("Ordering Site: "_$$GET1^DIQ(63.04,IENS,.33,""),"","!?2")
 . D EN^DDIOL(" Ordering Site UID: "_$P(LRX,"^",5),"","?43")
 I $P(LRX,"^",2) D EN^DDIOL("Collecting Site: "_$$GET1^DIQ(63.04,IENS,.32,""),"","!")
 Q
