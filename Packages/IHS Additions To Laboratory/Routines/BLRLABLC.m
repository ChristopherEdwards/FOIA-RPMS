BLRLABLC ; IHS/DIR/FJE - INTERMEC 7421 LABEL PRINT BARCODE/PLAIN 10:16 ; 
 ;;5.2;LR;**1006,1007,1009,1018,1022**;September 20, 2007
 ;;5.2;LR;**1006,1007,1009**;Mar 7, 2001
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;;V5.1;LAB;;04/11/91 11:06
 ;This routine is used in conjunction with the Intermec program routine
 ;LRBARA to print a two label accession label for accession areas which
 ;have their BAR CODE PRINT field set to YES
 ;LRLABELA may have to be renamed LRLABEL6
 ;The code S X=0 X ^%ZOSF("RM") is needed to replace the U IO:0 which
 ;works with MSM but not DSM
 ;
EN S:$D(ZTQUEUED) ZTREQ="@"
 N I1,J
 S X=0 X ^%ZOSF("RM")
 S:'$L($G(LRRB)) LRRB=""
 S BLRURG=""  ;IHS/DIR TUC/AAB 03/23/98
 S J=0,LRTXT="",FLAG=0 F I1=1:1 S J=$O(LRTS(J)) Q:J<1  I ($L(LRTXT)+$L(LRTS(J))'>24) S LRTXT=LRTXT_LRTS(J) S:$O(LRTS(J))>0 FLAG=1,LRTXT=LRTXT_";"
 ;
FLAG S:FLAG=0 LRDTXT=LRTXT S:FLAG=1 LRDTXT=".............."
 S LRLPNM=$P(PNM,",",1),LRLPNM=LRLPNM_$S($L(LRLPNM)<18:","_$E($P(PNM,",",2),1),1:"")
 I $D(LRBAR) D BAR Q  ;IHS/MJL 3/18/99
 D PRT K BLRURG
 ;Q:'$D(LRBAR)!('$D(LRBAR($G(LRAA))))
 Q  ;IHS/DIR TUC/AAB 03/23/98
 ;
BAR ;barcode label..accession number barcoded
 ; --- IHS/OIT/MKK -- Total rewrite
 NEW DOBSTR                   ; Date of Birth String
 S DOBSTR="DOB:"
 I $G(DOB)'="" D
 . S X=$G(DOB)  D DT^DILF(,X,.Y)
 . ; I Y>0 S DOBSTR=DOBSTR_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_($E(Y,1,3)+1700)  ;IHS/DIR/FJE 10/08/99
 . I Y>0 S DOBSTR=DOBSTR_$$FMTE^XLFDT(Y,"5DZ")
 ;
 S BLRURG=""                  ; URGENCY
 S LRURG0=$G(LRURG0)
 I LRURG0'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)  ;IHS/DIR TUC/AAB 03/23/98
 ;
 NEW LOCSTR                  ; LOCATION (WARD & BED)
 S LOCSTR="W:"_$E($G(LRLLOC),1,7)
 I $G(LRRB)'="" S LOCSTR=LOCSTR_" B:"_LRRB
 ;
 NEW TESTSTR                  ; Lab Test(s) String
 S TESTSTR=$E($G(LRTXT),1,32)
 I $L($G(LRTXT))>32 S TESTSTR=TESTSTR_"..."
 ;
 ; NOTE: Using the $G function to ensure UNDEFINED variables 
 ;       don't cause problems.
 W *2,"R",*3
 W *2,*27,"E3",*24,!,$G(TESTSTR),*3               ; Lab Test(s)
 W *2,!,$G(LRTOP),*3                              ; Top/Specimen
 W *2,!,"Order#:",$G(LRCE),*3                     ; Order Number
 W *2,!,$G(LRACC),*3                              ; Accession String
 W *2,!,$G(LRDAT),*3                              ; Date
 W *2,!,$G(HRCN),*3                               ; Health Record Number
 W *2,!,LOCSTR,*3                                 ; Location String
 W *2,!,$E($G(PNM),1,27),*3                       ; Patient Name
 W *2,!,$G(BLRURG),*3                             ; Urgency
 W *2,!,$E("0000",$L($G(LRAN)),4)_$G(LRAN),*3     ; Barcoded Accession Number
 W *2,*23,*15,"S30",*12,*3
 ;
 K BLRURG  ;IHS/DIR TUC/AAB 03/23/98
 Q
 ;
PRT ; plain label..no barcode
 ; --- IHS/OIT/MKK -- Total rewrite
 NEW DOBSTR                   ; Date of Birth String
 S DOBSTR="DOB:"
 I $G(DOB)'="" D
 . S X=$G(DOB)  D DT^DILF(,X,.Y)
 . ; I Y>0 S DOBSTR=DOBSTR_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_($E(Y,1,3)+1700)  ;IHS/DIR/FJE 10/08/99
 . I Y>0 S DOBSTR=DOBSTR_$$FMTE^XLFDT(Y,"5DZ")
 ;
 S BLRURG=""                  ; URGENCY
 S LRURG0=$G(LRURG0)
 I LRURG0'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)  ;IHS/DIR TUC/AAB 03/23/98
 ;
 NEW LOCSTR                  ; LOCATION (WARD & BED)
 S LOCSTR="W:"_$E($G(LRLLOC),1,7)
 I $G(LRRB)'="" S LOCSTR=LOCSTR_" B:"_LRRB
 ;
 NEW TESTSTR                  ; Lab Test(s) String
 S TESTSTR=$E($G(LRTXT),1,32)
 I $L($G(LRTXT))>32 S TESTSTR=TESTSTR_"..."
 ;
 ; NOTE: Using the $G function to ensure UNDEFINED variables 
 ;       don't cause problems.
 W *2,"R",*3
 W *2,*27,"E2",*24,!,$G(TESTSTR),*3         ; TEST
 W *2,!,"Order#:",$G(LRCE),*3               ; ORDER #
 W *2,!,$G(LOCSTR),*3                       ; LOCATION (WARD & BED)
 W *2,!,$G(HRCN),*3                         ; HRCN
 W *2,!,$G(DOBSTR),*3                       ; DOB
 W *2,!,$E($G(PNM),1,27),*3                 ; PATIENT NAME
 W *2,!,$G(LRTOP),*3                        ; TOP/SPECIMEN
 W *2,!,$G(LRDAT),*3                        ; DATE
 W *2,!,$G(LRACC),*3                        ; ACCESSION
 W *2,!,$G(BLRURG),*3                       ; URGENCY
 W *2,*23,*15,"S30",*12,*3
 Q
