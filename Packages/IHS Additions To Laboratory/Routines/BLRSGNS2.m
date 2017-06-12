BLRSGNS2 ; IHS/OIT/MKK - IHS Lab SiGN or Symptom debug, part 2 ; 31-Jul-2015 06:30 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034,1035**;NOV 1, 1997;Build 5
 ;
 ; Some routines moved here from BLRSGNSD because BLRGSNSD became too large.
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
NEWPROBS ; EP - Latest entries in the Problem file
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$NEWPROBI()="Q"
 ;
 F  S ENTDT=$O(^TMP("BLRSGNSD",$J,ENTDT),-1)  Q:ENTDT<1!(QFLG="Q")  D
 . S IEN=0
 . F  S IEN=$O(^TMP("BLRSGNSD",$J,ENTDT,IEN))  Q:IEN<1!(QFLG="Q")  D NPRBLINE
 ;
 W !!,?4,CNT," Entries with ICD Codes."
 D PRESSKEY^BLRGMENU(9)
 K ^TMP("BLRSGNSD")
 Q
 ;
NEWPROBI() ; EP - Initialization
 D SETBLRVS("NEWPROBS")
 K ^TMP("BLRSGNSD")
 ;
 S HEADER(1)="Latest Modified Entries"
 S HEADER(2)="PROBLEM (#9000011) File"
 ;
 D HEADERDT^BLRGMENU
 ;
 W ?4,"Compiling"
 S IEN=.9999999,(CNT,PROBCNT)=0
 F  S IEN=$O(^AUPNPROB(IEN))  Q:IEN<1  D
 . S CNT=CNT+1
 . W:(CNT#1000)=0 "."  W:$X>75 !,?4
 . ;
 . Q:$D(^AUPNPROB(IEN,800))<1   ; Skip if no SNOMED entries
 . ;
 . ; S PROBICD=$$ICDDX^ICDCODE(+$G(^AUPNPROB(IEN,0)))
 . S PROBICD=$$ICDDX^ICDEX(+$G(^AUPNPROB(IEN,0)))     ; IHS/MSC/MKK - LR*5.2*1034
 . Q:PROBICD<1
 . ;
 . S PROBCNT=PROBCNT+1
 . ;
 . S ^TMP("BLRSGNSD",$J,+$P($G(^AUPNPROB(IEN,0)),"^",8),IEN)=""
 ;
 W !!,?4,$FN(CNT,",")," Entries in the Problem File (#9000011) Analyzed."
 W !!,?9,$S(PROBCNT:$FN(PROBCNT,","),1:"No")," Entries with ICD Codes."
 W:PROBCNT<1 " Routine Ends."
 D PRESSKEY^BLRGMENU(14)
 Q:PROBCNT<1 "Q"
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S QFLG="NO"
 S (CNT,PG)=0
 ;
 S HEADER(3)=" "
 S HEADER(4)="Entry",$E(HEADER(4),11)="Prob",$E(HEADER(4),59)="SNOMED CT",$E(HEADER(4),70)="SNOMED CT"
 S HEADER(5)="Date",$E(HEADER(5),11)="IEN",$E(HEADER(5),20)="STS"
 S $E(HEADER(5),25)="ICD CODE",$E(HEADER(5),35)="ICD DESCRIPTION"
 S $E(HEADER(5),59)="CONCEPT",$E(HEADER(5),70)="DESIGNATION"
 ;
 S ENTDT="A"
 Q "OK"
 ;
NPRBLINE ; EP - Line of Data
 D BREAKOUT^BLRSGNSD    ; Breakout Variables.  Skip if there is an issue.
 ;
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 ;
 W $$FMTE^XLFDT(ENTDT,"2DZ")
 W ?10,IEN
 W ?20,STATUS
 W ?24,ICDCODE,?34,$E(ICDDESC,1,22)
 W ?58,$$GET1^DIQ(9000011,IEN,80001)
 W ?69,$$GET1^DIQ(9000011,IEN,80002)
 W !
 ;
 S LINES=LINES+1
 S CNT=CNT+1
 Q
 ;
CHKPLIST(DFN) ; EP - Check Problem List.
 NEW PROBICD,PROBCNT,PROBIEN
 ;
 S PROBCNT=0,PROBICD="",PROBIEN="AAA"
 F  S PROBIEN=$O(^AUPNPROB("AC",DFN,PROBIEN),-1)  Q:PROBIEN<1  D
 . Q:$D(^AUPNPROB(PROBIEN,800))<1   ; Skip if no SNOMED entries
 . ;
 . ; S PROBICD=$$ICDDX^ICDCODE(+$G(^AUPNPROB(PROBIEN,0)))
 . S PROBICD=$$ICDDX^ICDEX(+$G(^AUPNPROB(PROBIEN,0)))      ; IHS/MSC/MKK - LR*5.2*1034
 . S PROBCNT=PROBCNT+1
 ;
 Q:PROBCNT>1 0            ; More than one entry in the PROBLEM list.
 ;
 Q:PROBCNT<1 1            ; No Problems in list
 ;
 ; If only one Problem and it's 799.9, treat it as if no problem in the PROBLEM list.
 Q $S($P(PROBICD,"^",2)=799.9:1,1:0)
 ;
RESETOFD ; EP - Given an Order Number, reset the Provider Narrative, SNOMED, & ICD fields, if possible, in file 69
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 ;
 S HEADER(1)="Reset Order File"
 S HEADER(2)="Sign/Symptom Variables Only"
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="NO"
 S DIR("A")="Order Number"
 S DIR("T")=1800   ; IHS/MSC/MKK - LR*5.2*1035 - Wait 30 Minutes
 D ^DIR
 I +$G(Y)<1!(+$G(DIRUT)) D  Q
 . W !!,?4,"No/Invalid Entry.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 S ORDNUM=+$G(Y)
 S LRODT=$O(^LRO(69,"C",ORDNUM,0)),LRSP=$O(^LRO(69,"C",ORDNUM,LRODT,0))
 S LRDFN=+$G(^LRO(69,LRODT,1,LRSP,0)),DFN=+$P($G(^LR(LRDFN,0)),"^",3)
 ;
 D ALLTESTS^BLRSGNSY(DFN,ORDNUM,LRODT)
 ;
 D HEADERDT^BLRGMENU
 ;
 S TEST=0
 F  S TEST=$O(^LRO(69,LRODT,1,LRSP,2,TEST))  Q:TEST<1  D
 . S IENS=TEST_","_LRSP_","_LRODT_","
 . W ?9,"PROVIDER NARRATIVE:",$$GET1^DIQ(69.03,IENS,"PROVIDER NARRATIVE"),!
 . W ?21,"SNOMED:",$$GET1^DIQ(69.03,IENS,"SNOMED"),!
 . D ICDCODE^BLRSGNSD
 Q
 ;
JUSTVALS ; EP - Given input, just display ALL entries returned from BSTS server.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 D:+$G(IOM)<1 HOME^%ZIS
 ;
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Search Text"
 S DIR("T")=1800   ; IHS/MSC/MKK - LR*5.2*1035 - Wait 30 Minutes
 D ^DIR
 I $L(X)<1 D  Q
 . W !,?4,"No/Invalid Entry.  Routine Ends."
 . D PRESSKEY^BLRGMENU
 ;
 ; S OUT="VARS",IN=$G(X)_"^F^^^^500",$P(IN,"^",5)=$$DT^XLFDT
 S OUT="VARS",IN=$G(X)_"^S^^^^500",$P(IN,"^",5)=$$DT^XLFDT      ; IHS/MSC/MKK - LR*5.2*1034
 S Y=+$$SEARCH^BSTSAPI(OUT,IN)
 D ADDICD9^BLRSGNSU
 I Y<1 D  Q
 . W !,?4,"No data returned for ",X," input.  Routine ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 ; S HEADER(2)="Sign or Symptom Debug Routines"
 S HEADER(2)="Clinical Indication Debug Routines"
 S HEADER(3)=$$CJ^XLFSTR("Terminology Server Response",IOM)
 S HEADER(4)=$$CJ^XLFSTR("Search Text:"_$G(X),IOM)
 S HEADER(5)=" "
 ; S HEADER(6)="WOT",$E(HEADER(6),10)="ICD"
 ; S $E(HEADER(6),20)="FSN/DSC",$E(HEADER(6),35)="FSN/TRM"
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 S HEADER(6)="WOT",$E(HEADER(6),10)="ICD-10"     ; 
 S $E(HEADER(6),20)="FSN/DSC",$E(HEADER(6),35)="FSN/TRM"
 S $E(HEADER(6),70)="ICD-9"  ; IHS/MSC/MKK - LR*5.2*1034
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
 S MAXLINES=20,LINES=MAXLINES+10,(CNT,PG)=0,QFLG="NO"
 ;
 S (CNT,WOT)=0
 F  S WOT=$O(VARS(WOT))  Q:WOT<1!(QFLG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,.HDRONE)  Q:QFLG="Q"
 . ;
 . W WOT
 . W ?9,$G(VARS(WOT,"ICD",1,"COD"))
 . W ?19,$G(VARS(WOT,"FSN","DSC"))
 . ; W ?34,$E($G(VARS(WOT,"FSN","TRM")),1,46)
 . W ?34,$E($G(VARS(WOT,"FSN","TRM")),1,33)      ; IHS/MSC/MKK - LR*5.2*1034
 . W ?69,$G(VARS(WOT,"IC9",1,"COD"))             ; IHS/MSC/MKK - LR*5.2*1034
 . W !
 . S LINES=LINES+1
 . S SYN=0
 . F  S SYN=$O(VARS(WOT,"SYN",SYN))  Q:SYN<1!(QFLG="Q")  D
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,.HDRONE)  Q:QFLG="Q"
 .. W ?9," SYNONYM"
 .. W ?19,$G(VARS(WOT,"SYN",SYN,"DSC"))
 .. W ?34,$E($G(VARS(WOT,"SYN",SYN,"TRM")),1,46)
 .. W !
 .. S LINES=LINES+1
 . S CNT=CNT+1
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
JUSTICDS ; EP - Given input, just display ALL entries returned from BSTS server that have ICD Code
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$JUSTICDI()="Q"
 ;
 F  S WOT=$O(VARS(WOT))  Q:WOT<1!(QFLG="Q")  D
 . ; Q:$G(VARS(WOT,"ICD",1,"COD"))=""
 . S BSTSCNT=BSTSCNT+1
 . S ICDCODE=$G(VARS(WOT,"ICD",1,"COD"))
 . Q:ICDCODE=""
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 . ;
 . W WOT
 . W ?9,$G(VARS(WOT,"ICD",1,"COD"))
 . W ?17,$G(VARS(WOT,"FSN","DSC"))
 . D LINEWRAP^BLRGMENU(29,$G(VARS(WOT,"FSN","TRM")),51)
 . W !
 . S LINES=LINES+1
 . S CNT=CNT+1
 ;
 W !!,?4,BSTSCNT," BSTS Entries."
 W:CNT !!,?9,CNT," Valid ICD Code Entries."
 ;
 D PRESSKEY^BLRGMENU($S(CNT:14,1:9))
 Q
 ;
JUSTICDI() ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," "),BLRVERN2="JUSTICDS"
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="Clinical Indication Debug Routines"
 S HEADER(3)=$$CJ^XLFSTR("Terminology Server Response with ICDs",IOM)
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 ;
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Search Text"
 S DIR("T")=1800   ; IHS/MSC/MKK - LR*5.2*1035 - Wait 30 Minutes
 D ^DIR
 Q:$L(X)<1!(+$G(DIRUT)) $$BADENDQ("No/Invalid Entry.  Routine Ends.")
 D PRESSKEY^BLRGMENU
 ;
 S OUT="VARS",IN=$G(X)_"^F^^^^500",$P(IN,"^",5)=$$DT^XLFDT
 ;
 Q:+$$SEARCH^BSTSAPI(OUT,IN)<1 $$BADENDQ("No data returned for "_X_" input.")
 ;
 D ADDICD9^BLRSGNSU
 ;
 S HEADER(4)=$$CJ^XLFSTR("Search Text:"_$G(X),IOM)
 S HEADER(5)=" "
 S HEADER(6)="WOT",$E(HEADER(6),10)="ICD"
 S $E(HEADER(6),18)="SNOMED",$E(HEADER(6),30)="DESCRIPTION"
 ;
 S MAXLINES=20,LINES=MAXLINES+10,(CNT,PG)=0,QFLG="NO"
 ;
 S (CNT,WOT)=0
 S BSTSCNT=0
 Q "OK"
 ;
ERRMSGRP ; EP - Report on Error Messages stored in the ^XTMP global by ERRMSG^BLRSGNS3
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("ERRMSGRP")
 ;
 S HEADER(1)="IHS Laboratory"
 S HEADER(2)="Error Messages Generated by BLRSGNSP"
 S HEADER(3)=" "
 S HEADER(4)="Order #"
 S $E(HEADER(4),10)="Date/Time"
 S $E(HEADER(4),30)="LineLabel^Routine"
 S $E(HEADER(4),60)="Error Message"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,ORDERNUM,PG)=0
 S QFLG="NO"
 ;
 F  S ORDERNUM=$O(^XTMP("BLRSGNSP","D",ORDERNUM))  Q:ORDERNUM<1!(QFLG="Q")  D
 . S NOWDTIME=0
 . F  S NOWDTIME=$O(^XTMP("BLRSGNSP","D",ORDERNUM,NOWDTIME))  Q:NOWDTIME<1!(QFLG="Q")  D
 .. S ERRFRTN=""
 .. F  S ERRFRTN=$O(^XTMP("BLRSGNSP","D",ORDERNUM,NOWDTIME,ERRFRTN))  Q:ERRFRTN=""!(QFLG="Q")  D
 ... I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,"NO")  Q:QFLG="Q"
 ... ;
 ... W ORDERNUM
 ... W ?9,NOWDTIME
 ... W ?29,ERRFRTN
 ... ; W ?59,$G(^XTMP(ERRFRTN,NOWDTIME,MSG))
 ... W ?59,$O(^XTMP(ERRFRTN,NOWDTIME,""))   ; IHS/MSC/MKK - LR*5.2*1034
 ... W !
 ... S LINES=LINES+1
 ... S CNT=CNT+1
 ;
 Q:QFLG="Q"
 ;
 W !!,?4,CNT," Entries"
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
SETBLRVS(TWO) ; EP - Set BLRVERN variable(s)
 S BLRVERN=$TR($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
 ;
BADSTUFN(MSG) ; EP - Function
 W !!,?4,MSG,"  Routine Ends."
 D PRESSKEY^BLRGMENU(9)
 Q ""
 ;
BADENDQ(MSG) ; EP - Function
 W !!,?4,MSG,"  Routine Ends."
 D PRESSKEY^BLRGMENU(9)
 Q "Q"
