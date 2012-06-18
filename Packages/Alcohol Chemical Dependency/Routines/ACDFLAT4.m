ACDFLAT4 ;IHS/ADC/EDE/KML - GENERATE FLAT RECORDS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine generates flat ascii records from one cdmis
 ;   prevention record.
 ;
FLAT(ACDPIEN,ACDARRAY) ; EP-SET FLAT RECORDS INTO ARRAY
 ; i $$flat^acdflat4(cdmis_prevention_ien,.array_name) then flat records
 ; will be in array_name(n)=flat_record where n=1:1 and Q value will
 ; be the number of entries in array_name.
 ;
 ; fields set into array so flat record can be built left to right
 ; which is a must if any value shorter than specified by set $E
 ;
 NEW ACDFREC,ACDN0,ACDRCTR,X,Y
 S ACDRCTR=0
 G:'$D(^ACDPD(ACDPIEN,0)) FLATX  ;      corrupt database or bad ptr
 S ACDN0=^ACDPD(ACDPIEN,0)
 K ACDARRAY,ACDF ;             kill caller array + local field array
 S ACDF(1,6)=ACD6DIG ;                       asufac code
 S ACDF(7,13)=$P(ACDN0,U) ;                  prevention date
 S Y=$P(ACDN0,U,2) ;                         component ptr
 S:Y ACDF(14,16)=$P($G(^ACDCOMP(Y,0)),U,2) ; component code
 S ACDF(17)=$P(ACDN0,U,3) ;                  component type
 S ACDF(18,19)="PR" ;                        type contact
 S Y=$P(ACDN0,U,5) ;                         primary provider ptr
 S:Y ACDF(127,132)=$P($G(^VA(200,Y,9999999)),U,9) ; adc
 ;S:Y ACDF(127,132)=$P($G(^DIC(6,Y,9999999)),U,9) ; adc
 ;
 D PR
 D SETARRAY
 ;
FLATX ; EXIT
 Q ACDRCTR
 ;
PR ;
 NEW ACDN0
 S ACDPDIEN=0
 F  S ACDPDIEN=$O(^ACDPD(ACDPIEN,1,ACDPDIEN)) Q:'ACDPDIEN  D PR2
 Q
 ;
PR2 ; PROCESS ONE PR DAY ENTRY
 ; killing of ACDF(n) necessary because one flat record is
 ; generated for each PR entry and all fields remain the same except
 ; those set here.  Fields may be missing.
 ;
 Q:'$D(^ACDPD(ACDPIEN,1,ACDPDIEN,0))  ;            corrupt database
 S ACDN0=^ACDPD(ACDPIEN,1,ACDPDIEN,0)
 S X=$P(ACDN0,U) ;                         day
 K ACDF(106)
 S:X'="" ACDF(106,107)=$$LZERO^ACDFUNC(X,2) ;left zero fill it
 S X=$P(ACDN0,U,2) ;                       prv act
 S X=$G(^ACDPREV(9002170.9,X,0)),X=$P(X,U,2)
 K ACDF(175)
 S:X'="" ACDF(175,176)=$$LZERO^ACDFUNC(X,2) ;left zero fill it
 S X=$P(ACDN0,U,3) ;                       loc
 S X=$G(^ACDLOT(X,0)),X=$P(X,U,2)
 K ACDF(177)
 S:X'="" ACDF(177,178)=$$LZERO^ACDFUNC(X,2) ;left zero fill it
 S X=$P(ACDN0,U,4) ;                       target
 K ACDF(179)
 S:X'="" ACDF(179)=X
 S X=$P(ACDN0,U,5) ;                       number reached
 K ACDF(180)
 S:X'="" ACDF(180,185)=$$LZERO^ACDFUNC(X,6) ;left zero fill it
 S X=$P(ACDN0,U,6) ;                       outcome
 K ACDF(186)
 S:X'="" ACDF(186,187)=X
 S X=$P(ACDN0,U,7) ;                       community education
 K ACDF(188)
 S:X'="" ACDF(188)=X
 S X=$P(ACDN0,U,8) ;                       hours
 K ACDF(189)
 S:X'="" ACDF(189,193)=$$LBLNK^ACDFUNC(X,5) ;left blank fill it
 NEW %,A
 K ACDF(133),ACDF(139),ACDF(145)
 S ACDMIEN=0
 F ACDLC=1:1:3 S ACDMIEN=$O(^ACDPD(ACDPIEN,1,ACDPDIEN,"PRV",ACDMIEN)) Q:'ACDMIEN  D
 . Q:'$D(^ACDPD(ACDPIEN,1,ACDPDIEN,"PRV",ACDMIEN,0))  ;  corrupt database
 . S Y=$P(^ACDPD(ACDPIEN,1,ACDPDIEN,"PRV",ACDMIEN,0),U) ;provider ptr
 . S %=ACDLC
 . S A=$S(%=1:133,%=2:139,1:145)
 . S ACDF(A,A+5)=$P($G(^VA(200,Y,9999999)),U,9) ;   adc
 .;S ACDF(A,A+5)=$P($G(^DIC(6,Y,9999999)),U,9) ;   adc
 . Q
 Q
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
