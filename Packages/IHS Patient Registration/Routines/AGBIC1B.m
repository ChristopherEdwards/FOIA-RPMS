AGBIC1B ; IHS/ASDS/EFG - WRITE BENEFICIARY ID CARD (BIC) ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
START ;Header question to print BIC card
 S Y="You have changed this patient's Eligibility."
 W *7,!!?40-($L(Y)\2)
 W $$S^AGVDF("RVN"),Y,$$S^AGVDF("RVF")
 W !!,"Do you want to print a BIC card? N//"
 D READ^AG
 Q:$D(DFOUT)!$D(DLOUT)!$D(DUOUT)!$D(DTOUT)
NAME ;
 S AGNAME=$P(^DPT(DFN,0),U)
 I AGNAME="" D  G DATERR
 . S AGITEM="AGNAME"
 S AGSSN=$P(^DPT(DFN,0),U,9)
 I AGSSN="" D  G DATERR
 . S AGITEM="AGSSN"
 S AGITEM="DOB"
 G:$P(^DPT(DFN,0),U,3)="" DATERR
 S AGDOB=$P(^DPT(DFN,0),U,3)
 S AGDOB=$$FMTE^XLFDT(AGDOB,"1D")
 S AGITEM="SEX"
 S AGSEX=$P(^DPT(DFN,0),U,2)
 G:AGSEX=""!("MF"'[AGSEX) DATERR
 S AGSEX=$S(AGSEX="M":"MALE",1:"FEMALE")
 ;Tribe Name & Facility
 S AGITEM="AGTRIBE"
 G:'$D(^AUPNPAT(DFN,11)) DATERR
 G:$P(^AUPNPAT(DFN,11),U,8)="" DATERR
 S AGTRIBE=$P(^AUTTTRI($P(^AUPNPAT(DFN,11),U,8),0),U)
 I AGTRIBE="" G DATERR
 S AGFACLTY=$P(^DIC(4,DUZ(2),0),U)
 I AGFACLTY="" D  G DATERR
 . S AGITEM="AGFACLTY"
 S AGITEM="FACILITY PHONE #"
 S AGFACPHN=""
 I AGFACPHN="" S AGFACPHN=$P(^AUTTLOC(DUZ(2),0),U,11)
 I AGFACPHN="" G DATERR
DT ;
 S AGDT=$$FMTE^XLFDT(DT,"1D")
 S AGXPHEAD="EXPIRES: "
 D EXPIRE
 I AGXPIRE="" S AGXPHEAD=""
DEV ;
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D  Q
 . S IOP=ION
 . D ^%ZIS
 I $D(IO("Q"))&(($D(IO("S")))!($E(IOST)'="P")) D  G DEV
 . W *7,!,"Please queue to system printers."
 . K IO("Q")
 . D ^%ZISC
 I $D(IO("Q")) D  Q
 . K IO("Q")
 . X ^%ZOSF("UCI")
 . S ZTRTN="PRNTCARD^AGBIC1B"
 . S ZTUCI=Y
 . S ZTDESC="BIC Card for "_AGNAME_"."
 . F G="AGFACLTY","AGFACPHN","AGNAME","AGSSN","AGDT","AGDOB","AGSEX","AGTRIBE","AGXPHEAD","AGXPIRE" S ZTSAVE(G)=""
 . D ^%ZTLOAD
 . G:'$D(ZTSK) DEV
 . K DIR
 . S DIR(0)="E"
 . S DIR("A")="Task Number = "_ZTSK_"  Press RETURN..."
 . D ^DIR
 . K AG,AGDT,AGDOB,AGSEX,AGXPHEAD,AGXPIRE,AGFACLTY,AGFACPHN,G,AGNAME
 . K AGSSN,AGTRIBE,ZTDESC,ZTRTN,ZTSAVE,ZTSK,ZTUCI
 . D ^%ZISC
PRNTCARD ;EP - TaskMan.
 U IO
 W $$S^AGVDF("IOF")
 F I=1:1:36 W "*"
 W !,"*",?6,"INDIAN HEALTH SERVICE",?35,"*"
 W !,"*",?16-($L(AGFACLTY)\2),AGFACLTY,?35,"*"
 W !,"*",?16-($L(AGFACPHN)\2),AGFACPHN,?35,"*"
 W !,"*",?35,"*",!,"*",?16-($L(AGNAME)\2),AGNAME,?35,"*"
 W !,"* SSN: ",$E(AGSSN,1,3),"-",$E(AGSSN,4,5),"-",$E(AGSSN,6,9),?35,"*"
 W !,"* DOB: ",AGDOB,?35,"*"
 W !,"* SEX: ",AGSEX,?14,"ISSUED: ",AGDT,?35,"*"
 W !,"* TRIBE: ",?35,"*",!,"* ",AGTRIBE,?14,?35,"* "
 W !,"*",AGXPHEAD,AGXPIRE,?35,"*",! F I=1:1:36 W "*"
 D ^%ZISC
 Q
DATERR ;Data error processing
 W !!,*7,"ERROR IN BIC INFORMATION: '",AGITEM
 W "' missing/incorrect.",!,*7,!,"The information must be"
 W " supplied/corrected before a card can be printed."
 W !,"Press Return..."
 D READ^AG
END ;End - close device and kill variables
 W $$S^AGVDF("IOF")
 D ^%ZISC
 K AG,AGDOB,AGDT,AGSEX,DFN,AGXPHEAD,AGXPIRE,AGFACLTY,AGFACPHN
 K AGFY,AGITEM,AGNAME,AGSSN,AGTRIBE,X,XY,Y
 Q
EXPIRE ;
 S AGXPIRE=""
 Q:$P(^DPT(DFN,0),U,3)=""
 Q:DT-$P(^DPT(DFN,0),U,3)'<180000
 Q:$P(^AUPNPAT(DFN,11),U,25)'="Y"
 S AGXPIRE=$$FMTE^XLFDT(DT+10000,"1D")
 Q
PRNTNOW ;
 D PTLK^AG
 Q:'$D(DFN)
 G NAME
