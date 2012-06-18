ACDRR3C ;IHS/ADC/EDE/KML - PROCESS CDMIS VISITS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ; This routine processes each visit for one patient within date range
 ; and lists the stages over time.  Date range and patient ien passed
 ; by calling routine.
 ;
START ;
 D INIT
 D VISITS ;                     process visits for selected patient
 D EOJ
 Q
 ;
INIT ;
 S (ACDBT,ACDBTH)=$H,ACDJOB=$J
 K ^TMP("ACDRR3",$J)
 Q
 ;
VISITS ; PROCESS ALL VISITS FOR PATIENT WITHIN DATE RANGE
 S ACDVCNT=0
 S ACDVIEN=0
 F  S ACDVIEN=$O(^ACDVIS("D",ACDDFNP,ACDVIEN)) Q:'ACDVIEN  D VISIT
 Q
 ;
VISIT ; PROCESS ONE VISIT
 Q:'$D(^ACDVIS(ACDVIEN,0))  ;           bad xref
 Q:$G(^ACDVIS(ACDVIEN,"BWP"))'=ACDPGM  ;not from current program
 S X=^ACDVIS(ACDVIEN,0)
 S ACDVDATE=$P(X,U) ;                   visit date
 Q:ACDVDATE<ACDDTLO!(ACDVDATE>ACDDTHI)  ; quit if not in range
 S ACDTC=$P(X,U,4) ;                    type contact
 I ACDTC'="IN",ACDTC'="RE",ACDTC'="TD",ACDTC'="FU" Q
 S ACDDFNP=$P(X,U,5) ;                  patient ien
 Q:'ACDDFNP  ;                          bad data
 I '$D(^TMP("ACDRR3",$J,ACDBTH,"PATIENT",ACDDFNP)) S ^(ACDDFNP)=""
 S ACDVCNT=ACDVCNT+1
 D @("PRC"_ACDTC) ;                     process iif/td
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
PRCIIF ; PROCESS IIF ENTRY
 S ACDIIEN=$O(^ACDIIF("C",ACDVIEN,0))
 Q:'ACDIIEN  ;                               no iif entry
 S ^TMP("ACDRR3",$J,ACDBTH,"PATIENT",ACDDFNP)=1 ; patients has iif or td
 S ^TMP("ACDRR3",$J,ACDBTH,"V",ACDVDATE,ACDVCNT,"TC")=ACDTC
 F ACDFIELD=9,10,11,12,13,14,14.5 D
 .  S ACDCOL=$P($T(@("IIFC"_$TR(ACDFIELD,".","P"))),";;",2)
 .  S ^TMP("ACDRR3",$J,ACDBTH,"V",ACDVDATE,ACDVCNT,"COL",ACDCOL)=$$VAL^XBDIQ1(9002170,ACDIIEN,ACDFIELD)
 .  Q
 Q
 ;
IIFC9 ;;1
IIFC10 ;;2
IIFC11 ;;3
IIFC12 ;;4
IIFC13 ;;5
IIFC14 ;;6
IIFC14P5 ;;7
 ;
PRCTD ; TRANS/DISC/CLOSE ENTRY
 S ACDTIEN=$O(^ACDTDC("C",ACDVIEN,0))
 Q:'ACDTIEN  ;                          no tdc entry
 S ^TMP("ACDRR3",$J,ACDBTH,"PATIENT",ACDDFNP)=1 ; patients has iif or td
 S ^TMP("ACDRR3",$J,ACDBTH,"V",ACDVDATE,ACDVCNT,"TC")=ACDTC
 F ACDFIELD=6,7,8,9,10,11,11.5 D
 .  S ACDCOL=$P($T(@("TDCC"_$TR(ACDFIELD,".","P"))),";;",2)
 .  S ^TMP("ACDRR3",$J,ACDBTH,"V",ACDVDATE,ACDVCNT,"COL",ACDCOL)=$$VAL^XBDIQ1(9002171,ACDTIEN,ACDFIELD)
 .  Q
 Q
 ;
TDCC6 ;;1
TDCC7 ;;2
TDCC8 ;;3
TDCC9 ;;4
TDCC10 ;;5
TDCC11 ;;6
TDCC11P5 ;;7
 ;
EOJ ;
 S ACDET=$H
 K C,X,Y,Z
 K ACDDFNP,ACDVCNT,ACDVDATE,ACDVIEN
 ;K ^TMP("ACDRR3",$J,1)
 Q
