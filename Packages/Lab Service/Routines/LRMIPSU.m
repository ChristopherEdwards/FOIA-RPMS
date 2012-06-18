LRMIPSU ; IHS/DIR/FJE - MICRO PATIENT REPORT 10/7/87 08:42 ; [ 11/19/2002  7:09 AM ]
 ;;5.2;LR;**1013,1015,1018,1022,1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;;Sep 27, 1994
FH ;EP - from LRMIPSZ1, LRMIPSZ2, LRMIPSZ5
 D:$Y>(IOSL-LRFLIP) FOOT,HDR
 Q
FHR ;EP - from LRMIPSZ1, LRMIPSZ2
 D:$Y>(IOSL-LRFLIP) FOOT,HDR Q:LREND  D REFS
 Q
REFS ;EP - from LRMIPSZ1
 S B=1,LREF=0
 F I=0:0 S LREF=$O(LRBUG(LREF)) Q:LREF=""  S LRIFN=LRBUG(LREF) D LIST Q:LREND
 K LRBUG
 Q
LIST Q:'$D(^LAB(61.2,LRIFN,"JR",0))
 S LRNUM=0
 F I=0:0 S LRNUM=$O(^LAB(61.2,LRIFN,"JR",LRNUM)) Q:LRNUM=""  D WR Q:LREND
 Q
WR S X1=^LAB(61.2,LRIFN,"JR",LRNUM,0) Q:$P(X1,U,7)'=1
 D:$Y>(IOSL-LRFLIP-2) FOOT,HDR Q:LREND
 W:B=1 !!,"Reference(s): " S B=0
 W !!,$J(LREF,2),". ",$P(X1,U,2),!,$P(X1,U)
 W ! W:$L($P(X1,U,3)) $P(^LAB(95,$P(X1,U,3),0),U)," ",$P(X1,U,4),":"
 W $P(X1,U,5) W:$L($P(X1,U,6)) ",",$E($P(X1,U,6),1,3)+1700
 Q
FOOT ;EP - from LRMIPSZ1
 ; F X=1:1 W ! Q:$Y>(IOSL-LRFLIP)
 F X=1:1 W ! Q:$Y>(IOSL-(LRFLIP+6))         ; IHS/OIT/MKK - LR*5.2*1030
 Q:'LRHC  W !,"Collection sample: ",LRCS,?40,"Collection date: ",LRTK
 ;W:LRCS'=LRST !,"Site/Specimen: ",LRST W !!
 W:LRCS'=LRST !,"Site/Specimen: ",LRST W !  ;IHS/ANMC/CLS 08/18/96
 ;W !!,PNM,?$X+3,SSN,?$X+3 W:$D(IA) IA W ?60,"  ROUTING: ",LRPATLOC,!
 ;
 D IHSKEY                                   ; IHS/OIT/MKK - LR*5.2*1030
 ;
 W !,PNM,?$X+3,HRCN,?$X+3 W:$D(IA) IA W ?60,"  ROUTING: ",LRPATLOC,!  ;IHS/ANMC/CLS 08/18/96
 W $$INS^LRU," LABORATORY",?62,LRACC,!,"MICROBIOLOGY",?62,"page ",LRPG,!
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
IHSKEY ; EP -- Legends for Micro Reports
 W !,$TR($J("",IOM)," ","=")
 W !,$$CJ^XLFSTR("S=Sensitive     I=Intermediate     R=Resistant     NI=Not Immune     I=Immune",IOM)
 W !,$$CJ^XLFSTR(" IB=Inducible Beta Lactam    NR=Non Reactive    WR=Weakly Reactive    R=Reactive",IOM),!
 Q
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 ;
HDR ;EP - from LRMIPSZ1
 S LRPG=LRPG+1 D:LRPG>1 WAIT Q:LREND
 W:($G(LRJ02))!($G(LRJ0))!($E(IOST,1,2)="C-") @IOF S LRJ02=1
 ;W !,PNM,?20," ",SSN,?35," AGE: ",AGE W:$L(LRWRD) ?46,"LOC: ",LRWRD
 W !,PNM,?20," ",HRCN,?35," AGE: ",AGE W:$L(LRWRD) ?46,"LOC: ",LRWRD  ;IHS/ANMC/CLS 08/18/96
 W ?61," ",LRDT0 S A8=$P($H,",",2),Y=A8\3600_":"_$E((A8\60#60+100),2,3)
 W " ",Y W:LRHC !
 ; W:LRPG=1 !?27,"----MICROBIOLOGY----",?70,"page 1"
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1022 -- Institution Name & Address
 NEW HDRSTR
 I LRPG=1 S HDRSTR=$$CJ^XLFSTR("----MICROBIOLOGY----",IOM)
 I LRPG>1 S HDRSTR=$$CJ^XLFSTR(">> CONTINUATION OF "_LRACC_" <<",IOM)
 S $E(HDRSTR,70,79)="Page "_LRPG
 W !,HDRSTR
 D LABHDR^BLRUTIL2
 ;----- END IHS MODIFICATIONS LR*5.2*1022 -- Institution Name & Address
 I $D(DUZ("AG")),$L(DUZ("AG")),"ARMYAFN"[DUZ("AG") D ^LRAIPRIV
 I '$D(LRH),LRHC W !?32,$S($D(^XUSEC("LRLAB",DUZ))&'$D(LRWRDVEW):"LAB",1:"CHART")," COPY"
 W:LRPG=1 !,"Accession: ",LRACC,?40,"Received: ",LRRC
 W !,"Collection sample: ",LRCS,?40,"Collection date: ",LRTK
 I LRCS'=LRST,LRPG=1 W !,"Site/Specimen: ",LRST
 I LRPG=1 W !,"Provider: ",LRDOC,! W:$L(LRCMNT) "Comment on specimen: ",LRCMNT,!
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 D ESIGINFO^BLRUTIL
 ;----- END IHS MODIFICATIONS
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1022 -- Institution Name & Address
 ;      Comment out the following line.
 ; W:LRPG>1 !?20,">> CONTINUATION OF ",LRACC," <<",?70,"page ",LRPG
 ;----- END IHS MODIFICATIONS LR*5.2*1022 -- Institution Name & Address
 Q
 ;
WAIT ; EP - from LRMIPSZ1, LRMIPSZ2
 ; 
 ;The following lines added per Appendix A of RPMS Lab E-Sig Enhancement V 5.2 Techinical Manual IHS/HQW/SCR - 8/23/01 
 I $P($G(XQY0),U)="LLRS"!($P($G(XQY0),U)="LRRS BY LOC")!($P($G(XQY0),U)="LRRD")!($P($G(XQY0),U)="LRRP2")!($P($G(XQY0),U)="BLR LRRD BY MD") D  ;IHS/HQW/SCR-8/23/01 
 .I $$ADDON^BLRUTIL("LR*5.2*1013","BLRALAF",DUZ(2)) D ^BLRALAU  ;IHS/HQW/SCR-8/23/01     
 ;
 D IHSKEY     ; IHS/OIT/MKK - LR*5.2*1030
 F I=$Y:1:IOSL-3 W !
 ;I 'LRHC W !,PNM,?25,"  ",SSN,"   ROUTING: ",LRPATLOC,?59," PRESS '^' TO STOP " R X:DTIME S:X="" X=1 S:(".^"[X)!('$T) LREND=1
 I 'LRHC W !,PNM,?25,"  ",HRCN,"   ROUTING: ",LRPATLOC,?59," PRESS '^' TO STOP " R X:DTIME S:X="" X=1 S:(".^"[X)!('$T) LREND=1  ;IHS/ANMC/CLS 08/18/96
 Q
PRE ;EP - from LRMIPSZ2, LRMIPSZ3, LRMIPSZ4
 Q:LRTUS["F"&('$D(^XUSEC("LRLAB",DUZ))!$D(LRWRDVEW))  W:+$O(^LR(LRDFN,"MI",LRIDT,LRPRE,0)) !,"Preliminary Comments: " S J=0 F I=0:0 S J=+$O(^LR(LRDFN,"MI",LRIDT,LRPRE,J)) Q:J<1  W !?3,^(J,0)
 W !
 Q
