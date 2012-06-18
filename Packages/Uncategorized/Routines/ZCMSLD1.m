ZCMSLD1 ;CMB/MEB; 20 Dec 95 14:26; Load all files from a CMS save set
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;CHCS ZCMS_TOOLS; GEN 4; 29-JUN-1999
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
 ;	
 ;
 N Z,%,X,Y,N,FI,RR,F,T,FN,DK,NOLOAD,ENAME,ETYP
 ;===================================================================
PROMPT ;PROMPT FOR ELEMENT TO LOAD
 R !!,"Enter Element name: ",ENAME
 I ENAME["^"!(ENAME="") Q
HLP I ENAME["?" W !!,"ENTER ELEMENT NAME AS IT APPEARS IN THE CMS LIBRARY." G PROMPT
 G EN
 ;===================================================================
ENK ;THIS IS AN ENTRY POINT TO LOAD ONE ELEMENT WITHOUT BEING PROMPTED
 ;THE VMS FILE WILL BE DELETED AFTER BEING LOADED.
 S ZCMSDEL=1,ZCMSNO=+$G(ZCMSNO),ZCDIR=$G(ZCDIR)
 I ENAME["[",ENAME["]" S DIR=$P(ENAME,"]",1),ENAME=$P(ENAME,"]",2)
 E  S DIR=""
 S ETYP=$P(ENAME,".",2) I ETYP="" G HLP
 I DIR="",ZCDIR'="" S ENAME=ZCDIR_ENAME
 W ! I $ZSE(ENAME)="" W !!,"THE VMS FILE FOR THE ELEMENT YOU ENTERED IS NOT IN YOUR CURRENT DIRECTORY." G PROMPT
 G RTN:ETYP="RTN",PT:ETYP="PT",IT:ETYP="IT",ST:ETYP="ST",OP:ETYP["OPTION",DD:ETYP="DD",SE:ETYP="SE",FU:ETYP="FU",BU:ETYP="BU",DE:ETYP="DE",FILE:ETYP="FILE",GAL:ETYP="GAL",BAR:ETYP="BAR",CA:ETYP="CA",CS:ETYP="CS",TT:ETYP="TT"
 S ENAME="?" G HLP
 ;===================================================================
EN ;THIS IS AN ENTRY POINT TO LOAD ONE ELEMENT WITHOUT BEING PROMPTED
 ;THE VMS FILE WILL NOT BE DELETED AFTER BEING LOADED.
 S ZCMSDEL=0,ZCMSNO=$G(ZCMSNO)
 I ENAME["[",ENAME["]" S DIR=$P(ENAME,"]",1),ENAME=$P(ENAME,"]",2)
 E  S DIR=""
 S ETYP=$P(ENAME,".",2) I ETYP="" G HLP
 W ! I $ZSE(ENAME)="" W !!,"THE VMS FILE FOR THE ELEMENT YOU ENTERED IS NOT IN YOUR CURRENT DIRECTORY." G PROMPT
 G RTN:ETYP="RTN",PT:ETYP="PT",IT:ETYP="IT",ST:ETYP="ST",OP:ETYP["OPTION",DD:ETYP="DD",SE:ETYP="SE",FU:ETYP="FU",BU:ETYP="BU",DE:ETYP="DE",FILE:ETYP="FILE",GAL:ETYP="GAL",BAR:ETYP="BAR",CA:ETYP="CA",CS:ETYP="CS",TT:ETYP="TT"
 S ENAME="?" G HLP
 ;==================================================================
FE(X) ;Translate a file name to a file element
 Q $TR(X,"_CHCS$.FILED",".")
 ;==================================================================
TE(X,DK) ;Translate a file name to a template element
 S DK=+$TR($P(X,"$",2),"_.",".;")
 Q $TR($P(X,"$"),"_"," ")
 ;==================================================================
OE(X) ;Translate a file name to an option element
 S M=X["_MENU"
 Q $TR($P(X,"."),"_"," ")
 ;==================================================================
RD(X,DK) ;Translate a data element to a file element
 S DK=+$TR($P(X,"$$",2),"_",".")
 Q $TR($P(X,"$$"),"$_",", ")
 ;==================================================================
RTN ;
 D LDINIT
 S Z="ZL  ZS @N"
 S $ZT="EOF" D
 .I $$ROUTEST^%ZTF("ZCMSLDI") D RTN^ZCMSLDI(ENAME) I NOLOAD1=1 Q
 .O ENAME:READ U ENAME R X,Y,N X Z C ENAME U 0 W N_$J("",10-$L(N))
 .I ENAME[";" S ENAME=$P(ENAME,";",1)
 .D:ZCMSDEL DFILE^ZCMSLD(.ENAME)
 W:NOLOAD=0&(ZCMSNO'=1) !,"Load completed.",!
 W:NOLOAD=1&(ZCMSNO'=1) !,"Partial Load completed.",! Q
 W !,B1_ZCMSCNT("RTN")_B0_" Routines Loaded.",!,"The stamp global has been updated to reflect this load."
 S ZCMSEND=$$CDATASC^%ZTFDT($H,4,2)
 W !,"LOAD STARTED:  "_ZCMSSTRT
 W !,"LOAD FINISHED: "_ZCMSEND
 D LGUPD^ZCMSLD3
 Q
 ;==================================================================
TT G RIF^INZTTR
 Q
 ;==================================================================
PT D LDINIT
 I '$D(DIJTT),ZCMSNO'=1 S DIJTT=+$O(^%ZIS(2,"B","C-VT320",0))
 S FI="PT" D LOAD1 Q
 ;==================================================================
IT D LDINIT
 I '$D(DIJTT),ZCMSNO'=1 S DIJTT=+$O(^%ZIS(2,"B","C-VT320",0))
 S FI="IT" D LOAD1 Q
 ;==================================================================
ST D LDINIT S FI="ST" D LOAD1 Q
 ;==================================================================
OP D LDINIT S FI="OPTION" D LOAD1 Q
 ;==================================================================
DD D LDINIT S FI="DD" D LOAD1 Q
 ;==================================================================
BAR D LDINIT S FI="BAR" D LOAD1 Q
 ;==================================================================
SE D LDINIT S FI="SE" D LOAD1 Q
 ;==================================================================
FU D LDINIT S FI="FU" D LOAD1 Q
 ;==================================================================
BU D LDINIT S FI="BU" D LOAD1 Q
 ;==================================================================
CA D LDINIT S FI="CA" D LOAD1 Q
 ;==================================================================
CS D LDINIT S FI="CS" D LOAD1 Q
 ;==================================================================
FILE D LDINIT S FI="FILE" D LOAD1 Q
 ;==================================================================
GAL D LDINIT S FI="GAL" D LOAD1 Q
 ;==================================================================
DE D LDINIT S FI="DE",RR="ENTR^ZCMSDE(DE,DK,ZCDIR)" D
 .S F=$ZC(%PARSE,ENAME,,,"NAME"),T=$ZC(%PARSE,ENAME,,,"TYPE"),%=F_T
 .S DE=$$RD(.ENAME,.DK)
 .D @RR
 .D:ZCMSDEL DFILE^ZCMSLD(.ENAME)
 W:NOLOAD=0&(ZCMSNO'=1) !,"Load completed.",!
 W:NOLOAD=1&(ZCMSNO'=1) !,"Partial Load completed.",!
 W !,B1_ZCMSCNT("DE")_B0_" DATA ELEMENTS LOADED.",!,"The stamp global has been updated to reflect this load."
 S ZCMSEND=$$CDATASC^%ZTFDT($H,4,2)
 W !,"LOAD STARTED:  "_ZCMSSTRT
 W !,"LOAD FINISHED: "_ZCMSEND
 D LGUPD^ZCMSLD3
 Q
 ;==========================================================
LOAD1 S FN=$S(ETYP["DD"!(ETYP["FILE"):$$FE(.ENAME),1:ENAME)
 S RR="ENTR^ZCMS"_$S(FI="FILE":"F",FI["OPTION":"OP",1:FI)_"(FN,ZCDIR)"
 D @RR,CNTUPD^ZCMSLD3(FI)
 D:ZCMSDEL DFILE^ZCMSLD(.ENAME)
 W:NOLOAD=0&(ZCMSNO'=1) !,"Load completed.",!
 W:NOLOAD=1&(ZCMSNO'=1) !,"Partial Load completed.",!
 W !,B1_ZCMSCNT(FI)_B0_" ELEMENTS LOADED.",!,"The stamp global has been updated to reflect this load."
 S ZCMSEND=$$CDATASC^%ZTFDT($H,4,2)
 W !,"LOAD STARTED:  "_ZCMSSTRT
 W !,"LOAD FINISHED: "_ZCMSEND
 D LGUPD^ZCMSLD3
 Q
 ;==================================================
LDINIT S NOLOAD=0,NOLOAD1=0,ZCMSUP=1,ZCDIR=$G(ZCDIR)
 S Z="ZL  ZS @N",U="^",DUZ(0)="@",CONFIRM=0,NOLOAD=0,NOLOAD1=0,ZCMSNO=+$G(ZCMSNO),TCMLD=+$G(TCMLD)
 N ETYP
 D INIT^ZCMSETUP,CNTINIT^ZCMSLD3
 S ZCMSSTRT=$$CDATASC^%ZTFDT($H,4,2)
 S %U=$P($ZC(%UCI),",",7)
 S DATEOUTF=$$DT^%ZTFDT()
 I %U="TRA"!(%U="TRS") R "Is this is a Training Data Base Environment? Y// ",ZCMSINP W !! D
 .I ZCMSINP'["N"!(ZCMSINP'["n") R "Enter date (Example 21-APR-1991): ",DATEOUT S DATEOUTF=$$CDATA2F^%ZTFDT(DATEOUT)
 Q
 ;=======================================
EOF I $ZE["-ENDOFILE" S $ZE="" U 0 W !,$P(ENAME,"]",2)," The VMS file does not contain a complete element.",! C ENAME:DELETE G EN
 U 0 W $ZE Q
 ;
FN(ENAME,ZCMSDEL) ;LOAD ONE ELEMENT WITHOUT BEING PROMPTED
 S ZCMSNO=1,ZCMSNOGO=0,ZCDIR=$G(ZCDIR)
 D INIT
 I ENAME["[",ENAME["]" S DIR=$P(ENAME,"]",1),ENAME=$P(ENAME,"]",2)
 E  S DIR=""
 I DIR="",ZCDIR'="" S ENAME=ZCDIR_ENAME
 S ETYP=$P(ENAME,".",2) I ETYP="" G HLP
 F TTYP="RTN","PT","IT","ST","SE","OPTION_MENU","OPTION","DD","FILE","FU","BU","GAL","DE","BAR","CA","CS","TT" I ETYP=TTYP S ZCMSNOGO=1
 I 'ZCMSNOGO W !!,"I do not know how to load an element with an extension ",B1,".",ETYP,B0,!!,"Please contact the CMS Dudes for help.",! Q
 W ! I $ZSE(ENAME)="" W !!,"File "_ENAME_" not found..." Q
 G RTN:ETYP="RTN",PT:ETYP="PT",IT:ETYP="IT",ST:ETYP="ST",OP:ETYP["OPTION",DD:ETYP="DD",SE:ETYP="SE",FU:ETYP="FU",BU:ETYP="BU",DE:ETYP="DE",FILE:ETYP="FILE",GAL:ETYP="GAL",BAR:ETYP="BAR",CA:ETYP="CA",CS:ETYP="CS",TT:ETYP="TT",Q
 ;
Q Q
 ;
INIT ;Init some needed values
 S DUZ=+$G(DUZ),DUZ(0)=$G(DUZ(0)),U="^"
 S %U=$P($ZC(%UCI),",",7)
 S VALID=""
 ;   load up the VALID character set (all upper case and numerics) 
 F %=0:1:127 I $C(%)?1UN S VALID=VALID_$C(%)
 S VALID=VALID_" -"
 ;     add in SPACE and hyphen to VALID characters
 S B1=$C(27)_"[1m",B0=$C(27)_"[m" ;BOLD ON/BOLD OFF
 Q
 ;=======================================
KP ;Load one element and keep VMS file.
 N Z,%,X,Y,N,FI,RR,F,T,FN,DK,NOLOAD,ENAME,ETYP
PROMPT ;PROMPT FOR ELEMENT TO LOAD
 R !!,"Enter Element name: ",ENAME
 I ENAME["^"!(ENAME="") Q
HLP I ENAME["?" W !!,"ENTER ELEMENT NAME AS IT APPEARS IN THE CMS LIBRARY." G PROMPT
 G EN ;keep going without deleting VMS file.
