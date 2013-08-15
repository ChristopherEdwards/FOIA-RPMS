BLRLLPRR ; IHS/MSC/MKK - Lab Label Printer Reset Routine ;   [ February 29, 2012 8:00 AM ]
 ;;5.2;LAB SERVICE;**1031**;NOV 01, 1997
 ;
EEP  ; EP
 D EEP^BLRGMENU
 Q
 ;
EP ; EP 
PEP ; EP
 NEW BLRMMENU,BLRVERN,LINES
 ;
 D SETMENU
 ;
 ; Main Menu driver
 D MENUDRFM^BLRGMENU("RPMS Lab Module","Reset Lab Label Printing")
 Q
 ;
SETMENU ; EP -- Lab Programmer Menu
 S BLRVERN=$P($P($T(+1),";")," ")
 ;
 D ADDTMENU^BLRGMENU("GETNEWR^BLRLLPRR","Overwrite LRLABEL4 With Specified Routine")
 D ADDTMENU^BLRGMENU("GETNEWO^BLRLLPRR","Replace ROUTINE in Specified Option")
 D ADDTMENU^BLRGMENU("PAIRS^BLRLLPRR","List Print Routines")
 Q
 ;
GETNEWR ; EP
 NEW CODE,ERRS,NEWRTN,PRINTRTN
 NEW HD1,HEADER,LINES,MAXLINES,PG,QFLG
 ;
 I $$GETPRINI(.NEWRTN)="Q" D  Q
 . W !,?4,"Routine not selected.",!
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q:$$REALLY("LRLABEL4")="Q"
 ;
 ; Retrieve code from new routine and store in CODE array
 S GETIT=$$ROUTINE^%R(NEWRTN_".INT",.CODE,.ERRS,"L")
 I GETIT<1 D DOERRS(.ERRS)  Q
 ;
 ; Backup & then Compile & then save new version of LRLABEL4 routine
 S GETIT=$$ROUTINE^%R("LRLABEL4.INT",.CODE,.ERRS,"BCS")
 I GETIT<1 D DOERRS(.ERRS)  Q
 ;
 W !!,?4,"LRLABEL4 routine has been successfully over-written by ",NEWRTN,".",!
 D PRESSKEY^BLRGMENU(9)
 ;
 Q
 ;
GETPRINI(NEWRTN) ; EP - GET new Print Routine - INItialization of variables
 S HEADER(1)="IHS Lab Label Printer Utilities"
 S HEADER(2)="Print Routine Replacement"
 ;
 Q:$$USERTNS(.NEWRTN)="Q" "Q"
 ;
 Q "OK"
 ;
USERTNS(NEWRTN) ; EP
 NEW DASH,HOWMANY,LABELRTN,ORD,RTNS,STR
 ;
 D PRNTRTNS(.LABELRTN,.HOWMANY)
 ;
 D SETUPDIR("Print Routines",.LABELRTN,10,20,"Routine",HOWMANY)
 ;
 D HEADERDT^BLRGMENU
 D ^DIR
 ;
 S (X,NEWRTN)=$O(LABELRTN(+$G(Y),""))
 Q $S($L(X)>0:X,1:"Q")
 ;
SETUPDIR(PROMPT,ARRAY,TABONE,TABTWO,HEADER1,HOWMANY) ; EP - SETUP DIR array and variables
 NEW DASH,HOWLONG,ORD,SELSTR,WHAT
 ;
 S DASH=$TR($J("",IOM)," ","-")
 S HOWLONG=IOM-TABTWO
 ;
 D ^XBFMK
 S DIR("A")="Enter Response (1-"_HOWMANY_")"
 S ORD=0,CNT=5
 F  S ORD=$O(ARRAY(ORD))  Q:ORD=""  D
 . S WHAT=$O(ARRAY(ORD,""))
 . K STR
 . S $E(STR,5)=$J(ORD,2)
 . S $E(STR,TABONE)=WHAT
 . S:HOWLONG>5 $E(STR,TABTWO)=$E($G(ARRAY(ORD,WHAT)),1,HOWLONG)
 . S DIR("L",CNT)=STR
 . S CNT=CNT+1
 . I ORD>1 S SELSTR=SELSTR_";"_ORD_":"
 . I ORD<2 S SELSTR="SO^"_ORD_":"
 S DIR("L",1)="Select one of the "_PROMPT_" below:"
 S DIR("L",2)=""
 K STR
 S $E(STR,TABONE)=HEADER1
 S $E(STR,TABTWO)="Description"
 S DIR("L",3)=STR
 K STR
 S $E(STR,TABONE)=$E(DASH,1,(TABTWO-TABONE)-2)
 S $E(STR,TABTWO)=$E(DASH,1,HOWLONG)
 S DIR("L",4)=STR
 S DIR("L")=""
 S DIR(0)=SELSTR
 Q
 ;
REALLY(WOT) ; EP - Prompt for certainty -- Ask 3 Times.
 NEW ANSWER
 ;
 S ANSWER=$$AREUSURE("CERTAIN",,WOT)
 Q:ANSWER="Q" "Q"
 ;
 S ANSWER=$$AREUSURE("REALLY certain",,WOT)
 Q:ANSWER="Q" "Q"
 ;
 Q $$AREUSURE("ABSOLUTELY certain","LAST CHANCE",WOT)
 Q:ANSWER="Q" "Q"
 ;
 Q "OK"
 ;
AREUSURE(MSG,WARNING,WOT) ; EP
 NEW MIDPOINT,WARNLEN
 ;
 D HEADERDT^BLRGMENU
 ;
 I $D(WARNING) D
 . S WARNING=$TR(WARNING," ","@")
 . S WARNING=$$CJ^XLFSTR(">>>>>>>>>>>@"_WARNING_"@<<<<<<<<<<<",IOM)
 . S WARNING=$TR(WARNING,"@"," ")
 . W WARNING
 . W !
 ;
 NEW PROMPT,TAB
 D ^XBFMK
 S PROMPT=$J("",5)_"Are you "_MSG_" you want to overwrite "_WOT
 I $L(PROMPT)<71 S DIR("A")=PROMPT
 I $L(PROMPT)>70 K DIR("A")  D
 . S DIR("A",1)=$J("",5)_"Are you "_MSG_" you want to"
 . S DIR("A",2)=" "
 . S DIR("A")=$J("",5)_"overwrite "_WOT
 S DIR(0)="YO"
 S DIR("B")="NO"
 D ^DIR
 ;
 I $E($$UP^XLFSTR(X),1)'="Y" D  Q "Q"
 . S XPDABORT=1
 . S TAB=9
 . S PROMPT="YES was NOT entered.  Overwriting of "_WOT_" Aborted."
 . S:($L(PROMPT)+9)>70 TAB=4
 . W !!,?TAB,"YES was NOT entered.  Overwriting of "_WOT_" Aborted.",!
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q "OK"
 ;
GETNEWO ; EP
 NEW CNT,CODE,ERRS,INITRTN,LABELRTN,NEWRTN,OPTSIEN,PRINTRTN,WOTOPTS
 NEW HD1,HEADER,LINES,MAXLINES,PG,QFLG
 ;
 I $$GETOOINI(.WOTOPTS,.OPTSIEN)="Q" D  Q
 . W !,?4,"Option not selected.",!
 . D PRESSKEY^BLRGMENU(9)
 ;
 K HEADER(3)
 S HEADER(3)=$$CJ^XLFSTR("Option "_WOTOPTS_" Selected",IOM)
 ;
 I $$GETORINI(.INITRTN)="Q" D  Q
 . W !,?4,"Routine not selected.",!
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q:$$REALLY("the Initialization Routine")="Q"
 ;
 D SETOPTIR(WOTOPTS,OPTSIEN,INITRTN)
 Q
 ;
SETOPTIR(WOTOPTS,OPTSIEN,INITRTN) ; EP -- Resets ROUTINE in selected option
 NEW ERRS,NEWRTN
 ;
 D ^XBFMK
 S DA=OPTSIEN
 S DIE=19
 S DR="25///"_INITRTN
 D ^DIE
 ;
 D ^XBFMK
 S NEWRTN=$$GET1^DIQ(19,OPTSIEN,25,,,"ERRS")
 I $D(ERRS) D  Q
 . W !,?4,"Errors Occurred.",!
 . D PRESSKEY^BLRGMENU(9)
 ;
 D HEADERDT^BLRGMENU
 W !,?4,"For Option ",WOTOPTS,!!
 W ?9,"ROUTINE:",NEWRTN
 D PRESSKEY^BLRGMENU(14)
 ;
 Q
 ;
GETOOINI(WOTOPTS,OPTSIEN) ; EP - GET Option & Option's IEN
 S HEADER(1)="IHS Lab Label Printer Utilities"
 S HEADER(2)="Option Routine Replacement"
 S HEADER(3)=$$CJ^XLFSTR("Option Selection",IOM)
 ;
 Q:$$USEORTNS(.WOTOPTS)="Q" "Q"
 D GOPTIEN(WOTOPTS,.OPTSIEN)
 Q "OK"
 ;
GETORINI(INITRTN) ; EP - GET Initialization Routine
 K HEADER(4)
 S HEADER(4)=$$CJ^XLFSTR("Routine Selection",IOM)
 S CNT=0
 ;
 D INITRTNS(.LABELRTN,.CNT)
 ;
 D SETUPDIR("Initialization Routines",.LABELRTN,10,20,"Routine",CNT)
 ;
 D HEADERDT^BLRGMENU
 D ^DIR
 ;
 S (X,INITRTN)=$O(LABELRTN(+$G(Y),""))
 Q $S($L(X)>0:X,1:"Q")
 ;
USEORTNS(WOTOPTS) ; EP
 NEW DASH,HOWMANY,LABELRTN,ORD,RTNS,STR,WOTOPTSA
 ;
 S DASH=$TR($J("",IOM)," ","-")
 D GETOPTS(.WOTOPTSA,.HOWMANY)
 ;
 D SETUPDIR("Options",.WOTOPTSA,10,41,"Option",HOWMANY)
 ;
 D HEADERDT^BLRGMENU
 D ^DIR
 ;
 S (X,WOTOPTS)=$O(WOTOPTSA(+$G(Y),""))
 Q $S($L(X)>0:X,1:"Q")
 ;
GOPTIEN(OPT,IEN) ; EP - Get Option's IEN from File 19
 D ^XBFMK
 S X=OPT,DIC="19"
 D ^DIC
 S IEN=+$G(Y)
 Q
 ;
GETOPTS(WOTOPTS,CNT) ; EP -- Set WOTOPTS array with BLR startup Options
 NEW OPT,ZERO
 S OPT=.9999999
 F  S OPT=$O(^DIC(19,OPT))  Q:OPT<1  D
 . S ZERO=$G(^DIC(19,OPT,0))
 . Q:ZERO'["BLR"
 . Q:ZERO'["STARTUP"
 . S CNT=1+$G(CNT)
 . S WOTOPTS(CNT,$P(ZERO,"^"))=$P(ZERO,"^",2)
 Q
 ;
DOERRS(ERRORS) ; EP
 W !!,"Errors follow:",!!
 W $$FMTERR^%R(.ERRORS)
 W !
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
PRNTRTNS(LABELRTN,CNT) ; EP -- Set LABELRTN array with Lab Label Print Routines on the system
 NEW RTNS,SEED,STR
 ;
 F SEED="BLRLAB","BLRIPL" D
 . S RTNS=SEED
 . F  S RTNS=$O(^ROUTINE(RTNS))  Q:RTNS=""!($E(RTNS,1,6)'=SEED)  D
 .. Q:SEED="BLRIPL"&($E($RE(RTNS),1)="I")     ; "I" routines are initializers
 .. S CNT=1+$G(CNT)
 .. D STRRTNS(.LABELRTN,RTNS,CNT)
 ;
 Q
 ;
STRRTNS(LABELRTN,RTNS,CNT) ; EP -- Store routine & description
 S STR=$$TRIM^XLFSTR($P($G(^ROUTINE(RTNS,0,1)),";",2),"LR"," ")
 S STR=$$TRIM^XLFSTR($P(STR,"-",2,99),"LR"," ")
 S STR=$$TRIM^XLFSTR($P(STR,"["),"LR"," ")
 S LABELRTN(CNT,RTNS)=STR
 Q
 ;
INITRTNS(LABELRTN,CNT) ; EP -- Set LABELRTN array with Lab Label Initialization Routines on the system
 NEW RTNS,SEED,STR
 ;
 F SEED="BLRBAR","BLRIPL" D
 . S RTNS=SEED
 . F  S RTNS=$O(^ROUTINE(RTNS))  Q:RTNS=""!($E(RTNS,1,6)'=SEED)  D
 .. Q:SEED="BLRIPL"&($E($RE(RTNS),1)="P")     ; "P" routines are the print routines
 .. S CNT=1+$G(CNT)
 .. D STRRTNS(.LABELRTN,RTNS,CNT)
 ;
 Q
 ;
 ; DEAD CODE follows, for the time being
GETPRTN(NEWRTN) ; EP -- Get Print Routine's Name
 NEW NAME
 ;
 S NAME=""
 F  Q:$L(NAME)!(NAME="Q")  D
 . D HEADERDT^BLRGMENU
 . D ^XBFMK
 . S DIR(0)="FAO"
 . S DIR("A")="Select Lab Label Print Routine: "
 . D ^DIR
 . I $L($G(X))<1 D  Q:NAME="Q"
 .. W !,?4,"Invalid/No Entry.",!!
 .. D ^XBFMK
 .. S DIR(0)="YAO"
 .. S DIR("A")="          Quit?"
 .. S DIR("B")="YES"
 .. D ^DIR
 .. I +$G(Y)>0 D
 ... S NAME="Q"
 ... W !,?4,"Routine Ends.",!
 . ;
 . I $D(^ROUTINE($G(X)))<1 D  Q
 .. W !,?4,"Routine ",$G(X)," Does Not Exist in this UCI.",!
 . ;
 . S NAME=$G(X)
 ;
 I $L(NAME)<1 Q "Q"
 ;
 S NEWRTN=NAME
 Q "OK"
 ;
PAIRS ; EP - List all the routines that are tied to Lab Label Printing.
 NEW CODE,ERRS,NEWRTN,PRINTRTN
 NEW BLRVERN,CNT,HD1,HEADER,LINES,MAXLINES,PG,QFLG
 NEW RTNS,SEED,STR
 ;
 D PAIRINIT
 ;
 F SEED="BLRBAR","BLRLAB","BLRIPL" D
 . S RTNS=SEED
 . F  S RTNS=$O(^ROUTINE(RTNS))  Q:RTNS=""!($E(RTNS,1,6)'=SEED)  D
 .. D PAIRLINE
 ;
 W !,?19,"COUNT:",CNT
 D ^%ZISC
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
PAIRINIT ; EP - Initialize variables
 S BLRVERN=$P($P($T(+1),";")," ")
 ;
 S HEADER(1)="IHS Lab Label Printer Utilities"
 S HEADER(2)="Print Routines Report"
 S HEADER(3)=$$CJ^XLFSTR("All BLRBAR, BLRLAB and BLRIPL Lab Label Routines",IOM)
 ;
 D HEADERDT^BLRGMENU
 D ^%ZIS
 I POP D  Q "Q"
 . W !,?4,"Device Not Available. Routine Ends.",!!
 . D PRESSKEY^BLRGMENU(9)
 U IO
 ;
 I IOST["C-VT" D HEADONE2^BLRLUAC2(.HD1)  W !
 ;
 S MAXLINES=IOSL-4
 S LINES=MAXLINES+10
 ;
 S (CNT,PG)=0,QFLG="NO"
 ;
 S HEADER(4)=" "
 S HEADER(5)="Routine"
 S $E(HEADER(5),15)="Routine Description"
 ;
 Q
 ;
PAIRLINE ; EP - Print a line of data
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HD1)  Q:QFLG="Q"
 ;
 S STR=$$TRIM^XLFSTR($P($P($G(^ROUTINE(RTNS,0,1)),";",2),"-",2),"LR"," ")
 W $E(RTNS,1,13)
 W ?14,$E(STR,1,65)
 W !
 S LINES=LINES+1
 S CNT=1+$G(CNT)
 Q
