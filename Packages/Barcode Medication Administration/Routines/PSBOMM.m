PSBOMM ;BIRMINGHAM/EFC-MISSED MEDS ;22-Feb-2007 10:53;SM
 ;;3.0;BAR CODE MED ADMIN;**1005**;Mar 2004
 ;
 ; Modified - IHS/MSC/PLS - 02/22/07 - Line PRINT+56
 ;
 ; Reference/IA
 ; ^DPT/10035
 ; EN^PSJBCMA/2828
 ; EN^PSJBCMA2/2830
 ;
EN ; Called from DQ^PSBO
 N PSBSTRT,PSBSTOP,DFN,PSBODATE,PSBFLAG,PSBCNT
 K ^TMP("PSJ",$J),^TMP("PSB",$J),^TMP("PSB1",$J)
 S PSBSTRT=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7)-.0000001
 S PSBSTOP=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,9)
 S PSBODATE=$P(PSBRPT(.1),U,6)
 F DFN=0:0 S DFN=$O(^TMP("PSBO",$J,DFN)) Q:'DFN  D EN1
 D PRINT
 K ^TMP("PSJ",$J),^TMP("PSB",$J),^TMP("PSBO",$J)
 Q
 ;
EN1 ; Expects DFN,PSBSTRT,PSBSTOP from EN
 N PSBGBL,PSBHDR,PSBX,PSBDFN,PSBDT,PSBEVDT,PSBHOUR
 K ^TMP("PSJ",$J) S PSBEVDT=PSBSTRT
 D EN^PSJBCMA(DFN,PSBSTRT)
 Q:^TMP("PSJ",$J,1,0)=-1
 S PSBX=""
 F  S PSBX=$O(^TMP("PSJ",$J,PSBX)) Q:PSBX=""  D
 .Q:^TMP("PSJ",$J,PSBX,0)=-1  ; No Orders
 .D CLEAN^PSBVT
 .D PSJ^PSBVT(PSBX)
 .Q:PSBIVT="A"  ; No Admix or Hyp.
 .Q:PSBIVT="H"
 .I PSBIVT["S",PSBISYR'=1 Q  ;    allow intermittent syringe only
 .I PSBIVT["C",PSBCHEMT'="P",PSBISYR'=1 Q
 .I PSBIVT["C",PSBCHEMT="A" Q  ;     allow Chemo with intermittent syringe or Piggyback type only
 .Q:PSBONX["P"  ;no pending orders
 .I PSBSCHT="C" D  Q  ; Only Continuous
 ..S (PSBYES,PSBODD)=0
 ..S PSBDOW="SU^MO^TU^WE^TH^FR^SA" F I=1:1:7 I $P(PSBDOW,"^",I)=$E(PSBSCH,1,2) S PSBYES=1
 ..I PSBYES,PSBADST="" Q
 ..F I=1:1 Q:$P(PSBSCH,"-",I)=""  I $P(PSBSCH,"-",I)?2N!($P(PSBSCH,"-",I)?4N) S PSBYES=1
 ..S PSBFREQ=$$GETFREQ^PSBVDLU1(DFN,PSBONX)
 ..I PSBFREQ="O" S PSBYES=1
 ..I 'PSBYES,PSBADST="",PSBFREQ<1 Q
 ..I (PSBFREQ#1440'=0),(1440#PSBFREQ'=0) S PSBODD=1
 ..I PSBODD,PSBADST'="" Q
 ..Q:PSBOSTS["D"  ;Discontinued
 ..Q:PSBNGF  ; Marked DO NOT GIVE
 ..Q:PSBOSTS="N"
 ..Q:PSBSM  ;Self med
 ..S PSBCADM=0
 ..I PSBADST="" S PSBADST=$$GETADMIN^PSBVDLU1(DFN,PSBONX,PSBOST,PSBFREQ,PSBEVDT) Q:PSBADST=""  S PSBCADM=1
 ..E  K ^TMP("PSB",$J,"GETADMIN") S ^TMP("PSB",$J,"GETADMIN",0)=PSBADST
 ..;Invalid admin times
 ..F Y=1:1:$L(PSBADST,"-") D
 ...Q:($P(PSBADST,"-",Y)'?2N)&($P(PSBADST,"-",Y)'?4N)
 ..; Below is (Order Start Date, Report Date, Schedule)
 ..Q:'$$OKAY^PSBVDLU1(PSBOST,PSBODATE,PSBSCH,PSBONX,$P(^TMP("PSJ",$J,PSBX,3),U,2),PSBFREQ,PSBOSTS)  ; Screens QOD type stuff
 ..K PSBOACTL,TMP("PSB1",$J) D EN^PSJBCMA2(DFN,PSBONX,1) I ^TMP("PSJ2",$J,0)'=1 M PSBOACTL=^TMP("PSJ2",$J) K ^TMP("PSJ2",$J)
 ..F PSBXX=0:1 Q:'$D(^TMP("PSB",$J,"GETADMIN",PSBXX))  S PSBADST=$G(^TMP("PSB",$J,"GETADMIN",PSBXX)) D
 ...F Y=1:1:$L(PSBADST,"-") D
 ....S PSBDT=+("."_$P(PSBADST,"-",Y))+(PSBSTRT\1)
 ....Q:PSBDT<PSBOST  ; Order Start Date
 ....Q:PSBDT'<PSBOSP  ; Order Stop Date
 ....Q:PSBDT<PSBSTRT  ; Report Window
 ....Q:PSBDT>PSBSTOP  ; Report Window
 ....I $D(^PSB(53.79,"AORD",DFN,PSBONX,PSBDT)) D  I PSBSTUS'="N",PSBSTUS'="M" Q  ; If it is on the log quit continue if status is "NOT GIVEN" or "MISSING"
 .....S PSBINDX=$O(^PSB(53.79,"AORD",DFN,PSBONX,PSBDT,"")),PSBSTUS=$P(^PSB(53.79,PSBINDX,0),U,9)
 ....S ^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)=""
 ....D UDCONT
 ....I PSBFLAG=1 S ^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)="(On Hold) "_$$FMTE^XLFDT(PSBHDDT)
 ....I PSBFLAG=2 S ^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)="(On Hold) "_$$FMTE^XLFDT(PSBHDDT)_"  "_"(Off Hold) "_$$FMTE^XLFDT(PSBUNHD) Q
 .K PSBHDDT,PSBUNHD,^TMP("PSB1",$J)
 .I PSBSCHT="O" D  Q
 ..Q:PSBOSTS["D"!(PSBOSTS="N")  ; Discontinued
 ..Q:PSBNGF  ; Marked DO NOT GIVE
 ..Q:PSBSM  ;Self med
 ..; Is the One Time Given?
 ..Q:PSBOSP=PSBOST   ;Expired one-time
 ..Q:PSBOST'<PSBSTOP
 ..Q:PSBOSP<PSBSTRT
 ..S (PSBGVN,X,Y)=""
 ..F  S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X),-1) Q:'X  D
 ...F  S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X,Y),-1) Q:'Y  D
 ....I $P(^PSB(53.79,Y,.1),U)=PSBONX,$P(^PSB(53.79,Y,0),U,9)'="N",$P(^PSB(53.79,Y,0),U,9)'="M" S PSBGVN=1,(X,Y)=0
 ..; How long does One Time remain on the this report ??
 ..D NOW^%DTC
 ..S PSBRMN=1
 ..I PSBSCHT="O",PSBOSP'=PSBOST&(%>PSBOSP) S PSBRMN=0
 ..D:('PSBGVN)&(PSBRMN)
 ...S VAR=""
 ...K ^TMP("PSJ2",$J),^TMP("PSB1",$J),PSBOACTL D EN^PSJBCMA2(DFN,PSBONX,1) I ^TMP("PSJ2",$J,0)'=1 D
 ....M PSBOACTL=^TMP("PSJ2",$J)
 ....D UDONE
 ....I PSBFLAG=1 S VAR="(On Hold) "_$$FMTE^XLFDT(PSBHDDT)
 ....I PSBFLAG=2 S VAR="(On Hold) "_$$FMTE^XLFDT(PSBHDDT)_"  (Off Hold) "_$$FMTE^XLFDT(PSBUNHD)
 ...S VAR=VAR_U_$TR($$FMTE^XLFDT(PSBOST,2),"@"," ")
 ...S VAR=VAR_U_$TR($$FMTE^XLFDT(PSBOSP,2),"@"," ")
 ...S $P(^TMP("PSB",$J,DFN,"*** ONE-TIME ***",PSBOITX,PSBONX),U,1,4)=VAR
 ...K PSBHDDT,PSBUNHD,^TMP("PSB1",$J),PSBCNT
 K PSBOACTL
 Q
 ;
PRINT ; Print meds stored in ^TMP("PSB",$J,DFN,....
 N PSBHDR,PSBDT,PSBOITX,PSBONX,DFN
 ;
 ; Print by Patient
 ;
 D:$P(PSBRPT(.1),U,1)="P"
 .S PSBHDR(1)="MISSED MEDICATIONS  from "_$$FMTE^XLFDT($P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7))_" thru "_$$FMTE^XLFDT($P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,9))
 .S DFN=$P(PSBRPT(.1),U,2)
 .W $$PTHDR()
 .I $O(^TMP("PSB",$J,DFN,""))="" W !,"No Missed Medications Found",$$PTFTR^PSBOHDR() Q
 .S PSBDT=""
 .F  S PSBDT=$O(^TMP("PSB",$J,DFN,PSBDT)) Q:PSBDT=""  D
 ..W !  ; Line Break Between Admin Times
 ..S PSBOITX=""
 ..F  S PSBOITX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX)) Q:PSBOITX=""  D
 ...S PSBONX=""
 ...F  S PSBONX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)) Q:PSBONX=""  D
 ....I $Y>(IOSL-5) W $$PTFTR^PSBOHDR(),$$PTHDR()
 ....W !,+PSBONX,$S(PSBONX["U":"UD",PSBONX["V":"IV",1:"")
 ....I PSBDT["ONE-TIME" D  Q
 .....W ?12,PSBDT,?38,PSBOITX
 .....W !,?38,$P(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX),U,1)
 .....W !,"Start Date/Time: ",?16,$P(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX),U,2)
 .....W !,"Stop Date/Time:  ",?16,$P(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX),U,3)
 .....W !
 ....W ?12,$S(PSBDT:$$FMTE^XLFDT(PSBDT),1:PSBDT),?38,PSBOITX
 ....W !,?38,^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)
 .W $$PTFTR^PSBOHDR()
 .Q
 ;
 ; Print by Ward
 ;
 D:$P(PSBRPT(.1),U,1)="W"
 .S PSBHDR(1)="MISSED MEDICATIONS  from "_$$FMTE^XLFDT($P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7))_" thru "_$$FMTE^XLFDT($P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,9))
 .S PSBWARD=$P(PSBRPT(.1),U,3)
 .W $$WRDHDR()
 .I '$O(^TMP("PSB",$J,0)) W !,"No Missed Medications Found" Q
 .S PSBSORT=$P(PSBRPT(.1),U,5)
 .F DFN=0:0 S DFN=$O(^TMP("PSB",$J,DFN)) Q:'DFN  D
 ..S PSBINDX=$S(PSBSORT="P":$P(^DPT(DFN,0),U),1:$G(^DPT(DFN,.1))_" "_$G(^(.101)))
 ..S:PSBINDX="" PSBINDX=$P(^DPT(DFN,0),U)
 ..S ^TMP("PSB",$J,"B",PSBINDX,DFN)=""
 .S PSBINDX=""
 .F  S PSBINDX=$O(^TMP("PSB",$J,"B",PSBINDX)) Q:PSBINDX=""  D
 ..F DFN=0:0 S DFN=$O(^TMP("PSB",$J,"B",PSBINDX,DFN)) Q:'DFN  D
 ...W ! ; Line Break Between Pt's
 ...S PSBDT=""
 ...F  S PSBDT=$O(^TMP("PSB",$J,DFN,PSBDT)) Q:PSBDT=""  D
 ....W !  ; Line Break Between Admin Times
 ....S PSBOITX=""
 ....F  S PSBOITX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX)) Q:PSBOITX=""  D
 .....S PSBONX=""
 .....F  S PSBONX=$O(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)) Q:PSBONX=""  D
 ......I $Y>(IOSL-5) W $$WRDHDR()
 ......W !,+PSBONX,$S(PSBONX["U":"UD",PSBONX["V":"IV",1:"")
 ......W ?10,$G(^DPT(DFN,.101),"**")
 ......; IHS/MSC/PLS - 02/22/07 - Commented out next line and added the following line
 ......;W ?30,$P(^DPT(DFN,0),U)," (",$E($P(^(0),U,9),6,9),")"
 ......W ?30,$P(^DPT(DFN,0),U)," (",$$PTID^PSBOML(DFN,1),")"
 ......I PSBDT["ONE-TIME" D  Q
 .......W !,PSBDT,?30,PSBOITX," ",$P(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX),U,1)
 .......W !,"Start Date/Time:  ",?30,$P(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX),U,2)
 .......W !,"Stop Date/Time:  ",?30,$P(^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX),U,3)
 .......W !
 ......W ?64,$S(PSBDT:$$FMTE^XLFDT(PSBDT,2),1:PSBDT),?80,PSBOITX
 ......W " ",^TMP("PSB",$J,DFN,PSBDT,PSBOITX,PSBONX)
 Q
 ;
WRDHDR() ; Ward Header
 D WARD^PSBOHDR(PSBWRD,.PSBHDR)
 W !,"Ord Num",?10,"Room-Bed",?30,"Patient",?64,"Admin Date/Time",?80,"Medication"
 W !,$TR($J("",IOM)," ","-")
 Q ""
 ;
PTHDR() ; Patient Header
 D PT^PSBOHDR(DFN,.PSBHDR)
 W !,"Order Num",?12,"Administration Date/Time",?38,"Medication"
 W !,$TR($J("",IOM)," ","-")
 Q ""
 ;
UDCONT ;
 S PSBFLAG=0,J=1
 K ^TMP("PSB1",$J)
 F I=1:1:$P(PSBOACTL(0),U,4) D
 . I $P($G(PSBOACTL(I,1)),U,4)["ON HOLD"!($P($G(PSBOACTL(I,1)),U,4)="HOLD") S ^TMP("PSB1",$J,DFN,J)="HOLD"_U_$E($P($G(PSBOACTL(I,1)),U,1),1,12)
 . I $P($G(PSBOACTL(I,1)),U,4)["TAKEN OFF HOLD"!($P($G(PSBOACTL(I,1)),U,4)["UNHOLD") S $P(^TMP("PSB1",$J,DFN,J),U,3)="OFF HOLD"_U_$E($P($G(PSBOACTL(I,1)),U,1),1,12),J=J+1
 D:$D(^TMP("PSB1",$J,DFN))&($P(PSBOACTL(0),U,4)'=1)
 .S J=0 F  S J=$O(^TMP("PSB1",$J,DFN,J)) Q:'J  Q:PSBFLAG  D
 ..S PSBHDDT=$P(^TMP("PSB1",$J,DFN,J),U,2)
 ..S PSBHDST=$P(^TMP("PSB1",$J,DFN,J),U)
 ..S PSBOFDT=$P(^TMP("PSB1",$J,DFN,J),U,4)
 ..S PSBOFST=$P(^TMP("PSB1",$J,DFN,J),U,3)
 ..I PSBDT>PSBHDDT,PSBHDST="HOLD",PSBOFST'="" I PSBDT<PSBOFDT,PSBOFST="OFF HOLD" S PSBFLAG=2,PSBUNHD=PSBOFDT
 ..I PSBDT>PSBHDDT,PSBHDST="HOLD",PSBOFST="" S PSBFLAG=1
 K PSBCNT,TMP("PSB1",$J)
 Q
 ;
UDONE ;
 S PSBFLAG=0,J=1
 F I=1:1:$P(PSBOACTL(0),U,4) D
 .I $P($G(PSBOACTL(I,1)),U,4)["ON HOLD"!($P($G(PSBOACTL(I,1)),U,4)="HOLD") S ^TMP("PSB1",$J,DFN,J)="HOLD"_U_$E($P($G(PSBOACTL(I,1)),U,1),1,12)
 .I $P($G(PSBOACTL(I,1)),U,4)["TAKEN OFF HOLD"!($P($G(PSBOACTL(I,1)),U,4)["UNHOLD") S $P(^TMP("PSB1",$J,DFN,J),U,3)="OFF HOLD"_U_$E($P($G(PSBOACTL(I,1)),U,1),1,12),J=J+1
 D:$D(^TMP("PSB1",$J,DFN))&($P(PSBOACTL(0),U,4)'=1)
 .S J="" F  S J=$O(^TMP("PSB1",$J,DFN,J)) Q:'J  Q:PSBFLAG  D
 ..S PSBHDDT=$P(^TMP("PSB1",$J,DFN,J),U,2)
 ..S PSBHDST=$P(^TMP("PSB1",$J,DFN,J),U)
 ..S PSBOFDT=$P(^TMP("PSB1",$J,DFN,J),U,4)
 ..S PSBOFST=$P(^TMP("PSB1",$J,DFN,J),U,3)
 ..I PSBOSTS="A",PSBHDST="HOLD",PSBOFST'="",'$D(^TMP("PSB1",$J,DFN,J+1)) I PSBSTOP>PSBOFDT,PSBOFST="OFF HOLD" S PSBFLAG=2,PSBUNHD=PSBOFDT
 ..I PSBOSTS="A",PSBHDST="HOLD",PSBOFST'="",PSBOFDT'<PSBSTOP S PSBFLAG=1
 ..I PSBOSTS="H",PSBHDST="HOLD",'$D(^TMP("PSB1",$J,DFN,J+1)) S PSBFLAG=1
 K PSBCNT,^TMP("PSB1",$J)
 Q
 ;
