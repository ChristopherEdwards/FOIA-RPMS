INTENV ; bar ; 19 Jun 96 15:57; Menu driver for GIS environment mgmt system 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN ;Main entry point
 D ENV^UTIL
 Q:'$G(DUZ)
INITO ;Build option list
 K OPT
 F OCO=1:1 S OPT=$P($T(OPT+OCO),";;",2) Q:OPT=""  S OPT(OCO)=OPT
PAINT ;Paint screen
 W #,!!?15,"GIS Development Environment Management",!
 S OCO=0
 F COUNT=0:1 S OCO=$O(OPT(OCO)) Q:'OCO  D
 . W !,?10,OCO,".",?15,$P(OPT(OCO),U),?50 W $S($L($P(OPT(OCO),U,2)):"("_$P(OPT(OCO),U,2,3)_")",1:"*INACTIVE*")
 W !!,?20,"Select Option NUMBER (1-",COUNT,"): "
 R SEL:$G(DTIME,300)
VAL ;Validate option
 I SEL=""!($E(SEL)=U) Q
 I '$D(OPT(SEL)) W *7 G PAINT
EX ;Execute option
 W #,!!,?(80-$L($P(OPT(SEL),U))-8\2),"*** ",$P(OPT(SEL),U,1)," ***",!!
 I '$L($P(OPT(SEL),U,2)) W *7 G INITO
 D @($P(OPT(SEL),U,2,3))
 W ! S X=$$CR^INHU1
 G INITO
 Q
 ;
OPT ;List of options                   <- max name length
 ;;General daily clean up    (Green)^GREEN^INTENV
 ;;Major clean up/MFN purge (Yellow)^YELLOW^INTENV
 ;;Clear all GIS dynamic files (Red)^RED^INTENV
 ;;Purge transactions by type^PTT^INTENV
 ;;Purge transactions by destination^PDT^INTENV
 ;;Purge and/or consolidate errors^PERR^INTENV
 ;;
PTT ; purge trans by TT
 L +^INRHB("PURGE"):1 E  W !!,"Purge already running.",! Q
 L -^INRHB("PURGE")
 N INPURGE,INTT
 S INPURGE=$$DATA Q:'$L(INPURGE)
 Q:$$TTYPE(.INTT)  Q:'$$SURE(2)
 D TASK("PTTT^INTENV","Purge GIS by type","INPURGE,INTT(")
 Q
PTTT ;
 L +^INRHB("PURGE"):5 E  Q
 D TPURGE^INTENV1(INPURGE,.INTT)
 L -^INRHB("PURGE")
 Q
 ;
PDT ; purge trans by dest
 L +^INRHB("PURGE"):1 E  W !!,"Purge already running.",! Q
 L -^INRHB("PURGE")
 N INPURGE,INDEST
 S INPURGE=$$DATA Q:'$L(INPURGE)
 S INDEST=$$DEST Q:'INDEST
 Q:'$$SURE(2)
 D TASK("PDTT^INTENV","Purge GIS by dest","INPURGE,INDEST")
 Q
PDTT ;
 L +^INRHB("PURGE"):5 E  Q
 D TDPURGE^INTENV1(INPURGE,INDEST)
 L -^INRHB("PURGE")
 Q
 ;
PERR ; purge errors
 L +^INRHB("PURGE"):1 E  W !!,"Purge already running.",! Q
 L -^INRHB("PURGE")
 N INPURGE,INCON
 S INPURGE=$$DATA Q:'$L(INPURGE)
 S INCON=$$YN^UTSRD("Do you want to consolidate the remaining errors? ;0","^D ECONH^INTENV")
 Q:INCON["^"
 Q:'$$SURE(2)
 D TASK("PERRT^INTENV","Purge GIS Errors","INPURGE,INCON")
 Q
 ;
PERRT ;
 L +^INRHB("PURGE"):5 E  Q
 D EPURGE^INTENV1(INPURGE,INCON)
 L -^INRHB("PURGE")
 Q
 ;
GREEN ; general daily clean up - GREEN purge
 L +^INRHB("PURGE"):1 E  W !!,"Purge already running.",! Q
 L -^INRHB("PURGE")
 S INPURGE=$$SITE
 W !!,"This option will purge GIS transactions and errors."
 W !,"It will keep "_(INPURGE*24)_" hours worth of transactions and errors."
 W !,"All broken entries in the destination queue will be removed.",!
 Q:'$$SURE(1)
 S INPURGE=INPURGE_"D"
 D TASK("YELLOWT^INTENV","Purge GIS Trans & Err","INPURGE")
 Q
 ;
GREENT ;
 L +^INRHB("PURGE"):5 E  Q
 D TPURGE^INTENV1(INPURGE),EPURGE^INTENV1(INPURGE),DPURGE^INTENV1
 L -^INRHB("PURGE")
 Q
 ;
YELLOW ; purge all by time
 L +^INRHB("PURGE"):1 E  W !!,"Purge already running.",! Q
 L -^INRHB("PURGE")
 W !!,"This option will purge GIS transactions and errors."
 W !,"It will keep 72 hours worth of transactions, purge all MFN's,"
 W !,"keep 24 hours of errors and consolidate remaining errors.",!
 W !,"All broken entries in the destination queue will be removed.",!
 Q:'$$SURE(2)
 D TASK("YELLOWT^INTENV","Purge GIS Trans & Err")
 Q
 ;
YELLOWT ;
 L +^INRHB("PURGE"):5 E  Q
 D TPURGE^INTENV1("3D"),TPURGE^INTENV1("0D","*MASTER FILE*"),EPURGE^INTENV1("1D",1),DPURGE^INTENV1
 L -^INRHB("PURGE")
 Q
 ;
RED ; stop GIS and clean out all dynamic globals
 W !!,"This will STOP all processes of the GIS and COMPLETELY"
 W !,"DELETE all transactions, errors, and CLEAR all queues.",!
 Q:'$$SURE(3)
 W !!,"Shutting down GIS..."
 D SHUT^INTENV1
 W "done.",!!,"Clearing all transactions, errors, and queues..."
 D CLEAN^INTENV1
 W "done.",!
 Q
 ;
DATA() ; ask for amount of data
 N INX,INOUT S INOUT=0
 F  R !,"Enter amount of data to keep: ",INX:$G(DTIME,300) D  Q:INOUT
 . I '$L(INX)!(INX["^") S INOUT=1,INX="" Q
 . I $E("NONE",1,$L(INX))=INX S INX="0D",INOUT=1 Q
 . I INX?1.N1U,"DHM"[$E(INX,$L(INX)) S INOUT=1 Q
 . W:INX'["?" *7,"  ??"
 . W !,"  Enter a code for the length of time to keep data."
 . W !,"  format: nL where n = number and L is a letter"
 . W !,"                D = days, H = hours, M = minute"
 . W !,"  You may also enter NONE to not keep any data.",!
 Q INX
 ;
TTYPE(INTTA) ; get transaction types to delete
 ; output: INTTA = array of TTs
 ;
 N C,INTT,INOUT
 F  R !,"Enter Transaction Type(s) to delete: ",INTT:$G(DTIME,300) D  Q:$D(INOUT)
 . I INTT="^L" D TTLIST(.INTTA) Q
 . I '$L(INTT) S INOUT=0,INTT="" Q
 . I INTT["^" S INOUT=1,INTT="" Q
 . I INTT["?" D  Q
 .. W !,"  Transactions can be deleted based on the Tranasaction"
 .. W !,"  Types entered here.  You can use wild cards ""*"" to select"
 .. W !,"  many types.  If you enter nothing, all transactions"
 .. W !,"  within the purge date range will be deleted."
 .. W !,"  Enter ""^L"" to see what is selected so far."
 .. W !,"  Enter ""^"" to exit."
 . S C=$$TTCONV^INTENV1(INTT,.INTTA)
 . W "  "_$TR(C,"-")_" "_$S($E(INTT)="-":"de",1:"")_"selected"
 S:$D(INTTA)<10 INOUT=1
 Q INOUT
 ;
TTLIST(INTTA) ; list out selected TT
 ; input: INTTA = array of Tranaaction Types
 N I,Y,L,%
 S I=0,L=$G(IOSL,24)-4,%=""
 F Y=1:1 S I=$O(INTTA(I)) Q:'I  S:Y>L Y=0,%=$$CR^UTSRD Q:%  W !,INTTA(I)
 Q
 ;
DEST() ; select destination
 N DIC,Y
 S DIC="^INRHD(",DIC(0)="AEMQZ",DIC("S")="I $D(^INLHDEST(Y))"
 D ^DIC S:Y<0 Y=0
 Q +Y
 ;
SURE(INREP) ; are you sure question
 ; input: INREP = number of times to ask, max is three for now
 N I,P,X
 F I=1:1:INREP D  W ! S X=$$YN^UTSRD("    "_P_$C(7)_" ;0") Q:'X
 . S P=$S(I=1:"Is this ok?",I=2:"Are you sure?",1:"This is going to delete a lot of data. Are you really sure?")
 W ! Q X
 ;
ECONH ; help for consolidate question
 W !,"  If YES, the error log will retain the most recent of each type of"
 W !,"         error and delete the duplicates after the purge date."
 W !,"  IF NO, only errors before the purge date will be deleted."
 Q
 ;
TASK(ZTRTN,ZTDESC,INSAVE) ; send routine to background
 ; input:  ZTRTN = routine to run
 ;         ZTDESC = Description of task
 N X,I
 S X=$$YN^UTSRD("Do you want to run this in the background? ;1")
 I X K ZTDTH S ZTIO="NL:" D  D ^%ZTLOAD W !,"Queued to background. ("_$G(ZTSK)_")" Q
 . F I=1:1 S X=$P($G(INSAVE),",",I) Q:'$L(X)  S ZTSAVE(X)=""
 D @ZTRTN
 Q
 ;
SITE() ; return # of days from GIS site parms
 N X
 S X=$P($G(^INRHSITE(1,0)),U,11) S:'X X=3
 Q X
 ;
