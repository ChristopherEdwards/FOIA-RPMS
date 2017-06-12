BLRSGNSU ; IHS/OIT/MKK - IHS Lab SiGN or SYmptom Utilities ; 31-Jul-2015 06:30 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034,1035**;NOV 1, 1997;Build 5
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ; Called from ADDTST^BLRDIAG
CHKORDAC(LRODT,ORDIEN,TST) ; EP - Adding a test?
 D ENTRYAUD^BLRUTIL("CHKORDAC^BLRSGNSU 0.0")
 ;
 Q:$$ADDTLRAS(LRODT,ORDIEN,TST) 1
 ;
 Q:$$ACCESST(LRODT,ORDIEN,TST) 0       ; IHS/MSC/MKK - LR*5.2*1034 - Accession on Order, exit
 ;
 Q:$$ADDTORDN(LRODT,ORDIEN,TST) 1      ; IHS/MSC/MKK - LR*5.2*1034 - Only orders
 ;
 Q 0
 ;
ADDTLRAS(LRODT,LRSP,LRTST) ; EP - Adding a test to an accession?
 NEW (BAILOUT,DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRORD,LRODT,LRSP,LRTST,PNM,HRCN,U,XPARSYS,XQXFLG)
 ;
 D ENTRYAUD^BLRUTIL("ADDTLRAS^BLRSGNSU 0.0")
 ;
 S LRASTEST=$$ACCESST(LRODT,LRSP,LRTST)    ; Get first test on order with Accession data
 Q:LRASTEST<1 0
 ;
 S IENS=LRASTEST_","_LRSP_","_LRODT_","
 ;
 S ORIGPN=$$GET1^DIQ(69.03,IENS,"PROVIDER NARRATIVE")
 S ORIGSN=$$GET1^DIQ(69.03,IENS,"SNOMED")
 S ORIGICDP=$$GET1^DIQ(69.05,1_","_IENS,"ICD CODES")
 S ORIGICDI=+$$GET1^DIQ(69.05,1_","_IENS,"ICD CODES","I")
 ;
 ; Q:$L(ORIGPN)<1!($L(ORIGSN)<1) 0    ; If no data to copy, quit
 Q:$L(ORIGPN)<1&($L(ORIGSN)<1) 0  ; IHS/MSC/MKK - LR*5.2*1035 -- If no data to copy, quit
 ;
 S LRNEWTST=+$O(^LRO(69,LRODT,1,LRSP,2,"B",LRTST,0))
 S IENS=LRNEWTST_","_LRSP_","_LRODT_","
 ;
 ; S FDA(69.03,IENS,9999999.1)=ORIGPN
 ; S FDA(69.03,IENS,9999999.2)=ORIGSN
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 ; Data Can be either SNOMED or PROVIDER NARRATIVE or both
 S:$L(ORIGPN) FDA(69.03,IENS,9999999.1)=ORIGPN
 S:$L(ORIGSN) FDA(69.03,IENS,9999999.2)=ORIGSN
 ; ----- END IHS/MSC/MKK - LR*5.2*1035
 ;
 D UPDATE^DIE("EKS","FDA",,"ERRS")
 ; I $D(ERRS) D ERRMSG^BLRSGNSP("ADDTLRAS: UPDATE^DIE","BLRSGNSU")
 I $D(ERRS) D ERRMSG^BLRSGNS3("ADDTLRAS: 69.03 UPDATE^DIE","BLRSGNSU")    ; IHS/MSC/MKK - LR*5.2*1035
 ;
 K FDA,ERRS
 S FDA(69.05,"?+1,"_IENS,.01)=ORIGICDP
 ; D UPDATE^DIE("EKS","FDA",,"ERRS")
 D:$L(ORIGICDP) UPDATE^DIE("EKS","FDA",,"ERRS")  ; IHS/MSC/MKK - LR*5.2*1035 -- UPDATE IFF ORIGICDP variable has data
 ;
 I $D(ERRS),ORIGICDI D  ; If Error, try using ICD's IEN, if it exists
 . K FDA,ERRS
 . S FDA(69.05,"?+1,"_IENS,.01)=ORIGICDI
 . D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 ; I $D(ERRS) D ERRMSG^BLRSGNSP("ADDTLRAS: UPDATE^DIE","BLRSGNSU")
 I $D(ERRS) D ERRMSG^BLRSGNS3("ADDTLRAS: UPDATE^DIE","BLRSGNSU")     ; IHS/MSC/MKK - LR*5.2*1035
 Q 1
 ;
ACCESST(LRODT,LRSP,ORDTEST) ; EP - Determine the first test on an order with Accession data
 NEW IENS,ORDTEST,LRASTEST
 ;
 S (ORDTEST,LRASTEST)=0
 F  S ORDTEST=$O(^LRO(69,LRODT,1,LRSP,2,ORDTEST))  Q:ORDTEST<1!(LRASTEST)  D
 . S IENS=ORDTEST_","_LRSP_","_LRODT
 . Q:$$GET1^DIQ(69.03,IENS,9999999.2)=""    ; LR*5.2*1035 - If no SNOMED, go to next test
 . ;
 . S:+$$GET1^DIQ(69.03,IENS,"ACCESSION DATE","I") LRASTEST=ORDTEST
 ;
 Q LRASTEST
 ;
 ; Called from ADDTST^BLRDIAG
ADDTORDN(LRODT,LRSP,LRTST) ; EP - Adding a test to an order?
 ; NEW (BAILOUT,DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRORD,LRODT,LRSP,LRTST,PNM,HRCN,U,XPARSYS,XQXFLG)
 NEW (BAILOUT,DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,LRORD,LRODT,LRSP,LRTST,PNM,HRCN,U,XPARSYS,XQXFLG)
 ;
 D HOME^%ZIS
 ;
 D ENTRYAUD^BLRUTIL("ADDTORDN^BLRSGNSU 0.0")
 S ORDERN=$$GET1^DIQ(69.01,LRSP_","_LRODT,"ORDER #")
 ;
 Q:+ORDERN<1 0  ; Skip if no Order #
 ;
 S DIRZERO="SO^"
 S (CNT,FOUNDIT,LR69ODT)=0
 F  S LR69ODT=$O(^LRO(69,"C",ORDERN,LR69ODT))  Q:LR69ODT<1  D
 . S LR69SP=0
 . F  S LR69SP=$O(^LRO(69,"C",ORDERN,LR69ODT,LR69SP))  Q:LR69SP<1  D
 .. S LROTST=0
 .. F  S LROTST=$O(^LRO(69,LR69ODT,1,LR69SP,2,LROTST))  Q:LROTST<1  D
 ... S IENS=LROTST_","_LR69SP_","_LR69ODT
 ... S F60DESC=$$GET1^DIQ(69.03,IENS,"TEST/PROCEDURE")
 ... S PROVNARR=$$GET1^DIQ(69.03,IENS,"PROVIDER NARRATIVE")
 ... S LRSNOMED=$$GET1^DIQ(69.03,IENS,"SNOMED")
 ... Q:$L(PROVNARR)<1&($L(LRSNOMED)<1)
 ... ;
 ... S FOUNDIT=FOUNDIT+1
 ... S CNT=CNT+1
 ... S ORDTEST(CNT)=LROTST_","_LR69SP_","_LR69ODT
 ... S DIRZERO=DIRZERO_CNT_":"_CNT_";"
 ... K STR
 ... S STR=$J(CNT,2)
 ... S $E(STR,5)=$E(F60DESC,1,18)
 ... S $E(STR,25)=LRSNOMED
 ... ; S $E(STR,41)=$E(PROVNARR,1,40)
 ... ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 ... S $E(STR,40)=$E(PROVNARR,1,31)
 ... S ICDCODE=$$GET1^DIQ(69.05,"1,"_IENS,.01)
 ... S:$L(ICDCODE) $E(STR,73)=ICDCODE
 ... ; ----- END IHS/MSC/MKK - LR*5.2*1035
 ... S DIRZERO(CNT)=STR
 ;
 Q:FOUNDIT<1 0  ; Skip -- No Data found on any of the other tests
 ;
 S CNT=CNT+1
 S DIRZERO=DIRZERO_(CNT)_":NA"
 S LASTCNT=CNT
 ;
 D ^XBFMK
 S DIR(0)=DIRZERO
 ; S DIR("L",1)="    TEST                SNOMED          PROVIDER NARRATIVE"
 ; S DIR("L",2)="    ------------------  -------------   ----------------------------------------"
 ; ----- BEGIN IHS/MSC/MKK LR*5.2*1035
 ;             12345678901234567890123456789012345678901234567890123456789012345678901234567890
 S DIR("L",1)="    TEST                SNOMED         PROVIDER NARRATIVE               ICD"
 S DIR("L",2)="    ------------------  -------------  -------------------------------  --------"
 ; ----- END IHS/MSC/MKK LR*5.2*1035
 S (CNT,MENUCNT)=0
 F  S CNT=$O(DIRZERO(CNT))  Q:CNT<1  D
 . S DIR("L",CNT+2)=$G(DIRZERO(CNT))
 . S MENUCNT=CNT
 S MENUCNT=MENUCNT+1
 S DIR("L",MENUCNT+2)=" "
 S MENUCNT=MENUCNT+1
 K STR
 S STR=$J(LASTCNT,2)
 S $E(STR,5)="None of the Above"
 S DIR("L",MENUCNT+2)=STR
 ;
 S DIR("L")=""
 S DIR("A")="Select number"    ; Change default prompt
 ;
 S ADDTSTPN=$$GET1^DIQ(60,LRTST,"PRINT NAME")
 S HEADER(1)="Lab Order Entry (#69)"
 S HEADER(2)="Adding Test "_ADDTSTPN_" ["_LRTST_"] to Order # "_ORDERN
 S HEADER(3)=$$CJ^XLFSTR("Selecting SNOMED",IOM)
 ;
 D HEADERDT^BLRGMENU
 ;
 D ^DIR
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 I +$G(ORDTEST(+Y))<1 D  Q 0
 . W !!,?4,"No/Invalid/Quit Entry."
 . D PRESSKEY^BLRGMENU(9)
 ; ----- END IHS/MSC/MKK - LR*5.2*1035
 ;
 I Y=LASTCNT D  Q 0
 . W !!,?4,"'None of the Above' Selected.  Terminology Server will be called."
 . D PRESSKEY^BLRGMENU(9)
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 ; Moved this code above
 ; I +$G(ORDTEST(Y))<1 D  Q 0
 ; . W !!,?4,"No/Invalid/Quit Entry."
 ; . D PRESSKEY^BLRGMENU(9)
 ; ----- END IHS/MSC/MKK - LR*5.2*1035
 ;
 S IENS=$G(ORDTEST(Y))
 ;
 S ORIGPN=$$GET1^DIQ(69.03,IENS,"PROVIDER NARRATIVE")
 S ORIGSN=$$GET1^DIQ(69.03,IENS,"SNOMED")
 S ORIGICDP=$$GET1^DIQ(69.05,"1,"_IENS,"ICD CODES")
 ;
 Q:$L(ORIGPN)<1!($L(ORIGSN)<1) 0    ; If no data to copy, quit
 ;
 S LRNEWTST=+$O(^LRO(69,LRODT,1,LRSP,2,"B",LRTST,0))
 S IENS=LRNEWTST_","_LRSP_","_LRODT_","
 ;
 S FDA(69.03,IENS,9999999.1)=ORIGPN
 S FDA(69.03,IENS,9999999.2)=ORIGSN
 S:$L(ORIGICDP) FDA(69.05,"?+1,"_IENS,.01)=ORIGICDP
 D UPDATE^DIE("EKS","FDA",,"ERRS")
 ;
 I $D(ERRS) D  Q 0
 . W !!,?4,"Error trying to add data.  See MailMan message."
 . D PRESSKEY^BLRGMENU(9)
 . ; D ERRMSG^BLRSGNSP("ADDTLRAS: UPDATE^DIE","BLRSGNSU")
 . D ERRMSG^BLRSGNS3("ADDTLRAS: UPDATE^DIE","BLRSGNSU")    ; IHS/MSC/MKK - LR*5.2*1035
 ;
 S ADDTESTN=$$GET1^DIQ(60,LRTST,"NAME")
 W !!,?4,"SNOMED ",ORIGSN," data added to test "_ADDTESTN_" ["_LRTST_"]."
 D PRESSKEY^BLRGMENU(9)
 ;
 Q 1  ; Successfully added entry
 ;
 ; Subroutines moved from BLRSGNSY to here because BLRSGNSY became too large
CHKITOUT(DFN,LRODT) ; EP - User MUST select a diagnosis from list
 Q:$$CHKPLIST(DFN,LRODT)<1 $$TEXTPOVI(DFN,LRODT) ; Check Problem List.  If zero, use TEXTPOVI function
 ;
 NEW (DFN,DEBUG,DILOCKTM,DISYS,DT,DTIME,DUZ,HRCN,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRODT,PNM,U,XPARSYS,XQXFLG)
 ;
 Q $$GETSNOPN(DFN,LRODT)     ; Use SNOMED codes & Provider Narrative
 ;
CHKPLIST(DFN,LRODT) ; EP - Check Problem List.
 NEW APISTR,ONLYONE,PROBICD,PROBCNT,PROBIEN,PSTATUS
 ;
 S PROBCNT=0,PROBICD="",PROBIEN="AAA"
 F  S PROBIEN=$O(^AUPNPROB("AC",DFN,PROBIEN),-1)  Q:PROBIEN<1  D
 . S CONCID=$$GET1^DIQ(9000011,PROBIEN,"SNOMED CT CONCEPT CODE","I")
 . Q:CONCID<1
 . ;
 . S PSTATUS=$$GET1^DIQ(9000011,PROBIEN,"STATUS","I")
 . Q:PSTATUS="I"!(PSTATUS="D")    ; If problem's status is INACTIVE or DELETED, skip
 . ;
 . S $P(CONCID,"^",3)=LRODT            ; Make sure current codes as of Order's date are returned
 . ; S APISTR=$$CONC^BSTSAPI(CONCID)     ; Return Data from Terminology Server
 . S APISTR=$$CONC^BSTSAPI(CONCID_"^^^1")                  ; Search for Data from Terminology Server's local cache first -- LR*5.2*1034
 . S:$L($TR(APISTR,"^"))<1 APISTR=$$CONC^BSTSAPI(CONCID)   ; If no local cache data, return Data from Terminology Server -- LR*5.2*1034
 . S PROBICD=$P($P(APISTR,"^",5),";")
 . ; Q:$E(PROBICD)="Z"                   ; Skip if ICD code begins with "Z"
 . ; Q:PROBICD=799.9                     ; Skip if ICD code is a place holder
 . ; Q:PROBICD=.9999                     ; Skip if ICD code is invalid
 . ;
 . S PROBCNT=PROBCNT+1
 ;
 Q PROBCNT
 ;
 ; The following code reads the patient's entries in the PROBLEM file, uses the SNOMED Code
 ; and creates the necessary string for ListMan.
GETSNOPN(DFN,LRODT) ; EP - SNOMED Selections
 NEW APISTR,ENTERDT,ICDCODE,ICDDESC,ICDPROB,ICDSTR,IEN,IN,LASTMODD,PROBICD,PROBCNT,PROBIEN,PROBLEMS,SNOMED,SNOMEDSC,VARS,VARSDESC
 ;
 S PROBIEN="AAA",OUT="VARSDESC",CNT=0
 F  S PROBIEN=$O(^AUPNPROB("AC",DFN,PROBIEN),-1)  Q:PROBIEN<1  D
 . S CONCID=$$GET1^DIQ(9000011,PROBIEN,"SNOMED CT CONCEPT CODE","I")
 . Q:CONCID<1
 . ;
 . S PSTATUS=$$GET1^DIQ(9000011,PROBIEN,"STATUS","I")
 . Q:PSTATUS="I"!(PSTATUS="D")    ; If problem's status is INACTIVE or DELETED, skip
 . ;
 . S $P(CONCID,"^",3)=LRODT            ; Make sure current codes as of Order's date are returned
 . ; S APISTR=$$CONC^BSTSAPI(CONCID)     ; Return Data from Terminology Server
 . S APISTR=$$CONC^BSTSAPI(CONCID_"^^^1")                  ; Search for Data from Terminology Server's local cache first -- LR*5.2*1034
 . S:$L($TR(APISTR,"^"))<1 APISTR=$$CONC^BSTSAPI(CONCID)   ; If no local cache data, return Data from Terminology Server -- LR*5.2*1034
 . S ICDCODE=$P($P(APISTR,"^",5),";")
 . ; Q:$E(ICDCODE)="Z"                   ; Skip if ICD code begins with "Z"
 . ; Q:ICDCODE=799.9                     ; Skip if ICD code is a place holder
 . ; Q:ICDCODE=.9999                     ; Skip if ICD code is invalid
 . ;
 . S SNOMED=$P(APISTR,"^",3)
 . S SNOMEDSC=$P(APISTR,"^",4)
 . ;
 . S CNT=CNT+1
 . S VARS(CNT,"PRB","DSC")=SNOMED
 . S VARS(CNT,"PRB","TRM")=SNOMEDSC
 . S VARS(CNT,"ICD",1,"COD")=ICDCODE
 ;
 ; S ^TMP("BLR SNOMED GET",$J,"HDR")="You MUST Select an appropriate SNOMED code from the Patient's Problem List."
 S ^TMP("BLR SNOMED GET",$J,"HDR")="Select an appropriate SNOMED code from the Patient's "_CNT_" Problems."  ; IHS/MSC/MKK - LR*5.2*1035
 Q $$LISTMSEL^BLRSGNSY()
 ;
TEXTPOVI(DFN,LRODT) ; EP - No Entries in PROBLEM file; use Text & BSTS Database
 NEW (DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,HRCN,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRODT,PNM,U,XPARSYS,XQXFLG)
 ;
 I +$G(DFN) D  ; Do "banner" like notice to user
 . W !!,?4,$TR($J("",67)," ","*"),!
 . W ?4,"** Patient has no entries in the PROBLEM File with SNOMED codes. **",!
 . W ?4,$TR($J("",67)," ","*"),!!
 ;
 D GETDIAG(LRODT)
 Q:+$G(BAILOUT) "BAILOUT"
 ;
 S ^TMP("BLR SNOMED GET",$J,"HDR")="You MUST Select an appropriate SNOMED code."
 Q $$LISTMSEL^BLRSGNSY()
 ;
GETDIAG(LRODT) ; EP - Get a diagnosis.
 NEW ONETEST
 ;
 S ONETEST=+$G(^TMP("BLRDIAG",$J,"ORDER","ADDTST"))
 ;
 S (BAILOUT,Y)=0
 F  Q:Y!(BAILOUT)  D
 . W !!
 . D PROVNARR^BLRSGNSY
 . D ^XBFMK
 . S DIR(0)="F"
 . S DIR("A")="Enter Clinical Indication (Free Text)"
 . S DIR("T")=1800      ; IHS/MSC/MKK - LR*5.2*1035 - Wait 30 Minutes
 . D ^DIR
 . I $G(X)="^^^^^"  S Y=99999999  Q    ; Trick to exit
 . ;
 . I $L(X)<1 D  Q
 .. W !!,?4,"Invalid.  Must Enter a Clinical Indication.",!
 .. D PRESSKEY^BLRGMENU(9)
 .. S Y=0
 . I +$G(DUOUT) D  Q
 .. D ^XBFMK
 .. S DIR(0)="Y"
 .. ; S DIR("A")="Delete Order (Y/N)"
 .. S DIR("A")="Delete "_$S(ONETEST:"Test",1:"Order")_" (Y/N)"
 .. S DIR("B")="NO"
 .. S DIR("T")=1800      ; IHS/MSC/MKK - LR*5.2*1035 - Wait 30 Minutes
 .. D ^DIR
 .. I Y=1 S BAILOUT=1,Y=0
 .. E  S Y=0
 . K OUT
 . S OUT="VARS",IN=$G(X)_"^S"
 . S $P(IN,"^",5)=LRODT      ; Make certain current codes returned
 . S $P(IN,"^",6)=200,$P(IN,"^",8)=1
 . S Y=$$SEARCH^BSTSAPI(OUT,IN)
 . D ADDICD9
 . I Y<1 W !!,?9,"No entries found in the IHS STANDARD TERMINOLOGY database.  Try Again."
 ;
 D:BAILOUT GETRID^BLRSGNSP($G(^TMP("BLRDIAG",$J,"ORDER")))
 S:Y=99999999 BAILOUT=1
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 S VARSCNT=$O(VARS("A"),-1)
 S ^TMP("BLR SNOMED GET",$J,"HDR")="Select an appropriate SNOMED code from the "_VARSCNT_" retrieved."
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 ;
 Q
 ;
ADDICD9 ; EP - Adds ICD9 codes to VARS array
 Q  ; IHS/MSC/MKK - LR*5.2*1035 -- Do *NOT* add the ICD9 codes
 ;
 NEW WOT,ICD10DT,ICD10PTR,TODAY
 ;
 S ICD10PTR=+$$FIND1^DIC(80.4,,,"ICD-10-CM")
 S ICD10DT=+$P($$GET1^DIQ(80.4,ICD10PTR,"IMPLEMENTATION DATE","I"),".")
 S:ICD10DT<1 ICD10DT=3151001   ; If no ICD10DT, hard set to 10/1/2015.
 S TODAY=$$DT^XLFDT
 ;
 ; Q:TODAY'<ICD10DT       ; Skip if after ICD-10 "start date" - IHS/MSC/MKK - LR*5.2*1034
 ;
 S WOT=0
 F  S WOT=$O(VARS(WOT))  Q:WOT<1  D
 . Q:$D(VARS(WOT,"ICD"))  ; If ICD code, just return
 . ;
 . S VARS(WOT,"ICD",1,"COD")=$S(TODAY<ICD10DT:".9999",1:"ZZZ.999")
 . S VARS(WOT,"ICD",1,"TYP")=$S(TODAY<ICD10DT:"ICD",1:"10D")
 ;
 Q
