BLRUTIL3 ;IHS/OIT/MKK - MISC IHS LAB UTILITIES (Cont) ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1025,1027,1030**;NOV 01, 1997
 ;
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK LR*5.2*1025
GETACCCP(LRAS,LRAA,LRAD,LRAN) ; EP -- Take Accession # & break apart
 ; Parse and process user input.  Cloned from LRWU4.
 NEW LRIDIV,LRQUIT,LRX,X1,X2,X3
 S LRX=LRAS
 ;
 S (LRAA,LRAD,LRAN)=""
 ;
 S (X1,X2,X3)="",X1=$P(LRX," ",1),X2=$P(LRX," ",2),X3=$P(LRX," ",3)
 S:X3=""&(+X2=X2) X3=X2,X2=""
 I X1'?1A.AN Q 0
 ;
 S LRAA=$O(^LRO(68,"B",X1,0))
 I LRAA<1 Q 0
 ;
 ; S %=$P(^LRO(68,LRAA,0),U,14)     ; Don't bother with Security Check
 ; I $L(%),'$D(^XUSEC(%,DUZ)) Q 0   ; Don't bother with Security Check
 ;
 S LRX=$G(^LRO(68,LRAA,0)),LRIDIV=$S($L($P(LRX,U,19)):$P(LRX,U,19),1:"CP")
 ;
 ; Only accession area identifier, no date or number
 I X2="",X3="" D
 . N %DT
 . S %DT="AP",%DT("A")="  Accession Date: ",%DT("B")="TODAY"
 . ; D DATE^LRWU
 . ; D DATE
 . I $D(DUOUT) Q
 . I Y<1 Q
 . S LRAD=Y
 ;
 ; Convert middle value to FileMan date
 ; Adjust for monthly and quarterly formats (MM00) if user enters 4 digit 
 ; number as middle part of accession then convert to appropriate date.
 I +$G(LRAD)<1 D
 . N %DT
 . I X2="" S X2=DT
 . I X2?4N D
 . . S X2=$E(DT,1,3)_X2
 . . I X2>DT S X2=X2-10000
 . S %DT="P",X=X2
 . D ^%DT
 . I Y>0 S LRAD=Y Q
 I +$G(LRAD)<1 Q 0
 ;
 ; Convert date entered to apropriate date for accession area transform
 S X=$P(^LRO(68,LRAA,0),U,3)
 S LRAD=$S("D"[X:LRAD,X="Y":$E(LRAD,1,3)_"0000","M"[X:$E(LRAD,1,5)_"00","Q"[X:$E(LRAD,1,3)_"0000"+(($E(LRAD,4,5)-1)\3*300+100),1:LRAD)
 ; W:X3>0 "  ",+X3
 ;
 I X3="",$D(LRACC) D
 . N DIR,DIRUT,DUOUT,DTOUT,X,Y
 . S DIR(0)="NO^1:999999",DIR("A")="  Number part of Accession"
 . D ^DIR
 . I Y=""!$D(DIRUT) Q
 . S X3=Y
 ;
 I X3="",$D(LRACC) Q 0
 S LRAN=+X3
 Q 1
 ;
DATE ; EP
 K DTOUT,DUOUT S LREND=0
 W !,"DATE",!!,$S($D(%DT("A")):%DT("A"),1:"DATE: "),$S($D(%DT("B")):%DT("B"),1:"TODAY"),"//" R X:DTIME S:X="^" DUOUT=1 S:'$T X="^",DTOUT=1 I $D(DUOUT)!($D(DTOUT)) S LREND=1,Y=-1 Q
 S:X="" X=$S($D(%DT("B")):%DT("B"),1:"T") S:$D(%DT)[0 %DT="E" S:%DT["A" %DT=$P(%DT,"A",1)_$P(%DT,"A",2) S:%DT'["E" %DT="E"_%DT D ^%DT G DATE:X="?"!(Y<1)
 K %DT
 Q
 ;
D2HBOLD(STR) ; EP - Write string DOUBLE HEIGHT & BOLDED
 W !
 W *27,"#3",*27,"[1m",STR,!
 W *27,"#4",*27,"[1m",STR,!
 W *27,"[0m",!                ; Turn OFF all attributes
 Q
 ;
BOLDUNDR(STR) ; EP -- Write string BOLDED & UNDERLINED
 W *27,"[1;4m",STR,*27,"[0m"
 Q
 ;
REVIDEO(STR) ; EP -- Write string in Reverse Video & BOLDED
 W *27,"[1;7m",STR,*27,"[0m"
 Q
 ; ----- END IHS/OIT/MKK LR*5.2*1025
 ;
 ; ----- BEGIN IHS/OIT/MKK LR*5.2*1027
ESIGINFO ; EP -- Rework of BLRUTIL ESIGINFO subroutine.
 NEW DOCDUZ,DOCIEN,ESIGDSTR,REVIEWDV,TAB
 NEW REVSTS
 ;
 ; If E-SIG not turned on, Quit
 I '$$ADDON^BLRUTIL("LR*5.2*1013","BLRALAF",+$G(DUZ(2))) Q
 ;
 S DOCIEN=$O(^VA(200,"B",LRDOC,""))      ; LRDOC = Ordering Provider
 ;
 ; If no IEN, Quit. Usually happens when LRDOC="Unknown"
 Q:$G(DOCIEN)=""
 ;
 I '($D(^BLRALAB(9009027.1,DOCIEN,0))#2) W ?56,"NOT E-SIG PARTICIPATING"  Q
 I $P(^BLRALAB(9009027.1,DOCIEN,0),U,7)'="A" W ?53,"INACTIVE E-SIG PARTICIPANT"  Q
 ;
 ;LRSS doesn't exist when doing option 'BLRTASK CUM', so set it.
 S:$G(LRSS)="" LRSS=$P($G(^LRO(68,LRAA,0)),"^",2)
 ;
 S ESIGDSTR=$G(^LR(LRDFN,LRSS,LRIDT,9009027))           ; E-SIG string Data
 ;
 Q:$P(ESIGDSTR,U,2)=""                                  ; NO Signing Physician
 Q:$P(^BLRALAB(9009027.1,$P(ESIGDSTR,U,2),0),U,7)'="A"  ; NOT Active
 ;
 ; REVIEW status Data Values
 S REVIEWDV=$$UP^XLFSTR($P($G(^DD(63.04,.9009025,0)),U,3))
 S REVSTS=$P($P(REVIEWDV,$P(ESIGDSTR,U)_":",2),";")
 ;
 ; Make sure E-SIG STATUS is flush right
 S TAB=IOM-(16+$L(REVSTS))
 W ?TAB,"E-SIG STATUS: ",REVSTS
 ;
 Q:'$P(ESIGDSTR,U,5)                                    ; NO Signed Date
 ;
 Q:REVSTS["NOT REV"                                     ; NOT Reviewed
 ;
 W !?5,"SIGNING PHYSICIAN: "
 W $P($G(^VA(200,$P(ESIGDSTR,U,2),0)),U)
 W !?5,"DATE/TIME RESULT SIGNED: "
 W $TR($$FMTE^XLFDT($P(ESIGDSTR,U,5),"2MZ"),"@"," ")
 Q
 ;
BLINKER(STR) ; EP -- Write string in BOLDED, UNDERLINED, & BLINKING
 W *27,"[1;4;5m",STR,*27,"[0m"
 Q
 ;
 ; Cloned from LR7OSAP1.  Wrap Text in array to ^TMP global
WRAP(ROOT,FMT) ; EP - Wrap text
 I '$L($G(ROOT)) Q ""
 N CCNT,GCNT,INC,LRI,LRINDX,LRTX,SP,X
 S:'$G(FMT) FMT=79
 S LRINDX=0,LRI=0,GCNT=0
 K ^TMP("BLRUTIL3",$J)
 F  S LRI=$O(@ROOT@(LRI)) Q:LRI'>0  D
 . S X=$S($L($G(@ROOT@(LRI))):@ROOT@(LRI),$L($G(@ROOT@(LRI,0))):@ROOT@(LRI,0),1:""),LRINDX=LRINDX+1
 . S X=$$FMT^LR7OSAP1(FMT,.LRINDX,X)
 S LRI=0
 F  S LRI=$O(LRTX(LRI)) Q:'LRI  D LN^LR7OSAP S ^TMP("BLRUTIL3",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LRTX(LRI))
 Q
 ;
 ;
ALERT ; EP
 W !!
 W "Patient Name:",$P(XQADATA,"^"),!
 W "         UID:",$P(XQADATA,"^",2),!
 W "        TEST:",$P(XQADATA,"^",3),!!
 Q
 ; ----- END IHS/OIT/MKK LR*5.2*1027
 ; 
 ; ----- BEGIN IHS/OIT/MKK -- LR*5.2*1030
REVBLINK(STR) ; EP - Print string in Bold, Blinking, Reverse Video
 W *27,"[1;7;5m",STR,*27,"[0m"
 Q
 ;
 ; Moved PCC Bulletin code to here in order to standardize messages
 ; BLRBUL=1 SENDS BLRTXLOG BULLETIN
 ; BLRBUL=2 SENDS BLRTXLOGERR BULLETIN
 ; BLRBUL=3 SENDS BLRTXLOG AND BLRTXLOGERR BULLETIN
BULTNS ; EP - Send PCC Bulletin
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("BULTNS^BLRUTIL3 0.0")
 ;
 Q:BLRPCC["Lab deleted test"      ; If Lab Deleted Test, don't send message.
 ;
 I "13"[BLRBUL D BULTX("BLRTXLOG")  Q:BLRBUL=1
 D BULTX("BLRTXLOGERR")
 Q
 ;
BULTX(BULLETIN)     ; EP - SEND BULLETIN IF PCC ERROR IN FILING
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("BULTX^BLRUTIL3 0.0")
 ;
 K XMB                  ; Initialize array
 S Y=""                 ; Initialize variable
 ;
 ; If BLRTXLOG number exists, use ^BLRTXLOG database
 I +$G(BLRLOGDA)>0 D BULTXSET
 ;
 ; If BLRTXLOG number DOES NOT exist, use variables
 I +$G(BLRLOGDA)<1 D BLTXNSET
 ;
 S XMB(7)=$G(BLRLOGDA)  ; BLR Transaction Log Number
 ;
 S XMB(8)=BLRPCC        ; Error Message
 ;
 S XMB=BULLETIN         ; Bulletin to use
 ;
 ; Send the Bulletin
 ; S BLRDUZ=DUZ,DUZ=.5 D ^XMB S DUZ=BLRDUZ
 S XMDUZ="Lab to PCC Link Processor"
 D ^XMB
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EXIT BULTX^BLRUTIL3","APCDALVR","XMB")
 ;
 ; Clean up
 K XMB
 Q
 ;
 ; Set bulletin parameters from ^BLRTXLOG global
BULTXSET ; EP 
 NEW COLLDT,LABTIEN,PTPTR
 ;
 S PTPTR=+$P($G(^BLRTXLOG(BLRLOGDA,0)),"^",4)    ; Patient Pointer
 ;
 S XMB(1)=$P($G(^DPT(PTPTR,0)),"^",1)            ; Patient Name
 S XMB(2)=$G(^DPT(PTPTR,"LR"))                   ; LRDFN
 ;
 ; Date of Visit -- Collection Date
 S COLLDT=$P($G(^BLRTXLOG(BLRLOGDA,12)),"^",1)
 S XMB(3)=$$FMTE^XLFDT(COLLDT,"1D")
 ;
 S XMB(4)=$P($G(^BLRTXLOG(BLRLOGDA,11)),"^",3)   ; Order Number
 S XMB(5)=$P($G(^BLRTXLOG(BLRLOGDA,12)),"^",2)   ; Accession Number
 ;
 S LABTIEN=+$P($G(^BLRTXLOG(BLRLOGDA,0)),"^",6)
 S XMB(6)=$P($G(^LAB(60,LABTIEN,0)),"^",1)       ; Lab Test
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("BULTXSET^BLRUTIL3 9.0","XMB")
 Q
 ;
 ; Set bulletin parameters from variables
BLTXNSET ; EP
 NEW PTPTR
 ;
 S PTPTR=+$G(APCDALVR("APCDPAT"))                ; Patient Pointer
 ;
 S XMB(1)=$P($G(^DPT(PTPTR,0)),"^",1)            ; Patient Name
 S XMB(2)=$G(^DPT(PTPTR,"LR"))                   ; LRDFN
 ;
 ; Visit/Collection Date
 S XMB(3)=$$FMTE^XLFDT($G(APCDALVR("APCDDATE")),"1D")
 ;
 S XMB(4)=$G(BLRORD)                             ; Order Number
 S XMB(5)=$G(BLRACCN)                            ; Accession Number
 S XMB(6)=$P($G(^LAB(60,+$G(BLRTEST),0)),"^",1)  ; Test Description
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("BLTXNSET^BLRUTIL3 9.0","XMB")
 Q
 ;
 ; Get Reference Range for a Test for File 63
 ; Used by MEAG Delta Check
GETREFR(TESTNAME) ; EP
 NEW IEN,MESSAGE,REFL,REFH,SPEC,TARGET,UNITS
 ;
 ; Get Internal Entry Number of Test
 D FIND^DIC(60,,,,TESTNAME,,,,,"TARGET","MESSAGE")
 S IEN=+$G(TARGET("DILIST",2,1))
 Q:IEN<1 "!!!!!!!!"
 ;
 S SPEC=+$O(^LAB(60,IEN,1,0))  ; First Site/Spec
 Q:SPEC<1 "!!!!!!!!"
 ;
 S REFL=$$GET1^DIQ(60.01,SPEC_","_IEN_",",1,"I")
 S REFH=$$GET1^DIQ(60.01,SPEC_","_IEN_",",2,"I")
 S UNITS=$$GET1^DIQ(60.01,SPEC_","_IEN_",",6,"I")
 ;
 ; If UNITS is a pointer to the IHS UCUM file, get units text
 S:+$G(UNITS)>0 UNITS=$P($G(^BLRUCUM(UNITS,0)),"^")
 ;
 Q SPEC_"!"_REFL_"!"_REFH_"!!!!"_UNITS_"!!"
 ;
INSTLRPT ; EP -- Report of ^BLRINSTL global
 NEW CP,CNT,WHO,WHEN
 NEW HEADER,PG,LINES,MAXLINES,QFLG,HD1
 ;
 D INSTLRPI
 ;
 F  S CP=$O(^BLRINSTL("LAB PATCH",CP))  Q:CP<1!(QFLG="Q")  D
 . F  S CNT=$O(^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",CNT))  Q:CNT<1!(QFLG="Q")  D
 .. D INSTLRPL
 Q
 ;
INSTLRPI ; EP -- Initialize variables
 NEW DTRANGE,FIRST,FIRSTDT,FRSTPTCH,LAST,LASTPTCH
 S HEADER(1)="IHS LAB Patches Report"
 ;
 S FRSTPTCH=$O(^BLRINSTL("LAB PATCH",0))
 S FIRST=$O(^BLRINSTL("LAB PATCH",FRSTPTCH,"INSTALLED BY",0))
 S FIRSTDT=$P($G(^BLRINSTL("LAB PATCH",FRSTPTCH,"INSTALLED BY",FIRST,"DATE/TIME")),"@")
 ;
 S LASTPTCH=$O(^BLRINSTL("LAB PATCH","A"),-1)
 S LAST=$O(^BLRINSTL("LAB PATCH",LASTPTCH,"INSTALLED BY","A"),-1)
 S LASTDT=$P($G(^BLRINSTL("LAB PATCH",LASTPTCH,"INSTALLED BY",LAST,"DATE/TIME")),"@")
 ;
 S HEADER(2)="Patches Installed From "_FIRSTDT_" thru "_LASTDT
 S HEADER(3)=" "
 S $E(HEADER(4),5)="Patch"
 S $E(HEADER(4),15)="Who"
 S $E(HEADER(4),45)="When"
 ;
 S MAXLINES=22,LINES=MAXLINES+10,PG=0,(HD1,QFLG)="NO"
 S (CP,CNT)=0
 Q
 ;
INSTLRPL ; EP -- Line of Data
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HD1)  Q:QFLG="Q"
 ;
 W ?4,CP
 W ?14,$G(^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",CNT))
 W ?44,$TR($P($G(^BLRINSTL("LAB PATCH",CP,"INSTALLED BY",CNT,"DATE/TIME")),":",1,2),"@"," ")
 W !
 S LINES=LINES+1
 Q
 ;
MAKE132 ; EP - Force Screen to 132 Characters
 W "Setting display to 132 column mode",!
 W $C(27)_"[?3h",!
 W "132 column mode active.",!
 W $TR($J("",132)," ","*"),!
 W !
 S IOM=132
 Q
 ;
MAKE80 ; EP - Force Screen to 80 Characters
 W "Setting display to 80 column mode",!
 W $C(27)_"[?3l",!
 W "80 column mode active.",!
 W $TR($J("",80)," ","*"),!
 W !
 S IOM=80
 Q
 ;
MAILALMI(MESSAGE,MSGARRAY,FROMWHOM) ; EP - send e-MAIL and an Alert to members of the LMI Mail Group
 NEW MAILARRY
 ;
 ; Alert just sends MESSAGE string
 D SNDALERT(MESSAGE)
 ;
 ; Setup variables for sending MailMan e-mail
 I $L($G(MSGARRAY(1))) M MAILARRY=MSGARRAY
 ;
 I $L($G(MSGARRAY(1)))<1 D     ; If MSGARRAY null, create generic array
 . S MAILARRY(1)="The Subject of this email is the message:"
 . S MAILARRY(2)="     "_MESSAGE
 ;
 I $G(FROMWHOM)="" S FROMWHOM="RPMS Lab Package"
 ;
 D SENDMAIL(MESSAGE,.MAILARRY,FROMWHOM)
 Q
 ;
SNDALERT(ALERTMSG) ; EP - Send alert to LMI group AND User (if not member of LMI Mail Group)
 S XQAMSG=ALERTMSG
 S XQA("G.LMI")=""
 ;
 ; If user not part of LMI Mail Group, send them alert also
 S:$$NINLMI(DUZ) XQA(DUZ)=""
 ;
 S X=$$SETUP1^XQALERT
 K XQA,XQAMSG
 Q:X
 ;
 NEW SUBSCRPT
 S SUBSCRPT="BLRLINKU Alert^"_+$H_"^"_$J
 S ^XTEMP(SUBSCRPT,0)=$$FMADD^XLFDT($$DT^XLFDT,90)_"^"_$$DT^XLFDT_"^"_"Lab Package Alert."
 S ^XTEMP(SUBSCRPT,1)="Alert was not sent."
 S ^XTEMP(SUBSCRPT,2)="  Message that should have been sent follows:"
 S ^XTEMP(SUBSCRPT,3)="     "_ALERTMSG
 S ^XTEMP(SUBSCRPT,4)="  ALERT Error Message Follows:"
 S ^XTEMP(SUBSCRPT,5)="     "_XQALERR
 Q
 ;
NINLMI(CHKDUZ) ; EP -- Check to see if DUZ is NOT part of LMI Mail Group
 NEW MGRPIEN,XMDUZ
 ;
 ; Get IEN of LMI MaiL Group
 D CHKGROUP^XMBGRP("LMI",.MGRPIEN)  ; VA DBIA 1146
 Q:+(MGRPIEN)<1 1                   ; If no Mail Group, return TRUE
 ;
 ; XMDUZ = DUZ of the user
 ; Y     = IEN of the mail group
 S XMDUZ=DUZ
 S Y=MGRPIEN
 D CHK^XMA21                        ; VA DBIA 10067
 ;
 Q $S($T=1:0,1:1)
 ;
 ; Send MailMan E-mail to LMI group AND User (if User is not a member of LMI Mail Group)
SENDMAIL(MAILMSG,MAILARRY,FROMWHOM,NOUSER) ; EP 
 NEW DIFROM
 ;
 K XMY
 S XMY("G.LMI")=""
 ;
 ; If User not part of LMI Mail Group, send them e-mail also, but
 ; If-And-Only-If the NOUSER variable is null.
 S:$G(NOUSER)=""&($$NINLMI(DUZ)) XMY(DUZ)=""
 ;
 S LRBLNOW=$E($$NOW^XLFDT,1,12)
 ;
 S XMSUB=MAILMSG
 S XMTEXT="MAILARRY("
 S XMDUZ=FROMWHOM
 S XMZ="NOT OKAY"
 D ^XMD
 ;
 I $G(XMMG)'=""!(XMZ="NOT OKAY") D
 . NEW SUBSCRPT,ARRAY
 . S SUBSCRPT="MailMan Message Failure^"_+$H_"^"_$J
 . S ^XTEMP(SUBSCRPT,0)=$$FMADD^XLFDT($$DT^XLFDT,90)_"^"_$$DT^XLFDT_"^"_"Lab Package MailMan Message."
 . S ^XTEMP(SUBSCRPT,1)="MailMan Message was not sent."
 . S ^XTEMP(SUBSCRPT,2)="  Message that should have been sent follows:"
 . S ARRAY=0
 . F  S ARRAY=$O(MAILARRY(ARRAY))  Q:ARRAY<1  D
 .. S ^XTEMP(SUBSCRPT,(ARRAY+3))="     "_$G(MAILARRY(ARRAY))
 ;
 K X,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,Y   ; Cleanup
 Q
 ;
 ; ----- END IHS/OIT/MKK -- LR*5.2*1030
