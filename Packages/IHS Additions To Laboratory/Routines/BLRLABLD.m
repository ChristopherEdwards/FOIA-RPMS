BLRLABLD ; IHS/DIR/FJE - INTERMEC 7421 LABEL PRINT BARCODE/PLAIN 10:16 ; [ 03/18/1999  9:09 AM ]
 ;;5.2;LR;**1006,1007**;MAR 1, 1999
 ;;5.2;LR;**1001**;FEB 1, 1998
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;;V5.1;LAB;;04/11/91 11:06
 ;This routine is used in conjunction with the Intermec program routine
 ;BLRBARD to print a 3 label accession label for accession areas which
 ;have their BAR CODE PRINT field set to YES
 ;BLRLABLD may have to be renamed LRLABEL4
 ;The code S X=0 X ^%ZOSF("RM") is needed to replace the U IO:0 which
 ;works with MSM but not DSM
 ;
EN S:$D(ZTQUEUED) ZTREQ="@"
 N I1,J
 S X=0 X ^%ZOSF("RM")
 S:'$L($G(LRRB)) LRRB=""
 S BLRURG=""  ;IHS/DIR TUC/AAB 03/23/98
 S J=0,LRTXT="",FLAG=0 F I1=1:1 S J=$O(LRTS(J)) Q:J<1  I ($L(LRTXT)+$L(LRTS(J))'>24) S LRTXT=LRTXT_LRTS(J) S:$O(LRTS(J))>0 FLAG=1,LRTXT=LRTXT_";"
FLAG S:FLAG=0 LRDTXT=LRTXT S:FLAG=1 LRDTXT=".............."
 S LRLPNM=$P(PNM,",",1),LRLPNM=LRLPNM_$S($L(LRLPNM)<18:","_$E($P(PNM,",",2),1),1:"")
 I $D(LRBAR) D BAR Q  ;IHS/MJL 3/18/99
 D PRT K BLRURG
 Q
BAR ;barcode label..accession number barcoded
 W *2,"R",*3
 W *2,*27,"E4",*24,LRACC,*3
 W *2,!,LRDAT,!,LRTOP,*3
 W *2,!,$E(PNM,1,27),!,HRCN,!,"W:"_$E(LRLLOC,1,7)_" B:"_LRRB,*3
 W *2,!,$E("0000",$L(LRAN),4)_LRAN,*3
 W *2,!,"Order#:",LRCE,!,$E(LRTXT,1,32) W:$L(LRTXT)>32 "..."
 S LRURG0=$G(LRURG0) I LRURG0'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)
 W *2,!,BLRURG,*3
 W *2,!,LRACC,*3
 W *2,!,LRDAT,*3
 W *2,!,LRACC,*3
 W *2,!,$E(PNM,1,27),!,HRCN,!,"W:"_$E(LRLLOC,1,7)_" B:"_LRRB,*3
 W *2,!,LRDAT,!,$E(LRTXT,1,32) W:$L(LRTXT)>32 "..."
 W *2,*23,*15,"S30",*12,*3
 K BLRURG
 Q
PRT ;plain label..no barcode
 W *2,"R",*3
 W *2,*27,"E5",*24,!,LRACC,*3
 W *2,!,LRDAT,!,LRTOP,*3
 S X=$G(DOB) D ^%DT 
 W *2,!,$E(PNM,1,27),!,HRCN,!,"DOB:"_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3),!,"W:"_$E(LRLLOC,1,7)_" B:"_LRRB,*3
 W *2,!,"Order#:",LRCE,!,$E(LRTXT,1,32) W:$L(LRTXT)>32 "..."
 S LRURG0=$G(LRURG0) I LRURG0'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)
 W *2,!,BLRURG,*3
 W *2,!,LRACC,*3
 W *2,!,LRDAT,*3
 W *2,!,LRACC,*3
 W *2,!,$E(PNM,1,27),!,HRCN,!,"W:"_$E(LRLLOC,1,7)_" B:"_LRRB,*3
 W *2,!,LRDAT,!,$E(LRTXT,1,32) W:$L(LRTXT)>32 "..."
 W *2,*23,*15,"S30",*12,*3
 K BLRURG
 Q
