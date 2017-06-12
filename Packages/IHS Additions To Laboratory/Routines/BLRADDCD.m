BLRADDCD ;IHS/MSC/MKK - Add Completed Date to all tests in an Accession ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 01, 1997
 ;
 ; This is a "quick and dirty" routine so as to help
 ; sites with accessions that exist but do not have
 ; any data in the Lab Data file. The only solution is
 ; to put a COMPLETED DATE on ALL the tests in the Accession
 ; and let ROLLOVER push them off the incomplete list.
 ;
EEP ; EP - Ersatz Entry Point
 D EEP^BLRGMENU
 Q
 ;
PEP ; EP
EP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D INITVARS
 ;
 F  Q:LRAS="Q"  D
 . D HEADERDT^BLRGMENU
 . Q:$$GETACCS(.LRAA,.LRAD,.LRAN,.LRAS)="Q"
 . ;
 . S COMPDATE=$$NOW^XLFDT
 . ;
 . S F60CNT=0,LRAT=.9999999
 . F  S LRAT=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT))  Q:LRAT<1  D
 .. D WARMFZZY(LRAA,LRAD,LRAN,LRAT,.F60CNT,.F60IEN,.F60DESC)
 .. ;
 .. S IENS=LRAT_","_LRAN_","_LRAD_","_LRAA_","
 .. ;
 .. ; If already COMPLETED DATE, skip
 .. I +$$GET1^DIQ(68.04,IENS,4,"I")  D DATEOKAY(F60IEN,F60DESC)  Q
 .. ;
 .. D ^XBFMK
 .. K FDA,ERRS
 .. S FDA(68.04,IENS,4)=COMPDATE
 .. S FDA(68.04,IENS,5)="*Not Performed"
 .. D FILE^DIE("KS","FDA","ERRS")
 .. I $D(ERRS) D SHOWERRS("ACCESSION FILE",F60IEN,F60DESC)  Q
 .. ;
 .. ; Modify File 69
 .. D ORDERMSG
 .. ;
 .. D SUCCESS(F60IEN,F60DESC)
 . D:F60CNT<1 NOTESTS
 . D PRESSKEY^BLRGMENU(4)
 Q
 ;
INITVARS ; EP - Initialization of variables
 S BLRVERN=$$TRIM^XLFSTR($P($T(+1),";"),"LR"," ")
 ;
 S HEADER(1)="Invalid Accession Fix"
 S HEADER(2)="Add Completed Date to Tests"
 ;
 S LRAS="NOT YET"
 S CDFIELDN=4             ; The Completed Date's field #
 S DISPFLD=5              ; Disposition field
 Q
 ;
GETACCS(LRAA,LRAD,LRAN,LRAS) ; EP - Get Accession Number
 D ^LRWU4
 I (LRAA<1)!(LRAD<1)!(LRAN<1) S LRAS="Q"  Q "Q"
 ;
 S LRAS=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))
 I $G(LRAS)="" D BADENTRY  Q "Q"
 ;
 ; Skip if data exists in the Lab Data file for the Accession
 NEW LRDFN,LRIDT,LRSS
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),LRIDT=+$P($G(^(3)),"^",5)
 S LRSS=$P($G(^LRO(68,LRAA,0)),"^",2)
 ;
 Q:$D(^LR(LRDFN,LRSS,LRIDT,0))<1 "OK"  ; No Data, okay to use
 ;
 W !!,?4,"Lab Data Exists for Accession ",LRAS,".",!!
 W ?4,"Cannot Use that Accession.  Try Again."
 D PRESSKEY^BLRGMENU(9)
 ;
 Q "Q"
 ;
GETCOMPD(COMPDATE) ; EP - Get Completed Date
 W !!
 D ^XBFMK
 S DIR(0)="DAO"
 S DIR("A")="Enter Completed Date:"
 D ^DIR
 I +$G(Y)<1 D BADENTRY  Q "Q"
 ;
 S COMPDATE=+$G(Y)
 Q "OK"
 ;
BADENTRY ; EP - Invalid/No Data Entered.  Confirm quit
 W !!
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")=$J("",4)_"Invalid/No Entry.  Try Again"
 S DIR("B")="NO"
 D ^DIR
 I +$G(Y)<1 S LRAS="Q"
 Q
 ;
NOTESTS ; EP - No Tests on the accesssion
 W !!,?9,"No Tests on Accession."
 Q
 ;
WARMFZZY(LRAA,LRAD,LRAN,LRAT,F60CNT,F60IEN,F60DESC) ; EP - "Warm Fuzzy" for user
 S F60CNT=F60CNT+1
 S F60IEN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRAT,0))
 S F60DESC=$P($G(^LAB(60,F60IEN,0)),"^")
 W:F60CNT=1 !!,?4,"For Accession ",LRAS,!
 Q
 ;
DATEOKAY(F60IEN,F60DESC) ; EP
 W ?9,"Completed Date already exists on test ",F60DESC," (#",F60IEN,").",!
 Q
 ;
SUCCESS(F60IEN,F60DESC) ; EP
 W ?9,"Completed Date added to test ",F60DESC," (#",F60IEN,").",!
 Q
 ;
SHOWERRS(WOTFILE,F60IEN,F60DESC) ; EP - Show the details from the ERRORS Array
 W ?9,"ERROR - Updating File ",WOTFILE,!
 I $G(F60IEN)'="",$G(F60DESC)'="" W ?14,"Trying to Add Completed Date to test ",F60DESC," (#",F60IEN,").",!
 D CHKERRS("FDA")
 D CHKERRS("ERRS")
 Q
 ;
CHKERRS(ARRY) ; EP - Errors Occurred.  Check them out.
 NEW LEN,STR1,STR2,TAB
 ;
 ; The following code "dumps" the array.
 S STR1=$Q(@ARRY@(""))
 W ?14,STR1,"=",@STR1,!
 F  S STR1=$Q(@STR1)  Q:STR1=""  D
 . S STR2=@STR1
 . W ?14,STR1,"="
 . S TAB=$X
 . S LEN=IOM-TAB                ; Max length before wrapping
 . W $E(STR2,1,LEN-1),!
 . W:$L(STR2)>(LEN-1) ?TAB,$E(STR2,LEN,9999),!
 W !
 Q
 ;
 ; Setup Order file with "Cancelled" message, if it doesn't exist already
ORDERMSG ; EP
 NEW DONE,LRORD,LRORN,LRORT,NOWDT,NOWDTT,ORDERN,STR
 NEW ERRS,FDA,FDAIENS
 ;
 S ORDERN=+$G(^LRO(68,LRAA,1,LRAN,1,LRAN,.1))
 ;
 S (DONE,LRORD,LRORN,LRORT)=0
 F  S LRORD=$O(^LRO(69,"C",ORDERN,LRORD))  Q:LRORD<1!(DONE)  D
 . F  S LRORN=$O(^LRO(69,"C",ORDERN,LRORD,LRORN))  Q:LRORN<1!(DONE)  D
 .. F  S LRORT=$O(^LRO(69,LRORD,1,LRORN,2,LRORT))  Q:LRORT<1!(DONE)  D
 ... S STR=$G(^LRO(69,LRORD,1,LRORN,2,LRORT,0))
 ... Q:+STR'=LRAT
 ... ;
 ... ; Skip if already cancelled
 ... Q:$L($P(^LRO(69,LRORD,1,LRORN,2,LRORT,0),"^",11))
 ... ;
 ... S FDAIENS=LRORT_","_LRORN_","_LRORD_","
 ... K FDA
 ... S FDA(69.03,FDAIENS,8)="CA"
 ... S FDA(69.03,FDAIENS,11)=$G(DUZ)
 ... D FILE^DIE("KS","FDA","ERRS")
 ... I $D(ERRS) D SHOWERRS("Order File")  Q
 ... D MAKEMESG(LRORD,LRORN,LRORT)
 ... S DONE=1
 Q
 ;
 ; S LRODT=LRORD,LRSN=LRORN,LRI=LRORT
MAKEMESG(LRODT,LRSN,LRI) ; EP - Create the cancel reason in 69 - some code cloned from LRHYDEL routine.
 NEW ORIFN,LRODT,LRSN,LRI,II
 ;
 S (LRSTATUS,II(LRAT))=""
 ;
 S ORIFN=$P(^LRO(69,LRODT,1,LRSN,2,LRI,0),U,7)
 S X=1+$O(^LRO(69,LRODT,1,LRSN,2,LRI,1.1,"A"),-1),X(1)=$P($G(^(0)),U,4)
 S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,X,0)="OTHER CANCEL REASON: *NP Reason:Malformed Accession"
 S X=X+1,X(1)=X(1)+1
 S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,X,0)="*NP Action:"_$$HTE^XLFDT($H,"5MZ")
 S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,0)="^^"_X_"^"_X(1)_"^"_DT
 I $G(ORIFN),$D(II) D NEW^LR7OB1(LRODT,LRSN,$S($G(LRMSTATI)=""!($G(LRMSTATI)=1):"OC",1:"SC"),$G(LRNATURE),.II,LRSTATUS)
 I ORIFN,$$VER^LR7OU1<3 D DC^LRCENDE1
 S $P(^LRO(69,LRODT,1,LRSN,2,LRI,0),"^",9)="CA",$P(^(0),U,10)="L",$P(^(0),U,11)=DUZ
 S:$D(^LRO(69,LRODT,1,LRSN,"PCE")) ^LRO(69,"AE",DUZ,LRODT,LRSN,LRI)=""
 Q
