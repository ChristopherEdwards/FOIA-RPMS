AGED4A1 ; IHS/ASDS/EFG - PAGE 4 - INSURANCE SUMMARY PART 2;    
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
HEADING ;EP -
 D ^AGED
 W !,AGLINE("-")
 W !?0,"SEQ",?9,"INSURER",?33,"COVERAGE TYPE",?56,"ELIG BEGIN",?67,"-",?69,"ELIG END"
 W !?10,"SUBSCRIBER",?34,"POLICY NUMBER"
 W !,AGLINE("EQ")
 Q
ADDMSG ;EP - ELIGIBILITY MESSAGE
 W !!,"YOU HAVE ADDED NEW ELIGIBILITY, YOU MAY NEED TO RESEQUENCE INSURERS."
 H 2
 K ADDCHK
 Q
GUARDIS(CATREC) ;EP - DISPLAY GUARANTOR ON SEQUENCED DISPLAY. CALLED FROM AGED4A
 N CORECPTR,GLOREC,GUARPTR,GUARNAME
 I $P(CATREC,U,11)="" Q  ;W !?8,"NOTHING IN THE GUARANTOR FILE FOR THIS PATIENT" Q  ;IHS/OKCAO/POC 12/5/2005 REPORTED BY POC AG*7.1*1
 S CORECPTR=$P(CATREC,U,11)_",0)"
 ;S CORECPTR=$P(CATREC,U,9)_",0)"  ;IHS/SD/TPF AG*7.1*1 9/7/2005 NO IM
 S GLOREF="^AUPNGUAR("_CORECPTR
 I $G(@GLOREF)']"" Q  ;W !?8,"NO ENTRY IN THE GUARANTOR FIELD FOR THIS PATIENT" Q   ;IHS/OKCAO/POC 12/5/2005 REPORTED BY POC AG*7.1*1
 S GUARREC=$P($P($G(@GLOREF),U),";")
 S GUARGLO=U_$P($P($G(@GLOREF),U),";",2)
 S GUARPTR=GUARGLO_GUARREC_",0)"
 S GUARPO=$P($G(@GLOREF),U,3)
 I GUARGLO[("AUPNPAT") I $P($G(@GUARPTR),U) S GUARNAME=$P($G(^DPT($P(@GUARPTR,U),0)),U)
 E  S GUARNAME=$P(@GUARPTR,U)
 S Y=$P(CATREC,U,3) X ^DD("DD") S GUAREFF=Y
 S Y=$P(CATREC,U,4) X ^DD("DD") S GUAREND=Y
 W ?8,GUARNAME,?33,"GUARANTOR",?56,GUAREFF,?69,GUAREND
 W !?10,$P($G(^DPT(DFN,0)),U),?34,GUARPO
 Q
TPLDIS(CATREC) ;EP - DISPLAY THIRD PARTY LIABILITY ON SEQUENCED DISPLAY. CALLED FROM AGED4A
 N TPLPTR,INSURPTR,INSURNAM,POLNUM,TPLEFF,TPLEND,TPLRESP
 I $P(CATREC,U,11)="" Q  ;AG*7.1*2 IM20280
 S TPLPTR="^AUPNTPL("_$P(CATREC,U,11)_",0)"
 S TPLPTR2="^AUPNTPL("_$P(CATREC,U,11)_",1)"
 S INSURPTR=$P($G(@TPLPTR),U,2)
 S INSURNAM=$S($G(INSURPTR)'="":$P($G(^AUTNINS(INSURPTR,0)),U),1:"UNDEFINED")
 S POLNUM=$P($G(@TPLPTR),U,3)
 S TPLRESP=$P($G(@TPLPTR2),U)
 S Y=$P($G(@TPLPTR),U,4) X ^DD("DD") S TPLEFF=Y
 S Y=$P($G(@TPLPTR),U,5) X ^DD("DD") S TPLEND=Y
 W ?8,INSURNAM,?33,"TPL",?56,TPLEFF,?69,TPLEND
 W !?10,TPLRESP,?34,POLNUM
 Q
DISPCAT ;EP
DISPCATA ;
 S AGSEL=0
 Q:$G(CATPTR)=""
 ;I $D(CATPTR),('$D(AGCAT(CATPTR))) D  Q
 I $D(CATPTR),('$D(AGCAT(CATPTR))),($G(CATPTR)'="U") D  Q  ;AG*7.1*2 AG/SD/TPF 6/26/2006 PAGE 37 OF TASK ORDER
 .W !!
 .W !?10,"*** THIS PATIENT HAS NOTHING SET UP IN THIS CATEGORY. ***"
 .W !?10,"*** TO ENTER DATA INTO THIS CATEGORY, USE ""Sequence"". ***"
 .W !!
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 .;AG*7.1*2 AG/SD/TPF 6/26/2006 PAGE 37 OF TASK ORDER 
 .;D HEADING^AGED4A1  ;AG*7.1*2 AG/SD/TPF 6/26/2006 PAGE 37 OF TASK ORDER
 .;D DISPLAYN
 D HEADING^AGED4A1  ;AG*7.1*2 AG/SD/TPF 6/26/2006 PAGE 37 OF TASK ORDER
 I $D(CATPTR),('$D(AGCAT(CATPTR))) Q
 I $D(CATPTR),($D(AGCAT(CATPTR))) D
 .;S SQDT="",CNT=0
 .I $G(VIEWDT) S SQDT=VIEWDT+.01,CNT=0 K VIEWDT
 .E  S SQDT=DT+.01,CNT=0  ;AG*7.1*2 AG/SD/TPF 6/26/2006 PAGE 37 OF TASK ORDER
 .;S SQDT=DT+.01,CNT=0  ;IHS/SD/TPF 5/1/2006 AG*7.1*2 IM20494 ;AG*7.1*2 AG/SD/TPF
 .F  S SQDT=$O(AGCAT(CATPTR,SQDT),-1) Q:'SQDT  D
 ..S CNT=CNT+1
 ..Q:CNT>1
 ..W !,"SEQ DATE: ",$E(SQDT,4,5)_"/"_$E(SQDT,6,7)_"/"_($E(SQDT,1,3)+1700)
 ..W !
 ..I $D(AGFRMMSG) W ?5,$$S^AGVDF("RVN"),$$S^AGVDF("BLN"),"*** NEW "_AGFRMSG2_" SEQUENCE REQUIRED FOR ",AGFRMMSG," ***",$$S^AGVDF("BLF"),$$S^AGVDF("RVF")
 ..K AGFRMMSG,AGFRMSG2
 ..S SEQFLG=SQDT
 ..S AGSEL=0
 ..F  S AGSEL=$O(AGCAT(CATPTR,SQDT,AGSEL)) Q:'AGSEL  D
 ...S CATREC=$G(AGCAT(CATPTR,SQDT,AGSEL))
 ...;REQUEST TO NOT DISPLAY INACTIVE ELIGIBILITIES WOULD GO HERE
 ...;ATTACHMENT VIII.1 PATCH 2
 ...;DID ADRIAN CANCEL THIS REQUEST?
 ...;END CODE
 ...W !
 ...W ?1,AGSEL,"."
 ...I $P(CATREC,U,2)="G" D GUARDIS^AGED4A1(CATREC) Q
 ...I $P(CATREC,U,2)="T" D TPLDIS^AGED4A1(CATREC) Q
 ...;BEGIN NEW CODE AG*7.1*1 ITEM 2
 ...I $P(CATREC,U,2)="D",($P(CATREC,U)=2) D
 ....S IENS=$P(CATREC,U,11)
 ....Q:IENS=""
 ....S PARTDGLO="^AUPNMCR("_IENS_")"
 ....S PLANPTR=$P($G(@PARTDGLO),U,4)
 ....I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ....W ?8,"UNDEFINED"
 ....;END NEW CODE
 ...;IM  HANDLE RR WITH DD
 ...I $P(CATREC,U,2)="D",($P(CATREC,U)=1) D
 ....S IENS=$P(CATREC,U,11)
 ....Q:IENS=""
 ....S PARTDGLO="^AUPNRRE("_IENS_")"
 ....S PLANPTR=$P($G(@PARTDGLO),U,4)
 ....I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ....W ?8,"UNDEFINED"
 ...I $E($P(CATREC,U,5),1,1)="D" D
 ....S RECPTR=$E($P(CATREC,U,5),2,10)
 ....S STPTR=$P($G(^AUPNMCD(RECPTR,0)),U,4)
 ....I STPTR'="" W ?8,$P($G(^DIC(5,STPTR,0)),U,2)_" "
 ....I STPTR="" W ?8," "
 ....;I $P(CATREC,U,8)="" W "MEDICAID"
 ....;I $P(CATREC,U,8)="" W "UNDEFINED"  ;AG*7.1*1 ITEM 3C
 ....;AG*7.1*2 IM20270
 ....I $P(CATREC,U,8)="" W "MEDICAID" Q
 ....I $P(CATREC,U,8)'="" W ?8,$E($P($G(^AUTNINS($P(CATREC,U,8),0)),U),1,24)
 ...;I $E($P(CATREC,U,5),1,1)'="D" D
 ...I $E($P(CATREC,U,5),1,1)'="D",($P(CATREC,U,2)'="D") D
 ....I $P(CATREC,U)="" W !,"UNDEFINED" Q  ;IHS/SD/TPF AG*7.1*1 IM18805
 ....W ?8,$E($P($G(^AUTNINS($P(CATREC,U),0)),U),1,24)
 ...I ($P(CATREC,U,2)="D"),(($P(CATREC,U)'=1)),(($P(CATREC,U)'=2)) D
 ....W:$P(CATREC,U)'="" $P($G(^AUTNINS($P(CATREC,U),0)),U)
 ...W ?33,$P(CATREC,U,2)
 ...S EFF=$P(CATREC,U,3)
 ...I EFF'="" W ?56,$E(EFF,4,5)_"/"_$E(EFF,6,7)_"/"_($E(EFF,1,3)+1700)
 ...S END=$P(CATREC,U,4)
 ...I END'="" W ?69,$E(END,4,5)_"/"_$E(END,6,7)_"/"_($E(END,1,3)+1700)
 ...W ! S RECPTR=$P(CATREC,U,5)
 ...I $E(RECPTR)="D" W ?10,$P($G(^AUPNMCD($E(RECPTR,2,10),21)),U)
 ...I $E(RECPTR)="M" W ?10,$P($G(^AUPNMCR($E(RECPTR,2,10),21)),U)
 ...I $E(RECPTR)="R" W ?10,$P($G(^AUPNRRE($E(RECPTR,2,10),21)),U)
 ...I $E(RECPTR)="P" W ?10,$P($G(^AUPN3PPH($E(RECPTR,2,10),0)),U)
 ...W ?34,$P(AGCAT(CATPTR,SQDT,AGSEL),U,6)
 I $D(CATPTR),($D(AGCAT(CATPTR))) D
 .W !!?6,"*** THIS SEQUENCE REFLECTS THE LATEST PRIORITY SEQUENCE DATE ***"
 W !,$G(AGLINE("-")) D VERIF2^AGUTILS W !,AGLINE("EQ")
 K AG("ED"),AG("ERR"),DFOUT,DTOUT,DUOUT,DQOUT,DLOUT,DIROUT,DIR
 ;S DIR("A")="Enter S(equence), A(dd) insurer, E(dit) insurer, T(oggle seq category) "
 ;S DIR("?")="Enter an ""S"" to sequence insurers, a ""T"" to ""toggle"" to a category to see if there's anything in that category."
 S DIR("A")="Enter S(equence), A(dd) insurer, E(dit) insurer, T(oggle seq category)          V(iew) Historical Sequence Dates:"   ;AG*7.1*2 IHS/SD/TPF 6/26/2006 PAGE 36
 S DIR("?")="Enter an ""S"" to sequence insurers, a ""T"" to ""toggle"" to a category to see if there's anything in that category."
 S DIR(0)="FO^1:3" D ^DIR S X=Y,Y=$$UP^XLFSTR(X) S AGANS=Y K DIR
 I AGANS="V" D VPROMPT^AGED4A2(CATPTR) G DISPCATA  ;VIEW PROMPT AG*7.1*2 IHS/SD/TPF 6/26/2006 PAGE 37
 I AGANS="T" D CPROMPT^AGED4A Q:CATPTR="U"  G DISPCATA  ;TO ACCOMODATE CHANGE TO DEFAULT DISPLAY IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 2 PAGE 35
 I AGANS="S" D CPROMPT^AGED4A K:CATPTR="U" CATHD Q:CATPTR="U"  D:$G(CATPTR)'="U" SPROMPT^AGED4A S:$G(CATPTR)="U" AGANS="" G DISPCATA
 S CATPTR="U" K CATHD ;AG*7.1*2 IHS/SD/TPF 6/26/2006 PAGE 37 RESET TO SUMMARY PAGE IF EXITING SEQUENCE DISPLAY
 Q
DISPLAYN ;EP - MCR/RAILROAD
 ;IHS/SD/TPF 12/5/05 PER PATCH 1 ITEM 1, DISPLAY MCR PART D ON ITS OWN LINE.
DISPLAG ;
 S GLO="AGINSNN("""")"
 S OLDSEL=""
 F  S GLO=$Q(@GLO) Q:GLO=""  D
 .W !
 .S ISACTIVE=$P(@GLO,U,13)
 .S END=$P(@GLO,U,6)
 .I $L(GLO,",")>1 S SEL=$P($P(GLO,","),"(",2)
 .E  S SEL=$P($P(GLO,")"),"(",2)
 .I OLDSEL=SEL
 .E  W ?1,SEL,"."
 .I $P(@GLO,U,10)="D"!($P(@GLO,U,10)="K") D
 ..S MCDREC=$P(@GLO,U,11)
 ..S STPTR=$S(MCDREC="":"",1:$P($G(^AUPNMCD($P(MCDREC,","),0)),U,4))
 ..I STPTR'="" S ST=$P($G(^DIC(5,STPTR,0)),U,2)
 ..I STPTR'="" W ?8,ST
 ..I $P(@GLO,U,12)'="" W ?11,$E($P($G(^AUTNINS($P(@GLO,U,12),0)),U),1,24)
 ..;I $P(@GLO,U,12)="" W ?11,"MEDICAID"
 ..;I $P(@GLO,U,12)="" W ?11,"UNDEFINED"  ;IHS/SD/TPF 12/5/05 AG*7.1*1 ITEM 3C
 ..I $P(@GLO,U,12)="" W ?11,"MEDICAID"   ;;AG*7.1*2 IM20270
 .;I $P(@GLO,U,10)'="D"&($P(@GLO,U,10)'="K") W ?8,$E($P(@GLO,U),1,24)
 .I $P(@GLO,U,10)'="D"&($P(@GLO,U,10)'="K"),($P(@GLO,U,4)'="D") W ?8,$E($P(@GLO,U),1,24)
 .;BEGIN NEW CODE ;IHS/SD/TPF 12/5/05 AG*7.1*1 ITEM 2
 .I $P(@GLO,U,4)="D",($P(@GLO,U,2)=2) D  ;IHS/SD/TPF 5/2/2006 AG*7.1*2
 ..S IENS=$P(@GLO,U,11)
 ..Q:IENS=""
 ..S PARTDGLO="^AUPNMCR("_IENS_")"
 ..S PLANPTR=$P($G(@PARTDGLO),U,4)
 ..I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ..W ?8,"UNDEFINED"
 .;END NEW CODE
  .I $P(@GLO,U,4)="D",($P(@GLO,U,2)=1) D  ;IHS/SD/TPF 5/2/2006 AG*7.1*2
 ..S IENS=$P(@GLO,U,11)
 ..Q:IENS=""
 ..S PARTDGLO="^AUPNRRE("_IENS_")"
 ..S PLANPTR=$P($G(@PARTDGLO),U,4)
 ..I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ..W ?8,"UNDEFINED"
 .;END NEW CODE
 .I $P(@GLO,U,4)="D",($P(@GLO,U,2)'=1),($P(@GLO,U,2)'=2) D  ;IHS/SD/TPF 5/2/2006 AG*7.1*2
 ..S PLANPTR=$P($G(@GLO),U,2)
 ..I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ..W ?8,"UNDEFINED"
 .;END NEW CODE
 .W ?33,$S($P(@GLO,U,4)="T"!($P(@GLO,U,4)="W")!($P(@GLO,U,4)="G"):"",1:$P(@GLO,U,4))
 .S EFF=$P(@GLO,U,5)
 .I EFF'="" W ?56,$E(EFF,4,5)_"/"_$E(EFF,6,7)_"/"_($E(EFF,1,3)+1700)
 .I END'="" W ?69,$E(END,4,5)_"/"_$E(END,6,7)_"/"_($E(END,1,3)+1700)
 .W ?79,$S(ISACTIVE:"A",1:"I")
 .W !?10,$P(@GLO,U,8),?34,$P(@GLO,U,9)
 .S OLDSEL=SEL
 W !,$G(AGLINE("-"))
 W !,AGLINE("EQ")
 K AG("ED"),AG("ERR"),DFOUT,DTOUT,DUOUT,DQOUT,DLOUT,DIROUT,DIR
 Q:$G(AGANS)="S"
 I '$D(AGSEENLY) D
 .;I '$D(AGINS),$$NEEDTOSQ^AGUTILS(DFN,DUZ(2)) W !!!,"THIS PATIENT DOES NOT HAVE A SEQUENCE SET UP AND YOUR SITE REQUIRES SEQUENCING!!" S AGANS="S" D CPROMPT^AGED4A S AGANS="REQSEQ" Q  ;AG*7.1*1 SAC RTN SIZE
 .I $D(AGINS),$$NEEDTOSQ^AGUTILS(DFN,DUZ(2)) W !!!,"THIS PATIENT DOES NOT HAVE A SEQUENCE SET UP AND YOUR SITE REQUIRES SEQUENCING!!" S AGANS="S" G REQ  ;D CPROMPT^AGED4A S AGANS="REQSEQ" Q  ;AG*7.1*2 IM20351
 .;I $G(AGANS)'="E" S DIR("A")="Enter S(equence), A(dd) insurer, E(dit) insurer, T(oggle seq category) "
 .I $G(AGANS)'="E" D
 ..S DIR("A")="Enter S(equence), A(dd) insurer, E(dit) insurer, T(oggle seq category)"
 ..S DIR("A")=DIR("A")_"          V(iew) Historical Sequence Dates  "_$S($G(SHOWINAC):"L(ist active eligibilities)",1:"L(ist inactive eligibilities)")   ;AG*7.1*2 IHS/SD/TPF 6/26/2006 PAGE 36
 .;I $G(AGANS)'="E" S DIR("?")="Enter an ""S"" to sequence insurers, a ""T"" to ""toggle"" to a category to see if there's anything in that category."
 .I $G(AGANS)'="E" D
 ..S DIR("?")="Enter an ""S"" to sequence insurers, a ""T"" to"
 ..S DIR("?")=DIR("?")_" ""toggle"" to a category to see if there's anything in that category, or ""V"" to view sequences set up for this patient, or "_$S($G(SHOWINAC):"L to view active eligiblities",1:"L to view inactive eligibilities")_"."
 .I $G(AGANS)'="E" S DIR(0)="FO^1:3"
 .I $G(AGANS)="E" S DIR("A")="Enter the insurer number to edit. "
 .I $G(AGANS)="E" S DIR(0)="NO"
 .D ^DIR S X=Y,Y=$$UP^XLFSTR(X) S AGANS=Y K DIR
 .I AGANS="L" S SHOWINAC=$S(SHOWINAC=1:0,1:1) D ^AGINS
 I AGANS="V" D CPROMPT^AGED4A D:$G(CATPTR)'="U" VPROMPT^AGED4A2(CATPTR) S CATPTR="U" K CATHD D HEADING^AGED4A1 S:AGANS="A"!(AGANS="E") AGVIEWSQ=1 Q:AGANS="A"!(AGANS="E")  G DISPLAG  ;VIEW PROMPT AG*7.1*2 IHS/SD/TPF 6/26/2006 PAGE 37
 I AGANS="T" D CPROMPT^AGED4A D:$G(CATPTR)'="U" DISPCAT Q:$G(AGANS)="E"!($G(AGANS)="A")  D HEADING^AGED4A1 G DISPLAG  ;TO ACCOMODATE CHNAGE TO DEFAULT DISPLAY IHS/SD/TPF 4/12/2006 AG*7.1*2 ITEM 2 PAGE 35
REQ I AGANS="S" D  K AGANS G DISPLAG
 .D CPROMPT^AGED4A
 .D:$G(CATPTR)'="U" SPROMPT^AGED4A
 .S:$G(CATPTR)="U" AGANS="",CATPTR="U" K CATHD
 .D HEADING^AGED4A1
 I $D(AGSEENLY) S DIR(0)="FO^1:3",DIR("A")="Enter the insurer number to view. " D ^DIR S X=Y,Y=$$UP^XLFSTR(X),AGANS=Y K DIR
 Q
DISPINS ;EP - DISPLAY INSURERS
 S SEL=0
 F  S SEL=$O(AGINS(SEL)) Q:'SEL  D
 .S ISACTIVE=$P(AGINS(SEL),U,13)
 .W !
 .S END=$P(AGINS(SEL),U,6)
 .W ?1,SEL
 .;NEW CODE AG*7.1*1 ITEM 2
 .;I $P(AGINS(SEL),U,4)="D" D
 .I $P(AGINS(SEL),U,4)="D",($P(AGINS(SEL),U,2)=2) D  ;IHS/SD/TPF 5/2/2006 AG*7.1*2
 ..S IENS=$P(AGINS(SEL),U,11)
 ..Q:IENS=""
 ..S PARTDGLO="^AUPNMCR("_IENS_")"
 ..S PLANPTR=$P($G(@PARTDGLO),U,4)
 ..I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ..W ?8,"UNDEFINED"
 .;END NEW
 .I $P(AGINS(SEL),U,4)="D",($P(AGINS(SEL),U,2)'=2),($P(AGINS(SEL),U,2)'=1) D  ;IHS/SD/TPF 5/2/2006 AG*7.1*2
 ..S PLANPTR=$P($G(AGINS(SEL)),U,2)
 ..I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ..W ?8,"UNDEFINED"
 .;IM  HANDLE RR WITH DD ;IHS/SD/TPF 5/2/2006 AG*7.1*2
 .I $P(AGINS(SEL),U,4)="D",($P(AGINS(SEL),U,2)=1) D
 ..S IENS=$P(AGINS(SEL),U,11)
 ..Q:IENS=""
 ..S PARTDGLO="^AUPNRRE("_IENS_")"
 ..S PLANPTR=$P($G(@PARTDGLO),U,4)
 ..I PLANPTR'="" W ?8,$E($P($G(^AUTNINS(PLANPTR,0)),U),1,20) Q
 ..W ?8,"UNDEFINED"
 .I $P(AGINS(SEL),U,10)="D"!($P(AGINS(SEL),U,10)="K") D
 ..S MCDREC=$P(AGINS(SEL),U,11)
 ..S STPTR=$S(MCDREC="":"",1:$P($G(^AUPNMCD($P(MCDREC,","),0)),U,4))
 ..I STPTR'="" S ST=$P($G(^DIC(5,STPTR,0)),U,2)
 ..I STPTR'="" W ?8,ST
 ..I $P($G(AGINS(SEL)),U,12)'="" W ?11,$E($P($G(^AUTNINS($P(AGINS(SEL),U,12),0)),U),1,24) Q
 ..I $P($G(AGINS(SEL)),U,12)="" W ?11,"MEDICAID"
 .;I $P(AGINS(SEL),U,10)'="D"&($P(AGINS(SEL),U,10)'="K") W ?8,$E($P(AGINS(SEL),U),1,24)
 .I $P(AGINS(SEL),U,4)'="D" I $P(AGINS(SEL),U,10)'="D"&($P(AGINS(SEL),U,10)'="K") W ?8,$E($P(AGINS(SEL),U),1,24)
 .W ?33,$P(AGINS(SEL),U,4)
 .S EFF=$P(AGINS(SEL),U,5)
 .I EFF'="" W ?56,$E(EFF,4,5)_"/"_$E(EFF,6,7)_"/"_($E(EFF,1,3)+1700)
 .I END'="" W ?69,$E(END,4,5)_"/"_$E(END,6,7)_"/"_($E(END,1,3)+1700)
 .W !?10,$P(AGINS(SEL),U,8),?34,$P(AGINS(SEL),U,9)
 W !,AGLINE("EQ")
 K AG("ED"),AG("ERR")
 K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT,DIROUT,DIR
 Q:$G(AGANS)="S"
 Q:$G(AGVIEWSQ)  ;
 I '$D(AGSEENLY) D
 .;I $G(AGANS)'="E" S DIR("A")="Enter S(equence), A(dd) insurer, E(dit) insurer, T(oggle seq category) "
 .I $G(AGANS)'="E" D  ;AG*7.1*2 IHS/SD/TPF 6/26/2006 PAGE 36
 ..S DIR("A")="Enter S(equence), A(dd) insurer, E(dit) insurer, T(oggle seq category)"
 ..S DIR("A")=DIR("A")_"          V(iew) Historical Sequence Dates  "
 ..S DIR("A")=DIR("A")_$S($G(SHOWINAC):"L(ist active eligibilities)",1:"L(ist inactive eligibilities)")
 .;I $G(AGANS)'="E" S DIR("?")="Enter an ""S"" to sequence insurers, a ""T"" to ""toggle"" to a category to see if there's anything in that category."
 .I $G(AGANS)'="E" D
 ..S DIR("?")="Enter an ""S"" to sequence insurers, a ""T"" to ""toggle"" to a"
 ..S DIR("?")=DIR("?")_" category to see if there's anything in that category, or ""V"" to view sequences set up for this patient, or "_$S($G(SHOWINAC):"L to view active eligiblities",1:"L to view inactive eligibilities")_"."
 .I $G(AGANS)'="E" S DIR(0)="FO^1:3"
 .I $G(AGANS)="E" S DIR("A")="Enter the insurer number to edit. "
 .I $G(AGANS)="E" S DIR(0)="NO"
 .D ^DIR S X=Y,Y=$$UP^XLFSTR(X) S AGANS=Y K DIR
 .I AGANS="L" S SHOWINAC=$S(SHOWINAC=1:0,1:1) D ^AGINS
 I $D(AGSEENLY) D
 .S DIR(0)="FO^1:3"
 .S DIR("A")="Enter the insurer number to view. "
 .D ^DIR S X=Y,Y=$$UP^XLFSTR(X) S AGANS=Y K DIR
 Q
