ADGRPD ; IHS/ADC/PDW/ENM - PATIENT INQUIRY (NEW) 5/21/91 15:17 ;  [ 09/17/2002  4:12 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;;MAS VERSION 5.0;
 ;IHS/ANMC/RAM,LJF;
 ; -- added ;EP to labels FA and INP
 ;IHS/HQW/KML 2/12/97 replace $N with $O w/o changing functionality
 ;IHS/HQW/WAR 9/17/02 renamed rtn from version 5.0 to accomodate v5.3
 ;
SEL K DFN,DGRPOUT W ! S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC G Q:Y'>0 S DFN=+Y D EN G SEL
 ;
EN ;call to display patient inquiry - input DFN
 D CHECK^DGPMV ;convert on the fly - remove after v5
 K DGRPOUT,DGHOW S DGABBRV=$S($D(^DG(43,1,0)):+$P(^(0),"^",38),1:0),DGRPU="UNSPECIFIED" D DEM^VADPT,HDR F I=0,.11,.13,.121,.31,.32,.36,.361 S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
 S DGAD=.11,(DGA1,DGA2)=1 D A^DGRPU S DGTMPAD=0 I $P(DGRP(.121),"^",9)="Y" S DGTMPAD=$S('$P(DGRP(.121),"^",8):1,$P(DGRP(.121),"^",8)'<DT:1,1:0) I DGTMPAD S DGAD=.121,DGA1=1,DGA2=2 D A^DGRPU
 W "Address: ",$S($D(DGA(1)):DGA(1),1:"NONE ON FILE"),?40,"Temporary: ",$S($D(DGA(2)):DGA(2),1:"NO TEMPORARY ADDRESS")
 S I=2 F I1=0:0 S I=$O(DGA(I)) Q:'I  W:(I#2)!($X>50) !?9 W:'(I#2) ?51 W DGA(I)
 S DGCC=+$P(DGRP(.11),U,7),DGST=+$P(DGRP(.11),U,5),DGCC=$S($D(^DIC(5,DGST,1,DGCC,0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)]"":" ("_$P(^(0),U,3)_")",1:""),1:DGRPU) W !?1,"County: ",DGCC
 S X="NOT APPLICABLE" I DGTMPAD S Y=$P(DGRP(.121),U,7) X:Y]"" ^DD("DD") S X=$S(Y]"":Y,1:DGRPU)_"-",Y=$P(DGRP(.121),U,8) X:Y]"" ^DD("DD") S X=X_$S(Y]"":Y,1:DGRPU)
 W ?42,"From/To: ",X,!?2,"Phone: ",$S($P(DGRP(.13),U,1)]"":$P(DGRP(.13),U,1),1:DGRPU),?44,"Phone: ",$S('DGTMPAD:X,$P(DGRP(.121),U,10)]"":$P(DGRP(.121),U,10),1:DGRPU) K DGTMPAD
 W !?1,"Office: ",$S($P(DGRP(.13),U,2)]"":$P(DGRP(.13),U,2),1:DGRPU) I 'DGABBRV W !?4,"POS: ",$S($D(^DIC(21,+$P(DGRP(.32),"^",3),0)):$P(^(0),"^",1),1:DGRPU),?42,"Claim #: ",$S($P(DGRP(.31),"^",3)]"":$P(DGRP(.31),"^",3),1:"")
 I 'DGABBRV W !?2,"Relig: ",$S($D(^DIC(13,+$P(DGRP(0),"^",8),0)):$P(^(0),"^",1),1:DGRPU),?46,"Sex: ",$P(VADM(5),"^",2)
 S X1=DGRP(.36),X=$P(DGRP(.361),"^",1) W !!,"Primary Eligibility: ",$S($D(^DIC(8,+X1,0)):$P(^(0),"^",1)_" ("_$S(X="V":"VERIFIED",X="P":"PENDING VERIFICATION",X="R":"PENDING REVERIFICATION",1:"NOT VERIFIED")_")",1:DGRPU)
 W !,"Other Eligibilities: " F I=0:0 S I=$O(^DIC(8,I)) Q:'I  I $D(^DIC(8,I,0)),I'=+X1 S X=$P(^(0),"^",1)_", " I $D(^DPT("AEL",DFN,I)) W:$X+$L(X)>79 !?21 W X
 ;D ^DGMT1 I 'DGABBRV F I=$Y:1:20 W !  ;IHS
 I 'DGABBRV F I=$Y:1:20 W !
 I 'DGABBRV S DIR(0)="E" D ^DIR K DIR S:'Y DGRPOUT=1 G:'Y Q D HDR
 S VAIP("L")="" D INP,SA
Q D KVA^VADPT K %DT,DGA,DGABBRV,I,LDM,X,I1,DGAD,DGA1,DGA2,DGMTLL,DGRP,DGRPU,DGS,DGXFR0,X1,VA,Y,DGCC,DGST,D0,D1,DIC,POP,SDCT Q
HDR I '$D(IOF) S IOP="HOME" D ^%ZIS K IOP
 W @IOF,!,$P(VADM(1),"^",1),?40,$P(VADM(2),"^",2),?65,$P(VADM(3),"^",2) S X="",$P(X,"=",78)="" W !,X,! Q
INP ;EP; called by ^ADGPI, ^ADGPM1 ;IHS added
 ;9/17/02 WAR Chgd call to reflect v5.3 rtn name change
 ;S VAHOW=2,VAIP("D")="L" D IN5^DGPMV10
 S VAHOW=2,VAIP("D")="L" D IN5^ADGPMV10
 S DGPMT=0 K ^UTILITY("VAIP",$J)
 ;9/17/02 WAR Chgd call to reflect v5.3 rtn name change
 ;D CS^DGPMV10 K DGPMT,DGPMIFN K:'$D(DGSWITCH) DGPMVI,DGPMDCD Q
 D CS^ADGPMV10 K DGPMT,DGPMIFN K:'$D(DGSWITCH) DGPMVI,DGPMDCD Q
SA F I=0:0 S I=$O(^DGS(41.1,"B",DFN,I)) G CL:'I S X=^DGS(41.1,I,0) I $P(X,"^",2)>(DT-1),$P(X,"^",13)']"",'$P(X,"^",17) S L=$P(X,"^",2) W !?18,"Scheduled Admit" D SAA
 Q
SAA W $S($D(^DIC(42,+$P(X,"^",8),0)):" on ward "_$P(^(0),"^",1),$D(^DIC(45.7,+$P(X,"^",9),0)):" for treating specialty "_$P(^(0),"^",1),1:"")," on ",$E(L,4,5),"/",$E(L,6,7),"/",$E(L,2,3) Q
CL G FA:$O(^DPT(DFN,"DE",0))="" S SDCT=0 F I=0:0 S I=$O(^DPT(DFN,"DE",I)) Q:'I  I $D(^(I,0)),$P(^(0),"^",2)'="I",$O(^(0)) S SDCT=SDCT+1 W:SDCT=1 !!,"Currently enrolled in " W:$X>50 !?22 W $S($D(^SC(+^(0),0)):$P(^(0),"^",1)_", ",1:"")
 ;
FA ;EP; called by ^ADGPI; IHS added
 S CT=0 W !!,"Future Appointments: " I $O(^DPT(DFN,"S",DT))="" W "NONE" G RMK
 W ?22,"Date",?32,"Time",?39,"Clinic",!?22 F I=22:1:75 W "="
 F FA=DT:0 S FA=$O(^DPT(DFN,"S",FA)) G RMK:'FA S L=^(FA,0),C=+L I $P(L,"^",2)'["C" D COV W !?22,$E(FA,4,5),"/",$E(FA,6,7),"/",$E(FA,2,3),$J(+$E(FA_"00",9,10)_":"_$E(FA_"0000",11,12),6),?39,$P($S($D(^SC(C,0)):^(0),1:""),"^")," ",COV Q:CT>5
 I $O(^DPT(DFN,"S",FA))>0 W !,"See Scheduling options for additional appointments."
RMK ;W !!,"Remarks: ",$P(^DPT(DFN,0),"^",10)  ;IHS
 W:$P(^DPT(DFN,0),"^",10)'="" !!,"Remarks: ",$P(^(0),"^",10)  ;IHS
 K ADM,TRN,DIS,SSN,FA,C,COV,NOW,CT,DGD,DGD1,I ;Y killed after dghinqky 
 Q
COV S COV=$S($P(L,"^",7)=7:" (Collateral) ",1:""),COV=COV_$S($P(L,"^",2)["N":" * NO-SHOW *",1:""),CT=CT+1 Q
 Q
 ;
OREN S XQORQUIT=1 Q:'$D(ORVP)  S DFN=+ORVP D EN R !!,"Press RETURN to CONTINUE: ",X:DTIME
 Q
