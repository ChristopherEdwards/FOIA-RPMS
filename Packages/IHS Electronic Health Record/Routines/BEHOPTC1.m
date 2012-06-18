BEHOPTC1 ;MSC/IHS/MGH - Patcient Context Object;30-Dec-2010 13:51;PLS
 ;;1.1;BEH COMPONENTS;**004006**;Mar 20, 2007
 ;Copy o DGRPD
 ;ALB/MRL/MLR/JAN/LBD-PATIENT INQUIRY (NEW) ;11-Oct-2010 17:18;DU
 ;5.3;Registration;**109,124,121,57,161,149,286,358,436,445,489,498,506,513,518**;Aug 13, 1993
 ;IHS/ANMC/LJF  3/16/2001 removed limit on # of future appt to display
 ;
SEL K DFN,DGRPOUT W ! S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC G Q:Y'>0 S DFN=+Y N Y W ! S DIR(0)="E" D ^DIR G SEL:$D(DTOUT)!($D(DUOUT)) D EN G SEL
 ;
EN ;call to display patient inquiry - input DFN
 ;MPI/PD CHANGE
 S DGCMOR="UNSPECIFIED",DGMPI=$G(^DPT(+DFN,"MPI"))
 S DGLOCATN=$$FIND1^DIC(4,"","MX","`"_+$P(DGMPI,U,3)),DGLOCATN=$S(+DGLOCATN>0:$P($$NS^XUAF4(DGLOCATN),U),1:"NOT LISTED")
 I $D(DGMPI),$D(DGLOCATN) S DGCMOR=$P(DGLOCATN,"^")
 ;END MPI/PD CHANGE
 K DGRPOUT,DGHOW S DGABBRV=$S($D(^DG(43,1,0)):+$P(^(0),"^",38),1:0),DGRPU="UNSPECIFIED" D DEM^VADPT,HDR F I=0,.11,.13,.121,.31,.32,.36,.361,.141 S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
 S DGAD=.11,(DGA1,DGA2)=1 D A^DGRPU S DGTMPAD=0 I $P(DGRP(.121),"^",9)="Y" S DGTMPAD=$S('$P(DGRP(.121),"^",8):1,$P(DGRP(.121),"^",8)'<DT:1,1:0) I DGTMPAD S DGAD=.121,DGA1=1,DGA2=2 D A^DGRPU
 W ?1,"Address: ",$S($D(DGA(1)):DGA(1),1:"NONE ON FILE"),?40,"Temporary: ",$S($D(DGA(2)):DGA(2),1:"NO TEMPORARY ADDRESS")
 S I=2 F I1=0:0 S I=$O(DGA(I)) Q:I=""  W:(I#2)!($X>50) !?10 W:'(I#2) ?51 W DGA(I)
 S DGCC=+$P(DGRP(.11),U,7),DGST=+$P(DGRP(.11),U,5),DGCC=$S($D(^DIC(5,DGST,1,DGCC,0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)]"":" ("_$P(^(0),U,3)_")",1:""),1:DGRPU) W !?2,"County: ",DGCC
 S X="NOT APPLICABLE" I DGTMPAD S Y=$P(DGRP(.121),U,7) X:Y]"" ^DD("DD") S X=$S(Y]"":Y,1:DGRPU)_"-",Y=$P(DGRP(.121),U,8) X:Y]"" ^DD("DD") S X=X_$S(Y]"":Y,1:DGRPU)
 W ?42,"From/To: ",X,!?3,"Phone: ",$S($P(DGRP(.13),U,1)]"":$P(DGRP(.13),U,1),1:DGRPU),?44,"Phone: ",$S('DGTMPAD:X,$P(DGRP(.121),U,10)]"":$P(DGRP(.121),U,10),1:DGRPU) K DGTMPAD
 W !?2,"Office: ",$S($P(DGRP(.13),U,2)]"":$P(DGRP(.13),U,2),1:DGRPU)
 W !,"Bad Addr: ",$$EXTERNAL^DILFD(2,.121,"",$$BADADR^DGUTL3(+DFN))
 D CA
 I 'DGABBRV W !!?4,"POS: ",$S($D(^DIC(21,+$P(DGRP(.32),"^",3),0)):$P(^(0),"^",1),1:DGRPU),?42,"Claim #: ",$S($P(DGRP(.31),"^",3)]"":$P(DGRP(.31),"^",3),1:"UNSPECIFIED")
 I 'DGABBRV W !?2,"Relig: ",$S($D(^DIC(13,+$P(DGRP(0),"^",8),0)):$P(^(0),"^",1),1:DGRPU),?46,"Sex: ",$S($P(VADM(5),"^",2)]"":$P(VADM(5),"^",2),1:"UNSPECIFIED")
 I 'DGABBRV W ! D
 .N RACE,ETHNIC,PTR,VAL,X,DIWL,DIWR,DIWF
 .K ^UTILITY($J,"W")
 .S PTR=0 F  S PTR=+$O(^DPT(DFN,.02,PTR)) Q:'PTR  D
 ..S VAL=+$G(^DPT(DFN,.02,PTR,0))
 ..Q:$$INACTIVE^DGUTL4(VAL,1)
 ..S VAL=$$PTR2TEXT^DGUTL4(VAL,1) S:+$O(^DPT(DFN,.02,PTR)) VAL=VAL_", "
 ..S X=VAL,DIWL=0,DIWR=30,DIWF="" D ^DIWP
 .M RACE=^UTILITY($J,"W",0) S:$G(RACE(1,0))="" RACE(1,0)="UNANSWERED"
 .K ^UTILITY($J,"W")
 .S PTR=0 F  S PTR=+$O(^DPT(DFN,.06,PTR)) Q:'PTR  D
 ..S VAL=+$G(^DPT(DFN,.06,PTR,0))
 ..Q:$$INACTIVE^DGUTL4(VAL,2)
 ..S VAL=$$PTR2TEXT^DGUTL4(VAL,2) S:+$O(^DPT(DFN,.06,PTR)) VAL=VAL_", "
 ..S X=VAL,DIWL=0,DIWR=30,DIWF="" D ^DIWP
 .M ETHNIC=^UTILITY($J,"W",0) S:$G(ETHNIC(1,0))="" ETHNIC(1,0)="UNANSWERED"
 .K ^UTILITY($J,"W")
 .W ?3,"Race: ",RACE(1,0),?40,"Ethnicity: ",ETHNIC(1,0)
 .F X=2:1 Q:'$D(RACE(X,0))&'$D(ETHNIC(X,0))  W !,?9,$G(RACE(X,0)),?51,$G(ETHNIC(X,0))
 I '$$OKLINE(16) G Q
 S X1=DGRP(.36),X=$P(DGRP(.361),"^",1) W !!,"Primary Eligibility: ",$S($D(^DIC(8,+X1,0)):$P(^(0),"^",1)_" ("_$S(X="V":"VERIFIED",X="P":"PENDING VERIFICATION",X="R":"PENDING REVERIFICATION",1:"NOT VERIFIED")_")",1:DGRPU)
 W !,"Other Eligibilities: " F I=0:0 S I=$O(^DIC(8,I)) Q:'I  I $D(^DIC(8,I,0)),I'=+X1 S X=$P(^(0),"^",1)_", " I $D(^DPT("AEL",DFN,I)) W:$X+$L(X)>79 !?21 W X
 ;
 ;display the catastrophic disability review date if there is one
 D CATDIS
 ;
 I $G(DGPRFLG)=1 G Q:'$$OKLINE(19) D
 . N DGPDT,DGPTM
 . W !,$$REPEAT^XLFSTR("-",78)
 . S DGPDT="",DGPDT=$O(^DGS(41.41,"ADC",DFN,DGPDT),-1)
 . W !,"[PRE-REGISTER DATE:]  "_$S(DGPDT]"":$$FMTE^XLFDT(DGPDT,"1D"),1:"NONE ON FILE")
 . S DGPTM=$$OUTPTTM^SDUTL3(DFN)
 . I $P(DGPTM,U,2)]"" W !,"[PRIMARY CARE TEAM:] "_$P(DGPTM,U,2)
 . W !,$$REPEAT^XLFSTR("-",78)
 ; Check if patient is an inpatient and on a DOM ward
 ; If inpatient is on a DOM ward, don't display MT or CP messages
 ; If inpatient is NOT on a DOM ward, don't display CP message
 N DGDOM,DGDOM1,VAHOW,VAROOT,VAINDT,VAIP,VAERR
 G Q:'$$OKLINE(14)
 D DOM^DGMTR
 I '$G(DGDOM) D
 .D DIS^DGMTU(DFN)
 .D IN5^VADPT
 .I $G(VAIP(1))="" D DISP^IBARXEU(DFN,DT,3,1)
 .;IHS/ITSC/WAR 1/9/04 REM'd next line. IHS does not us co-pay enroll
 .;D DIS^EASECU(DFN)   ;Added for LTC III (DG*5.3*518)
 ;I 'DGABBRV,$E(IOST,1,2)="C-" F I=$Y:1:20 W !
 S VAIP("L")=""
 I $$OKLINE(14) D INP
 I '$G(DGRPOUT),($$OKLINE(17)) D SA
 ;MPI/PD CHANGE
Q D KVA^VADPT K %DT,D0,D1,DGA,DGA1,DGA2,DGABBRV,DGAD,DGCC,DGCMOR,DGDOM,DGLOCATN,DGMPI,DGRP,DGRPU,DGS,DGST,DGXFR0,DIC,DIR,DTOUT,DUOUT,DIRUT,DIROUT,I,I1,L,LDM,POP,SDCT,VA,X,X1,Y Q
CA ;Confidential Address
 W !!?1,"Confidential Address:  ",?44,"Confidential Address Categories:"
 N DGCABEG,DGCAEND,DGA,DGARRAY,DGERROR
 S DGCABEG=$P(DGRP(.141),U,7),DGCAEND=$P(DGRP(.141),U,8)
 I 'DGCABEG!(DGCABEG>DT)!(DGCAEND&(DGCAEND<DT)) D  Q
 .W !?9,"NO CONFIDENTIAL ADDRESS"
 .W !?1,"From/To: NOT APPLICABLE"
 S DGAD=.141,(DGA1,DGA2)=1
 D AL^DGRPU(30)
 D GETS^DIQ(2,DFN,".141*,","E","DGARRAY","DGERROR")
 ;Format Confidential Address categories
 N DGIEN,DGCAST
 S DGIEN=0
 S DGA2=2
 F  S DGIEN=$O(DGARRAY(2.141,DGIEN)) Q:'DGHIEN  D
 .S DGA(DGA2)=DGARRAY(2.141,DGIEN,.01,"E")
 .S DGCAST=DGARRAY(2.141,DGIEN,1,"E")
 .S DGA(DGA2)=DGA(DGA2)_"("_$S(DGCAST="YES":"Active",1:"Inactive")_")"
 .S DGA2=DGA2+2
 S I=0 F I1=0:0 S I=$O(DGA(I)) Q:I=""  W:(I#2)!($X>43) !?9 W:'(I#2) ?44 W DGA(I)
 W !?1,"From/To:  ",$$FMTE^XLFDT(DGCABEG)_"-"_$S(DGCAEND'="":$$FMTE^XLFDT(DGCAEND),1:"UNANSWERED")
 Q
HDR I '$D(IOF) S IOP="HOME" D ^%ZIS K IOP
 ;MPI/PD CHANGE
 N SSN
 S SSN=$$FMTSSN^BEHOPTCX($P(VADM(2),"^",1))
 W @IOF,!,$P(VADM(1),"^",1),?40,SSN,?65,$P(VADM(3),"^",2) S X="",$P(X,"=",78)="" W !,X,!?15,"COORDINATING MASTER OF RECORD: ",DGCMOR,! Q
 ;END MPI/PD CHANGE
INP S VAIP("D")="L" D INP^DGPMV10
 S DGPMT=0
 D CS^DGPMV10 K DGPMT,DGPMIFN K:'$D(DGSWITCH) DGPMVI,DGPMDCD Q
SA F I=0:0 S I=$O(^DGS(41.1,"B",DFN,I)) G CL:'I S X=^DGS(41.1,I,0) I $P(X,"^",2)>(DT-1),$P(X,"^",13)']"",'$P(X,"^",17) S L=$P(X,"^",2) D:$$OKLINE(17) SAA Q:$G(DGRPOUT)
 Q
SAA ;Scheduled Admit Data
 W !!?14,"Scheduled Admit"
 W:$D(^DIC(42,+$P(X,U,8),0)) " on ward "_$P(^(0),U)
 W:$D(^DIC(45.7,+$P(X,U,9),0)) " for treating specialty "_$P(^(0),U)
 W " on "_$$FMTE^XLFDT(L,"5DZ")
 Q  ;SAA
 ;
CL G FA:$O(^DPT(DFN,"DE",0))="" S SDCT=0 F I=0:0 S I=$O(^DPT(DFN,"DE",I)) Q:'I  I $D(^(I,0)),$P(^(0),"^",2)'="I",$O(^(0)) S SDCT=SDCT+1 W:SDCT=1 !!,"Currently enrolled in " W:$X>50 !?22 W $S($D(^SC(+^(0),0)):$P(^(0),"^",1)_", ",1:"")
 ;
FA G:'$$OKLINE(20) RMK
 S CT=0 W !!,"Future Appointments: " I $O(^DPT(DFN,"S",DT))'>0 W "NONE" G RMK
 W ?22,"Date",?33,"Time",?39,"Clinic",!?22 F I=22:1:75 W "="
 ;F FA=DT:0 S FA=$O(^DPT(DFN,"S",FA)) G RMK:'FA S L=^(FA,0),C=+L I $P(L,"^",2)'["C" D COV D  Q:CT>5  ;IHS/ANMC/LJF 3/16/2001
 F FA=DT:0 S FA=$O(^DPT(DFN,"S",FA)) G RMK:'FA S L=^(FA,0),C=+L I $P(L,"^",2)'["C" D COV D           ;IHS/ANMC/LJF 3/16/2001
 .N DGAPPT
 .S DGAPPT=$$FMTE^XLFDT($E(FA,1,12),"5Z")
 .W !?22,$P(DGAPPT,"@")
 .W ?33,$P(DGAPPT,"@",2)
 .W ?39,$P($S($D(^SC(C,0)):^(0),1:""),"^")," ",COV
 .Q
 I $O(^DPT(DFN,"S",FA))>0 W !,"See Scheduling options for additional appointments."
RMK I '$G(DGRPOUT),($$OKLINE(21)) W !!,"Remarks: ",$P(^DPT(DFN,0),"^",10)
 K ADM,L,TRN,DIS,SSN,FA,C,COV,NOW,CT,DGD,DGD1,I ;Y killed after dghinqky
 Q
COV S COV=$S($P(L,"^",7)=7:" (Collateral) ",1:""),COV=COV_$S($P(L,"^",2)["NT":" * NO ACTION TAKEN *",$P(L,"^",2)["N":" * NO-SHOW *",1:""),CT=CT+1 Q
 Q
 ;
OREN S XQORQUIT=1 Q:'$D(ORVP)  S DFN=+ORVP D EN R !!,"Press RETURN to CONTINUE: ",X:DTIME
 Q
OKLINE(DGLINE) ;DOES PAUSE/HEADER IF $Y EXCEEDS DGLINE
 ;
 ;IN:   DGLINE --MAX LINE COUNT W/O PAUSE
 ;OUT:  DGLINE[RETURNED] -- 0 IF TIMEOUT/UP ARROW
 ;      DGRPOUT[SET]     -- 1 IF "
 N X,Y  ;**286** MLR 09/25/00  Newing X & Y variables prior to ^DIR
 I $G(IOST)["P-" Q DGLINE ; if printer, quit
 I $Y>DGLINE N DIR S DIR(0)="E" D ^DIR D:Y HDR I 'Y S DGRPOUT=1,DGLINE=0
 Q DGLINE
 ;
CATDIS ;
 ;displays catastrophic disabity review date if there is one
 N DGCDIS
 I $$GET^DGENCDA(DFN,.DGCDIS) D
 .Q:'DGCDIS("REVDTE")
 .W !!,"Catastrophically Disabled Review Date: ",$$FMTE^XLFDT(DGCDIS("REVDTE"),1)
 Q
 ;
