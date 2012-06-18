ACDFLAT3 ; IHS/ADC/EDE/KML - GENERATE FLAT ASCII RECORDS ;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
FILESFT ; EP-SHIFT TO SUBORDINATE FILE FOR REST OF DATA
 NEW ACDIIEN,ACDTIEN,ACDLC,ACDMIEN,ACDCSIEN
 S ACDIIEN=$O(^ACDIIF("C",ACDVIEN,0))
 I ACDIIEN D IIF,SETARRAY Q  ;             init/info/fu
 S ACDTIEN=$O(^ACDTDC("C",ACDVIEN,0))
 I ACDTIEN D TDC,SETARRAY Q  ;             trans/disc/close
 I $O(^ACDCS("C",ACDVIEN,0)) D CS Q  ;     client services
 Q
 ;
IIF ; GET DATA FROM INIT/INFO/FU FILE
 Q:'$D(^ACDIIF(ACDIIEN,0))  ;              corrupt database
 NEW ACDN0
 S ACDN0=^ACDIIF(ACDIIEN,0)
 S Y=$P(ACDN0,U) ;                         primary prob ptr
 S ACDF(113,114)=$$PROBCD(Y) ;             problem code
 NEW %,A
 S ACDMIEN=0
 F ACDLC=1:1:6 S ACDMIEN=$O(^ACDIIF(ACDIIEN,3,ACDMIEN)) Q:'ACDMIEN  D
 . Q:'$D(^ACDIIF(ACDIIEN,3,ACDMIEN,0))
 . S Y=$P(^ACDIIF(ACDIIEN,3,ACDMIEN,0),U) ;other prob ptr
 . S %=ACDLC
 . S A=$S(%=1:115,%=2:117,%=3:119,%=4:121,%=5:123,1:125)
 . S ACDF(A,A+1)=$$PROBCD(Y) ;             problem code
 . Q
 S X=$P(ACDN0,U,4) ;                       days used alcohol
 S:X'="" ACDF(53,55)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S X=$P(ACDN0,U,5) ;                       days used drugs
 S:X'="" ACDF(56,58)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 NEW %,A
 S ACDMIEN=0
 F ACDLC=1:1:4 S ACDMIEN=$O(^ACDIIF(ACDIIEN,2,ACDMIEN)) Q:'ACDMIEN  D
 . Q:'$D(^ACDIIF(ACDIIEN,2,ACDMIEN,0))
 . S Y=$P(^ACDIIF(ACDIIEN,2,ACDMIEN,0),U) ;drug ptr
 . S %=ACDLC
 . S A=$S(%=1:59,%=2:61,%=3:63,%=4:65)
 . S ACDF(A,A+1)=$$DRUGCD(Y) ;             drug code
 . Q
 S X=$P(ACDN0,U,7) ;                       days hospitalized
 S:X'="" ACDF(67,69)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S X=$P(ACDN0,U,8) ;                       alc/drug arrests
 S:X'="" ACDF(70,72)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S ACDF(73)=$P(ACDN0,U,10) ;               alc/sub stage
 S ACDF(74)=$P(ACDN0,U,11) ;               physical stage
 S ACDF(75)=$P(ACDN0,U,12) ;               emotional stage
 S ACDF(76)=$P(ACDN0,U,13) ;               social stage
 S ACDF(77)=$P(ACDN0,U,14) ;               cul/spirit stage
 S ACDF(78)=$P(ACDN0,U,15) ;               behavioral stage
 S (X,Y)=0
 F %=1:1:6 S W=$P(ACDN0,U,9+%) S:W'="" Y=Y+1,X=X+W ; compute stage
 S:Y ACDF(79,81)=$J(X/Y,3,1) ;               round & format
 S Y=$P(ACDN0,U,16) ;                      rec comp ptr
 S:Y ACDF(82,84)=$P($G(^ACDCOMP(Y,0)),U,2) ; rec comp code
 S ACDF(85)=$P(ACDN0,U,17) ;               rec comp type
 S Y=$P(ACDN0,U,18) ;                      act comp ptr
 S:Y ACDF(86,88)=$P($G(^ACDCOMP(Y,0)),U,2) ; act comp code
 S ACDF(89)=$P(ACDN0,U,19) ;               act comp type
 S Y=$P(ACDN0,U,20) ;                      difference reason
 S:Y Y=$P($G(^ACDPLEX(Y,0)),U,2) ;         difference code
 S:Y'="" ACDF(90,91)=$$LBLNK^ACDFUNC(X,2)
 S ACDF(100)=$P(ACDN0,U,23) ;              status
 S X=$P(ACDN0,U,6) ;                       hours
 S:X'="" ACDF(101,105)=$$LBLNK^ACDFUNC(X,5) ;left blank fill it
 Q
 ;
TDC ; GET DATA FROM TRANS/DISC/CLOSE FILE
 Q:'$D(^ACDTDC(ACDTIEN,0))  ;              corrupt database
 NEW ACDN0
 S ACDN0=^ACDTDC(ACDTIEN,0)
 S Y=$P(ACDN0,U,27) ;                      primary prob ptr
 S ACDF(113,114)=$$PROBCD(Y) ;             problem code
 NEW %,A
 S ACDMIEN=0
 F ACDLC=1:1:6 S ACDMIEN=$O(^ACDTDC(ACDTIEN,3,ACDMIEN)) Q:'ACDMIEN  D
 . Q:'$D(^ACDTDC(ACDTIEN,3,ACDMIEN,0))
 . S Y=$P(^ACDTDC(ACDTIEN,3,ACDMIEN,0),U) ;other prob ptr
 . S %=ACDLC
 . S A=$S(%=1:115,%=2:117,%=3:119,%=4:121,%=5:123,1:125)
 . S ACDF(A,A+1)=$$PROBCD(Y) ;             problem code
 . Q
 S X=$P(ACDN0,U,1) ;                       days used alcohol
 S:X'="" ACDF(53,55)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S X=$P(ACDN0,U,2) ;                       days used drugs
 S:X'="" ACDF(56,58)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 NEW %,A
 S ACDMIEN=0
 F ACDLC=1:1:4 S ACDMIEN=$O(^ACDTDC(ACDTIEN,2,ACDMIEN)) Q:'ACDMIEN  D
 . Q:'$D(^ACDTDC(ACDTIEN,2,ACDMIEN,0))
 . S Y=$P(^ACDTDC(ACDTIEN,2,ACDMIEN,0),U) ;drug ptr
 . S %=ACDLC
 . S A=$S(%=1:59,%=2:61,%=3:63,%=4:65)
 . S ACDF(A,A+1)=$$DRUGCD(Y) ;             drug code
 . Q
 S X=$P(ACDN0,U,4) ;                       days hospitalized
 S:X'="" ACDF(67,69)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S X=$P(ACDN0,U,5) ;                       alc/drug arrests
 S:X'="" ACDF(70,72)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S ACDF(73)=$P(ACDN0,U,7) ;                alc/sub stage
 S ACDF(74)=$P(ACDN0,U,8) ;                physical stage
 S ACDF(75)=$P(ACDN0,U,9) ;                emotional stage
 S ACDF(76)=$P(ACDN0,U,10) ;               social stage
 S ACDF(77)=$P(ACDN0,U,11) ;               cul/spirit stage
 S ACDF(78)=$P(ACDN0,U,12) ;               behavioral stage
 S (X,Y)=0
 F %=1:1:6 S W=$P(ACDN0,U,9+%) S:W'="" Y=Y+1,X=X+W ; compute stage
 S:Y ACDF(79,81)=$J(X/Y,3,1) ;             round & format
 S Y=$P(ACDN0,U,13) ;                      rec comp ptr
 S:Y ACDF(82,84)=$P($G(^ACDCOMP(Y,0)),U,2) ; rec comp code
 S ACDF(85)=$P(ACDN0,U,14) ;               rec comp type
 S Y=$P(ACDN0,U,15) ;                      act comp ptr
 S:Y ACDF(86,88)=$P($G(^ACDCOMP(Y,0)),U,2) ; act comp code
 S ACDF(89)=$P(ACDN0,U,16) ;               act comp type
 S Y=$P(ACDN0,U,17) ;                      difference reason
 S:Y Y=$P($G(^ACDPLEX(Y,0)),U,2) ;         difference code
 S:Y'="" ACDF(90,91)=$$LBLNK^ACDFUNC(Y,2)
 S X=$P(ACDN0,U,18) ;                      inpatient days
 S:X'="" ACDF(92,94)=$$LZERO^ACDFUNC(X,3) ;left zero fill it
 S ACDF(95,96)=$P(ACDN0,U,19) ;            goal attainment
 S ACDF(97,98)=$P(ACDN0,U,20) ;            t/d/c reason
 S ACDF(99)=$P(ACDN0,U,21) ;               discharge plan
 S ACDF(100)=$P(ACDN0,U,26) ;              status
 S X=$P(ACDN0,U,29) ;                      hours
 S:X'="" ACDF(101,105)=$$LBLNK^ACDFUNC(X,5) ;left blank fill it
 Q
 ;
CS ; GET DATA FROM CLIENT SERVICE ENTRIES
 NEW ACDN0
 S ACDCSIEN=0
 F  S ACDCSIEN=$O(^ACDCS("C",ACDVIEN,ACDCSIEN)) Q:'ACDCSIEN  D CS2
 Q
 ;
CS2 ; PROCESS ONE CS ENTRY
 ; killing of ACDF(n) necessary because one flat record is
 ; generated for each CS entry pointing to visit and all fields
 ; remain the same except those set here.  Fields may be missing.
 ;
 Q:'$D(^ACDCS(ACDCSIEN,0))  ;              corrupt database
 S ACDN0=^ACDCS(ACDCSIEN,0)
 S X=$P(ACDN0,U) ;                         day
 K ACDF(106)
 S:X'="" ACDF(106,107)=$$LZERO^ACDFUNC(X,2) ;left zero fill it
 S X=$P(ACDN0,U,2) ;                       svc/act
 K ACDF(108)
 S:X'="" ACDF(108,109)=$$LBLNK^ACDFUNC(X,3) ;left blank fill it
 S X=$P(ACDN0,U,3) ;                       loc/type
 K ACDF(110)
 S:X'="" ACDF(110,111)=$$LBLNK^ACDFUNC(X,2) ;left blank fill it
 S X=$P(ACDN0,U,4) ;                       hours
 S:X'="" ACDF(101,105)=$$LBLNK^ACDFUNC(X,5) ;left blank fill it
 NEW %,A
 K ACDF(133),ACDF(139),ACDF(145)
 S ACDMIEN=0
 F ACDLC=1:1:3 S ACDMIEN=$O(^ACDCS(ACDCSIEN,1,ACDMIEN)) Q:'ACDMIEN  D
 . Q:'$D(^ACDCS(ACDCSIEN,1,ACDMIEN,0))  ;  corrupt database
 . S Y=$P(^ACDCS(ACDCSIEN,1,ACDMIEN,0),U) ;provider ptr
 . S %=ACDLC
 . S A=$S(%=1:133,%=2:139,1:145)
 . S ACDF(A,A+5)=$P($G(^VA(200,Y,9999999)),U,9) ;   adc
 .;S ACDF(A,A+5)=$P($G(^DIC(6,Y,9999999)),U,9) ;   adc
 . Q
 D SETARRAY
 Q
 ;
PROBCD(Y)          ; GET 2 DIGIT PROBLEM CODE
 Q:'$G(Y) ""
 NEW X
 S X=""
 S X=$P($G(^ACDPROB(Y,0)),U,2) ;           prob code
 S:X'="" X=$$LZERO^ACDFUNC(X,2) ;          left zero fill it
 Q X
 ;
DRUGCD(Y)          ; GET 2 DIGIT DRUG CODE
 Q:'$G(Y) ""
 NEW X
 S X=""
 S X=$P($G(^ACDDRUG(Y,0)),U,2) ;           drug code
 S:X'="" X=$$LZERO^ACDFUNC(X,2) ;          left zero fill it
 Q X
 ;
SETARRAY ; SET RECORD INTO ARRAY
 S ACDFREC=""
 ; set values positionally ,left to right, into flat record from array
 F X=0:0 S X=$O(ACDF(X)) Q:X=""  K V S Y=$O(ACDF(X,0)) S:'Y Y=X,V=ACDF(X) S:'$D(V) V=ACDF(X,Y) S @("$E(ACDFREC,"_X_","_Y_")=V")
 S:$L(ACDFREC)<200 $E(ACDFREC,200)=" " ;   force fixed length
 S ACDRCTR=ACDRCTR+1
 S ACDARRAY(ACDRCTR)=ACDFREC
 D:$D(ACDFTEST) EP^XBCLM(ACDFREC) ;        show record for test
 Q
