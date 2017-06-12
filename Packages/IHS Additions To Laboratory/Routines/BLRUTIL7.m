BLRUTIL7 ;IHS/MSC/MKK - MISC IHS LAB UTILITIES (Cont) ; 26-Mar-2015 06:30 ; MKK
 ;;5.2;IHS LABORATORY;**1035**;NOV 01, 1997;Build 5
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
OVERFLOW(TEST) ; EP - Send ALERT and E-MAIL to LMI Mail Group due to Max # BLR Errors in Error Trap
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,TEST,U,XPARSYS,XQXFLG)
 S MESSAGE="RPMS Lab to PCC Linker **HALTED**"
 S FROMWHOM="Lab to PCC Linker"
 S TAB=$J("",2),LINE=0
 ;
 D AROUNDIT(.MSGARRAY,.LINE,"RPMS LAB TO PCC LINKER HALTED",55)
 ;
 D ADDLINE(.MSGARRAY,.LINE)
 D ADDLINE(.MSGARRAY,.LINE,TAB_"The RPMS Lab to PCC Linker has been *HALTED* by too")
 D ADDLINE(.MSGARRAY,.LINE,TAB_"many BLR errors in the Error Trap.")
 D ADDLINE(.MSGARRAY,.LINE)
 D ADDLINE(.MSGARRAY,.LINE,TAB_"No Lab Data will be sent to PCC until this has been")
 D ADDLINE(.MSGARRAY,.LINE,TAB_"resolved.")
 ;
 ; If TEST, then just display information to the screen and Quit.
 I +$G(TEST)  D ^XBCLS  W "SUBJECT:",MESSAGE,!,"FROMWHOM:",FROMWHOM,!  D EN^DDIOL(.MSGARRAY)  W !!  Q
 ;
 ; Send ALERT and MailMan Message to LMI Mail Group.
 D MAILALMI^BLRUTIL3(MESSAGE,.MSGARRAY,FROMWHOM,1)
 Q
 ;
AROUNDIT(MSGARRAY,LINE,STR,MAX) ; EP - Create a "Box" Message in an Array
 NEW AROUND,GAPSTARS,J,MAXIT,ROWSTARS
 S MAXIT="@"
 F J=1:1:$L(STR) S MAXIT=MAXIT_$E(STR,J,J)_"@"
 S AROUND=$TR($J("",8+$L(MAXIT))," ","@")
 S MAXIT="@@!!"_$TR(MAXIT," ","@")_"!!@@"
 I $L(MAXIT)'<(MAX-4) D
 . S AROUND=$TR($J("",10+$L(STR))," ","@")
 . S MAXIT="@@!!@"_$TR(STR," ","@")_"@!!@@"
 ;
 S MAX=$G(MAX,IOM)
 S ROWSTARS=$TR($J("",MAX)," ","*")
 S GAPSTARS=$TR($$CJ^XLFSTR(AROUND,MAX)," @","* ")
 D ADDLINE(.MSGARRAY,.LINE,ROWSTARS)
 D ADDLINE(.MSGARRAY,.LINE,ROWSTARS)
 D ADDLINE(.MSGARRAY,.LINE,GAPSTARS)
 D ADDLINE(.MSGARRAY,.LINE,$TR($$CJ^XLFSTR(MAXIT,MAX)," @","* "))
 D ADDLINE(.MSGARRAY,.LINE,GAPSTARS)
 D ADDLINE(.MSGARRAY,.LINE,ROWSTARS)
 D ADDLINE(.MSGARRAY,.LINE,ROWSTARS)
 Q
 ;
ADDLINE(MSGARRAY,LINE,STR) ; EP - Add a String to a line in an ARRAY
 S STR=$G(STR,$J("",5))
 S LINE=1+$G(LINE),MSGARRAY(LINE)=STR
 Q
 ;
LONGALRT(ALRTSUBJ,NOUSER,ALERTMSG,SPECIFIC) ; EP - Alert that includes full message
 NEW (ALERTMSG,ALRTSUBJ,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,NOUSER,SPECIFIC,U,XPARSYS,XQXFLG)
 ;
 S XQAID="BLR"
 S XQAMSG=ALRTSUBJ
 M XQATEXT=ALERTMSG
 ;
 ; If the SPECIFIC variable is set, send alert to ONLY that one user
 S XQA($G(SPECIFIC,"G.LMI"))=""
 ;
 ; If User not part of LMI Mail Group, send them alert also, but
 ; If-And-Only-If the NOUSER variable is null.
 S:$G(NOUSER)=""&($$NINLMI^BLRUTIL3(DUZ)) XQA(DUZ)=""
 ;
 S X=$$SETUP1^XQALERT
 K XQA,XQAMSG
 Q:X
 ;
 NEW SUBSCRPT
 S SUBSCRPT="BLRLINKU Alert^"_+$H_"^"_$J
 S ^XTMP(SUBSCRPT,0)=$$FMADD^XLFDT($$DT^XLFDT,90)_"^"_$$DT^XLFDT_"^"_"Lab Package Alert."
 S ^XTMP(SUBSCRPT,1)="Alert was not sent."
 S ^XTMP(SUBSCRPT,2)="  Message that should have been sent follows:"
 S ^XTMP(SUBSCRPT,3)="     SUBJ:"_ALRTSUBJ
 I $L(ALERTMSG(1))<1  S ^XTMP(SUBSCRPT,4)="     MESSAGE:"_ALERTMSG,LINE=5
 I $L($G(ALERTMSG(1))) D
 . S ^XTMP(SUBSCRPT,4)="     MESSAGE:"_ALERTMSG(1)
 . S ARRAYLNE=1,LINE=4
 . F  S ARRAYLNE=$O(ALERTMSG(ARRAYLNE))  Q:ARRAYLNE<1  D
 .. S ^XTMP(SUBSCRPT,ARRAYLNE)="             "_ALERTMSG(ARRAYLNE)
 .. S LINE=LINE+1
 ;
 S ^XTMP(SUBSCRPT,LINE)="  ALERT Error Message Follows:"
 S LINE=LINE+1
 S ^XTMP(SUBSCRPT,LINE)="     "_XQALERR
 Q
 ;
 ;
OERRSTSC(ODT,SN) ; EP - Change OERR Status from PENDING to DISCOUNTINUED - ALL tests on the Order
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,ODT,SN,U,XPARSYS,XQXFLG)
 S CONTROL="OC"
 D NEW^LR7OB1(ODT,SN,CONTROL,,,1)
 Q
 ;
 ;
OERRSTSO(LRODT,LRSN,LROT) ; EP - Change OERR Status from PENDING to DISCOUNTINUED - Specific Test
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRODT,LROT,LRSN,U,XPARSYS,XQXFLG)
 S LROTIEN=LROT_","_LRSN_","_LRODT
 S ORIFN=$$GET1^DIQ(69.03,LROTIEN,6)
 Q:$L(ORIFN)<1
 ;
 S F60IEN=$$GET1^DIQ(69.03,.01,LROTIEN,"I")
 Q:$L(F60IEN)<1
 ;
 S II(F60IEN)="",LRSTATUS=1
 S CONTROL="OC"
 D NEW^LR7OB1(LRODT,LRSN,CONTROL,,.II,LRSTATUS)
 Q
 ;
FORCEIT(LABEL,ARRY1,ARRY2,ARRY3) ; EP - Force the Audting of Varibles, even if TAKE SNAPSHOTS is set to OFF
 ; Code cloned from ENTRYAUD^BLRUTIL
 ;
 D DISABLE^%NOJRN       ; Disable Journaling of ^BLRENTRY global
 ;
 N ORIGX,ORIGY,%ORIG    ; Want to see what %, X & Y variables are
 M ORIGX=X,ORIGY=Y
 M:$D(%) %ORIG=%
 NEW %
 M:$D(%ORIG) %=%ORIG
 ;
 N X,Y,NOW,ENTRYNUM,STARTTIM,NOWTIM
 S NOW=$$NOW^XLFDT
 S ENTRYNUM=$G(^BLRENTRY)+1
 S NOWTIM=$P($H,",",2)
 S $P(^BLRENTRY,U)=ENTRYNUM
 S ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL)=""
 ;
 D CAPVARS^BLRUTIL("BLRVARS","^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL)")
 ;
 I $L($G(ARRY1)) D      ; Have an array that needs to be monitored; Merge it  
 . M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL,ARRY1)=@ARRY1
 ;
 I $L($G(ARRY2)) D      ; Have another array that needs to be monitored; Merge it  
 . M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL,ARRY2)=@ARRY2
 ;
 I $L($G(ARRY3)) D      ; Have another array that needs to be monitored; Merge it  
 . M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL,ARRY3)=@ARRY3
 ;
 M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL,"DUZ")=DUZ   ; Always merge in the DUZ array
 I $D(ORIGX)>1 M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL,"ORIGX")=ORIGX
 I $D(ORIGY)>1 M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL,"ORIGY")=ORIGY
 ;
 D GETSTACK^BLRUTIL6    ; Merge in the $STACK
 ;
 D ENABLE^%NOJRN        ; Enable Journaling again
 Q
 ;
 ;
REFLABT ; EP - REFerence LAB Tests
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("REFLABT")
 ;
 S HEADER(1)="Reference Lab Tests"
 S HEADER(2)=$$GET1^DIQ(9009026,+$G(^BLRSITE(DUZ(2),"RL")),.01)
 ;
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 ;
 S HEADER(3)=" "
 F J=5,27,49  S $E(HEADER(4),J)="PrntName",$E(HEADER(4),J+10)="F60 IEN"
 ;	
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,F60CNT,PG)=0
 S QFLG="NO"
 ;
 S F60IEN=.9999999
 F  S F60IEN=$O(^LAB(60,F60IEN))  Q:F60IEN<1!(QFLG="Q")  D
 . S F60CNT=F60CNT+1
 . Q:$$REFLAB^BLRUTIL6(DUZ(2),F60IEN)<1
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"  W ?4
 . ;
 . S CNT=CNT+1
 . W $$LJ^XLFSTR($$LJ^XLFSTR($$GET1^DIQ(60,F60IEN,51),9)_"["_F60IEN_"]",22)
 . I $X>55 W !,?4  S LINES=LINES+1
 ;
 I CNT<1 D HEADERDT^BLRGMENU
 ;
 W !!,?4,F60CNT," Tests analyzed."
 W !!,?9,$S(CNT<1:"No",1:CNT)," Reference Lab Test",$$PLURAL(CNT),"."
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
BADSTUFF(MSG,TAB) ; EP - Simple Message that "ends" with "Routine Ends" string.
 S:+$G(TAB)<1 TAB=4
 W !!,?TAB,$$TRIM^XLFSTR(MSG,"LR"," "),"  Routine Ends."
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
BADSTUFQ(MSG,TAB) ; EP - Simple Message.  Calls BADSTUFF.  Quits with "Q"
 D BADSTUFF(MSG,$G(TAB))
 Q "Q"
 ;
BADSTUFN(MSG,TAB) ; EP - Simple Message.  Calls BADSTUFF.  Quits with Null string
 D BADSTUFF(MSG,$G(TAB))
 Q ""
 ;
BADSTUF2(MSG,TAB) ; EP - Simple Message.  Displays MSG string only.
 S TAB=$S($L($G(TAB)):TAB,1:4)
 W !!,?TAB,$$TRIM^XLFSTR(MSG,"LR"," ")
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
BADSTF2N(MSG,TAB) ; EP - Simple Message.  Calls BADSTUF2.  Quits with Null string
 D BADSTUF2(MSG,$G(TAB))
 Q ""
 ;
BADSTF2Q(MSG,TAB) ; EP - Simple Message.  Calls BADSTUF2.  Quits with "Q"
 D BADSTUF2(MSG,$G(TAB))
 Q "Q"
 ;
PROMPTO(MSG,TAB) ; EP - prompt only.
 S TAB=$S($L($G(TAB)):TAB,1:4)
 W !!,?TAB,MSG
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
PROMPTON(MSG,TAB) ; EP - Calls PROMPTO.  Quits with null
 D PROMPTO(MSG,$G(TAB))
 Q ""
 ;
PROMPTOQ(MSG,TAB) ; EP - Calls PROMPTO.  Quits with "Q"
 D PROMPTO(MSG,$G(TAB))
 Q "Q"
 ;
SHOUTMSG(STR,RM) ; EP - Return a string like >>>> STR <<<<
 ; RM = Right Margin (how long the string will be)
 NEW HALFLEN,J,STRLEN,TMPSTR
 ;
 S RM=$G(RM,IOM)
 ;
 S HALFLEN=(RM\2)-(($L(STR)+2)\2)
 S TMPSTR=$TR($J("",HALFLEN)," ",">")
 S TMPSTR=TMPSTR_" "_STR_" "
 S STRLEN=$L(TMPSTR)
 F J=STRLEN:1:(RM-1) S TMPSTR=TMPSTR_"<"
 Q TMPSTR
 ;
PURGALRT ; EP - Purge ALL Alerts for user
 D RECIPURG^XQALBUTL(DUZ)
 W !!,?14,"Alerts Purged for DUZ:",DUZ
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
GETUCIS(ARRAY) ; EP - Create an Array of UCIs
 NEW obj,X
 NEW CNT,UCI,MSG,MSGLINE
 ;
 S CNT=0
 SET obj=##class(%ResultSet).%New("%SYS.Namespace:List")
 D obj.Execute()
 S X=$G(obj.Data,"none")
 SET X=1
 F  Q:X=""  D
 . D obj.Next()
 . S X=$G(obj.Data("Nsp"))
 . Q:X=""
 . ;
 . S UCI=X
 . ;
 . Q:'$$CHEKIT(X)
 . ;
 . S ARRAY(UCI)=""
 . S CNT=CNT+1
 ;
 I CNT<1 D
 . W !,?4,"No UCIs could be determined on this system.",!
 . D PRESSKEY^BLRGMENU(4)
 ;
 D:$D(MSG) SENDMAIL^BLRUTIL3("UCI Error",.MSG,"BZHHUTLU")
 ;
 Q CNT
 ;
CHEKIT(UCI) ; EP - Checking to make sure UCI doesn't throw an error
 NEW ERRMSG,errobj,NOW,X
 ;
 TRY {
 	S X=$O(^[UCI]XPD(9.7,"B","LR*5.2*1099"),-1)
 } CATCH errobj {
 	S ERRMSG=errobj.Name
 }
 ;
 Q:$D(ERRMSG)<1 1
 ;
 I $D(MSG) S MSGLINE=$O(MSG("A"),-1)
 E  D
 . S MSG(1)="Error Occurred during UCI processing"
 . S MSG(2)=" "
 . S MSGLINE=2
 ;
 S MSGLINE=MSGLINE+1
 S $E(MSG(MSGLINE),5)="UCI:"_UCI_" Error:"_ERRMSG
 ;
 Q 0
 ;
URGCHK(ORDERNUM) ; EP - Check the Urgency of an Order and, if STAT, send ALERT to LMI Mail Group
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,ORDERNUM,U,XPARSYS,XQXFLG)
 ;
 S (LRODT,URGENCY)=0
 F  S LRODT=$O(^LRO(69,"C",ORDERNUM,LRODT))  Q:LRODT<1!(URGENCY)  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDERNUM,LRODT,LRSP))  Q:LRSP<1!(URGENCY)  D
 .. I $$GET1^DIQ(69.03,LRSP_","_LRODT,1)["STAT" S URGENCY=URGENCY+1
 ;
 D:URGENCY SNDALERT^BLRUTIL3("Order # "_ORDERNUM_" is a STAT Order.",1)
 Q
 ;
 ;
STATORDA(LRODT,LRSP,STATUS) ; EP - If STAT Order from EHR, send ALERT to LMI Mail Group
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRODT,LRSP,STATUS,U,XPARSYS,XQXFLG)
 ;
 S STATIEN=$$FIND1^DIC(62.05,,,"STAT") ; Get the IEN of the STAT urgency
 Q:STATIEN<1  ; If no STAT urgency, skip
 ;
 Q:STATUS'=STATIEN      ; If STATUS not STAT, skip
 ;
 ; Status is STAT, so send alert
 ;
 S ORDERNUM=$$GET1^DIQ(69.01,LRSP_","_LRODT,9.5)
 Q:ORDERNUM<1           ; If no Order Number, skip
 ;
 D SNDALERT^BLRUTIL3("Order # "_ORDERNUM_" is a STAT Order.",1)
 Q
 ;
MAKESTR(ARRAY) ; EP - Pass in Word Processing Array and return String
 NEW (ARRAY,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S STRING="",LINE=0
 F  S LINE=$O(ARRAY(LINE))  Q:LINE<1  S STRING=STRING_($$TRIM^XLFSTR(ARRAY(LINE),"R"," "))_" "
 Q $$TRIM^XLFSTR(STRING,"LR"," ")
 ;
NOSNAPS ; EP - Make certain TAKE SNAPSHOTS field in BLR MASTER CONTROL file is OFF.  This should be queued.
 NEW CNT,DESC,FDA,IEN,STR
 ;
 S:$D(ZTQUEUED) ZTREQ="@"
 ;
 S (CNT,IEN)=0
 F  S IEN=$O(^BLRSITE(IEN))  Q:IEN<1  D
 . Q:+$$GET1^DIQ(9009029,IEN,"TAKE SNAPSHOTS","I")<1
 . ;
 . S CNT=CNT+1,CNT(IEN)=""
 . K FDA
 . S FDA(9009029,IEN_",",1)=0
 . D FILE^DIE(,"FDA","ERRS")
 ;
 Q:CNT<1   ; If no update, just return
 ;
 S STR(1)="File 9009029 'TAKE SNAPSHOTS' Field Set to OFF for the following:"
 S IEN=0
 F  S IEN=$O(CNT(IEN))  Q:IEN<1  D
 . S STR(IEN+2)=$J("",5)_$$GET1^DIQ(9009029,IEN,.01)
 ;
 D SENDMAIL^BLRUTIL3("TAKE SNAPSHOTS OFF",.STR,"BLRUTIL7",1)
 Q
 ;
 ;
GLODUMP ; EP - "Dump" a global using $Q
 NEW FRSTPART,GLOVAR,STR1
 ;
 D ^XBFMK
 S DIR(0)="FO",DIR("A")="Global"
 D ^DIR
 I $L(X)<1!(+$G(DIRUT)) D BADSTUFF("No/Invalid Input.")  Q
 ;
 S GLOBAL=X
 I $E(GLOVAR)'=U S GLOVAR=U_GLOVAR
 ;
 S FRSTPART=$P(GLOVAR,")")
 S STR1=$Q(@GLOVAR@(""))
 I STR1="" D BADSTUFF("No data found for "_GLOVAR_".")  Q
 ;
 W !!,STR1,"="  D LINEWRAP^BLRGMENU($X,@STR1,(IOM-$X))  W !
 F  S STR1=$Q(@STR1)  Q:STR1=""!(STR1'[FRSTPART)  W ?4,STR1,"="  D LINEWRAP^BLRGMENU($X,@STR1,(IOM-$X))  W !
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
SETBLRVS(TWO) ; EP - Set BLRVERN variable(s)
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
 ;
PLURAL(CNT) ; EP - Return "s" if CNT>1, else return "".
 Q $S(CNT>1:"s",1:"")
 ;
PLURALI(CNT) ; EP - Return "ies" if CNT>1, else return the letter "y".
 Q $S(CNT>1:"ies",1:"y")
 ;
LJZEROF(NUM,JW) ; EP - Left Justify, ZERO Fill - JW = Justify Width
 Q $TR($$LJ^XLFSTR(NUM,JW)," ","0")
 ;
RJZEROF(NUM,JW) ; EP - Right Justify, ZERO Fill
 Q $TR($$RJ^XLFSTR(NUM,JW)," ","0")
 ;
RESETERM ; EP - Reset Terminal Characteristics for a Terminal session
 W *27,"[0m",!,$C(27),"[?7h"      ; Resets and ensures "Auto Wrap" is ON
 Q
 ;
AUTOWRAP ; EP - Reset Auto-wrap for a Terminal Session
 W $C(27),"[?7h"
 Q
