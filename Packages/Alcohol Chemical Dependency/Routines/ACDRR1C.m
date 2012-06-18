ACDRR1C ;IHS/ADC/EDE/KML - PROCESS CDMIS VISITS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine processes each visit within date range, determines
 ; if patient has problem of alcohol or drugs, and counts substances
 ; being used.  A count is also kept for each problem encountered.
 ;
START ;
 D INIT
 D VISITS
 D PATIENTS
 D EOJ
 Q
 ;
INIT ;
 S (ACDBT,ACDBTH)=$H,ACDJOB=$J
 K ^TMP("ACDRR1",$J)
 Q
 ;
VISITS ; PROCESS ALL VISITS WITHIN DATE RANGE
 S ACDVCNT=0
 S ACDVDATE=$O(^ACDVIS("B",ACDDTLO),-1)
 F  S ACDVDATE=$O(^ACDVIS("B",ACDVDATE)) Q:ACDVDATE=""!(ACDVDATE>ACDDTHI)  D
 . S ACDVIEN=0
 . F  S ACDVIEN=$O(^ACDVIS("B",ACDVDATE,ACDVIEN)) Q:'ACDVIEN  D VISIT
 . Q
 Q
 ;
VISIT ; PROCESS ONE VISIT
 Q:'$D(^ACDVIS(ACDVIEN,0))  ;           bad xref
 Q:$G(^ACDVIS(ACDVIEN,"BWP"))'=ACDPGM  ;not from current program
 S X=^ACDVIS(ACDVIEN,0)
 S ACDTC=$P(X,U,4) ;                    type contact
 I ACDTC="IR"!(ACDTC="OT") Q
 S ACDPIEN=$P(X,U,5) ;                  patient ien
 Q:'ACDPIEN  ;                          bad data
 I '$D(^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN)) S ^(ACDPIEN)=""
 I ACDTC="CS" S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"CS",ACDVIEN)="" Q
 I ACDTC="TD" D
 .  NEW ACDCODE,ACDTYPE,ACDDATE
 .  S ACDDATE=$P(X,U),ACDCODE=$P(X,U,2),ACDTYPE=$P(X,U,7)
 .  S ^TMP("ACDRR1",$J,1,"LOS",ACDPIEN,ACDCODE_"/"_ACDTYPE,ACDDATE)=ACDVIEN
 .  Q
 D @("PRC"_ACDTC) ;                     process iif/td
 S ACDVCNT=ACDVCNT+1
 S (X,Y)=""
 I $D(^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"A",ACDVIEN)) S X="A"
 F  S Y=$O(ACDSTBL(Y)) Q:Y=""  S ^TMP("ACDRR1",$J,1,"DRUG",Y,ACDPIEN)="",X=$S(X="":Y,1:X_","_Y)
 I X'="",X["," S ^TMP("ACDRR1",$J,1,"DRUG COMBO",X,ACDPIEN)=""
 Q
 ;
PRCIN ; INITIAL
 D PRCIIF
 Q
 ;
PRCRE ; REOPEN
 D PRCIIF
 Q
 ;
PRCFU ; FOLLOWUP
 D PRCIIF
 Q
 ;
PRCIIF ; EP-PROCESS IIF ENTRY
 K ACDSTBL
 S ACDIIEN=$O(^ACDIIF("C",ACDVIEN,0))
 Q:'ACDIIEN  ;                          no iif entry
 S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN)=1 ; patients has iif or td
 D PRCIIF2 ;                            check problems
 D PRCIIF3 ;                            check drugs
 Q
 ;
PRCIIF2 ; CHECK FOR PROBLEM OF ALCOHOL OR DRUGS & SAVE ALL PROBLEMS
 ; do not stop when both found because need visits
 Q:'$D(^ACDIIF(ACDIIEN,0))  ;           bad xref
 S X=^ACDIIF(ACDIIEN,0)
 S ACDTOB=$P(X,U,30) ;                  save tobacco use
 D:ACDTOB PRCSETT
 S ACDADAYS=$P(X,U,4) ;                 save days used alcohol
 S ACDDDAYS=$P(X,U,5) ;                 save days used drugs
 S X=+X
 S ^TMP("ACDRR1",$J,1,"PROBLEM",X,ACDPIEN)=""
 S ^TMP("ACDRR1",$J,1,"PRI PROB",X,ACDPIEN)=""
 I X=ACDAIEN D PRCSETA
 I X=ACDDIEN D PRCSETD
 S Y=0
 F  S Y=$O(^ACDIIF(ACDIIEN,3,Y)) Q:'Y  I $D(^ACDIIF(ACDIIEN,3,Y,0)) S X=+^(0) D
 .  S ^TMP("ACDRR1",$J,1,"PROBLEM",X,ACDPIEN)=""
 .  I X=ACDAIEN D PRCSETA
 .  I X=ACDDIEN D PRCSETD
 .  Q
 Q
 ;
PRCIIF3 ; CHECK FOR DRUGS
 Q:'$D(^ACDIIF(ACDIIEN,0))  ;           bad xref
 S Y=0
 F  S Y=$O(^ACDIIF(ACDIIEN,2,Y)) Q:'Y  I $D(^ACDIIF(ACDIIEN,2,Y,0)) S X=+^(0) S ACDSTBL(X)=""
 Q
 ;
PRCTD ; EP-TRANS/DISC/CLOSE ENTRY
 K ACDSTBL
 S ACDTIEN=$O(^ACDTDC("C",ACDVIEN,0))
 Q:'ACDTIEN  ;                          no tdc entry
 S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN)=1 ; patients has iif or td
 D PRCTD2 ;                             check alcohol
 D PRCTD3 ;                             check drugs
 Q
 ;
PRCTD2 ; CHECK FOR PROBLEM OF ALCOHOL OR DRUGS & SAVE ALL PROBLEMS
 ; do not stop when both found because need visits
 Q:'$D(^ACDTDC(ACDTIEN,0))  ;           bad xref
 S X=^ACDTDC(ACDTIEN,0)
 S ACDTOB=$P(X,U,30) ;                  save tobacco use
 D:ACDTOB PRCSETT
 S ACDADAYS=$P(X,U) ;                   save days used alcohol
 S ACDDDAYS=$P(X,U,2) ;                 save days used drugs
 S X=$P(X,U,27)
 Q:'X  ;                                bad data
 S ^TMP("ACDRR1",$J,1,"PROBLEM",X,ACDPIEN)=""
 S ^TMP("ACDRR1",$J,1,"PRI PROB",X,ACDPIEN)=""
 I X=ACDAIEN S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"A")="",^("A",ACDVIEN)=""
 I X=ACDDIEN S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"D")="",^("D",ACDVIEN)=""
 S Y=0
 F  S Y=$O(^ACDTDC(ACDTIEN,3,Y)) Q:'Y  I $D(^ACDTDC(ACDTIEN,3,Y,0)) S X=+^(0) D
 .  S ^TMP("ACDRR1",$J,1,"PROBLEM",X,ACDPIEN)=""
 .  I X=ACDAIEN S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"A")="",^("A",ACDVIEN)=""
 .  I X=ACDDIEN S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"D")="",^("D",ACDVIEN)=""
 .  Q
 Q
 ;
PRCTD3 ; CHECK FOR DRUGS
 Q:'$D(^ACDTDC(ACDTIEN,0))  ;           bad xref
 S Y=0
 F  S Y=$O(^ACDTDC(ACDTIEN,2,Y)) Q:'Y  I $D(^ACDTDC(ACDTIEN,2,Y,0)) S X=+^(0) S ACDSTBL(X)=""
 Q
 ;
PRCSETA ; SET ALCOHOL HIT
 S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"A")="",^("A",ACDVIEN)="",^(ACDVIEN,"DAYS")=ACDADAYS
 Q
 ;
PRCSETD ; SET DRUG HIT
 S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"D")="",^("D",ACDVIEN)="",^(ACDVIEN,"DAYS")=ACDDDAYS
 Q
 ;
PRCSETT ; SET TOBACCO HIT
 S ^TMP("ACDRR1",$J,1,"PATIENT",ACDPIEN,"T",ACDTOB)=""
 Q
 ;
PATIENTS ; PROCESS PATIENTS WITH VISITS WITHIN TIME FRAME
 D PATIENTS^ACDRR1CB
 Q
 ;
EOJ ;
 S ACDET=$H
 K C,X,Y,Z
 K ACDA,ACDADAYS,ACDAGE,ACDAIEN,ACDCMBO,ACDCSC,ACDCSH,ACDCSHC,ACDCSIEN,ACDCT,ACDD,ACDDDAYS,ACDDIEN,ACDDRUG,ACDIIEN,ACDPIEN,ACDPRIEN,ACDSEX,ACDSTBL,ACDTC,ACDTOB,ACDTIEN,ACDVCNT,ACDVDATE,ACDVIEN
 K ^TMP("ACDRR1",$J,1)
 Q
