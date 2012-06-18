ABMDE1 ; IHS/ASDST/DMJ - CLAIM IDENTIFIERS-SCRN 1 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;    Added code to check when VT changes to check for
 ;    replacement insurer
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM22787
 ;    Fix for replacement insurer
 ;
OPT K ABM,ABMV,ABME
 S ABMP("OPT")="EVNJBQ"
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 S ABMP("VTYP")=$P(ABMP("C0"),U,7)
 D DISP
 W !
 D SEL^ABMDEOPT
 I "EV"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I $E(Y)="V" D ^ABMDE1A G OPT
 I $E(Y)="C" D ^ABMDECK G XIT:$D(ABMP("OVER")),OPT
 ;
EDIT ; Entry of Claim Identifiers
 S ABMP("FLDS")=8
 D FLDS^ABMDEOPT
 W !
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S DR=""
 F ABM("I")=1:1 S ABM=$P(ABMP("FLDS"),",",ABM("I")) Q:ABM=""  D
 .S:ABM("I")>1 DR=DR_";"
 .S DR=DR_$P($T(@ABM),";;",2)
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 D ^DIE
 ;edited visit type-check if it should mimic a different insurer/vt
 I DR[".07" D TPICHECK
 K DR
 G OPT
 ;
DISP ;
 S ABMZ("TITL")="CLAIM IDENTIFIERS"
 S ABMZ("PG")=1
 I '$D(ABMP("DDL")) D SUM^ABMDE1 I 1
 E  S ABMC("CONT")="" D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT
 ;
 D ^ABMDE1X
 ;
 W !?17,"[1] Clinic.............: ",ABM(6)
 W !?17,"[2] Visit Type.........: ",ABM(7)
 W !?17,"[3] Bill Type..........: ",ABM(12)
 W !?17,"[4] Billing From Date..: ",ABM(71)
 W !?17,"[5] Billing Thru Date..: ",ABM(72)
 W !?17,"[6] Super Bill #.......: ",ABM(11)
 W !?17,"[7] Mode of Export.....: ",$P($G(^ABMDEXP(+$G(ABMP("EXP")),0)),U)
 W !?17,"[8] Visit Location.....: ",$P($G(^DIC(4,+ABM(3),0)),U)
 D CNT^ABMDERR
 I ABM("ERR")>0 S ABM("ERROR")=""
 I +$O(ABME(0)) D
 .S ABME("CONT")=""
 .D ^ABMDERR
 .K ABME("CONT")
 Q
 ;
 ; Entry of Claim Identifiers
1 ;;.06T
2 ;;.07T
3 ;;.12T
4 ;;.71T
5 ;;.72T
6 ;;.11T
7 ;;.14T
8 ;;.03[8] Visit Location..
 ;
XIT ;
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 K ABM,ABMV,ABME
 Q
 ;
PAUSE ;EP - Entry Point for Page Pause and Header
 I $D(ABMC("CONT")),$D(ABMP("DDL")) D  G S4
 .K ABMC("CONT")
 .W $$EN^ABMVDF("IOF")
 I $E(IOST)="C",'$D(IO("S")) D   I $D(ABMP("DDL")) Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!$D(ABME("QUIT"))
 . K DIR
 . S DIR(0)="EO"
 . D ^DIR
 . K DIR
 W $$EN^ABMVDF("IOF")
 I $D(ABMP("DDL")) G S4
 I $D(ABMC("ERR")) G SUM
 Q
 ;
SUM ;EP - Entry Point for Page Header Summary
 I $D(ABMP("DDL")) G S3
 W $$EN^ABMVDF("IOF")
S2 ;
 W !
 S ABM("D")=""
 S ABM("PG")="  PAGE "_ABMZ("PG")_"  "
 S $P(ABM("D"),"~",(80-$L(ABM("PG"))/2)+1)=""
 W ABM("D"),ABM("PG"),ABM("D"),!
 W "Patient: ",$P(^DPT(ABMP("PDFN"),0),U)
 ;
HRN ;
 I ABMP("LDFN")]"" D
 . W " ",$S($D(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)):" [HRN:"_$P(^(0),U,2)_"]",1:" [no HRN]")
 W ?59,"Claim Number: ",ABMP("CDFN"),!
 I +ABMZ("PG")=8 D
 .W "Mode of Export: ",$P($G(^ABMDEXP(ABMP(ABMZ("PG")),0)),U),!
 S ABM("D")=""
 S ABM("TITL")=" ("_ABMZ("TITL")_") "
 S $P(ABM("D"),".",(80-$L(ABM("TITL"))/2)+1)=""
 W ABM("D"),ABM("TITL"),ABM("D"),!
 Q
 ;
S3 ;
 S ABM("D")=""
 S ABM("TITL")=" (PAGE "_ABMZ("PG")_" - "_ABMZ("TITL")_") "
 S $P(ABM("D"),".",(80-$L(ABM("TITL"))/2)+1)=""
 W !,ABM("D"),ABM("TITL"),ABM("D"),!
 Q
 ;
S4 ;
 W !
 S ABM("D")=""
 S ABM("PG")="  DETAILED CLAIM LISTING  "
 S $P(ABM("D"),"~",(80-$L(ABM("PG"))/2)+1)=""
 W ABM("D"),ABM("PG"),ABM("D"),!
 W "Patient: ",$P(^DPT(ABMP("PDFN"),0),U),?59,"Claim Number: ",ABMP("CDFN"),!
 S ABM("D")=""
 S ABM("TITL")=" (PAGE "_ABMZ("PG")_" - "_ABMZ("TITL")_") "
 S $P(ABM("D"),".",(80-$L(ABM("TITL"))/2)+1)=""
 W ABM("D"),ABM("TITL"),ABM("D"),!
 Q
TPICHECK ;EP
 S ABMDVTCK=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,7) ;vt
 ;loop thru insurers on claim removing existing replacments
 S ABMINSI=0
 F  S ABMINSI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINSI)) Q:+ABMINSI=0  D
 .S ABMINS=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINSI,0)),U)
 .D RMVRPLC  ;remove replacement insurer from claim
 .I ABMP("INS")=ABMINS D  ;this is the active insurer; check for replacement
 ..S ABMVTEDT="",ABMVFLG=0
 ..;F  S ABMVTEDT=$O(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,"B",ABMVTEDT),-1) Q:ABMVTEDT=""  D  Q:ABMVFLG=1  ;abm*2.6*9 HEAT28364
 ..F  S ABMVTEDT=$O(^ABMNINS(ABMP("LDFN"),ABMINS,1,ABMDVTCK,12,"B",ABMVTEDT),-1) Q:ABMVTEDT=""  D  Q:ABMVFLG=1  ;abm*2.6*9 HEAT28364
 ...S ABMVIEN=0
 ...;F  S ABMVIEN=$O(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,"B",ABMVTEDT,ABMVIEN)) Q:ABMVIEN=""  D  Q:ABMVFLG=1  ;abm*2.6*9 HEAT28364
 ...F  S ABMVIEN=$O(^ABMNINS(ABMP("LDFN"),ABMINS,1,ABMDVTCK,12,"B",ABMVTEDT,ABMVIEN)) Q:ABMVIEN=""  D  Q:ABMVFLG=1  ;abm*2.6*9 HEAT28364
 ....;I $P($G(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,2)="" S ABMVFLG=1 Q  ;abm*2.6*9 HEAT28364
 ....I $P($G(^ABMNINS(ABMP("LDFN"),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,2)="" S ABMVFLG=1 Q  ;abm*2.6*9 HEAT28364
 ....;I $P($G(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,2)'="",($P(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,ABMVIEN,0),U,2))>($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,2)) S ABMVFLG=1 Q  ;abm*2.6*9 HEAT28364
 ....I $P($G(^ABMNINS(ABMP("LDFN"),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,2)'="",($P(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,ABMVIEN,0),U,2))>($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,2)) S ABMVFLG=1 Q  ;abm*2.6*9 HEAT28364
 ..Q:ABMVFLG=0  ;no replacement--quit
 ..;change active insurer
 ..S DA=ABMP("CDFN")
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..;S DR=".08////"_$P($G(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,3)  ;abm*2.6*9 HEAT28364
 ..S DR=".08////"_$P($G(^ABMNINS(ABMP("LDFN"),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,3)  ;abm*2.6*9 HEAT28364
 ..D ^DIE
 ..;
 ..S DA(1)=ABMP("CDFN")
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ..S DA=ABMINSI
 ..;S DR=".011////"_$P($G(^ABMNINS(DUZ(2),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,3)  ;abm*2.6*9 HEAT28364
 ..S DR=".011////"_$P($G(^ABMNINS(ABMP("LDFN"),ABMINS,1,ABMDVTCK,12,ABMVIEN,0)),U,3)  ;abm*2.6*9 HEAT28364
 ..D ^DIE
 D ^ABMDEVAR
 Q
RMVRPLC ; if there's a replacement, is it the active insurer
 I ABMP("INS")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINSI,0)),U,11) D
 .S DA=ABMP("CDFN")
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DR=".08////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINSI,0)),U)
 .D ^DIE
 .S ABMP("INS")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,8)
 ;remove replacement
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 S DA=ABMINSI
 S DR=".011////@"
 D ^DIE
 Q
