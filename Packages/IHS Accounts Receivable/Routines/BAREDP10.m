BAREDP10 ; IHS/SD/LSL - NEW REPORT ERA CLAIMS ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,20**;OCT 26,2005
 ;
 ; IHS/SD/LSL - 10/1/03 - V1.7 Patch 4 - HIPAA
 ;      Routine Created
 ;
 ; IHS/SD/LSL - 02/26/04 - V1.7 Patch 5
 ;      Change check to chk/eft
 ;
 ; IHS/SD/RTL - 04/8/05 - V1.8 Patch 1
 ;      Can't view check detail in ERA Claim Report
 ; IHS/SD/SDR - 1/5/2011 - V1.8 P20 - Included new status Exception (E)
 ;
 ; ********************************************************************
 ;;
EN ; EP
 D DISP                     ; Display File and Check choice
 D INIT                     ; Initialize Variables
 F  D  Q:+BARDONE  Q:($D(BARINDX)&$D(BARTYP)&$D(BARMEDIA))
 . D STATUS                 ; Ask which Claim status to report
 . Q:'$D(BARINDX)
 . F  D  Q:'$D(BARTYP)  Q:($D(BARTYP)&$D(BARMEDIA))
 . . D RPTYP                  ; Ask report type
 . . Q:'$D(BARTYP)
 . . F  D  Q:$D(DIRUT)  Q:$D(BARMEDIA)                   ; Ask Browse or print
 . . . D ASK
 I ('$D(BARINDX)!('$D(BARTYP))!('$D(BARMEDIA))) D  Q
 . D PAZ^BARRUTL
 . D XIT
 D SETHDR                   ; Set up report header
 I BARMEDIA="B" D BROWSE
 E  D PRINT
 ;D PAZ^BARRUTL
 D XIT
 Q
 ; ********************************************************************
 ;
DISP ;
 ; Display File and Check Choices for report
 K IMP
 D ENP^XBDIQ1(90056.02,IMPDA,".01;.05","IMP(")
 W !,@IOF,!,"Reports for : ",?20,IMP(.01)
 W !,?20,IMP(.05),?50,"CHK/EFT #: ",$E(BARCHK,1,23)
 Q
 ; ********************************************************************
INIT ;
 ;
 S BARDONE=0
 S BAR("PRIVACY")=1                  ; Privacy act applies (used BARRHD)
 S $P(BARDASH,"-",81)=""
 S $P(BARSTAR,"*",81)=""
 F I=0,2 S BARCHK(I)=$G(^BARECHK(BARCKIEN,I))
 S BARZ("C")="CLAIM UNMATCHED"
 S BARZ("C","HDR")="= = = = = = = = = = = = C L A I M    U N M A T C H E D = = = = = = = = = = ="
 S BARZ("P")="POSTED"
 S BARZ("P","HDR")="= = = = = = = = = = = = = = = =  P O S T E D = = = = = = = = = = = = = = = ="
 S BARZ("M")="MATCHED"
 S BARZ("M","HDR")="= = = = = = = = = = = = = = = =  M A T C H E D = = = = = = = = = = = = = = ="
 S BARZ("N")="NOT TO POST"
 S BARZ("N","HDR")="= = = = = = = = = = = = = = N O T   T O    P O S T = = = = = = = = = = = = ="
 S BARZ("X")="CLAIM & REASON UNMATCHED"
 S BARZ("X","HDR")="= = = = = = =  C L A I M   &   R E A S O N   U N M A T C H E D = = = = = = ="
 S BARZ("R")="REASON UNMATCHED"
 S BARZ("R","HDR")="= = = = = = = = = = = R E A S O N    U N M A T C H E D = = = = = = = = = = ="
 ;start new code bar*1.8*20 REQ7
 S BARZ("E")="EXCEPTION"
 S BARZ("E","HDR")="= = = = = = = = = = = = = = = E X C E P T I O N= = = = = = = = = = = = = = ="
 ;end new code REQ7
 ;start new code bar*1.8*20
 S BARZ("W")="MATCHED W/REASON NOT TO POST"
 S BARZ("W","HDR")="= = = = = M A T C H E D   W / R E A S O N   N O T   T O   P O S T = = = = = ="
 ;end new code
 Q
 ; ********************************************************************
 ;
STATUS ;
 ; Select claim status for reports
 W !!,"Enter the list of Claim Status(s) you desire to print,"
 W !,"and in the sequence to be printed out.",!
 W !,"C - Claim Unmatched",?25,"R - Reason Unmatched",?50,"N - Not to Post"
 W !,"M - Matched",?25,"P - Posted",?50,"X - Claim & Reason Unmatched"
 ;W !,"A - All Categories",!,?5,"Example:   CRXN",!  ;bar*1.8*20 REQ7
 W !,"A - All Categories",?25,"E - Exception",!,?5,"Example:   CRXN",!  ;bar*1.8*20 REQ7
 S BARBAD=0
 K DIR,BARINDX
 ;S DIR(0)="FO^0:6"  ;bar*1.8*20 REQ7
 S DIR(0)="FO^0:7"  ;bar*1.8*20 REQ7
 D ^DIR
 K DIR
 S Y=$$UPC^BARUTL(Y)  ;bar*1.8*20
 I $L(Y)'>0 D  Q
 . W !!,"NONE SELECTED - EXITING",!
 . S BARDONE=1
 I Y="^" S BARDONE=1 Q
 ;S Z="CRNMPX"  ;bar*1.8*20 REQ7
 S Z="CRNMPXE"  ;bar*1.8*20 REQ7
 I Y="A" S Y=Z
 ;S Z="CRNMPX"  ;bar*1.8*20 REQ7
 S Z="CRNMPXE"  ;bar*1.8*20 REQ7
 F I=1:1:$L(Y) I Z'[$E(Y,I) D  Q
 . W !!,">>>BAD ENTRY<<<>>> ",Y
 . S BARBAD=1
 Q:+BARBAD
 S BARINDX=Y
 Q
 ; ********************************************************************
 ;
RPTYP ;
 ; Select Report Type
 W !
 K DIR,BARTYP
 S DIR(0)="SOB^D:Detailed;B:Brief - One Line;S:Summary - Totals Only"
 S DIR("A")="Select the type of report: "
 D ^DIR
 K DIR
 I $D(DUOUT)!($D(DTOUT)) Q
 Q:(",D,B,S,"'[(","_Y_","))
 S BARTYP=Y
 S BARTYP("NAME")=Y(0)
 Q
 ; ********************************************************************
 ;
ASK ;
 ; Ask Browse or Print
 K DIRUT,DIR,Y
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 S BARMEDIA=Y
 S BARMEDIA("NAME")=Y(0)
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Set up Report Header lines
 K BARPCIEN,BARPC,BARIIEN,BARAIEN
 ; Find payer contact.
 ; BARPC(Count)=#^type of number^name
 S BARPCIEN=0
 F  S BARPCIEN=$O(^BARECHK(BARCKIEN,3,BARPCIEN)) Q:'+BARPCIEN  D
 . S BARPC(BARPCIEN)=$G(^BARECHK(BARCKIEN,3,BARPCIEN,0))
 I '$D(BARPC) D
 . I $P(BARCHK(0),U,3)="" S BARPC(1)="" Q
 . I $P(BARCHK(0),U,4)="" S BARPC(1)="" Q
 . S BARAIEN=$P($G(^BARCOL(DUZ(2),$P(BARCHK(0),U,3),1,$P(BARCHK(0),U,4),0)),U,7)
 . I BARAIEN="" S BARPC(1)="" Q
 . S BARIIEN=$P($G(^BARAC(DUZ(2),BARAIEN,0)),U,1)
 . I BARIIEN'["AUTNINS" S BARPC(1)="" Q
 . S BARPC(1)=$P($G(^AUTNINS(+BARIIEN,0)),U,6)
 . I BARPC(1)="" S BARPC(1)="" Q
 . S $P(BARPC(1),U,3)=$P($G(^AUTNINS(+BARIIEN,0)),U,9)
 ;
 S BAR("HD",0)="ELECTRONIC CLAIM REPORT - "_$P(BARTYP("NAME")," ")
 S BARTMP="FOR FILE NAME: "_IMP(.05)
 D PAD
 S BAR("HD",1)=BARTMP_"CHECK/EFT TRACE: "_$E(BARCHK,1,12)
  ;BAR*1.8*1 SRS ADDENDUM FOR BAR*1.8*1
 S BARTMP=" "
 D PAD
 I $P(BARCHK(0),U,8)="XX" D
 .S BAR("HD",1.5)=BARTMP_"            NPI: "_$P(BARCHK(0),U,9)
 E  S BAR("HD",1.5)=BARTMP_"            TIN: "_$P(BARCHK(0),U,11)
 ;END
 S BAR("HD",2)="FOR RPMS FILE: "_IMP(.01)_" FOR "_$P(BARCHK(0),U,7)
 S BAR("HD",3)=BARDASH
 S BARTMP=$$GET1^DIQ(90056.22,BARCKIEN,.03)
 S BARTMP="BATCH: "_$S(BARTMP="":"** No RPMS match **",1:BARTMP)
 D PAD
 S BAR("HD",4)=BARTMP_"ITEM # "_$P(BARCHK(0),U,4)
 S BAR("HD",5)=BARDASH
 ;
 S BARTMP=$P(BARCHK(2),U)
 D PAD
 S BAR("HD",6)=BARTMP       ; Payer name (RA)
 S BARTMP=$P(BARCHK(2),U,2)
 D PAD
 S BAR("HD",7)=BARTMP      ; Payer Address (RA)
 S BARLCNT=7
 I $P(BARCHK(2),U,3)]"" D
 . S BARLCNT=BARLCNT+1
 . S BARTMP=$P(BARCHK(2),U,3)
 . D PAD
 . S BAR("HD",BARLCNT)=BARTMP    ; Payer address 2 (RA)
 S BARLCNT=BARLCNT+1
 I $P(BARCHK(2),U,6)'["-",$L($P(BARCHK(2),U,6))>5 S $P(BARCHK(2),U,6)=$E($P(BARCHK(2),U,6),1,5)_"-"_$E($P(BARCHK(2),U,6),6,9)
 S BARTMP=$P(BARCHK(2),U,4)_", "_$P(BARCHK(2),U,5)_" "_$P(BARCHK(2),U,6)
 D PAD
 S BAR("HD",BARLCNT)=BARTMP
 S BAR("LVL")=BARLCNT
 S I=$O(BARPC(0))
 Q:BARPC(I)=""              ; No payer contact info
 S BAR("HD",6)=BAR("HD",6)_$S($P(BARPC(I),U,3)]"":$P(BARPC(I),U,3),1:"CUSTOMER SERVICE")
 K I,J,K
 S I=0
 S BARLCNT=6
 F  S I=$O(BARPC(I)) Q:'+I!(BARLCNT>9)  D
 . S BARLCNT=BARLCNT+1
 . S BARCTYP=$S($P(BARPC(I),U,2)="":"PH: ",$P(BARPC(I),U,2)="TE":"PH: ",$P(BARPC(I),U,2)="FX":"FX: ",1:"")
 . S $P(BARPC(I),U)=$TR($P(BARPC(I),U),")-","")
 . S BARTMP=$P(BARPC(I),U)
 . I (BARCTYP="PH: "!(BARCTYP="FX: ")) D
 . . I $L(BARTMP)=10 S $P(BARPC(I),U)="("_$E(BARTMP,1,3)_") "_$E(BARTMP,4,6)_"-"_$E(BARTMP,7,10)
 . . I $L(BARTMP)=7 S $P(BARPC(I),U)=$E(BARTMP,1,3)_"-"_$E(BARTMP,4,7)
 . I '$D(BAR("HD",BARLCNT)) D
 . . S BARTMP=" "
 . . D PAD
 . . S BAR("HD",BARLCNT)=BARTMP
 . S BAR("HD",BARLCNT)=BAR("HD",BARLCNT)_BARCTYP_$P(BARPC(I),U)
 I BARLCNT>BAR("LVL") S BAR("LVL")=BARLCNT
 Q
 ; ********************************************************************
 ;
PAD ;
 ; Fixed undefined error in detail report.
 ; (Reported previously in IM17021.)
 ;K L
 N L,I             ;IM17021
 S L=$L(BARTMP)
 F I=L:1:50 S BARTMP=BARTMP_" "
 ;K L,I            ;IM17021
 Q
 ; ********************************************************************
 ;
BROWSE ;
 ; Browse report to screen
 ; GET DEVICE (QUEUEING ALLOWED)
 S XBFLD("BROWSE")=1
 S BARIOSL=IOSL
 S IOSL=600
 D VIEWR^XBLM("PRINT^BAREDP11")
 D FULL^VALM1
 W $$EN^BARVDF("IOF")
 D CLEAR^VALM1  ;clears out all list man stuff
 K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP
 K VALMY,XQORS,XQORSPEW,VALMCOFF
 S IOSL=BARIOSL
 Q
 ; ********************************************************************
 ;
PRINT ;
 ; Print report to device.  Queuing allowed.
 S BARQ("RC")="COMPUTE^BAREDP11"      ; Build tmp global with data
 S BARQ("RP")="PRINT^BAREDP11"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S ZTSAVE("IMPDA")=""
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 Q
 ; *********************************************************************
 ;
XIT ;
 D ^BARVKL0
 Q
