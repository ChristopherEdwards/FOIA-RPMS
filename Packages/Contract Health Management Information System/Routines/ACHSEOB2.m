ACHSEOB2 ; IHS/ITSC/PMF - PROCESS EOBRS (3/6) - PRINT EOBR ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 U ACHSEOIO
 W @IOF
 I $P($P(^%ZIS(2,IOST(0),0),U,1),"-",1)="P",($D(^%ZIS(2,IOST(0),5))),$L($P(^(5),U,2)),$L($P(^(5),U,1)) W @($P(^%ZIS(2,IOST(0),5),U,2)) S IOM=90
 W !!?20,"+++  EXPLANATION OF BENEFITS REPORT  +++",!,ACHSTIME
 W !?5,"INDIAN HEALTH SERVICE",?47,"CONTRACT HEALTH SERVICES",!
 ;
 I +ACHSEOBR("A",8) W ?62,"CLAIM SEQ. COUNT ",$J(+$G(ACHSEOBR("A",8)),9)  ;CLAIM SEQUENCE COUNT
A ;
 W !!,"AREA OFFICE:   ",$E($P(^AUTTAREA($O(^AUTTAREA("C",ACHSEOBR("A",1),0)),0),U),1,17)
 W ?34,"CHECK NUMB.: ",$G(ACHSEOBR("A",9))
 W !!,"SERVICE UNIT:  ",$E($P(^AUTTSU($O(^AUTTSU("C",ACHSEOBR("A",1)_ACHSEOBR("A",2),0)),0),U),1,17)
 ;
 ; Labels begin in col 1 and 35.
 ; Begin print info in col 20 and 48.
 ;
 W ?34,"REMITTANCE.: ",$G(ACHSEOBR("A",10))
 W ?64,"DATE: ",$E(ACHSEOBR("A",11),5,6),"/",$E(ACHSEOBR("A",11),7,8),"/",$E(ACHSEOBR("A",11),1,4)
 ;
 W !!!,"PURCHASE ORDER NO: ",$G(ACHSEOBR("A",12))
 W ?34,"CONTROL NO.: ",$G(ACHSEOBR("A",13)),"-",$G(ACHSEOBR("A",5))
B ;
 W !!,"AUTHORIZING FAC..: ",$G(ACHSEOBR("A",14))
 W ?34,"PATIENT NAM: ",$G(ACHSEOBR("B",8)),!
 I $O(^AUTTLOC("C",ACHSEOBR("A",14),0)) W ?19,"(",$P(^AUTTLOC($O(^AUTTLOC("C",ACHSEOBR("A",14),0)),0),U,2),")"
 ;
 W !,"DOCUMENT TYPE....: ",$G(ACHSEOBR("A",15))
 W ?34,"HLTH REC NO: ",$G(ACHSEOBR("B",9))
 ;
 W !!,"AUTH. DATE.......: ",$$FMTE^XLFDT($G(ACHSEOBR("B",10))-17000000)
 W ?34,"ACTUAL DAYS:",?47,$G(ACHSEOBR("B",11))
 ;
 D RTRN^ACHS
 I $G(ACHSQUIT) D END Q
C ;
 W !!,"COMMON ACCTG NO..: ",$E($G(ACHSEOBR("C",8)),1,7)
 W ?34,"DRG........: ",$E($G(ACHSEOBR("C",8)),1,7)
 ; W ?47,"RATE QUOTE:" ; RQ is currently indicated with an "R" in the Contract number for those areas using RQ.   GTH 05-22-97
 ;
 W !,"INTEREST CAN.....: ",$G(ACHSEOBR("I",8))
 W ?34,"DIS. STATUS: ",$G(ACHSEOBR("B",13))
 W !!,"OBJECT CLASS CODE: ",$G(ACHSEOBR("C",9))
 W ?34,"SERV BILLED:"
 S X=$G(ACHSEOBR("C",10))
 W ?47,$S(X="A":"PROFESSIONAL",X="B":"INPATIENT",X="C":"OUTPAT",X="D":"DENTAL",X="E":"ANCILLARY",X="F":"NON-PATIENT SPECIFIC",1:"UNKNOWN")
 W !,"SERVICE CLASS CODE: ",$G(ACHSEOBR("B",14))
 W ?34,"INTERST OCC: ",$G(ACHSEOBR("I",9))
 W !!,"BLANKET IND......: ",$S($G(ACHSEOBR("C",11))="Y":"YES",$G(ACHSEOBR("C",11))="N":"NO",1:"??")
 W ?34,"CONTRACT NO: ",$G(ACHSEOBR("C",12))
 W !!,"INTERIM/FINAL IND: ",$S($G(ACHSEOBR("C",13))="F":"FINAL",$G(ACHSEOBR("C",13))="I":"INTERIM",1:"??")
 W ?34,"VENDOR NO..: ",$G(ACHSEOBR("C",16))
D ;
 W !!,"EST SERV DATES...: "
 I +$G(ACHSEOBR("C",14)) W $E(ACHSEOBR("C",14),5,6),"/",$E(ACHSEOBR("C",14),7,8),"/",$E(ACHSEOBR("C",14),1,4)
 ;
 W ?34,"VENDOR NAME: ",$E($G(ACHSEOBR("D",8)),1,30),!
 ;
 I +$G(ACHSEOBR("C",15)) W ?19,$E(ACHSEOBR("C",15),5,6),"/",$E(ACHSEOBR("C",15),7,8),"/",$E(ACHSEOBR("C",15),1,4)
 ;
 W !,"INTEREST RATE.(%): "
 S X=$G(ACHSEOBR("I",10))
 I X W $FN($E(X,1,2)_"."_$E(X,3,5),"",3)
 ;
 W !,"DAYS ELIGIBLE....: "
 W:+$G(ACHSEOBR("I",11)) ACHSEOBR("I",11)
 ;
 D RTRN^ACHS
 G END:$G(ACHSQUIT)
 ;
 S X=$G(ACHSEOBR("D",9))
 D FMT
 W !!!?19,"BILLED BY PROVIDER..........$",$G(X)
 S X=$G(ACHSEOBR("D",10))
 D FMT
 W !?19,"ALLOWABLE AMOUNT............$",$G(X)
 S X=$G(ACHSEOBR("D",11))
 D FMT
 W !?19,"AMOUNT PAID BY THIRD PARTY..$",$G(X)
E ;
 S X=$G(ACHSEOBR("E",8))
 D FMT
 W !?19,"FI PRINCIPLE PAYMENT........$",$G(X)
 S X=$G(ACHSEOBR("E",10))
 D FMT
 W !?19,$S($G(ACHSEOBR("E",9))=1:"P.O.NBR",$G(ACHSEOBR("E",9))=2:"SHR 424",1:"???????")," OBLIGATION AMOUNT...$",$G(X)
 ;
 S X=$G(ACHSEOBR("I",12))
 D FMT
 W !?19,"INTEREST PAID...............$",$G(X)
 ;
 S X=$G(ACHSEOBR("I",13))
 D FMT
 W !?19,"ADDITIONAL PENALTY PAID.....$",$G(X)
 ;
 S X=$G(ACHSEOBR("I",14))
 D FMT
 W !?19,"TOTAL PAID THIS TRANSACTION.$",$G(X)
 ;
 D RTRN^ACHS
 I $G(ACHSQUIT) D END Q
 ;
 W !!,"DIAGNOSIS CODES:"
 F ACHS=12:1:16 W "   ",$G(ACHSEOBR("E",ACHS))
 ;
 W !,"PROCEDURE CODES:"
 I $D(ACHSEOBR("G")) F ACHS=8:1:10 W "   ",$G(ACHSEOBR("G",ACHS))
 ;
 ;GET THE F ARRAY FIELDS FROM TMP GLOBAL   ;WHY DOES HE DO THIS?????
F ;
 D FHDR
F1 ;
 S ACHS=0
 F  S ACHS=$O(^TMP("ACHSEOB",$J,"F",ACHS)) Q:+ACHS=0  D
 .S ACHSX=$G(^TMP("ACHSEOB",$J,"F",ACHS))
 .I IO'=IO(0),$Y>(IOSL-8) D HDR,FHDR
 .K ACHSTEMP D REC2^ACHSEOBB(ACHSX,.ACHSTEMP)
 .W !,$E($G(ACHSTEMP("F",8)),5,6),"/",$E($G(ACHSTEMP("F",8)),7,8),"/"
 .W $E($G(ACHSTEMP("F",8)),3,4)," "
 .W $E($G(ACHSTEMP("F",9)),5,6),"/",$E($G(ACHSTEMP("F",9)),7,8),"/"
 .W $E($G(ACHSTEMP("F",9)),3,4)
 .S X="",ACHSZ=$G(ACHSTEMP("F",10))
 .F I=1:1:5 I $E(ACHSZ,I,I)'=" " S X=X_$E(ACHSZ,I,I)
 .W ?20,$J(X,5),?31,$G(ACHSTEMP("F",11)),?37,"$"
 .;S X=$E(ACHSX,43,51)
 .S X=$G(ACHSTEMP("F",12))
 .D FMT
 .W X,?51,"$"
 .;S X=$E(ACHSX,52,60)
 .S X=$G(ACHSTEMP("F",13))
 .D FMT
 .W X,?65,$G(ACHSTEMP("F",14)),?72,$G(ACHSTEMP("F",15))," ",$G(ACHSTEMP("F",16))
 Q
 ;
G ;
 N DIWL,DIWR,DIWF
 S DIWL=7,DIWR=79,DIWF="W"
 W !
 S ACHSMSG=""
 F  S ACHSMSG=$O(ACHSEOBR("M","B",ACHSMSG)) Q:ACHSMSG=""  W !,ACHSMSG," -" D GW
 D RTRN^ACHS
 ;
END ;
 I $P($P(^%ZIS(2,IOST(0),0),U,1),"-",1)="P",($D(^%ZIS(2,IOST(0),5))),$L($P(^(5),U,2)),$L($P(^(5),U,1)) W @($P(^%ZIS(2,IOST(0),5),U,1)) S IOM=80
 K ACHSEOBR("M")
 Q
 ;
GW ;
 S ACHSMSGN="MESSAGE NOT ON FILE"
 S ACHSZ="",ACHSZ=$O(^ACHSEOBM("B",ACHSMSG,ACHSZ))
 I 'ACHSZ W ?6,ACHSMSGN Q
GWA ;
 S ACHSY=0
 F  S ACHSY=$O(^ACHSEOBM(ACHSZ,1,ACHSY)) Q:+ACHSY=0  D
 .S X=$$SB^ACHS($$RPL^ACHS(^ACHSEOBM(ACHSZ,1,ACHSY,0),"  "," "))
 .D ^DIWP
 .I IO'=IO(0),$Y>(IOSL-8) D HDR
 D ^DIWW
 Q
 ;
FMT ;
 I X["*" S X=" *********" Q
 I X'["." S X=$E(X,1,$L(X)-2)_"."_$E(X,$L(X)-1,$L(X))
 S X=$J($FN(X,",P",2),11)
 Q
 ;
HDR ;
 W !!?32,"+++ Continued +++",@IOF,!!?16,"+++ EOBR FOR PURCHASE ORDER NO '",ACHSEOBR("A",12),"' +++",!?32,"+++ Continued +++",!,ACHSTIME,!!
 Q
 ;
FHDR ;
 W ?72,"TOOTH",!,"DATES OF SERVICE   PROCEDURE  UNITS   BILLED CHGS    ALLOWABLE    MSG  NBR SURF",!,"-----------------  ---------  -----  ------------  ------------  ----  --------"
 Q
 ;
