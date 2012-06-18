BLRLABLA ; IHS/DIR/MKK - INTERMEC 4100 2 LABEL PRINT BARCODE/PLAIN 10:16 ; 
 ;;5.2;LR;**1001,1006,1007,1009,1018,1019**;MAR 25, 2005
 ;;5.2;LR;**1001,1006,1007,1009**;Mar 7, 2001
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
FLAG S:FLAG=0 LRDTXT=LRTXT S:FLAG=1 LRDTXT=".............."
 S LRLPNM=$P(PNM,",",1),LRLPNM=LRLPNM_$S($L(LRLPNM)<18:","_$E($P(PNM,",",2),1),1:"")
 I $D(LRBAR) D BAR Q  ;IHS/MJL 3/18/99
 D PRT K BLRURG
 ;Q:'$D(LRBAR)!('$D(LRBAR($G(LRAA))))
 Q  ;IHS/DIR TUC/AAB 03/23/98
 ;
BAR ;barcode label..accession number barcoded
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018 IHS/ITSC/MKK
 ; Make certain DOB has something in it
 NEW DOBSTR                                 ; Date Of Birth STRing
 S DOBSTR=" DoB:"
 I $G(DOB)'="" D                            ; If DoB exists, get
 . S X=DOB  S %DT=""  D ^%DT
 . S DOBSTR=" DoB:"_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_($E(Y,1,3)+1700)
 ;
 ; Make certain date string has a 2-digit year
 NEW LRDSHRT                                ; LaboRatory SHort date
 S LRDSHRT=LRDAT
 I $L($P($P(LRDAT,"/",3)," ",1))>2 D
 . S LRDSHRT=$P(LRDAT,"/",1,2)_"/"_$E($P(LRDAT,"/",3),3,$L(LRDAT))
 ;
 ; Get Provider Name from NEW PERSON file, if it exists
 NEW PROVN                                  ; Provider Name
 S PROVN=""                                 ; Initialize
 NEW PTR                                    ; Provider Pointer
 I $G(LRAA)'=""&($G(LRAD)'="")&($G(LRAN)'="")  D
 . S PTR=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",8)
 . I $G(PTR)'="" S PROVN=$P($G(^VA(200,PTR,0)),"^",1)
 ;
 ; Location variable
 NEW LOCVAR                                 ; Location String
 S LOCVAR="W:"_$E($G(LRLLOC),1,7)
 I $G(LRRB)'="" S LOCVAR=LOCVAR_" B:"_LRRB  ; If Bed variable exists, get it
 ;
 NEW TESTSVAR                               ; TEST(S) VARiable
 S TESTSVAR=$E($G(LRTXT),1,32)
 I $L($G(LRTXT))>31 S TESTSVAR=TESTSVAR_"..."
 ;
 ; Urgency variable
 S BLRURG=""                                ; Intialize
 S LRURG0=$G(LRURG0) I LRURG0'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)  ;IHS/DIR TUC/AAB 03/23/98
 ;
 W *2,"R",*3
 W *2,*27,"E3",*24,!,TESTSVAR,*3            ; (01) Test(s)
 W *2,!,LRTOP,*3                            ; (02) Collection sample - tube top/specimen
 W *2,!,"Order#:",LRCE,*3                   ; (03) Order Number
 W *2,!,LRACC,*3                            ; (04) Accession String
 W *2,!,LRDSHRT,*3                          ; (05) Date
 W *2,!,HRCN,*3                             ; (06) Health Record Number
 W *2,!,LOCVAR,*3                           ; (07) Location
 W *2,!,$E(PNM,1,27),*3                     ; (08) Patient Name
 W *2,!,BLRURG,*3                           ; (09) Urgency
 W *2,!,$E("0000",$L(LRAN),4)_LRAN,*3       ; (10) Accession Number -- Bar Coded
 W *2,*23,*15,"S30",*12,*3
 ;
 K BLRURG  ;IHS/DIR TUC/AAB 03/23/98
 ;----- END IHS MODIFICATIONS LR*5.2*1018 IHS/ITSC/MKK           
 Q
PRT ;plain label..no barcode
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018 IHS/ITSC/MKK
 ; Make certain DOB has something in it
 NEW DOBSTR                                 ; Date Of Birth STRing
 S DOBSTR="XX/XX/XX"                        ; Initialize to nonsense
 I $G(DOB)'="" D             ; If something there, set to real date
 . S X=$G(DOB)
 . S %DT=""
 . D ^%DT
 . S DOBSTR=" DoB:"_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_($E(Y,1,3)+1700)
 ;
 ; Make certain date string has a 2-digit year
 NEW LRDSHRT                                ; LaboRatory SHort date
 S LRDSHRT=LRDAT                            ; Initialize
 I $L($P($P(LRDAT,"/",3)," ",1))>2 D
 . S LRDSHRT=$P(LRDAT,"/",1,2)_"/"_$E($P(LRDAT,"/",3),3,$L(LRDAT))
 ;
 ; Make certain provider name has data
 NEW PROVN                                  ; Provider Name
 S PROVN=""                                 ; Initialize
 NEW PTR                                    ; Provider Pointer
 I $G(LRAA)'=""&($G(LRAD)'="")&($G(LRAN)'="")  D
 . S PTR=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),"^",8)
 . I $G(PTR)'="" S PROVN=$P($G(^VA(200,PTR,0)),"^",1)
 ;
 ; Location variable
 NEW LOCVAR                                 ; LOCation VARiable
 S LOCVAR="W:"_$E(LRLLOC,1,7)
 I $L(LRRB)>0 S LOCVAR=LOCVAR_" B:"_LRRB    ; If Bed variable exists, get it
 ;
 NEW TESTSVAR                               ; TEST(S) VARiable
 S TESTSVAR=$E(LRTXT,1,32)
 I $L(LRTXT)>31 S TESTSVAR=TESTSVAR_"..."
 ;
 ; Urgency variable
 S BLRURG=""                                ; Initialize
 S LRURG0=$G(LRURG0) I LRURG0'="" S BLRURG=$E($P(^LAB(62.05,LRURG0,0),U,1),1,4)  ;IHS/DIR TUC/AAB 03/23/98
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1019 IHS/ITSC/MKK
 ; Using $G in case any of the variables are null -- an issue with testing labels
 W *2,"R",*3
 W *2,*27,"E2",*24,!,$G(TESTSVAR),*3        ; Test(s)
 W *2,!,$G(LRTOP),*3                        ; Collection sample - tube top/specimen
 W *2,!,"Order#:",$G(LRCE),*3               ; Order Number
 W *2,!,$G(LRACC),*3                        ; Accession string
 W *2,!,$G(LRDSHRT),*3                      ; Date
 W *2,!,$G(HRCN),*3                         ; Health Record Number
 W *2,!,$G(LOCVAR),*3                       ; Location
 W *2,!,$G(PNM),*3                          ; Patient Name
 W *2,!,$G(BLRURG),*3                       ; Urgency
 W *2,!,"Sex:",$G(SEX),*3                   ; Sex
 W *2,!,"Prov:"_$E($G(PROVN),1,18),*3       ; Provider
 W *2,!,$G(DOBSTR),*3                       ; Date of Birth
 ;----- END IHS MODIFICATIONS LR*5.2*1019 IHS/ITSC/MKK
 ;
 W *2,*23,*15,"S30",*12,*3
 ;----- END IHS MODIFICATIONS LR*5.2*1018 IHS/ITSC/MKK           
 Q
