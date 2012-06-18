BLRAAORU ;IHS/OIT/MKK - IHS LAB ASK-AT-ORDER UTILITIES ; JUL 06, 2011 3:15 PM
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
 ;
 Q
 ;
UPDTCOML(LRDFN,LRIDT,LRODT,LRSP) ; EP - Update the Comment line(s)
 NEW ANSWER,ASKORDQ,DIE,ERRCNT,ERRS,FDA,IENS,ORD,P60,P60DESC,P60BORDR,QUESCNT
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("UPDTCOML^BLRAAORU 0.0")
 ;
 ; Skip if nothing stored
 Q:$D(^BLRAAOQD(LRODT,LRSP))<1
 ;
 S (ERRCNT,ORD,P60,QUESTCNT)=0
 F  S P60=$O(^BLRAAOQD(LRODT,LRSP,P60))  Q:P60<1  D
 . F  S ORD=$O(^BLRAAOQD(LRODT,LRSP,P60,ORD))  Q:ORD<1  D
 .. S ASKORDQ=$G(^BLRAAOQD(LRODT,LRSP,P60,ORD))
 .. D ADDCOMNT(ASKORDQ,.ERRCNT)
 .. S QUESTCNT=QUESTCNT+1
 ;
 ; Data has been stored & no errors: clear out data global
 K:ERRCNT<1 ^BLRAAOQD(LRODT,LRSP)
 Q
 ;
ADDCOMNT(WOT,ERRCNT) ; EP - Add the comment
 NEW RJAMT
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("ADDCOMNT^BLRAAORU 0.0")
 ;
 ; Right Justify Date/Time amount
 ; Note: The +5 is the size difference between $H & MM/DD/YYYY@HH:MM
 S RJAMT=$J("",(69-($L(WOT)+5)))
 S:$L(RJAMT)<1 RJAMT="  "           ; Failsafe - need at least 1 space
 ;
 ; Change $H to external Date/Time
 S $P(WOT,"^",3)=RJAMT_$$HTE^XLFDT($P(WOT,"^",3),"5MZ")
 ;
 S IENS(1)=$O(^LR(LRDFN,"CH",LRIDT,1,"B"),-1)+1  ; Get next COMMENT line
 S FDA(63.041,"+1,"_LRIDT_","_LRDFN_",",.01)=$TR(WOT,"^"," ")
 ;
 D UPDATE^DIE(,"FDA","IENS","ERRS")
 ;
 D:$D(ERRS("DIERR"))>0 ADDERRS(WOT,.ERRS,.ERRCNT)   ; Errors
 Q
 ;
ADDERRS(WOT,ERRS,ERRCNT) ; EP -- Add Errors.  Send Alert & Email
 NEW LRAA,LRAD,LRAN,LRAS,STR,TAB,TST
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("ADDERRS^BLRAAORU 0.0")
 ;
 S ERRCNT=ERRCNT+1
 ;
 ; Store data for report
 M ^BLRAAORE(LRDFN,LRIDT,LRODT,LRSP,P60,ORD)=ERRS
 ;
 S TST=+$O(^LRO(LRODT,1,LRSP,2,"B",P60,0))
 I TST<1 D  Q
 . K STR
 . S TAB=$J("",7)
 . S STR(1)="In ADDCOMNT^BLRAAOQD:"
 . S STR(2)=" "
 . S STR(3)=TAB_"LRDFN:"_LRDFN
 . S STR(4)=TAB_"LRIDT:"_LRIDT
 . S STR(5)=TAB_"LRODT:"_LRODT
 . S STR(6)=TAB_"LRSP:"_LRSP
 . S STR(7)=TAB_"P60:"_P60
 . S STR(8)=TAB_"ORD:"_ORD
 . S STR(9)=TAB_"WOT:"_WOT
 . D SENDMAIL^BLRUTIL3("Invalid Ask-at-Order TST",.STR,"BLRAAORU")
 . D SNDALERT^BLRUTIL3("ADDCOMNT^BLRAAOQD: Invalid Ask-at-Order TST. Email Sent.")
 ;
 S STR=$G(^LRO(LRODT,1,LRSP,2,TST,0))
 S LRAA=$P(STR,"^",5),LRAD=$P(STR,"^",4),LRAN=$P(STR,"^",6)
 S LRAS=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))
 ;
 D SNDALERT^BLRUTIL3("Invalid Ask-at-Order Update for Accession "_LRAS)
 Q
 ;
 ; The IEN of the test must be passed to the routine
ASKQUES(P60,LRODT,LRSP,ORDNUM) ; EP - Ask the question(s) for a SPECIFIC test
 NEW ANSWERS,BAILOUT,CNT,CURANS,DATANAME,DEF,DZERO,ORDER,PTR,QUESDESC,QUESORD,QUEST
 NEW READWHAT,STORQUES,STR,TYPE,UCUM,UNITS
 ;
 S DZERO=$O(^BLRAAOQ("B",+$G(P60),""))
 Q:DZERO<1                                    ; If not in Lab Ask-At-Order dictionary, skip
 ;
 I +$G(ORDNUM)>0&((+$G(LRODT)<1)!(+$G(LRSP)<1))  D GETDTSP(ORDNUM,P60,.LRODT,.LRSP)
 Q:+$G(LRODT)<1!(+$G(LRSP)<1)                 ; If LRODT or LRSP null, skip
 ;
 Q:$D(^BLRAAOQD(LRODT,LRSP,P60))              ; If Question already asked, skip
 ;
 S (CNT,BAILOUT,QUESORD)=0
 ;
 F  S QUESORD=$O(^BLRAAOQ(DZERO,1,QUESORD))  Q:QUESORD<1!(BAILOUT)  D
 . D QUESASK(.ANSWERS,DZERO,QUESORD,.CNT,P60)
 ;
 D CORRAANS(.ANSWERS)
 ;
 D STOREANS(P60,.ANSWERS,LRODT,LRSP)
 ;
 Q
 ;
QUESASK(ANSWERS,DZERO,QUESORD,CNT,P60)   ; EP - Single Question
 S STR=$G(^BLRAAOQ(DZERO,1,QUESORD,0))
 S (STORQUES,QUEST)=$P(STR,"^",1)           ; Question
 S:STORQUES'["?" STORQUES=STORQUES_"?"      ; Make sure Question ends with a question mark
 S TYPE=$P(STR,"^",2)                       ; Type of Question
 S DEF=$P(STR,"^",3)                        ; Default value, if any
 S PTR=+$P(STR,"^",4)                       ; Pointer to Dictionary
 S UCUM=+$P(STR,"^",5)                      ; Pointer to IHS UCUM (#90475.3) file
 S UNITS=$$GET1^DIQ(90475.3,UCUM_",",3)     ; UCUM Print String
 ;
 S READWHAT=$S($L(TYPE):TYPE,1:"F")_"AO"    ; Type of Answer -- null implies free text
 S:PTR>0 READWHAT=READWHAT_"^"_PTR          ; If & only if PTR exists
 S:TYPE="N" READWHAT=READWHAT_"^::2"        ; If numeric, allow up to 2 decimals
 ;
 ; Reset Question string
 S:$L(UNITS) QUEST=$P(QUEST,"?")_" ("_UNITS_")?"
 ;
 ; Display notice first time through
 D:CNT<1 ASKNOTCE^BLRAAORU(P60)
 ;
 S CNT=CNT+1
 D ^XBFMK
 S DIR(0)=READWHAT
 S DIR("A")=QUEST_" "
 S:$L(DEF) DIR("B")=$G(DEF)
 D ^DIR
 ;
 S CURANS=""
 I $L(Y)>0 D
 . S:TYPE="D" X=$$FMTE^XLFDT(Y,"5DZ")              ; Store date as MM/DD/YYYY
 . S CURANS=$S(PTR<1:$G(X),1:$P($G(Y),"^",2))      ; Store text.  If pointer, store text, not IEN
 . S:$L(UNITS)>0 CURANS=CURANS_" ("_UNITS_")"      ; If there are units, store next to answer
 . I READWHAT'["YES/NO"  D                         ; If YES/NO type of question, do the following
 .. S:$G(CURANS)="Y" CURANS="YES"                  ; If Y for yes, then store YES
 .. S:$G(CURANS)="N" CURANS="NO"                   ; If N for no, then store NO
 ;
 ; Store ALL answers, even if NULL
 S ANSWERS(QUESORD)=STORQUES_"^"_CURANS_"^"_$H   ; Store Date/Time of answer
 Q
 ;
CORRAANS(ANSARRAY) ; EP - Determine if any changes are needed to answers
 NEW ALLOKAY
 ;
 S ALLOKAY=0
 F  Q:ALLOKAY  D
 . D SHOWANSA(.ANSARRAY,.HOWMANY)
 . D ^XBFMK
 . S DIR(0)="NO^1:"_HOWMANY
 . S DIR("B")=HOWMANY
 . D ^DIR
 . I +$G(Y)=HOWMANY!(+$G(Y)<1) S ALLOKAY=1  Q
 . ;
 . W !!
 . D QUESASK(.ANSARRAY,DZERO,+$G(Y),2,P60)
 Q
 ;
SHOWANSA(ANSARRAY,HOWMANY) ; EP - Display ANSWERS Array
 W !!!,?9,"Correct which Lab Ask-At-Order Answer?",!!
 W " #",?4,"Question",?66,"Answer",!
 W ?4,$TR($J("",60)," ","-"),?66,$TR($J("",14)," ","-"),!
 S QUESORD=0
 F  S QUESORD=$O(ANSARRAY(QUESORD))  Q:QUESORD<1  D
 . S STR=$G(ANSARRAY(QUESORD))
 . W $J(QUESORD,2),")",?4,$E($P(STR,"^"),1,60),?66,$E($P(STR,"^",2),1,14),!
 . S HOWMANY=QUESORD
 S HOWMANY=HOWMANY+1
 W !,$J(HOWMANY,2),")",?4,"None.  All Answers are correct.",!
 W !!
 Q
 ;
GETDTSP(ORDNUM,P60,LRODT,LRSP) ; EP -- Have Order # & Test: Need LRODT & LRSP
 NEW PTR,FOUNDIT,TEST
 ;
 S LRODT="",FOUNDIT=0
 F  S LRODT=$O(^LRO(69,"C",ORDNUM,LRODT))  Q:LRODT<1!(FOUNDIT)  D
 . S LRSP=.9999999
 . S LRSP=$O(^LRO(69,"C",ORDNUM,LRODT,LRSP))  Q:LRSP<1!(FOUNDIT)  D
 .. S TEST=.9999999
 .. F  S TEST=$O(^LRO(69,LRODT,1,LRSP,2,TEST))  Q:TEST<1!(FOUNDIT)  D
 ... I +$G(^LRO(69,LRODT,1,LRSP,2,TEST,0))=P60  S FOUNDIT("LRODT")=LRODT,FOUNDIT("LRSP")=LRSP,FOUNDIT=1  Q
 ;
 S:FOUNDIT LRODT=$G(FOUNDIT("LRODT")),LRSP=$G(FOUNDIT("LRSP"))
 Q
 ;
ASKNOTCE(P60)  ; EP - Notice that the test has been tagged as an ASK-AT-ORDER test
 W !!,"NOTICE:",!
 W ?4,"The test ",!
 W ?9,$P($G(^LAB(60,P60,0)),"^")," [",P60,"]",!
 W ?4,"has been designated a Lab Ask-At-Order test and, as such,",!
 W ?4,"has questions that should be answered at ordering.",!!
 W ?4,"Please  note that if you press the RETURN key, a null",!
 W ?4,"answer is stored.",!!
 Q
 ;
 ; Have to use Order Date & Number to keep unique
STOREANS(P60,ANSWERS,LRODT,LRSP) ; EP - Store Answers into AAO data file
 NEW CNT,ORD
 K ^BLRAAOQD(LRODT,LRSP)
 ;
 S ^BLRAAOQD(LRODT,LRSP,P60,1)="The following Lab ASK AT ORDER Questions"
 S ^BLRAAOQD(LRODT,LRSP,P60,2)="Answered by "_$P($G(^VA(200,DUZ,0)),"^")_" ("_DUZ_"):"
 ;
 S ORD=0,CNT=2
 F  S ORD=$O(ANSWERS(ORD))  Q:ORD<1  D
 . S CNT=CNT+1
 . S ^BLRAAOQD(LRODT,LRSP,P60,CNT)=$J("",3)_$G(ANSWERS(ORD))
 Q
 ;
LISTCOML(LRDFN,LRIDT) ; EP - List Comments from Lab Data File
 W !!,"Value in ^LR(",LRDFN,",",$C(34),"CH",$C(34),",",LRIDT,"):",!
 S COMMENT=.9999999
 F  S COMMENT=$O(^LR(LRDFN,"CH",LRIDT,1,COMMENT))  Q:COMMENT<1  D
 . W ?2,COMMENT,?4,$E($G(^LR(LRDFN,"CH",LRIDT,1,COMMENT,0)),1,77),!
 Q
 ;
LISTCOMA(LRAS) ; EP - List Comments from Lab Data File given Accession Number
 NEW LRAA,LRAD,LRAN,LRDFN,LRIDT
 ;
 D GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)
 I LRAA<1!(LRAD<1)!(LRAN<1) D  Q
 . W !,"Invalid Accession Number.",!
 . D PRESSKEY^BLRGMENU(4)
 ;
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 S LRIDT=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5)
 I LRDFN<1!(LRIDT<1) D  Q
 . W !,"Could not determine LRDFN and/or LRIDT.",!
 . D PRESSKEY^BLRGMENU(4)
 ;
 W !!,"Value in ^LR(",LRDFN,",",$C(34),"CH",$C(34),",",LRIDT,"):",!
 S COMMENT=.9999999
 F  S COMMENT=$O(^LR(LRDFN,"CH",LRIDT,1,COMMENT))  Q:COMMENT<1  D
 . W ?2,COMMENT,?4,$E($G(^LR(LRDFN,"CH",LRIDT,1,COMMENT,0)),1,77),!
 Q
 ;
ASKATORD(LRORD) ; EP - If have Order Number, Lab Ask-At-Order Questions
 NEW LRODT,LRSP,TSTORD,PTR
 ;
 Q:+$G(LRORD)<1           ; Failsafe
 ;
 S LRODT=.9999999
 F  S LRODT=$O(^LRO(69,"C",LRORD,LRODT))  Q:LRODT<1  D
 . S LRSP=.9999999
 . F  S LRSP=$O(^LRO(69,"C",LRORD,LRODT,LRSP))  Q:LRSP<1  D
 .. S TST=.9999999
 .. F  S TST=$O(^LRO(69,LRODT,1,LRSP,2,TST))  Q:TST<1  D
 ... S PTR=+$G(^LRO(69,LRODT,1,LRSP,2,TST,0))
 ... D:PTR>0 ASKQUES^BLRAAORU(PTR,LRODT,LRSP,LRORD)
 ;
 Q
 ;
ERRSPURG ; EP - Purge Errors Global
 NEW HEADER,LINES,MAXLINES,PG,QFLG,STR
 D ERRSPURI
 D HEADERDT^BLRGMENU
 ;
 Q:$$ERRPURYN("Do you want to purge the Lab Ask At Order Error (LAAOE) File")<1
 ;
 D HEADERDT^BLRGMENU
 Q:$$ERRPURYN("Are you CERTAIN you want to purge the LAAOE File")<1
 ;
 D HEADERDT^BLRGMENU
 Q:$$ERRPURYN("LAST CHANCE: Are you really certain you want to purge the LAAOE File")<1
 ;
 D HEADERDT^BLRGMENU
 W !!,"Very Well.  LAAOE File Purged.",!!
 ;
 S STR="^BLRAAORE"
 K @STR
 ;
 D PRESSKEY^BLRGMENU(4)
 ;
 Q
 ;
ERRSPURI ; EP -- Initialize variables
 S HEADER(1)="Lab Ask At Order Questions"
 S HEADER(2)="Purge Errors File"
 ;
 S MAXLINES=22,LINES=MAXLINES+10,PG=0,QFLG="NO"
 Q
 ;
ERRPURYN(QUES) ; EP -- Questions
 NEW RESPONSE
 ;
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")=$J("",4)_QUES
 D ^DIR
 S RESPONSE=+$G(Y)
 I +$G(Y)<1 D
 . W !!!,?9,"Quit/No/Invalid response. Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 Q RESPONSE
 ;
TASKPURG ; EP -- Tasked entry point for purging the ^BLRAAORE file.
 NEW STR
 ;
 S STR="^BLRAAORE"
 K @STR
 ;
 S STR(1)="Lab Ask-at-Order File (^BLRAAORE) has been purged."
 S STR(2)=" "
 S STR(3)=$J("",10)_"DATE:"_$$HTE^XLFDT($H,"5DZ")
 S STR(4)=$J("",10)_"TIME:"_$P($$HTE^XLFDT($H,"5MZ"),"@",2)
 ;
 D SENDMAIL^BLRUTIL3("Lab Ask-at-Order Task",.STR,"BLRAAORE","NO")
 Q
 ;
ORDNSTOR(LRORD) ; EP -- Store Ask at Order questions given Lab Order Number
 NEW LRAA,LRAD,LRAN,LRAS,LRIDT,LRODT,LRSP,PTR,STR,TST
 ;
 S LRODT=.9999999
 F  S LRODT=$O(^LRO(69,"C",LRORD,LRODT))  Q:LRODT<1  D
 . S LRSP=.9999999
 . F  S LRSP=$O(^LRO(69,"C",LRORD,LRODT,LRSP))  Q:LRSP<1  D
 .. Q:$D(^BLRAAOQD(LRODT,LRSP))<10       ; Can be called inappropriately due to LAB calling routines
 .. S TST=.999999
 .. F  S TST=$O(^LRO(69,LRODT,1,LRSP,2,TST))  Q:TST<1  D
 ... S STR=$G(^LRO(69,LRODT,1,LRSP,2,TST,0))
 ... S LRAD=+$P(STR,"^",3),LRAA=+$P(STR,"^",4),LRAN=+$P(STR,"^",5)
 ... S LRAS=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))
 ... Q:$L(LRAS)<1
 ... ;
 ... S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 ... S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5)
 ... D UPDTCOML(LRDFN,LRIDT,LRODT,LRSP)
 ;
 Q
 ;
UPDTAAOQ ; EP - Try to update the Lab Data file with entries in the BLRAAORD file
 NEW CNT,LRODT,LRSP,P60,LRORD
 ;
 S CNT=0
 S (LRODT,LRSP,P60,LRORD)=.9999999
 F  S LRODT=$O(^BLRAAOQD(LRODT))  Q:LRODT<1  D
 . F  S LRSP=$O(^BLRAAOQD(LRODT,LRSP))  Q:LRSP<1  D
 .. F  S P60=$O(^BLRAAOQD(LRODT,LRSP,P60))  Q:P60<1  D
 ... F  S LRORD=$O(^BLRAAOQD(LRODT,LRSP,P60,LRORD))  Q:LRORD<1  D
 .... D ORDNSTOR(LRORD)
 .... S CNT=CNT+1
 ;
 W "CNT:",CNT,!
 Q
 ;
GETLRAS(LRORD) ; EP -- Get the Accession(s) tied to an Order
 NEW LRAA,LRAD,LRAN,LRAS,LRIDT,LRODT,LRSP,PTR,STR,TST
 ;
 S LRODT=.9999999
 F  S LRODT=$O(^LRO(69,"C",LRORD,LRODT))  Q:LRODT<1  D
 . S LRSP=.9999999
 . F  S LRSP=$O(^LRO(69,"C",LRORD,LRODT,LRSP))  Q:LRSP<1  D
 .. S TST=.999999
 .. F  S TST=$O(^LRO(69,LRODT,1,LRSP,2,TST))  Q:TST<1  D
 ... S STR=$G(^LRO(69,LRODT,1,LRSP,2,TST,0))
 ... S LRAD=+$P(STR,"^",3),LRAA=+$P(STR,"^",4),LRAN=+$P(STR,"^",5)
 ... S LRAS=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2))
 ... S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 ... S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5)
 ... W LRORD
 ... W ?9,$S(LRAA>0:LRAA,1:"")
 ... W ?14,$S(LRAD>0:LRAD,1:"")
 ... W ?24,$S(LRAN>0:LRAN,1:"")
 ... W ?34,$S($G(LRAN)'="":LRAS,1:"")
 ... W ?54,LRDFN
 ... W ?64,LRIDT
 ... W !
 Q
