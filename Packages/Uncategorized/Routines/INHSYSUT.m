INHSYSUT ;JPD/WOM; 23 Aug 1999 12:26;gis sys con data installation utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 5; 6-OCT-1997
 ;COPYRIGHT 1994 SAIC
 Q
 ;
MSG(%X,%FNUM,%MSG,%MULT,%PASS) ;Display message if DIC lookup failed
 ; Input:
 ; %X - Entry we tried to look up Using DIC
 ; %FNUM - File number
 ; %MULT - 0 Not a multiple
 ;         1 Multiple
 ; Output:
 ; %MSG - 1 - Flag We have a message
 N %TP,QT
 S %TP="File",%MULT=$G(%MULT),QT=$C(34)
 I %MULT S %TP="Multiple"
 D PG^INHSYS03(%PASS)
 W !!,%TP_" entry "_QT_$P(%X,U)_QT_" does not exist for "_%TP_" "_%FNUM,!,"or is a duplicate entry!",!
 I %MULT W "If entry is a pointer, it will have to be entered by hand",!
 S %MSG=1
 Q
RQ(%RQ) ;Required fields
 ;output:  %RQ - Required fields array
 N I
 F I=4000,4005,4006,4004,4011,4010,4012,4090.2,4020 S %RQ(I,.01)=""
 F I=.02,.04,.08 S %RQ(4000,I)=""
 Q
OMT(%OMT) ;fields to omit from updating
 ;Output:
 ;    %OMT - Fields to omit
 ;      If a file/field is found in this array, it will not
 ;      be updated in Pass 2
 ;
 N I
 F I=.01 S %OMT(4005.01,I)=""
 F I=1,.01 S %OMT(4005.02,I)=""
 F I=3.01,1,5,7.01,7.03,9 S %OMT(4005,I)=""
 F I=.03,7.02,7.04,7.05 S %OMT(4004,I)=""
 Q
SAVE(%SAV) ;Save values from import environment
 ; Output:
 ;  %SAV - File and field to save value from
 ;    Files/fields to restore the site specific data
 ;
 ; Programmers note:
 ;   The DEVICE field (.03) in the BACKGROUND PROCESS CONTROL (4004)
 ;   was originally part of the %SAV array. This field was
 ;   omitted for two reasons. First, the field should no longer be
 ;   used by the GIS. Secondly, the field has an input transform that
 ;   causes the ^DIE call at tag FILE^INHSYSUT to ask for user input
 ;   if the string being stuffed is found in more than one entry.
 ;   This file/field should not be removed from array %OMT. The value
 ;   of this field will be NULL after running the GIS Transaction
 ;   Mover.
 ;
 N I
 F I=.05 S %SAV(4000,I)=""
 F I=.02,5,6,7.02,7.04,7.05,1.01,1.2,1.3,1.4,1.5,1.6,1.8,1.9,1.1,1.11,1.12,1.14,10.01,10.02 S %SAV(4004,I)=""
 F I=3.01,1,5,7.01,7.02,7.03,9 S %SAV(4005,I)=""
 Q
FLSV(%XRF,%OIEN,%ROOT) ;Save old file in temp global
 ; Input
 ; %XRF - File number
 ; %OIEN - ien of file saving
 ; %ROOT - Root file name
 N %X,%Y
 S %X=%ROOT_%OIEN_")",%Y="^UTILITY(""INHSYSUT"",$J,%XRF,%OIEN)"
 M @%Y=@%X
 ;S %X=%ROOT_%OIEN_",",%Y="^UTILITY(""INHSYSUT"",$J,%XRF,%OIEN,"
 ;D %XY^%RCR
 Q
LIST(INSELTT) ;selectable list of parent and child transaction types
 ;output:
 ;  INSELTT --> array of selected transaction types
 ;local:
 ;  INPAR   --> parent TT
 ;  INCHLD  --> child TT
 ;
 ;Note: Does not put TT in INSELTT if the UNIQUE IDENTIFIER is
 ;      blank
 N INPAR,DWLRF,DWLB,DWL,DWLMK,DWLR,DWLMK1,INTT,I,INS,INIEN
 S INPAR="",I=0 F  S INPAR=$O(^INRHT("B",INPAR)) Q:INPAR=""  D
 .S INIEN=$O(^INRHT("B",INPAR,"")) Q:$P(^INRHT(INIEN,0),"^",4)=""
 .S I=I+1,INTT(1,I)=INPAR,INTT(1,I,0)=INIEN_"^c",INTT(2,I)="Child"
 .I $D(^INRHT("AC",INIEN)) S INTT(1,I,0)=INIEN_"^p",INTT(2,I)="Parent"
 S DWLRF="INTT",DWLB="2^5^12^60^8",DWL="HEL0,20F1WXXM-1A2"
 S DWL("TITLE")="D HDR^INHSYSUT"
 F  D ^DWL Q:DWLR'="E"  D EXPAND^INHSYSUT
 I " ^ ^^ "[(" "_DWLR_" ")!'$D(DWLMK) S INSELTT=0 Q
 S INS="" F I=1:1 S INS=$O(DWLMK(1,INS)) Q:'INS  D
 .S INSELTT=I,INSELTT(DWLMK(1,INS))=INTT(1,INS,0)_"^"_$$LB^UTIL(INTT(1,INS))
 Q
HDR ;header for list processor
 X DIJC("H")
 W $$SETXY^%ZTF(0,4),$$CENTER^INHUTIL("Transaction Type List",80)
 W $$SETXY^%ZTF(0,18),"Use <FIND> Key to find desired Transaction."
 W $$SETXY^%ZTF(0,19),"Use <SELECT> Key to pick a Transaction Type to process"
 X DIJC("L")
 Q
LOCKFL(INLKFLS,INEX) ;Lock files that will be used and check for zero node
 ; Input: INEX - if TRUE, then this is called during
 ;               IMPORT so only lock those files affected
 ; Output:
 ; INLKFLS - Locked files
 ; Returns 0 to continue 1 to quit
 I $D(IO)#10,$D(IO(0))#10 I IO'=IO(0) U IO(0)
 N %FNUM,%LFLG,%ROOT,%FILES,AA
 S %LFLG=0 S:'$D(INEX) INEX=0
 D XRF(.%FILES)
 F AA=1:1 S %FNUM=$P(%FILES,U,AA) Q:%FNUM=""  D  Q:INPOP
 .I INEX,'$D(^UTILITY("INHSYS",$J,%FNUM)) Q
 .S %ROOT=$P(^DIC(%FNUM,0,"GL"),"(")
 .I '$$LOCK(%ROOT,%FNUM) S (%LFLG,INPOP)=1
 .S INLKFLS(%ROOT)=%FNUM
 .S %ROOT=^DIC(%FNUM,0,"GL")_"0)"
 .I $D(@%ROOT)#10'=1 W *7,!,"File Corruption in the "_%FNUM_" file!" S (%LFLG,INPOP)=1
 I %LFLG D
 .W !!,"You will have to try later",!!!!
 .I $$CR^UTSRD(0,IOSL-1)
 I $D(IO)#10,$D(IO(0))#10 I IO'=IO(0) U IO
 Q %LFLG
LOCK(%ROOT,%FILNM) ;Lock other users from this file
 ; %ROOT - Global file node to lock
 ; %FILNM - File Name
 N INLOK S INLOK=1
 L +@%ROOT:3
 E  S INLOK=0 W *7,!,"Another terminal is editing the "_%FILNM_" file!"
 Q INLOK
UNLK(%FILE) ;Unlock file
 N I F I=1:1:3 L -@%FILE
 Q
RPRT1(%LEVEL,%FILNM,ND) ;Do report
 ; Input:
 ; %LEVEL - Level of pointer
 ; %FILNM - File Number
 ; ND - Node
 N I
 D PG^INHSYS03(1)
 W ! F I=1:1:%LEVEL W "."
 W ?%LEVEL,%FILNM,?%LEVEL+14,$P($G(^DIC(%FILNM,0)),U),?%LEVEL+42,".01",?%LEVEL+48
 I %FILNM'=4020 W $P(@(ND),U)
 E  W $P($G(^INRHT($P(@(ND),U),0)),U)
 W !,?%LEVEL,ND
 Q
EXPAND ;Expand logic for list processor
 ;
 N INS,DA,DIC
 I '$D(DWLMK) W "SELECT an item to expand on.",*7
 E  D
 .S INS="" S INS=$O(DWLMK(1,INS))
 .S DA=+@(DWLRF_"(1,"_INS_",0)"),DIC="^INRHT("
 .D EN^DIQ
 I $$CR^UTSRD(0,IOSL-1)
 Q
FILE(DA,%DATA,%FLDNUM,DIE,INREPRT) ;file data
 ; Input:
 ; DA - ien and "Multiple entry"
 ; %DATA - What to file
 ; %FLDNUM - Field Number
 ; DIE - Global to file
 ; INREPRT - 0 - No report
 ;           1 - Report
 N X,DG,DNM,DQ,DIEZ,D0,D1,D2,D3,D4,D5,D6,D7,INY,FILNUM
 ;
 ; Don't stuff data for fields that are site specific except
 ;    on Pass 3
 S FILNUM=$P(@(DIE_"0)"),U,2) I %PASS'=3,$D(%SAV(FILNUM,%FLDNUM))!($D(%OMT(FILNUM,%FLDNUM))) Q
 I INREPRT=2 W ?70,DIE
 I DA'>0 D  Q
 .W !,"NON-EXISTENT OR DUPLICATE ENTRY! for "_$G(DIE)_" field #"_$G(%FLDNUM)_" Data: "_$G(%DATA)_" %XNODE="_$G(%XNODE)
 .D FLSUMERR^INHSYS11(FILNUM,%FLDNUM,DA,$P($G(%XNODE),U),DIE)
 S DR="S INY=0;"_%FLDNUM_"///^S X=%DATA;S INY=1"
 D ^DIE
 I '$G(INY) D
 .W ?56," NO DATA FILED for ",DIE," field #",%FLDNUM," Data: ",%DATA
 .D FLSUMERR^INHSYS11(FILNUM,%FLDNUM,DA,%DATA,DIE)
 Q
DATA(%B,%P,%D) ;retrieve the data from the buffer
 ;input:
 ;  %B - buffer
 ;  %P - If an integer, uparrow piece to return
 ;       If the first character is "E", then extract data
 ;output:
 ;  %D - Data
 S %D=""
 I $E(%P)="E",$D(@%B)#2 S %D=$E(@%B,+$E(%P,2,99),+$P(%P,",",2)) Q
 I $D(@%B)#2 S %D=$P(@%B,U,%P)
 Q
RUT(%ROOT) ;modify global root to indirection format
 ;%ROOT - Global root
 N Y
 ;get last value of root,set to all but last value & concact w/ ) or ""
 S Y=$E(%ROOT,$L(%ROOT)),Y=$E(%ROOT,1,$L(%ROOT)-1)_$S(Y=",":")",1:"")
 Q Y
 ;
UP(FN) ;goes up & up searching for the top level file number
 ;input:
 ;  FN - the current sub-level file number
 N Y
 I '$D(^DD(FN,0,"UP")) S Y=FN
 E  S Y=$$UP(^("UP"))
 Q Y
 ;
PG(%PASS) ;Page check
 ; Input:
 ;     %PASS - Which PASS
 I IOSL-5'>$Y D
 .I $E(IOST)="C",INCR,$$CR^UTSRD(0,IOSL-1)
 .D HEAD(%PASS)
 Q
HEAD(%PASS) ;header for destination report
 ; Input:
 ;   %PASS - Which pass is being run
 W @IOF
 I %PASS=1 W $$CENTER^INHUTIL("Pass 1 Required Fields",80)
 I %PASS=2 W $$CENTER^INHUTIL("Pass 2 All Fields",80)
 W !!,"File Number",?14,"File Name",?42,"Field Number",?56,"Data"
 W !,"^Root(IEN",!
 Q
WP(FIL,FLD) ;word process field
 ;input:
 ;  FIL - file number
 ;  FLD - field number
 ;  Returns 0 false 1 true
 N Y
 I $P(^DD(FIL,FLD,0),U,2) S Y=$$WP(+$P(^(0),U,2),.01)
 Q $P(^(0),U,2)["W"
 ;
XRF(%FILES) ;cross reference of files and fields requiring some resolution
 ; Output:
 ; %FILES(FILE#)=fields
 ;':' delimiter separates field # and sub-file #
 ;',' delimiter separates sub-file # and sub-field #
 ;';' delimiter separates fields
 ;i.e. field[:sub-file,sub-field,...][;field...] etc.
 ; Subnodes used at RSLV^INHSYS03
 S %FILES="4012^4005^4011^4000^4004^4010^4090.2^4020^4006"
 S %FILES(4012)=".02;10:4012.02,.01;50"
 S %FILES(4005)=".02;.1"
 S %FILES(4011)=".05;1:4011.01,.01,.11;2:4011.02,.01;100;101"
 S %FILES(4000)=".02;.03;.06;.09;.17"
 S %FILES(4004)=".07"
 S %FILES(4010)="1:4010.01,.01"
 S %FILES(4090.2)=".02"
 S %FILES(4020)=".01;.02"
 S %FILES(4006)=".03"
 Q
