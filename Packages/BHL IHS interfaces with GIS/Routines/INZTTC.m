INZTTC ;WOM; 29 Nov 95 11:41; CMS Transaction Type Create
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;;
 ;Copyright 1995 SAIC
 Q
CRE ; Create a TRANSACTION TYPE ELEMENT
 ; Also used by Replace, CIG, and RIG
 ; Input: %ACT = The menu number corresponding to
 ;        the CMS function requested by user.
 ;        Possible values shown at tag CRDEF
 ;==============================================
 N I,INSELTT,DIC,FRNAME,RTN,PAUSE,Y,ZCMSERC,%,%U,%UTILITY,%RTN
 S %=$ZSE("*.*"),$ZT="" I $P(%,":")=$P(%LIB,":")!($E(%,1,$F(%,"]")-1)=RLIB) D  Q
 .W !,B1,"This option is not available when your default directory is"
 .W !,"the library directory!!",B0,! H 2
 S PAUSE=1,%U=$P($ZC(%UCI),",",7),ZCMSERC=0
 D VAR^DWUTL
 S DIC="^INRHT(",DIC(0)="AEQZ",DIC("A")="Enter Transaction Type Name: "
 D ^DIC I Y<1 W:0 !,B1,"Transaction Type not found",B0,! Q
 I $P(Y(0),"^",4)="" W !,B1,"Invalid UNIQUE IDENTIFIER - Aborting!",B0,! Q
 S INSELTT=1,(INSELTT(1),RTN)=+Y,FRNAME=$$TR(Y(0,0))
 I %ACT=5!(%ACT=7),'$$CKRES(FRNAME) Q
 ;===============================================
 D REMARK^ZCMS41
 N %EN W ! S ZCMSGO=""
 D ^ZCMSENV I ZCMSERR K ^UTILITY($J) Q
 ;UPDATE THE DEFAULT ENVIRONMENT
 S DEFENV=$P(^ZCMSENV($J,"DEF"),"^",1),ULIB=$P(^ZCMSENV($J,"DEF"),"^",2)
 S DEF=1,DEFLIB=ULIB,DEFDIR="DISK$CHCS_LIBRARY:["_DEFLIB_"]"
 S ENVCNT=^ZCMSENV($J)-1
 ;==============================================
 U 0 W !!,"Attempting to update the default library...",!
 D CRDEF(FRNAME)
 Q
CKRES(FRNAME) ;Check reservation
 ;FRNAME - Element name
 N ZCMSRES,ZCMSRESU
 D SHORES^ZCMSFNC(FRNAME)
 I 'ZCMSRES W *7,!,FRNAME," not reserved!" Q 0
 I ZCMSRES,(UNAM'=ZCMSRESU) W *7,!," Cannot replace ",FRNAME,"! This element is reserved by "_ZCMSRESU,! Q 0
 Q 1
 ;===========================================
COMP() ; Compile IBxxxxnn and IBxxxxW programs for CREATE/CIG
 ; Returns 1 if successful, 0 if not
 N INPOP S INPOP=0 D COMP^INHSYS(.INSELTT,0) Q:INPOP 0
 D UTL I '$D(^UTILITY($J)) W !,B1,"No Transaction Type Created, aborting!",!,B0,! Q 0
 Q 1
 ;==========================================
UTL ; Get all IBxxxxnn and IBxxxxW programs into ^UTILITY($J
 S RTN="IB"_$$ID^INHSYS04(RTN),%RTN=RTN K ^UTILITY($J)
 D ORDER^INHUT3("^ ","%RTN",RTN,"$E(%RTN,1,$L(RTN))'=RTN","S ^UTILITY($J,%RTN)=""""")
 Q
 ;===========================================
CRDEF(FRNAME) ; Update Library
 S FILE2=RLIB_FRNAME,KEEP=0
 ; VALUES FOR %ACT, calculated by program ZCMS
 ; 1= CREATE      2= FETCH       3= RESERVE
 ; 4= UNRESERVE   5= REPLACE     6= CIG
 ; 7= RIG         8= REFRESH
 ; Used for CREATE,REPLACE,CIG and RIG only
 N FL S FL=1
 ;I %ACT=1!(%ACT=6)!(%ACT=7) D  Q:'FL
 D  Q:'FL
 .I $ZSE(FILE2)'="" U 0 W !,FRNAME," already exits in ",ULIB,! Q:%ACT=1!(%ACT=6)
 .S FL=$$COMP() I FL D SAVEROU(FRNAME) D:%ACT'=7&(%ACT'=5) CREATE^ZCMS41(FRNAME,KEEP)
 I %ACT'=5,%ACT'=6,%ACT'=7 Q
 I %ACT'=6 D  Q:'FL
 .D SHORES^ZCMSFNC(FRNAME) I 'ZCMSRES&(%ACT=5!(%ACT=7)) W *7,!,FRNAME," not reserved!" S FL=0 Q
 .I ZCMSRES,(UNAM'=ZCMSRESU) W *7,!," Cannot replace ",FRNAME,"! This element is reserved by "_ZCMSRESU,! S FL=0 Q
 .D REPLACE^ZCMS41(FRNAME,KEEP)
 I %ACT=6!(%ACT=7) W !,B1 S %DUMMY=$ZC(CMS,"INSERT GEN/ALWAYS "_FRNAME_" "_CNAME_" "_REMARK) W !,B0
 Q
 ;===========================================
TR(X) ; Calculate Valid VMS filename for TRANSACTION TYPE by translating
 ; " " to "_", all other invalid characters to "-", and adding
 ; a ".TT" extension.
 ; Input should be the TRANSACTION TYPE NAME field
 S:$L(X)>35 X=$$SUM(X)
 Q $$TR^INHUT3(X)_".TT"
 ;==========================================
SUM(X) ; Calculate new VMS filename based on a check sum
 ; if length > 35 since VMS filenames can only be
 ; 39 characters (not including extention)
 N I,SUM,A S SUM=0
 F I=36:1 S A=$E(X,I) Q:A=""  S SUM=SUM+$A($E(X,I))
 Q $E(X,1,35)_$E(SUM,1,4)
 ;=====================================================
SAVEROU(FRNAME) ;SAVE MULTIPLE ROUTINES AS ONE ELEMENT/VMS FILE
 ; Programs/^UTILITY($J, created in function COMP
 Q:'$D(^UTILITY($J))  N RNAME
 S RNAME=$$OPENSEQ^%ZTFS1(FRNAME,"BW") U FRNAME
 W "Saved by %RS from "_$ZU(0)_" on "_$P($ZH,",",3)
 W !,"For CMS"
 S RNAME="" F  S RNAME=$O(^UTILITY($J,RNAME)) Q:RNAME=""  W !,RNAME,! X "ZL @RNAME ZP"
 W ! I $$CLOSESEQ^%ZTFS1(FRNAME)
 U 0 W !
 Q
