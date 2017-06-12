BLRSGNSD ; IHS/OIT/MKK - IHS Lab SiGN or Symptom Debug ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034**;NOV 1, 1997;Build 88
 ;
 ; This routine created to debug the BLRSGNSY routine.
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
PEP ; EP
EP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 D ADDTMENU^BLRGMENU("DISPPRBL^BLRSGNSD","Select Patient & Then Select 'Clinical Indication' from List")
 D ADDTMENU^BLRGMENU("FINDSOME^BLRSGNSD","Find Patients With Problem List & Lab Orders")
 D ADDTMENU^BLRGMENU("FINDNOLA^BLRSGNSD","Find Patients With Problem List & No Lab Orders")
 D ADDTMENU^BLRGMENU("FINDNONE^BLRSGNSD","Find Patients With Lab orders But No Problem File Entries")
 D ADDTMENU^BLRGMENU("SHOAPROB^BLRSGNSD","Select Patient and Display ALL entries in Problem File")
 D ADDTMENU^BLRGMENU("RESETOFD^BLRSGNS2","Reset SNOMED/Descrip in File 69 Given Order #")
 D ADDTMENU^BLRGMENU("NEWPROBS^BLRSGNS2","List the Latest Entries in the Problem file")
 D ADDTMENU^BLRGMENU("JUSTVALS^BLRSGNS2","Test the Terminology Server")
 D ADDTMENU^BLRGMENU("JUSTICDS^BLRSGNS2","Test the Terminology Server - Valid ICD Only")
 D ADDTMENU^BLRGMENU("ERRMSGRP^BLRSGNS2","Report on ERRMSG^BLRSGNP Messages")
 ;
 ; Main Menu driver
 D MENUDRFM^BLRGMENU("RPMS Lab Meaningful Use Stage 2","Clnical Indication Debug Routines")
 Q
 ;
DISPPRBL ; EP - Enter Patient And Display Problem List
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="Select 'Clinical Indication' Debug"
 ;
 ; Get Patient
 S HEADER(3)=$$CJ^XLFSTR("Select Patient",IOM)
 D HEADERDT^BLRGMENU
 S DFN=0
 F  Q:DFN!(DFN<0)  D
 . S LRLOOKUP=1
 . K DIC,LRDPAF,%DT("B") S DIC(0)="A"
 . D ^LRDPA
 ;
 Q:DFN<0   ; Skip if no patient selected
 ;
 K HEADER(3)
 S HEADER(3)=$$CJ^XLFSTR("Patient Name:"_$P($G(^DPT(DFN,0)),"^"),IOM)
 D HEADERDT^BLRGMENU
 ;
 ; S SNOMEDS=$$CHKITOUT^BLRSGNSY(DFN)
 S SNOMEDS=$$CHKITOUT^BLRSGNSU(DFN,$$DT^XLFDT)   ; IHS/MSC/MKK - LR*5.2*1034
 ;
 W !!,?4,"SNOMED String:",SNOMEDS,!!
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
SHOWSELP() ; EP - Select Patient
 ; Select Patient
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="ALL Problems from PROBLEM (#9000011) File"
 S HEADER(3)=$$CJ^XLFSTR("Select Patient",IOM)
 ;
 S DFN=0
 F  Q:DFN!(DFN<0)  D
 . D HEADERDT^BLRGMENU
 . S LRLOOKUP=1
 . K DIC,LRDPAF,%DT("B") S DIC(0)="A"
 . D ^LRDPA
 ;
 Q:DFN<0 "Q"
 ;
 Q "OK"
 ;
SHOWPEND ; EP - Ending
 W:CNT<1 !!,?4,"No Active entries on Problem List for the patient."
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
FINDSOME ; EP - Find some patients that have a problem list AND lab orders
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D FINDSOMI
 ;
 F  S DFN=$O(^AUPNPROB("AC",DFN))  Q:DFN<1!(CNT>MAX)  D FINDSOML
 ;
 W !!,?4,DFNCNT," Patients in Problems File."
 W !!,?9,$S(DFNORDS:DFNORDS,1:"No")," Patients with Orders."
 W !!,?14,$S(CNT:CNT,1:"No")," Patients with Problems in the past year."
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
FINDSOMI ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 S LASTYEAR=+$P($$HTE^XLFDT((+$H-(365*2)),"5D"),"/",3)
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="Patients with PROBLEMS since "_LASTYEAR_" and Have ORDERS"
 ;
 D HEADERDT^BLRGMENU
 W !!,?4,"Compilation of Data"
 ;
 S HEADER(3)=" "
 S $E(HEADER(4),50)="Total",$E(HEADER(4),60)="Cur 'YR'"
 S HEADER(5)="DFN",$E(HEADER(5),10)="Patient Name"
 S $E(HEADER(5),40)="LRDFN",$E(HEADER(5),50)="# Probs"
 S $E(HEADER(5),60)="# Probs",$E(HEADER(5),70)="# Ords"
 ;
 S DFN=.9999999,MAX=13
 S (CNT,DFNCNT,DFNLABS,DFNORDS)=0
 Q
 ;
FINDSOML ; EP - Line of Data
 S DFNCNT=DFNCNT+1
 I DFNCNT<1 W:(DFNCNT#1000)=0 "."  W:$X>74 !,?4
 ;
 Q:$D(^DPT(DFN,"LR"))<1      ; Skip if no Labs
 ;
 S DFNLABS=DFNLABS+1         ; Patients with Labs
 ;
 S LRDFN=+$G(^DPT(DFN,"LR"))
 Q:+$O(^LRO(69,"D",LRDFN,0))<1    ; Skip if no orders
 ;
 S DFNORDS=DFNORDS+1    ; Patients with Orders
 ; 
 S STR=$$CNTPROBS(DFN)
 Q:+STR<1               ; Skip if no problems within the past year
 ;
 D:CNT<1 HEADERDT^BLRGMENU
 ;
 W DFN
 W ?9,$P($G(^DPT(DFN,0)),"^")
 W ?39,LRDFN
 W ?49,$P(STR,"^",2)
 W ?59,$P(STR,"^")
 W ?69,$$CNTORDRS(LRDFN)
 W !
 S CNT=CNT+1
 Q
 ;
CNTPROBS(DFN) ; EP
 NEW (DFN,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LASTYEAR,U,XPARSYS,XQXFLG)
 ;
 S (NUMPROBS,NUMCPRBS)=0,PROBS="AAA"
 F  S PROBS=$O(^AUPNPROB("AC",DFN,PROBS),-1)  Q:PROBS<1  D      ; Reverse Sort
 . S STR=$G(^AUPNPROB(PROBS,0))
 . S YRENTRY=$P($$FMTE^XLFDT($P(STR,"^",8),"5D"),"/",3)
 . S:YRENTRY'<LASTYEAR NUMCPRBS=NUMCPRBS+1    ; If Entry Date >= Year Ago, count as "current"
 . S NUMPROBS=NUMPROBS+1
 ;
 Q NUMCPRBS_"^"_NUMPROBS
 ;
CNTORDRS(LRDFN) ; EP 
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRDFN,U,XPARSYS,XQXFLG)
 ;
 S LRODT=.9999999,CNTORDS=0
 F  S LRODT=$O(^LRO(69,"D",LRDFN,LRODT))  Q:LRODT<1  D
 . S LROT=.9999999
 . F  S LROT=$O(^LRO(69,"D",LRDFN,LRODT,LROT))  Q:LROT<1  S CNTORDS=CNTORDS+1
 ;
 Q CNTORDS
 ;
FINDNONE ; EP - Find some patients that DO have lab orders but DO NOT have an entry in the Problem file.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D FINDNONI
 ;
 F  S LRODT=$O(^LRO(69,LRODT),-1)  Q:LRODT<1!(CNT>MAX)  D
 . S LRSN="A"
 . F  S LRSN=$O(^LRO(69,LRODT,1,LRSN),-1)  Q:LRSN<1!(CNT>MAX)  D
 .. S LRDFN=+$G(^LRO(69,LRODT,1,LRSN,0))
 .. S DFN=+$P($G(^LR(LRDFN,0)),"^",3)
 .. Q:$D(STORDFN(DFN))                   ; Skip if patient aready accounted for
 .. ;
 .. S STORDFN(DFN)=LRDFN
 .. Q:$D(^AUPNPROB("AC",DFN))            ; Skip if entry exists in 9000011
 .. ;
 .. S CNT=CNT+1
 .. S NOPROB(DFN)=LRDFN
 ;
 S DFN=0,CNT=0
 F  S DFN=$O(NOPROB(DFN))  Q:DFN<1!(QFLG="Q")  D
 . S LRDFN=$G(NOPROB(DFN))
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,"NO")  Q:QFLG="Q"
 . W DFN,?9,$$GET1^DIQ(2,DFN,"NAME"),?39,LRDFN,!  S LINES=LINES+1
 ;
 W !!
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
FINDNONI ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 S BLRVERN2="FINDNONE"
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="Patients with ORDERS"
 S HEADER(3)=$$CJ^XLFSTR("But NO Problem (#9000011) File Entries",IOM)
 S HEADER(4)=" "
 S HEADER(5)="DFN",$E(HEADER(5),10)="Patient Name",$E(HEADER(5),40)="LRDFN"
 ;
 S LRODT=$$HTFM^XLFDT(+$H+1),CNT=0,MAX=18
 S PG=0,MAXLINES=IOSL-4,LINES=MAXLINES+10,QFLG="NO"
 Q
 ;
SHOAPROB ; EP - Select Patient and Display ALL entries in Problem File
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q:$$SHOAPRBI()="Q"
 ;
 F  S IEN=$O(^AUPNPROB("AC",DFN,IEN))  Q:IEN<1!(QFLG="Q")  D SHOAPRBL
 ;
 D:QFLG'="Q" PRESSKEY^BLRGMENU(9)
 Q
 ;
SHOAPRBI() ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="Select 'Clinical Indication' Debug"
 ;
 ; Get Patient
 S HEADER(3)=$$CJ^XLFSTR("Select Patient",IOM)
 D HEADERDT^BLRGMENU
 S DFN=0
 F  Q:DFN!(DFN<0)  D
 . S LRLOOKUP=1
 . K DIC,LRDPAF,%DT("B") S DIC(0)="A"
 . D ^LRDPA
 ;
 Q:DFN<0 "Q"   ; Skip if no patient selected
 ;
 K HEADER(3)
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 ;
 S HEADER(3)=$$CJ^XLFSTR("Patient Name:"_$P($G(^DPT(DFN,0)),"^"),IOM)
 S HEADER(4)=$$CJ^XLFSTR("Problem File Listing",IOM)
 S HEADER(5)=" "
 S HEADER(6)="IEN",$E(HEADER(6),10)="Entry Dt",$E(HEADER(6),22)="ICD"
 S $E(HEADER(6),32)="ICD Description",$E(HEADER(6),52)="Provider Narrative"
 ;
 S LASTYEAR=+$P($$HTE^XLFDT((+$H-(365*2)),"5D"),"/",3)
 ;
 S MAXLINES=22,LINES=MAXLINES+10,(CNT,PG)=0,QFLG="NO"
 ;
 S IEN=.9999999,CNT=0
 Q "OK"
 ;
SHOAPRBL ; EP - Line of Data
 Q:$$CHKPROBV()="Q"  ; Breakout Variables.  Skip if there is an issue.
 ;
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 ;
 S CNT=CNT+1
 W IEN,?9,ENTERDT,?21,ICDCODE,?31,$E(ICDDESC,1,18)
 D LINEWRAP^BLRGMENU(51,PROVNDES,29)
 W !
 S LINES=LINES+1
 Q
 ;
FINDNOLA ; EP - Find some patients that have a problem list but NO lab orders
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 S LASTYEAR=+$P($$HTE^XLFDT((+$H-(365*2)),"5D"),"/",3)
 ;
 S HEADER(1)="RPMS Lab Meaningful Use Stage 2"
 S HEADER(2)="Patients with PROBLEMS since "_LASTYEAR_" and have No Lab ORDERS"
 ;
 D HEADERDT^BLRGMENU
 W !!,?4,"Compilation of Data"
 ;
 S HEADER(3)=" "
 S $E(HEADER(4),50)="Total"
 S $E(HEADER(4),60)="Cur 'YR'"
 S HEADER(5)="DFN"
 S $E(HEADER(5),10)="Patient Name",$E(HEADER(5),40)="LRDFN"
 S $E(HEADER(5),50)="# Probs",$E(HEADER(5),60)="# Probs"
 ; S $E(HEADER(5),70)="# Ords"
 ;
 S DFN=.9999999,CNT=0,MAX=13,DFNCNT=0
 F  S DFN=$O(^AUPNPROB("AC",DFN))  Q:DFN<1!(CNT>MAX)  D
 . ; Q:$D(^DPT(DFN,"LR"))
 . S LRDFN=+$$GET1^DIQ(2,DFN,"LABORATORY REFERENCE","I")
 . ;
 . I CNT<1 W:(DFNCNT#1000)=0 "."  W:$X>74 !,?4
 . S DFNCNT=DFNCNT+1
 . ;
 . S STR=$$CNTPROBS(DFN)
 . Q:+STR<1               ; Skip if no problems within the past year
 . ;
 . Q:$$CNTORDRS(LRDFN)    ; Skip if any orders
 . ;
 . D:CNT<1 HEADERDT^BLRGMENU
 . ;
 . W DFN
 . W ?9,$P($G(^DPT(DFN,0)),"^")
 . W ?49,$P(STR,"^",2)
 . W ?59,$P(STR,"^")
 . W !
 . S CNT=CNT+1
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
 ;
 ; Utilities follow
 ;
CHKPROBV() ; EP - Check the "Break Out" Variables from Problem List
 D BREAKOUT
 ;
 ; Q:STATUS'="A" "Q"   ; If problem's status is not active, skip
 ;
 ; Q:ICDCODE=799.99 "Q"               ; Skip generic ICD code
 ; Q:ICDCODE=.9999 "Q"                ; Skip "Uncoded" code
 ;
 Q "OK"
 ;
BREAKOUT ; EP - Breakout variables from PROBLEM file
 S STATUS=$$GET1^DIQ(9000011,IEN,"STATUS","I")
 ;
 S CONCID=$$GET1^DIQ(9000011,IEN,"SNOMED CT CONCEPT CODE","I")
 S ENTERDT=+$P($$GET1^DIQ(9000011,IEN,"DATE ENTERED","I"),".")
 S:ENTERDT $P(CONCID,"^",3)=ENTERDT    ; Make sure current codes as of Enter date are returned
 ; S APISTR=$$CONC^BSTSAPI(CONCID)       ; Return Data from Terminology Server
 S APISTR=$$CONC^BSTSAPI(CONCID_"^^^1")                    ; Search for Data from Terminology Server's local cache first -- LR*5.2*1034
 S:$L($TR(APISTR,"^"))<1 APISTR=$$CONC^BSTSAPI(CONCID)     ; If no local cache data, return Data from Terminology Server -- LR*5.2*1034
 S ICDCODE=$P($P(APISTR,"^",5),";")
 ; S ICDDESC=$P($$ICDDX^ICDCODE(ICDCODE),"^",4)
 S ICDDESC=$P($$ICDDX^ICDEX(ICDCODE),"^",4)      ; IHS/MSC/MKK - LR*5.2*1034
 ;
 S ENTERDT=$$GET1^DIQ(9000011,IEN,"DATE ENTERED","I")
 S ENTERDT=$S(ENTERDT:$$FMTE^XLFDT(ENTERDT,"5DZ"),1:" ")
 ;
 S LASTMODD=$$GET1^DIQ(9000011,IEN,"DATE LAST MODIFIED","I")
 S LASTMODD=$S(LASTMODD:$$FMTE^XLFDT(LASTMODD,"5DZ"),1:" ")
 ;
 S PROVNDES=$$GET1^DIQ(9000011,IEN,"PROVIDER NARRATIVE")
 S PROVNDES=$$TRIM^XLFSTR(PROVNDES,"L","*")      ; Get rid of leading "*"
 Q
 ;
SETHEAD(HD,COL,WOT) ; EP - Set the HEADER array
 I HD<3 S HEADER(HD)=WOT  Q
 ;
 I +$G(COL)<1 S HEADER(HD)=$$CJ^XLFSTR(WOT,IOM)  Q
 ;
 S $E(HEADER(HD),COL)=WOT
 Q
 ;
ICDCODE ; EP
 S (ICD,ICDCNT)=0
 F  S ICD=$O(^LRO(69,LRODT,1,LRSP,2,TEST,2,ICD))  Q:ICD<1  D
 . S ICDCNT=ICDCNT+1
 . S IENS=ICD_","_TEST_","_LRSP_","_LRODT
 . ; S STR=$$ICDDX^ICDCODE($$GET1^DIQ(69.05,IENS,"ICD-9 CODES","I"))
 . S STR=$$ICDDX^ICDEX($$GET1^DIQ(69.05,IENS,"ICD CODES","I"))     ; IHS/MSC/MKK - LR*5.2*1034
 . ;
 . W:ICDCNT=1 ?24,"ICD:"
 . S ICDDESC=$P(STR,"^",4)
 . W ?28,$P(STR,"^",2)  S TAB=$X+2
 . W:$L(ICDDESC)<(70-TAB) ?38,ICDDESC
 . D:$L(ICDDESC)>(70-TAB) LINEWRAP^BLRGMENU(TAB,ICDDESC,(70-TAB))
 . W !
 Q
 ;
SETBLRVS(TWO) ; EP - Set BLRVERN variable(s)
 S BLRVERN=$TR($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
