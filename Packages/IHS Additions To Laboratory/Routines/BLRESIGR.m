BLRESIGR ; IHS/OIT/MKK - Laboratory E-SIG Reports ; [ 04/12/06  4:00 PM ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;
 ; NOTE:  The LRIDT variable in the LR("BLRA") index is stored as a
 ; negative number.  That is why, in several places, the code does a 
 ; -(LRIDT).
 ;
 ; This routine also makes extensive use of the BLRGMENU (generic
 ; menu driver) routine.  See notes there regarding its calls.
 ;
 ; The main reason to use the BLRGMENU routine instead of making the
 ; various calls OPTIONs in the OPTION file is to make certain all the
 ; variables used in this routine are NEWed.  This means the variables
 ; will NOT interfere with other LAB routines.
 ;
EEP ; Ersatz EP
 W $C(7),$C(7),$C(7),!
 W "Use Label Only",!
 W $C(7),$C(7),$C(7),!
 Q
 ;
PEP ; "Real" EP
 ;
 ; This should never happen, BUT need to determine if IHS E-SIG
 ; is turned on -- if NOT, bail out
 I $$ADDON^BLRUTIL("LR*5.2*1013","BLRALAF",DUZ(2))'=1 D  Q
 . W !!,"IHS LR*5.2*1013 E-SIG is NOT on.",!!
 . D BLRGPGR^BLRGMENU(10)     ; Press RETURN prompt
 ;
 ; NEW variables so that they do not impact any other routines
 NEW BLRA,ESPHY,STATUS,LRIDT,LRDFN,LRAA,LRAS,LRAD,SPHY
 NEW BLRMMENU,BLRESIGR,ESIGIEN
 NEW NRESP,NSIGN,RESP,SIGN,CNT,PHYCNT,TOTCNT
 NEW HEADER,LINES,MAXLINES,QFLG,HLCNT
 NEW PATN,ACCN
 NEW BEGIDT,ENDIDT
 NEW PHYSUR,PHYSURG
 NEW SIGNDT,SELPHYS
 ;
 D SETMENU
 D MENUDRFM^BLRGMENU("LAB E-SIG Reports")   ; Main Menu driver
 ;
 D ^XBCLS
 W !,?11,"Lab E-SIG Menu"
 Q
 ;
SETMENU ;                            ; MAIN MENU INITIALIZATION
 K BLRMMENU
 D ADDTMENU^BLRGMENU("ALLESIGS^BLRESIGR","All E-SIG Transactions")
 D ADDTMENU^BLRGMENU("ALLESIGN^BLRESIGR","Signed Transactions")
 D ADDTMENU^BLRGMENU("ALLNSIGN^BLRESIGR","Not Signed by Responsible Physician")
 D ADDTMENU^BLRGMENU("NREVNSGN^BLRESRNS","Not Reviewed nor Signed Summary")
 ;
 Q
 ;
 ; All E-Sig Transactions in LAB DATA file
ALLESIGS ;                       EP
 D ^XBFMK                     ; Clear out ALL FileMan variables
 S DIR("A")="Output ALL E-SIG transactions for ALL Providers"
 S DIR(0)="Y",DIR("B")="YES"
 D ^DIR
 I X["^" D  Q
 . W !,?10,"Exit entered.  No Report.",!
 . D BLRGPGR^BLRGMENU(10)     ; Press Return prompt
 ;
 I Y=1 D ALLSTS
 I Y'=1 D SELSTS
 Q
 ;
 ; ALL E-Sig transactions in LAB DATA file by ALL Responsible Physicians
ALLSTS ;                       EP
 D FULLCOMP
 D FULLRPTH
 D ESIGRPT("FULLRPTL")
 Q
 ;
 ; ALL E-Sig transactions in LAB DATA file by SELECTED
 ; Responsible Physician(s)
SELSTS ;
 I $$SELCTPHY="Q" Q
 ;
 D ALLPCOMP
 D FULLRPTH
 D ESIGRPT("FULLRPTL")
 Q
 ;
 ; Sort E-SIG data
FULLCOMP ;
 D DATERNGE              ; Get Date Range
 K BLRESIGR              ; Clear array
 ;
 S ESPHY=""              ; E-SIG Physician
 F  S ESPHY=$O(^LR("BLRA",ESPHY))  Q:ESPHY=""  D
 . D GETESIGD^BLRESRCD
 Q
 ;
 ; Header
FULLRPTH ;
 D ESIGRPTH("ALL LAB E-SIG ACCESSIONS")
 S HLCNT=HLCNT+1
 S HEADER(HLCNT)="RESP PHYSICIAN"
 S $E(HEADER(HLCNT),17)="ACC #"
 S $E(HEADER(HLCNT),37)="COLL DATE/TIME"
 S $E(HEADER(HLCNT),53)="STATUS"
 S $E(HEADER(HLCNT),66)="SIGN PHYSICIAN"
 ;
 Q
 ;
 ; Output line of data
FULLRPTL ;
 D ESIGBRKO
 ;
 I LINES>MAXLINES D BLRGHWPN^BLRGMENU(.PG,.QFLG)  I QFLG="Q" Q
 ;
 W $E(NRESP,1,15)
 W ?16,ACCN
 W ?36,$$FMTE^XLFDT(COLLDTT,"2MZ")
 W ?52,$E(STATUS,1,12)
 W ?65,$E(NSIGN,1,15)
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 Q
 ;
 ; Initialize HEADER array
ESIGRPTH(HEAD1) ;
 NEW RANGESTR
 ;
 S RANGESTR="DATE RANGE: "
 S RANGESTR=RANGESTR_$$FMTE^XLFDT(LRSDT,"2DZ")
 S RANGESTR=RANGESTR_" THRU "_$$FMTE^XLFDT(LRLDT,"2DZ")
 S RANGESTR=$$CJ^XLFSTR(RANGESTR,IOM)
 ;
 K HEADER
 S HEADER(1)=HEAD1
 S HEADER(2)="SORTED BY RESPONSIBLE PHYSICIAN"
 S HEADER(3)=RANGESTR
 S HEADER(4)=" "
 S HLCNT=4     ; HEADER LINE COUNT
 ;
 Q
 ;
ESIGRPT(WOTDLINE) ;
 I $$GETDEV="Q" D  Q
 . W !,"Output Device Error",!!
 . D BLRGPGR^BLRGMENU()
 ;
 U IO
 S (NRESP,PATN,LRAA,LRDFN,LRIDT)=""
 S CNT=0
 F  S NRESP=$O(BLRESIGR(NRESP))  Q:NRESP=""!(QFLG="Q")  D
 . S PHYCNT=0
 . F  S PATN=$O(BLRESIGR(NRESP,PATN))  Q:PATN=""!(QFLG="Q")  D
 .. F  S LRAA=$O(BLRESIGR(NRESP,PATN,LRAA))  Q:LRAA=""!(QFLG="Q")  D
 ... F  S LRDFN=$O(BLRESIGR(NRESP,PATN,LRAA,LRDFN))  Q:LRDFN=""!(QFLG="Q")  D
 .... F  S LRIDT=$O(BLRESIGR(NRESP,PATN,LRAA,LRDFN,LRIDT))  Q:LRIDT=""!(QFLG="Q")  D
 ..... D @WOTDLINE
 ..... S PHYCNT=PHYCNT+1
 . I PHYCNT>0 D
 .. W !
 .. S LINES=LINES+1
 ;
 D ^%ZISC           ; Close IO port
 ;
 W !!,"Number of records = ",CNT,!!
 ;
 D BLRGPGR^BLRGMENU()
 Q
 ;
GETDEV() ; EP
 D ^%ZIS
 I POP>0 Q "Q"
 ;
 S PG=0
 S MAXLINES=IOSL-4
 S LINES=MAXLINES+10
 S QFLG="NO"
 ;
 Q "OK"
 ;
 ; "Break out" BLRESIGR array variables
ESIGBRKO ;
 S ACCN=$P($G(^LR(LRDFN,LRAA,LRIDT,0)),"^",6)     ; Accession Number
 S COLLDTT=$P($G(^LR(LRDFN,LRAA,LRIDT,0)),"^",1)  ; Collection Date/Time
 S STATUS=$P($G(^LR(LRDFN,LRAA,LRIDT,9009027)),"^",1)  ; E-SIG Transaction Status
 S STATUS=$S(STATUS=0:"NOT REVIEWED",STATUS=1:"REVIEWED",STATUS=2:"REV & SIGNED",1:"<UNK>")
 ;
 S SIGN=$P($G(^LR(LRDFN,LRAA,LRIDT,9009027)),"^",3)    ; Signing Physician's IEN
 I SIGN="" S NSIGN=""  Q
 S NSIGN=$P($G(^VA(200,SIGN,0)),"^",1)  ; Signing Physician's Name
 S SIGNDT=$P($G(^LR(LRDFN,LRAA,LRIDT,9009027)),"^",5)
 Q
 ;
 ; Select E-SIG participating Physician(s)
SELCTPHY() ;
 NEW FLG,PHYCNT
 K SELPHYS
 ;
 S FLG="OK",PHYCNT=0
 F  D  Q:FLG'="OK"
 . S FLG=$$GETPHYIN
 . I FLG="Q" Q
 . ;
 . S SELPHYS(ESIGIEN)=""
 . S PHYCNT=PHYCNT+1
 . W !
 ;
 I PHYCNT<1 D  Q "Q"
 . W !,"No Providers selected",!
 . D BLRGPGR^BLRGMENU()
 ;
 Q "OK"
 ;
 ; Get E-SIG Physician's Internal Entry Number (IEN)
GETPHYIN() ;
 D ^XBFMK
 S DIC=9009027.1
 S DIC(0)="QEAZ"
 D ^DIC
 I Y<1 Q "Q"
 I X["^"!($G(X)="") Q "Q"
 ;
 S ESIGIEN=+Y
 Q "OK"
 ;
 ; Sort E-SIG data using Selected Physicians
ALLPCOMP ;
 D DATERNGE              ; Get Date Range
 K BLRESIGR              ; Clear array
 ;
 S ESPHY=""
 F  S ESPHY=$O(SELPHYS(ESPHY))  Q:ESPHY=""  D
 . D GETESIGD^BLRESRCD
 ;
 Q
 ;
ALLESIGN ;                       EP
 D ^XBFMK                     ; Clear out ALL FileMan variables
 S DIR("A")="Output ALL E-SIG SIGNED transactions for ALL Providers"
 S DIR(0)="Y",DIR("B")="YES"
 D ^DIR
 I X["^" D  Q
 . W !,?10,"Exit entered.  No Report.",!
 . D BLRGPGR^BLRGMENU(10)     ; Press Return prompt
 ;
 I Y=1 D ASIGNSTS
 I Y'=1 D SSIGNSTS
 Q
 ;
 ;  ALL E-Sig Transactions with Status = 2 ==> Reviewed & Signed
ASIGNSTS ;                       EP
 D SIGNCOMP
 D SIGNRPT
 Q
 ;
 ; Sort Status = 2 E-SIG data
SIGNCOMP ;
 D DATERNGE
 K BLRESIGR              ; Clear array
 ;
 S STATUS=2              ; Initialize variable
 ;
 S ESPHY=""              ; E-SIG Physician
 F  S ESPHY=$O(^LR("BLRA",ESPHY))  Q:ESPHY=""  D
 . S NRESP=$P($G(^VA(200,ESPHY,0)),"^",1)
 . S BLRESIGR(NRESP)=ESPHY
 . D GETESIG2^BLRESRCD
 Q
 ;
SIGNRPT ;
 I $$GETDEV="Q" D  Q
 . W !,"Output Device Error",!!
 . D BLRGPGR^BLRGMENU()
 ;
 D ESIGRPTH("SIGNED LAB E-SIG ACCESSIONS")
 ;
 U IO
 S (NRESP,PATN,LRAA,LRDFN,LRIDT)=""
 S CNT=0
 F  S NRESP=$O(BLRESIGR(NRESP))  Q:NRESP=""!(QFLG="Q")  D
 . S PHYCNT=0
 . F  S PATN=$O(BLRESIGR(NRESP,PATN))  Q:PATN=""!(QFLG="Q")  D
 .. F  S LRAA=$O(BLRESIGR(NRESP,PATN,LRAA))  Q:LRAA=""!(QFLG="Q")  D
 ... F  S LRDFN=$O(BLRESIGR(NRESP,PATN,LRAA,LRDFN))  Q:LRDFN=""!(QFLG="Q")  D
 .... F  S LRIDT=$O(BLRESIGR(NRESP,PATN,LRAA,LRDFN,LRIDT))  Q:LRIDT=""!(QFLG="Q")  D
 ..... D SIGNRPTL
 . I PHYCNT>0 D
 .. W !!,?10,"Number of Signed E-SIG transactions for ",NRESP," = ",PHYCNT,!
 . S LINES=MAXLINES+10
 ;
 D ^%ZISC           ; Close IO port
 ;
 D BLRGPGR^BLRGMENU()
 Q
 ; 
 ; Output line of data
SIGNRPTL ;
 D ESIGBRKO
 ;
 I LINES>MAXLINES D  I QFLG="Q" Q
 . D SURINHDR(HLCNT)
 . D BLRGHWPN^BLRGMENU(.PG,.QFLG)
 ;
 W ACCN
 W ?19,$$FMTE^XLFDT(COLLDTT,"2MZ")
 W ?35,$$FMTE^XLFDT(SIGNDT,"2MZ")
 W ?51,$E(NSIGN,1,25)
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 S PHYCNT=1+$G(PHYCNT)
 Q
 ;
 ; Selected Physicians and their signed E-SIG transactions
SSIGNSTS ;
 I $$SELCTPHY="Q" Q
 ;
 D SGNPCOMP
 D SIGNRPT
 Q
 ;
SGNPCOMP ;
 D DATERNGE
 K BLRESIGR              ; Clear array
 ;
 S STATUS=2              ; Initialize variable
 ;
 S ESPHY=""              ; E-SIG Physician
 F  S ESPHY=$O(SELPHYS(ESPHY))  Q:ESPHY=""  D
 . S NRESP=$P($G(^VA(200,ESPHY,0)),"^",1)
 . S BLRESIGR(NRESP)=ESPHY
 . D GETESIG2^BLRESRCD
 Q
 ;
ALLNSIGN ;                       EP
 D ^XBFMK                     ; Clear out ALL FileMan variables
 S DIR("A")="Output E-SIG transactions Not Signed by Resp Phy - ALL"
 S DIR(0)="Y",DIR("B")="YES"
 D ^DIR
 I X["^" D  Q
 . W !,?10,"Exit entered.  No Report.",!
 . D BLRGPGR^BLRGMENU(10)     ; Press Return prompt
 ;
 I Y=1 D ANOSIGNR
 I Y'=1 D SNOSIGNR
 ;
 Q
 ;
 ; Report of NOT SIGNED by Responsible Physician for ALL Physicians
ANOSIGNR ;                       EP
 D NSIGNCOM
 D NSIGNRPT
 Q
 ;
NSIGNCOM ;
 D DATERNGE
 K BLRESIGR              ; Clear array
 ;
 S STATUS=2              ; Initialize variable
 ;
 S CNT=0
 S ESPHY=""              ; E-SIG Physician
 F  S ESPHY=$O(^LR("BLRA",ESPHY))  Q:ESPHY=""  D
 . S NRESP=$P($G(^VA(200,ESPHY,0)),"^",1)
 . S BLRESIGR(NRESP)=ESPHY
 . D NSIGNTXN^BLRESRCD
 . I CNT<1 K BLRESIGR(NRESP)
 Q
 ;
 ; Report of E-SIG Not Signed transaction by Responsible Physician
NSIGNRPT ;
 I $$NSGNRPTH="Q" D  Q
 . W !,"Output Device Error",!!
 . D BLRGPGR^BLRGMENU()
 ;
 U IO
 S (NRESP,PATN,LRAA,LRDFN,LRIDT)=""
 F  S NRESP=$O(BLRESIGR(NRESP))  Q:NRESP=""!(QFLG="Q")  D
 . D SURROGAT($G(BLRESIGR(NRESP)))
 . ;
 . S CNT=0
 . F  S PATN=$O(BLRESIGR(NRESP,PATN))  Q:PATN=""!(QFLG="Q")  D
 .. F  S LRAA=$O(BLRESIGR(NRESP,PATN,LRAA))  Q:LRAA=""!(QFLG="Q")  D
 ... F  S LRDFN=$O(BLRESIGR(NRESP,PATN,LRAA,LRDFN))  Q:LRDFN=""!(QFLG="Q")  D
 .... F  S LRIDT=$O(BLRESIGR(NRESP,PATN,LRAA,LRDFN,LRIDT))  Q:LRIDT=""!(QFLG="Q")  D
 ..... D NSGNRPTL
 . I CNT>0 W !,?10,"Number of records = ",CNT,!
 . S LINES=MAXLINES+10
 ;
 D ^%ZISC           ; Close IO port
 ;
 D BLRGPGR^BLRGMENU()
 ;
 Q
 ;
 ; Get Surrogate(s) Information and store in PHYSURG array
SURROGAT(RESP)          ;
 K PHYSURG
 S PHYSUR=0
 F  S PHYSUR=$O(^BLRALAB(9009027.1,RESP,1,PHYSUR))  Q:PHYSUR=""!(PHYSUR'?.N)  D
 . S SURDATES=$P(^BLRALAB(9009027.1,RESP,1,PHYSUR,0),"^",2,3)
 . S SURBDT=$$FMTE^XLFDT($P(SURDATES,"^",1),"2DZ")
 . S SUREDT=$$FMTE^XLFDT($P(SURDATES,"^",2),"2DZ")
 . S PHYSURG(RESP,PHYSUR)=$P($G(^VA(200,PHYSUR,0)),"^",1)_"^"_SURBDT_"^"_SUREDT
 Q
 ;
 ; Initialize HEADER array and IO
NSGNRPTH() ;
 D ESIGRPTH("REVIEWED & NOT SIGNED BY RESP PHYSICIAN")
 ;
 Q $$GETDEV
 ;
 ; Output line of data
NSGNRPTL ;
 D ESIGBRKO
 ;
 I LINES>MAXLINES D  I QFLG="Q" Q
 . D SURINHDR(HLCNT)
 . D BLRGHWPN^BLRGMENU(.PG,.QFLG)
 ;
 W ACCN
 W ?19,$$FMTE^XLFDT(COLLDTT,"2MZ")
 W ?35,$$FMTE^XLFDT(SIGNDT,"2MZ")
 W ?51,$E(NSIGN,1,25)
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 ;
 Q
 ;
 ; Put Surrogate(s) information in HEADER array
SURINHDR(HDCNT) ;
 S HDCNT=HDCNT+1
 F J=HDCNT:1:12 K HEADER(J)       ; Clear out array
 ;
 S HEADER(HDCNT)=$$CJ^XLFSTR("RESPONSIBLE PHYSICIAN:"_NRESP,IOM)
 S HDCNT=HDCNT+1
 ;
 NEW RESP
 S RESP=$G(BLRESIGR(NRESP))
 ;
 ; SURROGATE Information
 NEW SURDATES,SURSTR,SURBDT,SUREDT
 S PHYSUR=""
 F  S PHYSUR=$O(PHYSURG(RESP,PHYSUR))  Q:PHYSUR=""!(QFLG="Q")  D
 . S SURSTR="SURROGATE:"_$P($G(PHYSURG(RESP,PHYSUR)),"^",1)
 . S SURSTR=SURSTR_"  BEG DATE:"_$P($G(PHYSURG(RESP,PHYSUR)),"^",2)
 . S SURSTR=SURSTR_"  END DATE:"_$P($G(PHYSURG(RESP,PHYSUR)),"^",3)
 . S HEADER(HDCNT)=$$CJ^XLFSTR(SURSTR,IOM)
 . S HDCNT=HDCNT+1
 ;
 S HEADER(HDCNT)=" "
 S HDCNT=HDCNT+1
 ;
 S HEADER(HDCNT)="ACC #"
 S $E(HEADER(HDCNT),20)="COLL DATE/TIME"
 S $E(HEADER(HDCNT),36)="SIGN DATE/TIME"
 S $E(HEADER(HDCNT),52)="SIGNING PHY"
 ;
 Q
 ;
SNOSIGNR ;
 I $$SELCTPHY="Q" Q
 ;
 D SNSGNCOM
 D NSIGNRPT
 Q
 ;
SNSGNCOM ;
 D DATERNGE
 K BLRESIGR              ; Clear array
 ;
 S STATUS=2              ; Initialize variable
 ;
 S CNT=0
 S ESPHY=""              ; E-SIG Physician
 F  S ESPHY=$O(SELPHYS(ESPHY))  Q:ESPHY=""  D
 . S NRESP=$P($G(^VA(200,ESPHY,0)),"^",1)
 . S BLRESIGR(NRESP)=ESPHY
 . D NSIGNTXN^BLRESRCD
 . I CNT<1 K BLRESIGR(NRESP)
 Q
 ;
DATERNGE ;
 W !
 D B^LRU
 S BEGIDT=-(9999999-LRSDT)
 S ENDIDT=-(9999999-(LRLDT+1))
 Q
