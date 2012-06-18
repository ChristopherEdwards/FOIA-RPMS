BLRLINKU ;IHS/OIT/MKK - IHS LAB LINK TO PCC Utilities ; [ 05/31/2011  10:35 AM ]
 ;;5.2;LR;**1030**;NOV 01, 1997
 ;
 ;       Need to get Reference Ranges & Units from Incoming HL7 message
 ;       IF and ONLY IF the transaction is tied to a Reference Lab Accession
CHKINHL7 ; EP
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CHKINHL7^BLRLINKU 0.0","BLRVAL")
 NEW DNIEN,DNDESC,F60IEN,HL7TEST,LRAA,LRAD,LRAN,LRAS,STR,UID
 NEW ABNFLAG,REFHIGH,REFLOW,UNITS
 ;
 Q:+$G(BLRLOGDA)<1                                 ; If no BLR Txn #, skip
 ;
 S LRAS=$P($G(^BLRTXLOG(BLRLOGDA,12)),"^",2)       ; Accession number
 D GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)       ; Get Accession's component parts
 Q:LRAA<1!(LRAD<1)!(LRAN<1)                        ; Quit if Accession doesn't exist
 ;
 D REFLAB68                                        ; Check on ^XTMP("BLRLINKU")
 Q:$D(^XTMP("BLRLINKU",$G(DUZ(2)),LRAA))<1         ; If not a Ref Lab Accession, skip
 ;
 S F60IEN=+$P($G(^BLRTXLOG(BLRLOGDA,0)),"^",6)     ; File 60 IEN
 ;
 S UID=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3)),"^")
 Q:UID<1                                           ; If no UID, skip
 ;
 Q:$$GETINTHU(UID)<1
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CHKINHL7^BLRLINKU 4.5")
 ;
 S STR=$G(^TMP("BLR",$J,UID,F60IEN))
 Q:$L(STR)<1
 ;
 D STORVAL(2,$P(STR,"^",2))    ; Abnormal Flag
 D STORVAL(3,$P(STR,"^",5))    ; Units
 D STORVAL(8,$P(STR,"^",3))    ; Reference Low
 D STORVAL(9,$P(STR,"^",4))    ; Referench High
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("CHKINHL7^BLRLINKU 9.0","BLRVAL")
 Q
 ;
STORVAL(WHERE,WHAT)  ; EP -- Store values in the IHS LAB TRANSACTION LOG file AND the BLRVAL array
 Q:$L(WHAT)<1        ; Skip if no results
 ;
 S $P(BLRVAL(20),"^",WHERE)=WHAT
 S $P(^BLRTXLOG(BLRLOGDA,20),"^",WHERE)=WHAT
 Q
 ;
GETINTHU(UID) ; EP -- Get Reference Range information from File 4001 (UNIVERSAL INTERFACE)
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("GETINTHU^BLRLINKU 0.0")
 ;
 ; Don't search if test already stored in ^TMP global
 Q:$D(^TMP("BLR",$J,UID,F60IEN))>0 1
 ;
 NEW AUTIF60P,AUTOINSN,AUTOINSP,AUTOITST,FOUNDIT,MSGID,MSGNUM,MSGUID,MSGSEG,MSGSTR
 NEW MSGRESLT,MSGUNITS,MSGRLOW,MSGRHI,MSGABN,NOTMSG
 NEW LA7INST,AUTOINSP,WOTPIECE,WOTREF
 ;
 ; Retrieve "Instrument Name" for Reference Lab
 S LA7INST=$$GET1^DIQ(9009029,DUZ(2),3001)
 Q:$G(LA7INST)="" 0                                ; Quit with zero if no Reference Lab
 ;
 ; Determine what piece is the observation sub-id: QUEST uses OBX3.4; all others use OBX3.1
 S WOTPIECE=$S($$UP^XLFSTR(LA7INST)["QUEST":4,1:1)
 ;
 S AUTOINSP=+$O(^LAB(62.4,"B",LA7INST,""))         ; Auto Instrument IEN
 Q:AUTOINSP<1 0                                    ; Quit with zero if No Auto Instrument
 ;
 D:$G(SNAPSHOT) STORFIND(UID,0)                    ; Store Starting Time of search
 S WOTREF=+$G(^XTMP("BLRLINKU",+$G(DUZ(2))))       ; Interface Destination (# 4005) IEN
 Q:WOTREF<1 0                                      ; Quit with zero if IEN<1
 ;
 ; Use "AD" Cross Reference
 S (FOUNDIT,MSGNUM)=0
 F  S MSGNUM=$O(^INTHU("AD",WOTREF,MSGNUM))  Q:MSGNUM<1!(FOUNDIT)  D
 . S (MSGSEG,NOTMSG)=0
 . F  S MSGSEG=$O(^INTHU(MSGNUM,3,MSGSEG))  Q:MSGSEG<1!(FOUNDIT)  D
 .. I $P($G(^INTHU(MSGNUM,3,MSGSEG,0)),"|")="OBR" D
 ... ; Determine if UID = UID of Message
 ... S:UID=+$P($G(^INTHU(MSGNUM,3,MSGSEG,0)),"|",3) FOUNDIT=MSGNUM
 .. Q:'FOUNDIT
 .. ;
 .. ; Find OBX segment
 .. S (CNT,FOUNDIT)=0
 .. F  S MSGSEG=$O(^INTHU(MSGNUM,3,MSGSEG))  Q:MSGSEG<1!(FOUNDIT)  D
 ... S MSGSTR=$G(^INTHU(MSGNUM,3,MSGSEG,0))
 ... Q:$P(MSGSTR,"|")'="OBX"
 ... ;
 ... S CNT=CNT+1
 ... S MSGTEST=$P($P(MSGSTR,"|",4),"^",WOTPIECE)   ; OBX 3
 ... Q:$L(MSGTEST)<1                               ; Don't check if not defined
 ... ;
 ... Q:$D(^LAB(62.4,AUTOINSP,3,"AC",MSGTEST))<1    ; Don't check if not in Auto Instrument file
 ... ;
 ... ; File 60 IEN from Auto Instrument file
 ... S AUTIF60P=$P($G(^LAB(62.4,AUTOINSP,3,$O(^LAB(62.4,AUTOINSP,3,"AC",MSGTEST,0)),0)),"^")
 ... ;
 ... S MSGRESLT=$P(MSGSTR,"|",6)                   ; Results
 ... S MSGUNITS=$P(MSGSTR,"|",7)                   ; Units
 ... S MSGRLOW=$P($P(MSGSTR,"|",8),"-")            ; Reference Low
 ... S MSGRHI=$P($P(MSGSTR,"|",8),"-",2)           ; Reference High
 ... S MSGABN=$P(MSGSTR,"|",9)                     ; Status Flag
 ... S MSGABN=$S(MSGABN="L":MSGABN,MSGABN="H":MSGABN,MSGABN="A":MSGABN,1:"")
 ... ; 
 ... ; Store information
 ... S ^TMP("BLR",$J,UID,AUTIF60P)=MSGRESLT_"^"_MSGABN_"^"_MSGRLOW_"^"_MSGRHI_"^"_MSGUNITS
 ... S FOUNDIT=1                                   ; Set flag
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) STORFIND(UID,1)                    ; Store Ending Time of search
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("GETINTHU^BLRLINKU 9.0")
 Q FOUNDIT
 ;
 ; Done to speed up Lab to PCC processing for Ref Labs
 ; Sets ^XTMP array to only those accessions tied to reference labs
REFLAB68 ; EP -- Setup ^XTMP global with Ref Lab Accessions' IENs
 ; If purge date > Today, then RETURN
 Q:+$P($G(^XTMP("BLRLINKU",0)),"^")>$$DT^XLFDT
 ;
 NEW REFLLRAA,REFLLABN,REFLLABS,LRAAREF,INCOMIEN,BLRDIVS,DESTIEN,DESTNAME,OUTARRAY
 NEW INSTIEN,LOCIEN
 ;
 K ^XTMP("BLRLINKU")      ; Clear
 ;
 ; Initialize ^XTMP per SAC guidelines
 S ^XTMP("BLRLINKU",0)=$$HTFM^XLFDT(+$H+30)_"^"_$$HTFM^XLFDT(+$H)_"^BLRLINK Ref Lab Data"
 ;
 S BLRDIVS=.9999999
 F  S BLRDIVS=$O(^BLRSITE(BLRDIVS))  Q:BLRDIVS<1  D
 . S LOCIEN=+$G(^BLRSITE(BLRDIVS,0))
 . S INSTIEN=+$G(^AUTTLOC(LOCIEN,0))          ; Institution IEN
 . S REFLLABS=+$G(^BLRSITE(BLRDIVS,"RL"))
 . S REFLABN=$P($G(^BLRRL(REFLLABS,0)),"^")
 . S DESTNAME="HL IHS LAB R01 "_REFLABN_" IN"
 . K OUTARRAY
 . D FIND^DIC(4005,,,,DESTNAME,,,,,"OUTARRAY")
 . S DESTIEN=+$G(OUTARRAY("DILIST",2,1))
 . Q:DESTIEN<1
 . S ^XTMP("BLRLINKU",INSTIEN)=DESTIEN_"^"_DESTNAME
 . S REFLLRAA=.9999999
 . F  S REFLLRAA=$O(^BLRRL(REFLLABS,2,REFLLRAA))  Q:REFLLRAA=""  D
 .. S LRAAREF=+$G(^BLRRL(REFLLABS,2,REFLLRAA,0))
 .. Q:LRAAREF<1
 .. S ^XTMP("BLRLINKU",INSTIEN,LRAAREF)=$P($G(^LRO(68,LRAAREF,0)),"^")
 Q
 ;
STORFIND(UID,WOT) ; EP - Store Time Before or After $Order through the ^INTHU global
 D:$D(^XTMP("BLRSRCH"))<1 RESTART
 D:$$FMDIFF^XLFDT($$DT^XLFDT,$P($G(^XTMP("BLRSRCH")),"^",2),1)>7 RESTART
 ;
 S CNT=1+$G(^XTMP("BLRSRCH",-1))
 S ^XTMP("BLRSRCH",-1)=CNT
 S ^XTMP("BLRSRCH",CNT,UID,WOT)=$H
 Q
 ;
RESTART ; EP - Create ^XTMP("BLRSRCH") if it doesn't exist or restart it
 K ^XTMP("BLRSRCH")
 S ^XTMP("BLRSRCH")=$$HTFM^XLFDT(+$H+30)_"^"_$$HTFM^XLFDT(+$H)_"^Timing of ^INTHU Searches"
 Q
 ;
 ; The following report is designed for programmers ONLY.  It is used to
 ; determine the efficiency of the $ORDER command through the ^INTHU
 ; global.  This could be a major issue.
 ; Note: this report only prints to the screen.
REPTSTOR ; EP -- Progrmmaer Mode Only Report on ^XTMP("BLRSRCH") global
 NEW HEADER,HD1,LINES,MAXLINES,PG,QFLG
 NEW CNT,DIFFTIME,EDT,LRAS,SDT,UID
 ;
 D REPTSINI
 ;
 F  S CNT=$O(^XTMP("BLRSRCH",CNT))  Q:CNT<1!(QFLG="Q")  D
 . F  S UID=$O(^XTMP("BLRSRCH",CNT,UID))  Q:UID<1!(QFLG="Q")  D
 .. D REPTSLIN
 ;
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
REPTSINI ; EP -- Initialize Variables
 S HEADER(1)="RPMS LAB Report"
 S HEADER(2)="$ORDER Traversal Speed thru ^INTHU Global"
 S HEADER(3)=$$CJ^XLFSTR($FN($P($G(^INTHU(0)),"^",3),",")_" Entries in ^INTHU",IOM)
 S HEADER(4)=" "
 S HEADER(5)="UID"
 S $E(HEADER(5),12)="Accession"
 S $E(HEADER(5),32)="Start Dt/Time"
 S $E(HEADER(5),52)="End Dt/Time"
 S $E(HEADER(5),73)="How Long"
 ;
 S PG=0,MAXLINES=22,LINES=MAXLINES+10,QFLG="OKAY",HD1="NO"
 S CNT=.9999999,UID=""
 ;
 Q
 ;
REPTSLIN ; EP - Write a line of Data
 D RPTSBRKO
 ;
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HD1)  Q:QFLG="Q"
 ;
 W UID
 W ?11,LRAS
 W ?31,SDT
 W ?51,EDT
 W ?71,$J(DIFFTIME,9)
 W !
 S LINES=LINES+1
 Q
 ;
 ; ^XTMP("BLRSRCH",CNT,UID,WOT)=$H
RPTSBRKO ; EP - Breakout values for variables
 NEW HDE,HDS,LRAA,LRAD,LRAN
 S (SDT,EDT,DIFFTIME,LRAS)=""
 ;
 S LRAA=+$O(^LRO(68,"C",UID,""))
 S LRAD=+$O(^LRO(68,"C",UID,LRAA,""))
 S LRAN=+$O(^LRO(68,"C",UID,LRAA,LRAD,""))
 S LRAS=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))
 ;
 S HDS=$G(^XTMP("BLRSRCH",CNT,UID,0))
 S SDT=$$UP^XLFSTR($$HTE^XLFDT(HDS,"5MPZ"))
 ;
 ; If next entry is not the same UID, can't do a Time Comparison
 Q:$O(^XTMP("BLRSRCH",CNT+1,""))'=UID
 ;
 ; Skip if no "Ending Time"
 Q:$G(^XTMP("BLRSRCH",CNT+1,UID,1))=""
 ;
 S CNT=CNT+1    ; Yes, increment $ORDER variable.
 ;
 S HDE=$G(^XTMP("BLRSRCH",CNT,UID,1))
 S EDT=$$UP^XLFSTR($$HTE^XLFDT(HDE,"5MPZ"))
 ;
 S DIFFTIME=$$HDIFF^XLFDT(HDE,HDS,3)
 Q
 ;
 ;
ICDCHEK(ICDCODE) ; EP - Check to see if passed string is in ICD dictionary.
 NEW TARGET,ERRORS,X
 ;
 I ICDCODE["^" S ICDCODE=$P(ICDCODE,"^")
 Q:+ICDCODE<1 0
 ;
 D FIND^DIC(80,,,"M",ICDCODE,,,,,"TARGET","ERRORS")
 Q $S(+$G(TARGET("DILIST",1,1))>0:1,1:0)
