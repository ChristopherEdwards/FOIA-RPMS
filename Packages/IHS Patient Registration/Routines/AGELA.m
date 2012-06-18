AGELA ; IHS/ASDS/EFG - Add/Edit Eligibility Display ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;ALLOW PROPER EXIT FROM PRIVATE SCREEN AFTER DELETING ENTRY
 Q:$G(AGELP("PH"))=""
 I '$D(^AUPN3PPH(AGELP("PH"))) D
 .S $P(^AUPN3PPH(AGELP("PH"),0),U)="VALIDATE"
 .S $P(^AUPN3PPH(AGELP("PH"),0),U,2)=$G(AGELP("PI"))
 .S $P(^AUPN3PPH(AGELP("PH"),0),U,3)=$G(AGELP("INS"))
 S AGV("X2")=AGELP("PH")_";"_$P(^AUPN3PPH(AGELP("PH"),0),U)
 S AGV("X3")=""
 D ^AGELE2X2
 K AGE
 I $P(^AUPN3PPH(AGELP("PH"),0),U,2)]"" S AGELP("PHPAT")=$P(^(0),U,2)
 E  I $P(^AUPN3PPH(AGELP("PH"),0),U,16)]"" S AGELP("EMPL")=$P(^(0),U,16)
 I '$D(IOF) D HOME^%ZIS
 ;header
HDR W $$S^AGVDF("IOF")
 S AG("PG")="4PVTA"
 S ROUTID=$P($T(+1)," ")
 D PROGVIEW^AGUTILS(DUZ)
 W !
 W "IHS REGISTRATION ",$S($D(AGSEENLY):"VIEW SCREEN",1:"EDITOR")
 W ?33,"Private Insurance"
 W ?80-$L($P(^DIC(4,DUZ(2),0),U)),$P(^DIC(4,DUZ(2),0),U)
 S AGLINE("-")=$TR($J(" ",80)," ","-")
 S AGLINE("EQ")=$TR($J(" ",80)," ","=")
 W !,AGLINE("EQ")
 I $G(AGPAT)'="" W !,$E(AGPAT,1,23)
 E  W !,$E($P($G(^DPT(DFN,0)),U),1,23)
 I $G(AGUPDT)'="" W ?23,AGUPDT
 I $G(AGCHRT)'="" W ?42,"HRN#:",AGCHRT
 E  W ?42,"HRN#:",$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 S AGELSTS=$P($G(^AUPNPAT(DFN,11)),U,12)
 W ?56,"(",$S(AGELSTS="C":"CHS & DIRECT",AGELSTS="I":"INELIGIBLE",AGELSTS="D":"DIRECT ONLY",AGELSTS="P":"PENDING VERIFICATION",1:"NONE"),")"
 W !,AGLINE("EQ")
 K DR,DIE,AG("ED"),AGDTS
DATA W !,"1) Policy Holder.: ",$E($P(^AUPN3PPH(AGELP("PH"),0),U),1,20) S AGEL("P")=$P(^(0),U,2)
 I AGEL("P")]"",'$D(^DPT(AGEL("P"),0)) S AGEL("P")=""
 I AGEL("P")="" W " [NOT REG]"
 W ?50,"|5)  Gender (M/F): "
 W $S($P(AGV("X2"),U,6)="M":"MALE",$P(AGV("X2"),U,6)="F":"FEMALE",1:"")
 W !,"2) Policy or SSN.: ",$P(^AUPN3PPH(AGELP("PH"),0),U,4)
 W ?50,"|6)  Date of Birth: "
 S AGEL("DT")=$P(AGV("X2"),U,7)
 D DT
 W AGEL("DT")
 W !,"3) Effective Date: "
 S AGEL("DT")=$P(^AUPN3PPH(AGELP("PH"),0),U,17)
 D DT
 W AGEL("DT")
 W ?50,"|7) Prim care Prov: "
 K PRVTNODE
 I $G(AGSELECT)'="" S PRVTNODE=$P($G(AGSELECT),U,11),PRVTNODE="^AUPNPRVT("_PRVTNODE_")"
 E  I $G(AGREC)'="" S PRVTNODE="^AUPNPRVT("_DFN_",11,"_AGREC_",0)"
 I $G(PRVTNODE)'="" W $P($G(@PRVTNODE),U,14)
 K PRVTNODE
 W !,"4) Expire Date...: "
 S AGEL("DT")=$P(^AUPN3PPH(AGELP("PH"),0),U,18)
 D DT
 W AGEL("DT")
 W ?55,$$GET1^DIQ(9000006.11,$G(AGELP("INS"))_","_DFN_",",.14)
 W !,"-HOLDER'S EMPLOYER INFO---------------------------------------------------------"
 W !,"8) Status........: "
 W $$GET1^DIQ(9000003.1,AGELP("PH"),.15)
 W ?40,"| 9) Employer: "
 W $$GET1^DIQ(9000003.1,AGELP("PH"),.16)
 W !,"-INSURER INFORMATION-----------------------------------------------------------"
 N AGINS
 S AGINS=$S(AGELP("INS")'="":$G(^AUTNINS(AGELP("INS"),0)),1:"")
 W !,$P(AGINS,U)   ;insurer name
 W ?40,"|10)  Grp Name: "
 I $P(^AUPN3PPH(AGELP("PH"),0),U,6)]"" D
 .S AGEL("EGRP")=$P(^AUPN3PPH(AGELP("PH"),0),U,6)
 .I $D(^AUTNEGRP(AGEL("EGRP"),0)) W $E($P(^(0),U),1,17)
 E  K AGEL("EGRP")
 W !?2,$P(AGINS,U,2)
 W ?40,"|     Grp Number: "
 I $D(AGEL("EGRP")),AGEL("EGRP")]"",$D(^AUTNEGRP(AGEL("EGRP"),0)) D
 .W $E($S(+$O(^AUTNEGRP(AGEL("EGRP"),11,0)):"(Visit Specific)",1:$P(^AUTNEGRP(AGEL("EGRP"),0),U,2)),1,17)
 W !?2,$P(AGINS,U,3)_", "        ;insurer city
 I $P(AGINS,U,4)'=""  D
 . W $P($G(^DIC(5,$P(AGINS,U,4),0)),U,2)_"  "   ;insurer state
 E  W "  "
 W $P(AGINS,U,5)                 ;insurer zip
 W ?40,"|11)  Coverage: "
 I $P($G(^AUPN3PPH(AGELP("PH"),0)),U,5)]"",$D(^AUTTPIC($P(^(0),U,5),0)) W $E($P(^(0),U),1,17)
 W !?2,$P(AGINS,U,6)             ;insurer phone
 W ?23,"Ins. Type: "
 W:$G(AGELP("INS"))'="" $P($G(^AUTNINS(AGELP("INS"),2)),U)
 I '$G(AGEL("IN")) S AGEL("IN")=$G(AGELP("INS"))
 S AGPRVIN0=$G(^AUPNPRVT(DFN,11,AGEL("IN"),0))
 W ?40,"|12)  CCopy: "
 W $P(AGPRVIN0,U,15)
 I $P($G(^AUPNPRVT(DFN,11,AGEL("IN"),0)),U,15)'="",$P($G(^AUPNPRVT(DFN,11,AGEL("IN"),0)),U,15)'="N" D
 .W ?62,"Date: "
 .S AGEL("DT")=$P(AGPRVIN0,U,16)
 .D DT
 .W AGEL("DT")
PHADD ;
E0 ;
E1 ;
E2 ;
MEM W !,"----Policy Members----PC-----Member #------HRN-----"
 W "Rel----------From/Thru-------"
 Q:$G(AGELP("INS"))=""
 S AGEL("DIC")=$S($P(^AUTNINS(AGELP("INS"),2),U)="D":"MCD",1:"PRVT")_"^AGELA1"
 D @AGEL("DIC")
 S AGELP("FLDS")=AGEL("I")+11
 W !
 F J=1:1:80 W "="
 K MYERRS,MYVARS
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="FINDPVT",MYVARS("SELECTION")=$G(AGSELECT),MYVARS("SITE")=DUZ(2)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 W !,$G(AGLINE("-"))
 D VERIF^AGUTILS
 W !,$G(AGLINE("EQ"))
XIT ;
 K ROUTID
 Q
DT ;
 I AGEL("DT")]"" S AGEL("DT")=$$FMTE^XLFDT(AGEL("DT"),5)
 Q
