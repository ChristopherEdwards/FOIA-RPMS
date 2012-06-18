BLRLABLB ; IHS/DIR/FJE - 10 PART LABELS FOR THE INTERMEC 4100 PRINTER ; [ 03/17/1999  12:35 PM ]
 ;;5.2;LR;**1006**;MAR 1, 1999
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;This routine is used in conjunction with the Intermec program routine
 ;BLRBARB to print a ten part 2.5X4.0 inch label.
 ;The code S X=0 X ^%ZOSF("RM") is needed to replace the U IO:0 which
 ;works with MSM but not DSM
 ;
 S X=0 X ^%ZOSF("RM")
 S J=0,LRTXT="",FLAG=0 F I1=1:1 S J=$O(LRTS(J)) Q:J<1  I ($L(LRTXT)+$L(LRTS(J))'>24) S LRTXT=LRTXT_LRTS(J) S:$O(LRTS(J))>0 FLAG=1,LRTXT=LRTXT_";"
FLAG S:FLAG=0 LRDTXT=LRTXT S:FLAG=1 LRDTXT=".............."
 S LRLPNM=$P(PNM,",",1),LRLPNM=LRLPNM_$S($L(LRLPNM)<18:","_$E($P(PNM,",",2),1),1:"")
PRT W *2,"R",*3
 ;W *2,*27,"E4",*24,!,LRACC,!,LRDAT,!,LRTOP,!,$E(PNM,1,27),!,SSN,!,"W:",$E(LRLLOC,1,9),!,$E("0000",$L(LRAN),4)_LRAN,!,"Order#:",LRCE,!,$E(LRTXT,1,19) W:$L(LRTXT)>19 "..." W ! W:$D(LRURG)#2 "STAT"
 W *2,*27,"E4",*24,!,LRACC,!,LRDAT,!,LRTOP,!,$E(PNM,1,27),!,HRCN,!,"W:",$E(LRLLOC,1,9),!,$E("0000",$L(LRAN),4)_LRAN,!,"Order#:",LRCE,!,$E(LRTXT,1,19) W:$L(LRTXT)>19 "..." W ! W:$D(LRURG)#2 "STAT"  ;IHS/ANMC/CLS 11/1/95
 ;W !,LRACC,!,LRTOP,!,LRACC,!,LRLPNM,!,SSN,!,LRDAT,!,$S($P(LRTXT,";",1)'="":$P(LRTXT,";",1),1:LRDTXT),!,*3
 W !,LRACC,!,LRTOP,!,LRACC,!,LRLPNM,!,HRCN,!,LRDAT,!,$S($P(LRTXT,";",1)'="":$P(LRTXT,";",1),1:LRDTXT),!,*3  ;IHS/ANMC/CLS 11/1/95
 ;W *2,LRACC,!,LRTOP,!,LRACC,!,LRLPNM,!,SSN,!,LRDAT,!,$S($P(LRTXT,";",2)'="":$P(LRTXT,";",2),1:LRDTXT),!,LRACC,!,LRDAT,!,LRTOP,!,$E(PNM,1,27),!,SSN,!,"W:",$E(LRLLOC,1,9),!,*3
 W *2,LRACC,!,LRTOP,!,LRACC,!,LRLPNM,!,HRCN,!,LRDAT,!,$S($P(LRTXT,";",2)'="":$P(LRTXT,";",2),1:LRDTXT),!,LRACC,!,LRDAT,!,LRTOP,!,$E(PNM,1,27),!,HRCN,!,"W:",$E(LRLLOC,1,9),!,*3  ;IHS/ANMC/CLS 11/1/95
 W *2,"Order#:",LRCE,!,$E(LRTXT,1,26) W:$L(LRTXT)>26 "..." W ! W:$D(LRURG)#2 "STAT" W *3
 ;W *2,!,LRACC,!,LRTOP,!,LRACC,!,LRTOP,!,LRACC,!,LRLPNM,!,SSN,!,LRDAT,!,$S($P(LRTXT,";",3)'="":$P(LRTXT,";",3),1:LRDTXT),!,LRACC,!,LRLPNM,!,SSN,!,LRDAT,!,$S($P(LRTXT,";",4)'="":$P(LRTXT,";",4),1:LRDTXT),*3,*2,*23,*15,"S30",*12,*3
 W *2,!,LRACC,!,LRTOP,!,LRACC,!,LRTOP,!,LRACC,!,LRLPNM,!,HRCN,!,LRDAT,!,$S($P(LRTXT,";",3)'="":$P(LRTXT,";",3),1:LRDTXT),!,LRACC,!,LRLPNM,!,HRCN,!,LRDAT,!,$S($P(LRTXT,";",4)'="":$P(LRTXT,";",4),1:LRDTXT),*3,*2,*23,*15,"S30",*12,*3  ;IHS/ANMC/CLS
 Q
