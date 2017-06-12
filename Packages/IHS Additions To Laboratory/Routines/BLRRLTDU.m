BLRRLTDU ; IHS/MSC/MKK - Reference Lab Test Delete Utilities  ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 1, 1997
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ; Parameters:
 ;      F60IEN = Pointer  to entry in file 60
 ;      LRAS   = Accession Number
 ;      MSG    = Message # in file 62.49
 ;      TYPE   = "A" - for ADDING test to an acceession
 ;             = "N" - for marking test as NOT PERFORMED
STORTXNS(F60IEN,LRAS,TYPE) ; EP - Set data when Reference Lab update successful
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,F60IEN,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRAS,TYPE,U,XPARSYS,XQXFLG)
 ;
 S STR=$G(^XTMP("BLRRLTMR",0))
 I $L(STR)<1 D  ; Set ^XTMP Node Zero
 . S STR=$$HTFM^XLFDT(+$H)_"^^Reference Lab 'Not Performed' Update"
 S $P(STR,"^",2)=$$HTFM^XLFDT(+$H+30)
 S ^XTMP("BLRRLTMR",0)=STR
 ;
 ; Set the LRAA,LRAD,LRAN variables from the Accession number
 S X=$$GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)
 ;
 S UID=$G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.3),"<UNKNOWN>"),ORDER=$G(^(.1),"<UNKNOWN>")
 ;
 S (LRDFN,LRIDT,LRSS)="<UNKNOWN>"
 I +LRAA,+LRAD,+LRAN D
 . S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),LRIDT=$P($G(^(3)),"^",5)
 . S LRSS=$P($G(^LRO(68,LRAA,0)),"^",2)
 ;
 S ^XTMP("BLRRLTMR",$H,TYPE,LRAS,F60IEN)=UID_"^"_ORDER_"^"_LRDFN_"^"_LRSS_"^"_LRIDT
 S LREND=1
 ;
 Q
 ;
TXNSREPT ; EP - Report on Reference Lab successful updates
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$TXNSRPTI()="Q"
 ;
 F  S THEN=$O(^XTMP("BLRRLTMR",THEN),-1)  Q:THEN=""!(QFLG="Q")  D
 . S TYPE=""
 . F  S TYPE=$O(^XTMP("BLRRLTMR",THEN,TYPE))  Q:TYPE=""!(QFLG="Q")  D
 .. S LRAS=""
 .. F  S LRAS=$O(^XTMP("BLRRLTMR",THEN,TYPE,LRAS))  Q:LRAS=""!(QFLG="Q")  D
 ... S F60IEN=0
 ... F  S F60IEN=$O(^XTMP("BLRRLTMR",THEN,TYPE,LRAS,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D TXNSRPTL
 ;
 W:CNT&(QFLG'="Q") !!,?4,"Number of successful updates = ",CNT,!
 ;
 D ^%ZISC
 ;
 D:QFLG'="Q" PRESSKEY^BLRGMENU(9)
 Q
 ;
TXNSRPTI() ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 S BLRVERN2="TXNSREPT"
 ;
 S HEADER(1)="Reference Lab successful updates"
 S HEADER(2)="Set Test to 'Not Performed' (NP) OR Added Test"
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HEADONE)
 ;
 S HEADER(3)=" "
 S $E(HEADER(4),53)=$TR($$CJ^XLFSTR("@File@60@",27)," @","= ")
 S HEADER(5)="Entry Date/Time"
 S $E(HEADER(5),25)="Type"
 S $E(HEADER(5),33)="Accession Number"
 S $E(HEADER(5),53)="IEN"
 S $E(HEADER(5),63)="Description"
 ;
 D ^%ZIS
 I POP D  Q "Q"
 . W !!,?4,"Device Issue.  POP postive.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 U IO
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG)=0,QFLG="NO"
 S THEN="A"
 ;
 Q "OK"
 ;
TXNSRPTL ; EP - Line of Data
 Q:$$TXNSRPTB<1
 ;
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HEADONE)  Q:QFLG="Q"
 ;
 W EXTDATE
 W ?25,TYPEDESC
 W ?32,LRAS
 W ?52,F60IEN
 W ?62,F60DESC
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 ;
 Q
 ;
TXNSRPTB() ; EP - "Break out" variables for report
 S EXTDATE=$$HTE^XLFDT(THEN,"2MZ")
 S TYPEDESC=$S(TYPE="A":"ADD",TYPE="N":"NP",1:"<>")
 S F60DESC=$$GET1^DIQ(60,F60IEN,"NAME")
 S:$L(F60DESC)>18 F60DESC=$$GET1^DIQ(60,F60IEN,"PRINT NAME")
 Q 1
 ;
XTMPNSET(F60IEN,MSG) ; EP - Set data in ^XTMP when "Not Performed" update successful
 NEW UID,STR
 ;
 S STR=$G(^XTMP("BLRRLTDS",0))
 I $L(STR)<1 D  ; Set ^XTMP Node Zero
 . S STR=$$HTFM^XLFDT(+$H)_"^^Reference Lab 'Not Performed' Update"
 S $P(STR,"^",2)=$$HTFM^XLFDT(+$H+30)
 S ^XTMP("BLRRLTDS",0)=STR
 ;
 S UID=$G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.3),"<UNKNOWN>")
 S ^XTMP("BLRRLTDS","UID",UID,"DUZ",DUZ,$H,F60IEN)=MSG
 S ^XTMP("BLRRLTDS","UID")=1+$G(^XTMP("BLRRLTDS","UID"))
 S LREND=1
 ;
 Q
 ;
XTMPNRPT ; EP - Report on Successfully Updated Entries
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$XTMPNRPI()="Q"
 ;
 F  S UID=$O(^XTMP("BLRRLTDS","UID",UID))  Q:UID<1!(QFLG="Q")  D
 . S MSGDUZ=0
 . F  S MSGDUZ=$O(^XTMP("BLRRLTDS","UID",UID,"DUZ",MSGDUZ))  Q:MSGDUZ<1!(QFLG="Q")  D
 .. S NAMEDUZ=$$GET1^DIQ(200,MSGDUZ,"NAME")
 .. S HDATE=""
 .. F  S HDATE=$O(^XTMP("BLRRLTDS","UID",UID,"DUZ",MSGDUZ,HDATE))  Q:HDATE=""!(QFLG="Q")  D
 ... S F60IEN=0
 ... F  S F60IEN=$O(^XTMP("BLRRLTDS","UID",UID,"DUZ",MSGDUZ,HDATE,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D XTMPNRPL
 ;
 W:QFLG'="Q" !,?4,"Number of Reference Lab Tests set to 'Not Performed' = ",CNT
 ;
 D ^%ZISC
 ;
 Q:QFLG="Q"
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
XTMPNRPI() ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 S HEADER(1)=$$GET1^DIQ(9009029,DUZ(2),3001)_" Reference Lab: 'Not Performed' Tests"
 S HEADER(2)="^XTMP(""BLRRLTDS"") Report"
 S HEADER(3)=" "
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HEADONE)
 ;
 I $D(^XTMP("BLRRLTDS","UID"))<1 D  Q "Q"
 . W !,?4,"No entries in ^XTMP(""BLRRLTDS"",""UID"").  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 ;1         2         3         4         5         6         7         8
 ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
 ;                                     === File 60 ====  = 62.49 =
 ;UID           Date/Time       DUZ    IEN      Prnt NM    Msg #    Message
 ;--------------------------------------------------------------------------------
 ;6011000078    02/25/13@09:19  2011   9999622  AER+AN   123456789  *NP:Set
 ;
 S $E(HEADER(4),38)=$TR($$CJ^XLFSTR("@Lab@Test@File@(#60)@",28)," @","= ")
 S HEADER(5)="UID"
 S $E(HEADER(5),15)="Date/Time"
 S $E(HEADER(5),31)="DUZ"
 S $E(HEADER(5),38)="IEN"
 S $E(HEADER(5),48)="Description"
 S $E(HEADER(5),68)="Msg"
 ;
 D ^%ZIS
 ;
 I POP D  Q "Q"
 . W !,?4,"Issue opening device.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 . W 1/0
 ;
 U IO
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG,UID)=0
 S QFLG="NO"
 ;
 Q "OK"
 ;
XTMPNRPL ; EP - Line of Data
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HEADONE)  Q:QFLG="Q"
 ;
 W UID
 W ?14,$$HTE^XLFDT(HDATE,"2MZ")
 W ?30,MSGDUZ
 W ?37,F60IEN
 W ?47,$E($$GET1^DIQ(60,F60IEN,"NAME"),1,18)
 W ?67,$G(^XTMP("BLRRLTDS","UID",UID,"DUZ",MSGDUZ,HDATE,F60IEN))
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 Q
 ;
XTMPISET(MSG,RTN) ; EP - Set data in ^XTMP when there are issues
 NEW UID,STR
 ;
 S STR=$G(^XTMP("BLRRLTDI",0))
 I $L(STR)<1 D  ; Set ^XTMP Node Zero
 . S STR=$$HTFM^XLFDT(+$H)_"^^Reference Lab Errors"
 S $P(STR,"^",2)=$$HTFM^XLFDT(+$H+30)
 S ^XTMP("BLRRLTDI",0)=STR
 ;
 S UID=$G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.3),"<UNKNOWN>")
 S ^XTMP("BLRRLTDI","UID",UID,"DUZ",DUZ,$H)=RTN_"^"_MSG
 S ^XTMP("BLRRLTDI","UID")=1+$G(^XTMP("BLRRLTDI","UID"))
 S LREND=1
 ;
 D:+$G(^XTMP("BLRRLTDI","UID"))>99 XTMPIRPT
 ;
 Q
 ;
XTMPIRPT ; EP - There are 100 Entries in ^XTMP Issues node - Send Report to LMI Mail Group and CLEAR ^XTMP Issues
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 ; Create Message array
 ;
 ; HEADER
 S MESSAGE(1)=$$CJ^XLFSTR($$GET1^DIQ(9009029,DUZ(2),3001)_" Reference Lab: Issues",60)
 S MESSAGE(2)=$$CJ^XLFSTR("^XTMP Report",60)
 S MESSAGE(3)=" "
 S MESSAGE(4)="UID"
 S $E(MESSAGE(4),13)="Date/Time"
 S $E(MESSAGE(4),29)="DUZ"
 S $E(MESSAGE(4),36)="Routine"
 S $E(MESSAGE(4),46)="Message"
 S MESSAGE(5)=$TR($J("",(IOM-1))," ","-")
 ;
 ; Create the body of the Message array
 S UID=0,MSGL=5
 F  S UID=$O(^XTMP("BLRRLTDI","UID",UID))  Q:UID<1  D
 . S MSGDUZ=0
 . F  S MSGDUZ=$O(^XTMP("BLRRLTDI","UID",UID,"DUZ",MSGDUZ))  Q:MSGDUZ<1  D
 .. S NAMEDUZ=$$GET1^DIQ(200,MSGDUZ,"NAME")
 .. S HDATE=""
 .. F  S HDATE=$O(^XTMP("BLRRLTDI","UID",UID,"DUZ",MSGDUZ,HDATE))  Q:HDATE=""  D
 ... S STR=$G(^XTMP("BLRRLTDI","UID",UID,"DUZ",MSGDUZ,HDATE))
 ... S MSGL=MSGL+1
 ... S MESSAGE(MSGL)=UID
 ... S $E(MESSAGE(MSGL),13)=$$HTE^XLFDT(HDATE,"2MZ")
 ... S $E(MESSAGE(MSGL),29)=MSGDUZ
 ... S $E(MESSAGE(MSGL),36)=$P(STR,"^",2)
 ... S $E(MESSAGE(MSGL),46)=$E($P(STR,"^"),1,34)
 ;
 D SENDMAIL^BLRUTIL3($G(MESSAGE(1)),.MESSAGE,"BLRRLTDR",1)
 ;
 K ^XTMP("BLRRLTDI") ; Clear the ^XTMP global
 Q
 ;
TXNSURPT ; EP - Report on Reference Lab Unsuccessful updates
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$TXNURPTI()="Q"
 ;
 F  S UID=$O(^XTMP("BLRRLTDI","UID",UID))  Q:UID=""!(QFLG="Q")  D
 . S DUZVAR=""
 . F  S DUZVAR=$O(^XTMP("BLRRLTDI","UID",UID,"DUZ",DUZVAR))  Q:DUZVAR=""!(QFLG="Q")  D
 .. S HDATE=""
 .. F  S HDATE=$O(^XTMP("BLRRLTDI","UID",UID,"DUZ",DUZVAR,HDATE))  Q:HDATE=""!(QFLG="Q")  D TXNURPTL
 ;
 W:CNT&(QFLG'="Q") !!,?4,"Number of unsuccessful updates = ",CNT,!
 ;
 D ^%ZISC
 ;
 D:QFLG'="Q" PRESSKEY^BLRGMENU(9)
 Q
 ;
TXNURPTI() ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 S BLRVERN2="TXNSURPT"
 ;
 S HEADER(1)="Reference Lab NON Successful Updates"
 S HEADER(2)=" "
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HEADONE)
 ;
 S HEADER(4)="UID"
 S $E(HEADER(4),15)="DUZ"
 S $E(HEADER(4),25)="Date/Time"
 S $E(HEADER(4),43)="Routine"
 S $E(HEADER(4),53)="Message"
 ;
 D ^%ZIS
 I POP D  Q "Q"
 . W !!,?4,"Device Issue.  POP postive.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 U IO
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG,THEN,UID)=0,QFLG="NO"
 ;
 Q "OK"
 ;
TXNURPTL ; EP - Line of Data
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG)  Q:QFLG="Q"
 ;
 D TXNURPTB
 ;
 W UID
 W ?14,DUZVAR
 W ?24,DATETIME
 W ?42,RTN
 I $L(MESSAGE)<29 W ?52,MESSAGE,!  S LINES=LINES+1
 D:$L(MESSAGE)>28 LINEWRAP^BLRGMENU(52,MESSAGE,28)
 S CNT=CNT+1
 Q
 ;
TXNURPTB ; EP - Break out data
 S DATETIME=$$HTE^XLFDT(HDATE,"5MZ")
 S STR=$G(^XTMP("BLRRLTDI","UID",UID,"DUZ",DUZVAR,HDATE))
 S RTN=$P(STR,"^")
 S MESSAGE=$P(STR,"^",2)
 Q
 ;
DEBUGRPT ; EP - Debug the XTMPRPT report
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 I $NAMESPACE="LABMU" D  Q
 . W !!,?4,"Will not K ^XTMP(""BLRRLTDI"") nor reset it because MU testing has begun on this UCI."
 . D PRESSKEY^BLRGMENU(9)
 ;
 K ^XTMP("BLRRLTDI")
 ;
 S ^XTMP("BLRRLTDI",0)=DT_"^"_$$HTFM^XLFDT(+$H+30)_"^Reference Lab Test Delete Errors"
 ;
 ; Set the Error Messages
 S ERRMAX=1,ERRMSG(ERRMAX)="Not authorized to change test status."
 S ERRMAX=ERRMAX+1,ERRMSG(ERRMAX)="Accession has no Test."
 S ERRMAX=ERRMAX+1,ERRMSG(ERRMAX)="Someone else is working on this accession"
 S ERRMAX=ERRMAX+1,ERRMSG(ERRMAX)="Someone else is working on this data."
 S ERRMAX=ERRMAX+1,ERRMSG(ERRMAX)="Can't find Lab Data for this accession"
 S ERRMAX=ERRMAX+1,ERRMSG(ERRMAX)="There is no Order for this Accession"
 S ERRMAX=ERRMAX+1,ERRMSG(ERRMAX)="No Subscript for this Accession Area"
 ;
 ; Set the ^XTMP Array
 S CNT=0,ERR=1
 F  Q:CNT>99  D
 . F  S UID=$TR($J($R(10000000000),10)," ","0")  Q:$D(^XTMP("BLRRLTDI","UID",UID))<1
 . S ^XTMP("BLRRLTDI","UID")=1+$G(^XTMP("BLRRLTDI","UID"))
 . ;
 . S FAKEDUZ=$TR($J($R(10000),5)," ","0")
 . S FAKERTN=$S((CNT#2):"BLRRLTDR",1:"BLRRLTAR")
 . S ^XTMP("BLRRLTDI","UID",UID,"DUZ",FAKEDUZ,$H)=ERRMSG(ERR)_"^"_FAKERTN,ERR=ERR+1  S:ERR>ERRMAX ERR=1
 . S CNT=CNT+1
 ;
 D XTMPIRPT
 ;
 Q
 ;
DEBUG ; EP - Debug BLRRLTDR
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 K ^XTMP("BLRTRACE")
 D:$P($G(LRPARAM),"^",3)="" ^LRPARAM
 ;
 D ^XBFMK
 S DIR(0)="NO"
 S DIR("A")="Enter 62.49 Message Number"
 D ^DIR
 I +$G(DIRUT) D  Q
 . W !!,?4,"No/Invalid Entry.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 S LA76249=+$G(X)
 D PEP^BLRRLTDR
 Q
 ;
REPORTS ; EP - Reports Menu
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 D ADDTMENU^BLRGMENU("TXNSREPT^BLRRLTDU","Successful Updates")
 D ADDTMENU^BLRGMENU("XTMPNRPT^BLRRLTDU","'Not Performed' Success")
 D ADDTMENU^BLRGMENU("TXNSURPT^BLRRLTDU","NON Successful updates")
 ;
 ; Main Menu driver
 D MENUDRVR^BLRGMENU("RPMS Reference Lab ","Automatic Updating Reports")
 Q
