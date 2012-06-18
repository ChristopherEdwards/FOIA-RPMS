BLRCINDX ; IHS/OIT/MKK - Lab Accession File "C" Index "Orphan" Pointers Kill ;MAY 06, 2009 9:58 AM
 ;;5.2;IHS LABORATORY;**1026,1028**;NOV 01, 1997;Build 46
 ;;
 ;; Some code cloned from VA's LROC routine
 ;;
EP ; EP -- Entry Point
 NEW BLRMMENU,BLRVERN,QFLG
 ;
 D SETMENU
 ;
 ; Main Menu driver
 D MENUDRFM^BLRGMENU("IHS Lab Accession File","""C"" Index Routines")
 ;
 W !!
 Q
 ;
SETMENU ; EP
 S BLRVERN="BLRCINDX"
 D ADDTMENU^BLRGMENU("DELOPRHE^BLRCINDX","Delete ""Orphan"" Entries")
 D ADDTMENU^BLRGMENU("CIREPORT^BLRCINDX","""C"" Index Report")
 D ADDTMENU^BLRGMENU("REPORT^BLRCINDX","""Orphan"" Entries Report")
 Q
 ;
DELOPRHE ; EP -- Delete Orphan Entries in Accession File's "C" Index
 NEW KCNT,LRAA,LRAD,LRAN,LRCNT,LRROOT
 NEW HEADER
 ;
 D DELOEINI
 ;
 F  S UID=$O(^LRO(68,"C",UID))  Q:UID=""  D
 . F  S LRAA=$O(^LRO(68,"C",UID,LRAA))  Q:LRAA<1  D
 .. F  S LRAD=$O(^LRO(68,"C",UID,LRAA,LRAD))  Q:LRAD<1  D
 ... F  S LRAN=$O(^LRO(68,"C",UID,LRAA,LRAD,LRAN))  Q:LRAN<1  D
 .... D DELOEKLN
 ;
 D DELOEFIN
 ;
 Q
 ;
DELOEINI ; EP -- Delete Orphan Entries INItialization
 S HEADER(1)="IHS Lab Accession File"
 S HEADER(2)="""C"" Index ""Orphan"" Deletion"
 D HEADERDT^BLRGMENU
 ;
 D DISABLE^%NOJRN             ; Disable Journalling
 W ?5,"Journalling stopped for this process only.",!
 W ?5,"Deleting ""Orphan"" Pointers in Accession File's ""C"" Index",!!
 ;
 S LRROOT="^LRO(68,""C"")"
 S (KCNT,LRAA,LRAD,LRAN,LRCNT)=0
 S UID=""
 ;
 W !,?5
 Q
 ;
DELOEKLN ; EP -- Delete Orphan Entries Kill LiNes
 S LRCNT=LRCNT+1
 ;
 I $X>70 W !,?5
 ;
 ; Accession exists, so skip this entry
 I $D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) D  Q
 . W:LRCNT>0&((LRCNT#1000=0)) "."
 ;
 K ^LRO(68,"C",UID)
 S KCNT=KCNT+1
 W:LRCNT>0&((LRCNT#1000=0)) "*"
 Q
 ;
DELOEFIN ; EP - Delete Orphan Entries FINal lines
 D ENABLE^%NOJRN              ; Enable Journalling again
 W ?5,"Journalling restarted.",!!
 ;
 W ?5,"Number of Pointers in ""C"" Index = ",LRCNT,!
 W ?5,"Number of ""Orphan"" Pointers deleted from ""C"" Index = ",KCNT,!
 ;
 D PRESSKEY()
 Q
 ;
CIREPORT ; EP - Full "C" Index Report
 NEW CNT,CNTACC,CNTKILL,CNTZERO,KCNT,LRAA,LRAD,LRAN,LRCNT
 NEW OLDYEAR,LRROOT,UID,YEAR,YEARCNT
 NEW DASHER,HEADER
 ;
 D CIRCMPLD        ; Compile the Data
 D CIROUTD         ; Print the Data
 Q
 ;
CIRCMPLD ; EP -- "C" Index Report CoMPiLe Data
 D CIRCMPDI
 ;
 F  S UID=$O(^LRO(68,"C",UID))  Q:UID=""  D
 . F  S LRAA=$O(^LRO(68,"C",UID,LRAA))  Q:LRAA<1  D
 .. F  S LRAD=$O(^LRO(68,"C",UID,LRAA,LRAD))  Q:LRAD<1  D
 ... F  S LRAN=$O(^LRO(68,"C",UID,LRAA,LRAD,LRAN))  Q:LRAN<1  D
 .... D CIRCMPLC
 ;
 D CIRCMPFL
 ;
 Q
 ;
CIRCMPDI ; EP -- "C" Index Report CoMPile Data Initialization
 S HEADER(1)="IHS Lab Accession File"
 S HEADER(2)="""C"" Index Report"
 D HEADERDT^BLRGMENU
 ;
 W ?5,"Compilation of ""C"" Index Data Begins",!!
 ;
 S LRROOT="^LRO(68,""C"")"
 S (KCNT,LRAA,LRAD,LRAN,LRCNT)=0
 S UID=""
 ;
 W ?5
 Q
 ;
CIRCMPLC ; EP -- "C" Index Report CoMPiLation Counts
 S YEAR=$P($$FMTE^XLFDT(LRAD,"6D"),"/",3)
 ;
 S LRCNT=LRCNT+1
 ;
 I $X>70 W !,?5
 ;
 I $D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) D  Q
 . S YEARCNT(YEAR,LRAA,"VALID")=1+$G(YEARCNT(YEAR,LRAA,"VALID"))
 . S:$E(UID,1,2)="00" YEARCNT(YEAR,LRAA,"VALID","00")=1+$G(YEARCNT(YEAR,LRAA,"VALID","00"))
 . W:LRCNT>0&((LRCNT#1000=0)) "."
 ;
 S KCNT=KCNT+1
 S YEARCNT(YEAR,LRAA,"ORPHAN")=1+$G(YEARCNT(YEAR,LRAA,"ORPHAN"))
 S:$E(UID,1,2)="00" YEARCNT(YEAR,LRAA,"ORPHAN","00")=1+$G(YEARCNT(YEAR,LRAA,"ORPHAN","00"))
 W:LRCNT>0&((LRCNT#1000=0)) "*"
 Q
 ;
CIRCMPFL ; EP -- "C" Index Report CoMPilation data Final Lines
 W !,?5,"Compilation of ""C"" Index Data Ends",!!
 ;
 W ?5,"Number of Pointers in ""C"" Index = ",LRCNT,!
 W ?5,"Number of ""Orphan"" Pointers in ""C"" Index = ",KCNT,!
 ;
 D PRESSKEY()
 Q
 ;
CIROUTD ; EP -- "C" Index Report OUTput the Data
 NEW BLRMMENU,BLRVERN,HEADER
 ;
 D SETOMENU
 ;
 ; Main Menu driver
 D MENUDRFM^BLRGMENU("IHS Lab Accession File","""C"" Index Routines")
 ;
 Q
 ;
SETOMENU ; EP 
 D ADDTMENU^BLRGMENU("CINTERPT^BLRCINDX","Interactive ""C"" Index Report")
 D ADDTMENU^BLRGMENU("REPORTPR^BLRCINDX","Print ""C"" Index Report")
 Q
 ;
CINTERPT ; EP -- Interactive Version of the report
 NEW BLRCINDX,CNT,CNTACC,CNTKILL,CNTOZERO,CNTVZERO,LINES
 NEW OLDYEAR,TOPBAR,TOTZERO,YEAR
 ;
 S (CNT,CNTACC,CNTKILL,CNTZERO,LINES,OLDYEAR,YEAR)=0
 F  S YEAR=$O(YEARCNT(YEAR))  Q:YEAR=""  D
 . S LRAA=""
 . F  S LRAA=$O(YEARCNT(YEAR,LRAA))  Q:LRAA=""  D
 .. D CINTERPB
 ;
 D BROWSEIT
 ;
 D FINALBIT
 Q
 ;
CINTERPB ; EP -- Interactive Version of Report -- Building Arrays
 S:+$G(OLDYEAR)<1 OLDYEAR=YEAR
 S CNT=CNT+1
 I OLDYEAR'=YEAR&(CNT>0) S LINES=LINES+1  S BLRCINDX(LINES)=" "
 S:OLDYEAR'=YEAR OLDYEAR=YEAR
 S CNTKZERO=+$G(YEARCNT(YEAR,LRAA,"ORPHAN","00"))
 S CNTVZERO=+$G(YEARCNT(YEAR,LRAA,"VALID","00"))
 S TOTZERO=CNTVZERO+CNTKZERO
 S CNTZERO=CNTZERO+TOTZERO
 ;
 S LINES=LINES+1
 S $E(BLRCINDX(LINES),5)=YEAR
 S $E(BLRCINDX(LINES),10)=LRAA
 S $E(BLRCINDX(LINES),15)=$P($G(^LRO(68,LRAA,0)),"^",1)
 S $E(BLRCINDX(LINES),45)=$J($G(YEARCNT(YEAR,LRAA,"VALID")),8)
 S:TOTZERO>0 $E(BLRCINDX(LINES),55)=$J(TOTZERO,8)
 S $E(BLRCINDX(LINES),67)=$J($G(YEARCNT(YEAR,LRAA,"ORPHAN")),8)
 S CNTACC=CNTACC+$G(YEARCNT(YEAR,LRAA,"VALID"))
 S CNTKILL=CNTKILL+$G(YEARCNT(YEAR,LRAA,"ORPHAN"))
 Q
 ;
BROWSEIT ; EP -- Use Browser to display report
 S HEADER(3)=" "
 D HEADERDT^BLRGMENU
 ;
 S TOPBAR="YEAR LRAA Accession Description           # Accs  # 00 UIDs  # Orphans"
 S:+$G(YEARCNT(0))<1 TOPBAR="YEAR LRAA Accession Description           # Accs             # Orphans"
 D BROWSE^DDBR("BLRCINDX","N",TOPBAR,,,5,24)
 ;
 Q
 ;
FINALBIT ; EP -- Final section of interactive report
 S $E(HEADER(4),45)=$J("# Accs",8)
 S:CNTZERO>0 $E(HEADER(4),55)="# 00 UIDs"
 S $E(HEADER(4),67)=$J("# Orphans",8)
 ;
 D HEADERDT^BLRGMENU
 W ?14,"TOTAL"
 W ?44,$J($G(CNTACC),8)
 W:CNTZERO>0 ?55,$J(CNTZERO,8)
 W ?67,$J($G(CNTKILL),8)
 W !!
 D PRESSKEY()
 Q
 ;
REPORTPR ; EP -- Output Data
 NEW CNT,CNTACC,CNTKILL,CNTOZERO,CNTVZERO,LINES,OLDYEAR,YEAR
 NEW DASHER,HDR1,LINES,MAXLINES,PG,QFLG
 NEW TOTLZERO
 ;
 D REPORTPI
 ;
 F  S YEAR=$O(YEARCNT(YEAR))  Q:YEAR=""!(QFLG="Q")  D
 . S LRAA=""
 . F  S LRAA=$O(YEARCNT(YEAR,LRAA))  Q:LRAA=""!(QFLG="Q")  D
 .. D REPORTPL
 ;
 I QFLG'="Q" D TOTATLNE
 W !!
 ;
 D ^%ZISC                                ; Close all the devices
 ;
 D PRESSKEY()
 Q
 ;
REPORTPI ; EP -- Print Report Initialization
 S HEADER(1)="IHS Lab Accession File"
 S HEADER(2)="""C"" Index Report"
 S HEADER(3)=" "
 S $E(HEADER(4),5)="YEAR"
 S $E(HEADER(4),10)="LRAA"
 S $E(HEADER(4),15)="Accession Description"
 S $E(HEADER(4),45)=$J("# Accs",8)
 S:+$G(YEARCNT(0))>0 $E(HEADER(4),55)=$J("# 00 UIDs",8)
 S $E(HEADER(4),67)=$J("# Orphans",8)
 ;
 S PG=0
 S HDR1=0
 S QFLG="NO"
 ;
 D ^%ZIS
 I POP D
 . W !!,?10,"DEVICE could not be selected.  Output will be to the screen.",!!
 . D ^%ZISC
 ;
 S MAXLINES=IOSL-3
 S LINES=MAXLINES+10
 ;
 U IO
 S (CNT,CNTACC,CNTKILL,CNTOZERO,CNTVZERO,CNTZERO,OLDYEAR,TOTLZERO,YEAR)=0
 Q
 ;
REPORTPL ; EP - Report Liner
 S:+$G(OLDYEAR)<1 OLDYEAR=YEAR
 ;
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDR1)  I QFLG="Q" Q
 ;
 I OLDYEAR'=YEAR S OLDYEAR=YEAR  W:CNT>0 !
 S CNT=CNT+1
 ;
 S CNTKZERO=+$G(YEARCNT(YEAR,LRAA,"ORPHAN","00"))
 S CNTVZERO=+$G(YEARCNT(YEAR,LRAA,"VALID","00"))
 S TOTLZERO=CNTKZERO+CNTVZERO
 ;
 W ?4,YEAR
 W ?9,LRAA
 W ?14,$E($P($G(^LRO(68,LRAA,0)),"^",1),1,23)
 W ?44,$J($G(YEARCNT(YEAR,LRAA,"VALID")),8)
 W:TOTLZERO>0 ?55,$J(TOTLZERO,8)
 W ?67,$J($G(YEARCNT(YEAR,LRAA,"ORPHAN")),8)
 W !
 S LINES=LINES+1
 ;
 S CNTACC=CNTACC+$G(YEARCNT(YEAR,LRAA,"VALID"))
 S CNTZERO=CNTZERO+TOTLZERO
 S CNTKILL=CNTKILL+$G(YEARCNT(YEAR,LRAA,"ORPHAN"))
 Q
 ;
TOTATLNE ; EP - Totals Line for Report
 S DASHER=$TR($J("",8)," ","-")
 W ?44,DASHER
 W:CNTZERO>0 ?55,DASHER
 W ?67,DASHER
 W !
 W ?14,"TOTAL"
 W ?44,$J($G(CNTACC),8)
 W:CNTZERO>0 ?55,$J($G(CNTZERO),8)
 W ?67,$J($G(CNTKILL),8)
 Q
 ;
REPORT ; EP -- Report on orphan "C" index entries
 NEW KCNT,LRAA,LRAD,LRAN,LRCNT,LRROOT,YEARCNT
 NEW HEADER
 ;
 D REPORTIN
 ;
 F  S UID=$O(^LRO(68,"C",UID))  Q:UID=""  D
 . F  S LRAA=$O(^LRO(68,"C",UID,LRAA))  Q:LRAA<1  D
 .. F  S LRAD=$O(^LRO(68,"C",UID,LRAA,LRAD))  Q:LRAD<1  D
 ... F  S LRAN=$O(^LRO(68,"C",UID,LRAA,LRAD,LRAN))  Q:LRAN<1  D
 .... D REPORTCW
 ;
 D REPORTFL
 Q
 ;
REPORTIN ;  -- Report on orphan "C" index INitialization
 S HEADER(1)="IHS Lab Accession File"
 S HEADER(2)="""C"" Index ""Orphan"" Report"
 D HEADERDT^BLRGMENU
 ;
 W !,?5,"Counting ""Orphan"" Pointers in Accession File's ""C"" Index",!!
 ;
 S LRROOT="^LRO(68,""C"")"
 S (KCNT,LRAA,LRAD,LRAN,LRCNT)=0
 S UID=""
 ;
 W ?5
 Q
 ;
REPORTCW ; EP -- Report on orphan "C" index Counts & Warm fuzzies
 S YEAR=$P($$FMTE^XLFDT(LRAD,"6D"),"/",3)
 ;
 I $X>70 W !,?5
 S LRCNT=LRCNT+1
 ;
 ; Accession exists, so skip this entry
 I $D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) D  Q
 . S YEARCNT(YEAR,LRAA,"VALID")=1+$G(YEARCNT(YEAR,LRAA,"VALID"))
 . S:$E(UID,1,2)="00" YEARCNT(YEAR,LRAA,"VALID","00")=1+$G(YEARCNT(YEAR,LRAA,"VALID","00"))
 . W:LRCNT>0&((LRCNT#1000=0)) "."
 ;
 ; "Orphan" Entry
 S KCNT=KCNT+1
 S YEARCNT(YEAR,LRAA,"ORPHAN")=1+$G(YEARCNT(YEAR,LRAA,"ORPHAN"))
 S:$E(UID,1,2)="00" YEARCNT(YEAR,LRAA,"ORPHAN","00")=1+$G(YEARCNT(YEAR,LRAA,"ORPHAN","00"))
 W:LRCNT>0&((LRCNT#1000=0)) "*"
 ;
 Q
 ;
REPORTFL ; EP -- Report on orphan "C" index Counts Final Lines
 W !,?5,"Number of Pointers in ""C"" Index = ",LRCNT,!
 W ?5,"Number of ""Orphan"" Pointers in ""C"" Index = ",KCNT,!
 ;
 D PRESSKEY(5,"REPORT ENDS.  Press RETURN Key")
 Q
 ;
PRESSKEY(TAB,MSGSTR) ; EP
 NEW TABSTR
 ;
 S:+$G(TAB)<1 TAB=5
 S TABSTR=$J("",+$G(TAB))_$S(+$L($G(MSGSTR)):$G(MSGSTR),1:"Press RETURN Key")
 ;
 W !
 D ^XBFMK
 S DIR(0)="E"
 S DIR("A")=TABSTR
 D ^DIR
 I $G(DUOUT) S QFLG="Q"      ; If Fileman quit, then set Quit Flag
 ;
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1028
 ; Silent Version of the DELOPRHE option -- Created for TaskMan Entries
SILENT ; EP
 NEW KCNT,LRAA,LRAD,LRAN,LRCNT,LRROOT,STOREDTT
 ;
 D SILENTI
 ;
 F  S UID=$O(^LRO(68,"C",UID))  Q:UID=""  D
 . F  S LRAA=$O(^LRO(68,"C",UID,LRAA))  Q:LRAA<1  D
 .. F  S LRAD=$O(^LRO(68,"C",UID,LRAA,LRAD))  Q:LRAD<1  D
 ... F  S LRAN=$O(^LRO(68,"C",UID,LRAA,LRAD,LRAN))  Q:LRAN<1  D
 .... D SILENTD
 ;
 S STOREDTT=$$NOW^XLFDT
 S ^BLRCINDX(STOREDTT,LRCNT,KCNT)=""
 ;
 D SILENTR
 ;
 Q
 ;
SILENTI ; EP - Initialization
 D DISABLE^%NOJRN
 S LRROOT="^LRO(68,""C"")"
 S (CNT,KCNT,LRAA,LRAD,LRAN,LRCNT)=0
 S UID=""
 Q
 ;
SILENTD ; EP - Silent Delete
 S LRCNT=LRCNT+1
 ;
 ; Accession exists, so skip this entry
 Q:$D(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 ;
 K ^LRO(68,"C",UID)
 S KCNT=KCNT+1
 Q
 ;
SILENTR ; EP - Report on the Silent Deletes
 NEW DATETIME,CNT1,CNT2,STR,STRLINE
 ;
 D SILENTRI
 ;
 D SILENTRC
 ;
 D SENDMAIL("Accession File ""C"" Index ""Orphans"" Report")
 ;
 Q
 ;
SILENTRI ; EP - Initialization
 S STR(1)=" "
 S STR(2)=$$CJ^XLFSTR($$LOC^XBFUNC,70)
 S STR(3)=" "
 S $E(STR(4),45)="# of ""Orphan"""
 S $E(STR(5),5)="Date/Time ^BLRCINDX Run"
 S $E(STR(5),35)="# UIDs"
 S $E(STR(5),45)="Deletions"
 S STR(6)=$TR($J("",70)," ","-")
 ;
 S (DATETIME)=0
 S (CNT1,CNT2)=""
 S STRLINE=6
 Q
 ;
SILENTRC ; EP - Compilation
 F  S DATETIME=$O(^BLRCINDX(DATETIME))  Q:DATETIME<1  D
 . F  S CNT1=$O(^BLRCINDX(DATETIME,CNT1))  Q:CNT1=""  D
 .. F  S CNT2=$O(^BLRCINDX(DATETIME,CNT1,CNT2))  Q:CNT2=""  D
 ... S STRLINE=STRLINE+1
 ... S $E(STR(STRLINE),5)=$$UP^XLFSTR($$FMTE^XLFDT(DATETIME,"5MPZ"))
 ... S $E(STR(STRLINE),35)=CNT1
 ... S $E(STR(STRLINE),45)=CNT2
 Q
 ;
SENDMAIL(MAILMSG) ; EP -- Send MailMan E-mail to all users with LRSUPER key
 NEW BADUSERS,DIFROM,ERRORS,HEREYAGO,LRSUPER,WHO,WHOCNT,YEARAGO
 ;
 ; Get "LRSUPER" Security Key IEN
 D FIND^DIC(19.1,,,,"LRSUPER",,,,,"HEREYAGO")
 S LRSUPER=+$G(HEREYAGO("DILIST",2,1))
 Q:LRSUPER<1
 ;
 S YEARAGO=$P($$HTE^XLFDT(+$H-365,"5DZ"),"/",3)    ; Get year in CCYY format from 365 Days Ago
 ;
 K XMY
 S (WHO,WHOCNT)=0
 F  S WHO=$O(^VA(200,"AB",LRSUPER,WHO))  Q:WHO<1  D
 . K ERRORS,X
 . S X=+$P($$FMTE^XLFDT($$GET1^DIQ(3.7,WHO,"LATEST MAILMAN ACCESS DATE","I",,"ERRORS"),"5DZ"),"/",3)
 . Q:X<YEARAGO  ; Only send e-mail to those who have accessed MailMan within the past year
 . ;
 . S XMY(WHO)=""
 . D:WHOCNT<1 MAILHEAD
 . S STRLINE=STRLINE+1
 . S $E(STR(STRLINE),5)=WHO
 . S $E(STR(STRLINE),15)=$P($G(^VA(200,WHO,0)),"^")
 . S WHOCNT=WHOCNT+1
 ;
 S:WHOCNT<1 XMY("G.LMI")=""  ; Send to members of LMI Mail Group iff no user has LRSUPER key 
 ;
 S XMSUB=MAILMSG
 S XMTEXT="STR("
 S XMDUZ="IHS Lab Maintenance"
 S XMZ="NOT OKAY"
 D ^XMD
 ;
 I $G(XMMG)'=""!(XMZ="NOT OKAY") S ^BLRCINDX(STOREDTT,LRCNT,KCNT)="MAILMAN ERROR.^"_XMZ_"^"_XMMG
 ;
 K X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,Y   ; Cleanup
 Q
 ;
MAILHEAD ; EP - E-Mail Header
 D ADDONEL(.STR,.STRLINE," ")
 D ADDONEL(.STR,.STRLINE,"E-Mail sent to the following:")
 D ADDONEL(.STR,.STRLINE," ")
 ;
 S STRLINE=STRLINE+1
 S $E(STR(STRLINE),5)="File 200"
 ;
 S STRLINE=STRLINE+1
 S $E(STR(STRLINE),5)="  IEN"
 S $E(STR(STRLINE),15)="Name"
 ;
 S STRLINE=STRLINE+1
 S $E(STR(STRLINE),5)="--------"
 S $E(STR(STRLINE),15)=$TR($J("",30)," ","-")
 Q
 ;
ADDONEL(ARRAY,LINE,STR)  ; EP - Add 1 Line
 S LINE=1+$G(LINE)
 S ARRAY(LINE)=STR
 Q
 ;
SILENTRB ; EP -- Report Browser
 NEW DATETIME,CNT1,CNT2,STR,STRLINE
 NEW HEADER,TOPBAR
 ;
 S (DATETIME,STRLINE)=0
 S (CNT1,CNT2)=""
 D SILENTRC
 ;
 S HEADER(1)="IHS Lab Accession File"
 S HEADER(2)="""C"" Index ""Orphan"" Deletion"
 S HEADER(3)=" "
 ;
 S $E(TOPBAR,5)="Date/Time ^BLRCINDX Run"
 S $E(TOPBAR,35)="# UIDS"
 S $E(TOPBAR,45)="# of ""Orphan"" Deletions"
 S TOPBAR=$$LJ^XLFSTR(TOPBAR,80)
 ;
 D HEADERDT^BLRGMENU
 D BROWSE^DDBR("STR","N",TOPBAR,,,5,24)
 ;
 D PRESSKEY^BLRGMENU(5)
 Q
 ;
 ; ----- END IHS/OIT/MKK - LR*5.2*1028
