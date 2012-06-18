BAREISS ; IHS/SD/LSL - EISS data, file, send ;08/20/2008 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/SD/LSL - 02/20/03 - V1.7 Patch 2
 ;     Routine created to gather ASM and PSR data, create files, and
 ;     send them to the to ARMS Server where WEB team can access them.
 ;     The call is executed only if user chooses summary report by
 ;     Allowance Category for all Allowance Categories.  BARY("STCR")=5
 ;     and '$D(BARY("ALL")) and BARY("RTYP")=1
 ;
 ; IHS/SD/LSL - 11/04/03 - V1.7 Patch 4
 ;     Ensure that the time portion of run date is 6 characters.
 ;
 ; IHS/SD/SLS - 11/25/03 - V1.7 Patch 4
 ;     Modify ASM to include Visit Locations
 Q
 ; ********************************************************************
 ; Make sure 4 entries created in ZISH SEND PARAMETERS FILE
 ; AR Version 1.8 populate initially.
 ;
 ; 1.  For PSR report - not queued
 ;          Entry name =                BAR EISS PSR F
 ;          Target System ID =          127.0.0.1
 ;          Username =                  bardata
 ;          Password =                  1bardat/
 ;          Arguments =     -i   (immediate mode - otherwise ftp delay)
 ;          Foreground/Background =     F
 ;          Send Command =     sendto
 ;
 ; 2.  For PSR report - queued
 ;          Entry name =                BAR EISS PSR B
 ;          Target System ID =          127.0.0.1
 ;          Username =                  bardata
 ;          Password =                  1bardat/
 ;          Arguments =     -i   (immediate mode - otherwise ftp delay)
 ;          Foreground/Background =     B
 ;          Send Command =     sendto
 ;
 ; 3.  For ASM report - not queued
 ;          Entry name =                BAR EISS ASM F
 ;          Target System ID =          127.0.0.1
 ;          Username =                  bardata
 ;          Password =                  1bardat/
 ;          Arguments =     -i   (immediate mode - otherwise ftp delay)
 ;          Foreground/Background =     F
 ;          Send Command =     sendto
 ;
 ; 4.  For ASM report - queued
 ;          Entry name =                BAR EISS ASM B
 ;          Target System ID =          127.0.0.1
 ;          Username =                  bardata
 ;          Password =                  1bardat/
 ;          Arguments =     -i   (immediate mode - otherwise ftp delay)
 ;          Foreground/Background =     B
 ;          Send Command =     sendto
 ;
 ; *********************************************************************
 ; EISS File naming convention:
 ;
 ; ___A__|__B__|___C___|___D___|______E______F|__G__|_H_
 ; BARPSR202101200307012003073120030728155600_000010.TXT
 ;
 ;          Position Description
 ;
 ; A        1-6      NAMESPACE_RPT  (BARPSR)
 ; B        7-12     ASUFAC (if null send "XXXXXX")
 ; C        13-20    BEGIN DATE OF DATA (YYYYMMDD)
 ; D        21-28    END DATE OF DATA (YYYYMMDD)
 ; E        29-42    RUN DATE (YYYYMMDDHHMMSS)
 ; F        43       SPACER (_)
 ; G        44-49    RECORD COUNT, RIGHT JUSTIFY, O FILL
 ; H        50-53    FILE EXTENTSION (.TXT)
 ; ********************************************************************
 ;
PSR ; EP
 ; Called from SUMMARY^BARRPSRB after Summary report is done printing.
 ; ------------------------------------------------------------------
 ; Filename ex: BARPSR202101200307012003073120030728155600_000010.TXT
 ;
 ; File layout
 ;
 ; Piece #   Description
 ;
 ;   1       Unique RPMS DB ID  (if null, send "-1")
 ;   2       ASUFAC (if null, send "?")
 ;   3       Visit Location (if unkown, send "No visit location")
 ;   4       Allowance Category
 ;   5       Billed Amount (no formatting)
 ;   6       Payment Amount (no formatting)
 ;   7       Adjustment Amount(no formatting)
 ;   8       Refund Amount (no formatting)
 ;
 ; ^TMP($J,"BAR-PSR-EISS",line count)=1^2^3^4^5^6^7^8
 ;-------------------------------------------------------------------
 ; Obtain top level variables
 ;
 ; BARY("DT",1)   set in BARRPSRA   (FM Date)    ; Begin date of data
 ; BARY("DT",2)   set in BARRPSRA   (FM Date)    ; End date of data
 N BARPNUM,BARRDT,BARRD,BARUNDT,BARCNT,BARVLOC,BARCAT,BARHLD,BARVDUZ
 N BARDBID,BARVNUM,BARFN,BARTMP
 N XBFN,XBGL,XBFLT,XBMED,XBNAR,XBQTO,XBUF
 S BARTMP=0
 F  S BARTMP=$O(^BAREISS1(BARTMP)) Q:'+BARTMP  K ^BAREISS1(BARTMP)
 K BARTMP
 D INIT                                          ; set common vars
 ;
 ; -------------------------------
 ; Build ^BAREISS1 global of data
 S BARVLOC=""
 F  S BARVLOC=$O(^TMP($J,"BAR-PSRT",BARVLOC)) Q:BARVLOC=""  D
 . S BARVDUZ=$P($G(^TMP($J,"BAR-PSRT",BARVLOC)),U,5)
 . S BARCAT=""
 . F  S BARCAT=$O(^TMP($J,"BAR-PSRT",BARVLOC,BARCAT)) Q:BARCAT=""  D
 . . S BARCNT=BARCNT+1
 . . S (BARDBID,BARVNUM)=""
 . . S BARHLD=$G(^TMP($J,"BAR-PSRT",BARVLOC,BARCAT))
 . . I +BARVDUZ D
 . . . S BARDBID=$P($G(^AUTTLOC(BARVDUZ,1)),U,3)
 . . . S BARVNUM=$P($G(^AUTTLOC(BARVDUZ,0)),U,10)
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U)=$S(BARDBID="":"-1",1:BARDBID)
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,2)=$S(BARVNUM="":"?",1:BARVNUM)
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,3)=BARVLOC
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,4)=BARCAT
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,5)=$P(BARHLD,U)
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,6)=$P(BARHLD,U,2)
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,7)=$P(BARHLD,U,3)
 . . S $P(^BAREISS1($J,"BAR-PSR-EISS",BARCNT),U,8)=$P(BARHLD,U,4)
 S BARCNT="000000"_BARCNT
 S BARCNT=$E(BARCNT,$L(BARCNT)-5,$L(BARCNT))     ; zero fill to 6 digit
 S XBFN="BARPSR"
 D FILE
 Q
 ;*********************************************************************
 ;
ASM ; EP
 ;
 ; Called from SUMMARY^BARRASM after Summary report is done printing.
 ; ------------------------------------------------------------------
 ; Filename ex: BARASM202101000000002003073120030731115200_000005.TXT
 ;
 ; File layout
 ;
 ; Piece #   Description
 ;
 ;   1       Unique RPMS DB ID  (if null, send "-1") - of visit location
 ;   2       ASUFAC (if null, send "?") - of visit location
 ;   3       Visit Location (if unkown, send "No visit location")
 ;   4       Allowance Category
 ;   5       Current Balance (no formatting)
 ;   6       Aged 31-60 Balance (no formatting)
 ;   7       Aged 61-90 Balance (no formatting)
 ;   8       Aged 91-120 Balance (no formatting)
 ;   9       Aged >120 Balance (no formatting)
 ;   10      Total balance for category (no formatting)
 ;
 ; ^TMP($J,"BAR-ASM-EISS",line count)=1^2^3^4^5^6^7^8^9^10^11
 ;-------------------------------------------------------------------
 ; Obtain top level variables
 ;
 N BARPNUM,BARRDT,BARRD,BARUNDT,BARCNT,BARVLOC,BARCAT,BARHLD,BARVDUZ
 N BARDBID,BARVNUM,BARFN,BARFLG
 N XBFN,XBGL,XBFLT,XBMED,XBNAR,XBQTO,XBUF
 S BARTMP=0
 F  S BARTMP=$O(^BAREISS2(BARTMP)) Q:'+BARTMP  K ^BAREISS2(BARTMP)
 K BARTMP
 D INIT                                          ; Set common vars
 S BARY("DT",2)=DT                               ; End date of data
 ;
 ; -------------------------------
 ; Build ^BAREISS2 global of data
 S BARVLOC=""
 F  S BARVLOC=$O(^TMP($J,"BAR-ASMT",BARVLOC)) Q:BARVLOC=""  D
 . S BARVDUZ=$P($G(^TMP($J,"BAR-ASMT",BARVLOC)),U,7)
 . S BARCAT=""
 . F  S BARCAT=$O(^TMP($J,"BAR-ASMT",BARVLOC,BARCAT)) Q:BARCAT=""  D
 . . S BARCNT=BARCNT+1
 . . S (BARDBID,BARVNUM)=""
 . . I +BARVDUZ D
 . . . S BARDBID=$P($G(^AUTTLOC(BARVDUZ,1)),U,3)
 . . . S BARVNUM=$P($G(^AUTTLOC(BARVDUZ,0)),U,10)
 . . S BARHLD=$G(^TMP($J,"BAR-ASMT",BARVLOC,BARCAT))
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U)=$S(BARDBID="":"-1",1:BARDBID)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,2)=$S(BARVNUM="":"?",1:BARVNUM)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,3)=BARVLOC
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,4)=BARCAT
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,5)=$P(BARHLD,U)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,6)=$P(BARHLD,U,2)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,7)=$P(BARHLD,U,3)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,8)=$P(BARHLD,U,4)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,9)=$P(BARHLD,U,5)
 . . S $P(^BAREISS2($J,"BAR-ASM-EISS",BARCNT),U,10)=$P(BARHLD,U,6)
 S BARCNT="000000"_BARCNT
 S BARCNT=$E(BARCNT,$L(BARCNT)-5,$L(BARCNT))     ; zero fill to 6 digit
 S XBFN="BARASM"
 D FILE
 Q
 ; ********************************************************************
 ;
INIT ;
 ; Top level variables.
 S BARPNUM=$P($G(^AUTTLOC(DUZ(2),0)),U,10)       ; Parent ASUFAC
 S:BARPNUM="" BARPNUM="XXXXXX"                   ; If null, send XXXXXX
 I $L(BARPNUM)<6 D
 . S BARPNUM="000000"_BARPNUM
 . S BARPNUM=$E(BARPNUM,$L(BARPNUM)-5,$L(BARPNUM))   ; zero fill to 6
 D NOW^%DTC
 S BARRDT=%
 S BARRD=$$Y2KD2^BARDUTL(BARRDT)
 S BARUNDT=BARRD_$P(BARRDT,".",2)                ; Run date/time
 I $L(BARUNDT)<14 D
 . S BARTMP=$L(BARUNDT)
 . F I=BARTMP+1:1:14 S BARUNDT=BARUNDT_"0"
 S BARCNT=0                                      ; Initialize rec cnt
 I $D(IO("S")),$$VERSION^%ZOSV(1)["UNIX" D ^%ZISC       ; close slave
 Q
 ; ********************************************************************
 ;
FILE ;
 ; Create Filename
 S XBFN=XBFN_BARPNUM
 S XBFN=XBFN_$S($D(BARY("DT",1)):$$Y2KD2^BARDUTL(BARY("DT",1)),1:"00000000")
 S XBFN=XBFN_$$Y2KD2^BARDUTL(BARY("DT",2))
 S XBFN=XBFN_BARUNDT
 S XBFN=XBFN_"_"
 S XBFN=XBFN_BARCNT
 S XBFN=XBFN_".TXT"             ; Filename to create
 S BARFN=XBFN                     ; AR 1.8
 ;
 ; -------------------------------
 ; Create file and send to EISS
 S BAREISS=$G(^BAR(90052.06,DUZ(2),DUZ(2),2))
 S XBQSHO=""
 S XBGL="BAREISS2("             ; ASM default
 ; NEW AUTO FTP **********
 S XBS1="BAR EISS ASM F"
 I $D(ZTQUEUED) S XBS1="BAR EISS ASM B"
 ;I $E(XBFN,4,6)="PSR" S XBGL="BAREISS1("
 I $E(XBFN,4,6)="PSR" D
 . S XBGL="BAREISS1("
 . S XBS1="BAR EISS PSR F"
 . I $D(ZTQUEUED) S XBS1="BAR EISS PSR B"
 S XBQ="N"       ; so won't do old send code in ZIBSGVEM/P
 ; END AUTO FTP ***************
 S XBF=$J                       ; Beginning 1st level numeric subscript
 S XBE=$J                       ; Ending 1st level numeric subscript
 S XBFLT=1                      ; indicates flat file
 S XBMED="F"                    ; Flag indicates file as media
 S XBCON=1                      ; Q if non-cononic
 S XBUF=$P(BAREISS,U,4)         ; Local directory for file creation
 ; NEW AUTO FTP ****************
 ;S BARUNAM=$P(BAREISS,U,2)      ; Username of system receiving file
 ;S BARUPASS=$P(BAREISS,U,3)     ; Password of system receiving file
 ;S XBQTO=$P(BAREISS,U)          ; System id to receive file
 ; Include username and password in system id
 ; Add i to XBQTO to send immediately rather than queue.  Needed so can
 ; delete sent files. (A/R 1.8)
 ;S XBQTO="-il """_BARUNAM_":"_BARUPASS_""" "_XBQTO
 ;I XBUF=""!(BARUNAM="")!(BARUPASS="")!(XBQTO="") Q
 I XBUF="" Q
 I '$D(XBS1) Q
 ; END AUTO FTP *****************************
 I IO=IO(0) W !!
 D ^XBGSAVE
 ; Coding change A/R 1.8 - next 5 lines
 Q:+XBFLG                         ; Send not successful
 ; delete file from local, send successful
 H 10     ; try to make sure file at recieving system before deleting
 S BARDIR=$P(BAREISS,U,4)
 S BARDEL=$$DEL^%ZISH(BARDIR,BARFN)
 Q
