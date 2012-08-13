CIAU ;MSC/IND/DKM - General purpose utilities;12-Mar-2008 14:32;DKM
 ;;1.2;CIA UTILITIES;**1**;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Replaces delimited arguments in string, returning result
MSG(%CIATXT,%CIADLM,%CIARPL) ;EP
 N %CIAZ1,%CIAZ2
 I $$NEWERR^%ZTER N $ET S $ET=""
 S:$G(%CIADLM)="" %CIADLM="%"
 S %CIAZ2="",@$$TRAP^CIAUOS("M1^CIAU")
 S:$G(%CIARPL,1) %CIATXT=$TR(%CIATXT,"~","^")
 F  Q:%CIATXT=""  D
 .S %CIAZ2=%CIAZ2_$P(%CIATXT,%CIADLM),%CIAZ1=$P(%CIATXT,%CIADLM,2),%CIATXT=$P(%CIATXT,%CIADLM,3,999)
 .I %CIAZ1="" S:%CIATXT'="" %CIAZ2=%CIAZ2_%CIADLM
 .E  X "S %CIAZ2=%CIAZ2_("_%CIAZ1_")"
M1 Q %CIAZ2
 ; Case-insensitive string comparison
 ; Returns 0: X=Y, 1: X>Y, -1: X<Y
STRICMP(X,Y) ;EP
 S X=$$UP^XLFSTR(X),Y=$$UP^XLFSTR(Y)
 Q $S(X=Y:0,X]]Y:1,1:-1)
 ; Output an underline X bytes long
UND(X) ;EP
 Q $$REPEAT^XLFSTR("-",$G(X,$G(IOM,80)))
 ; Truncate a string if > Y bytes long
TRUNC(X,Y) ;EP
 Q $S($L(X)'>Y:X,1:$E(X,1,Y-3)_"...")
 ; Formatting for singular/plural
SNGPLR(CIANUM,CIASNG,CIAPLR) ;EP
 N CIAZ
 S CIAZ=CIASNG?.E1L.E,CIAPLR=$G(CIAPLR,CIASNG_$S(CIAZ:"s",1:"S"))
 Q $S('CIANUM:$S(CIAZ:"no ",1:"NO ")_CIAPLR,CIANUM=1:"1 "_CIASNG,1:CIANUM_" "_CIAPLR)
 ; Convert code to external form from set of codes
SET(CIACODE,CIASET) ;EP
 N CIAZ,CIAZ1
 F CIAZ=1:1:$L(CIASET,";") D  Q:CIAZ1'=""
 .S CIAZ1=$P(CIASET,";",CIAZ),CIAZ1=$S($P(CIAZ1,":")=CIACODE:$P(CIAZ1,":",2),1:"")
 Q CIAZ1
 ; Replace each occurrence of CIAOLD in CIASTR with CIANEW
SUBST(CIASTR,CIAOLD,CIANEW) ;EP
 N CIAP,CIAL1,CIAL2
 S CIANEW=$G(CIANEW),CIAP=0,CIAL1=$L(CIAOLD),CIAL2=$L(CIANEW)
 F  S CIAP=$F(CIASTR,CIAOLD,CIAP) Q:'CIAP  D
 .S CIASTR=$E(CIASTR,1,CIAP-CIAL1-1)_CIANEW_$E(CIASTR,CIAP,9999)
 .S CIAP=CIAP-CIAL1+CIAL2
 Q CIASTR
 ; Trim leading (Y=-1)/trailing (Y=1)/leading & trailing (Y=0) spaces
TRIM(X,Y) ;EP
 N CIAZ1,CIAZ2
 S Y=+$G(Y),CIAZ1=1,CIAZ2=$L(X)
 I Y'>0 F CIAZ1=1:1 Q:$A(X,CIAZ1)'=32
 I Y'<0 F CIAZ2=CIAZ2:-1 Q:$A(X,CIAZ2)'=32
 Q $E(X,CIAZ1,CIAZ2)
 ; Format a number with commas
FMTNUM(CIANUM) ;EP
 N CIAZ,CIAZ1,CIAZ2,CIAZ3
 S:CIANUM<0 CIANUM=-CIANUM,CIAZ2="-"
 S CIAZ3=CIANUM#1,CIANUM=CIANUM\1
 F CIAZ=$L(CIANUM):-3:1 S CIAZ1=$E(CIANUM,CIAZ-2,CIAZ)_$S($D(CIAZ1):","_CIAZ1,1:"")
 Q $G(CIAZ2)_$G(CIAZ1)_$S(CIAZ3:CIAZ3,1:"")
 ; Convert X to base Y padded to length L
BASE(X,Y,L) ;EP
 Q:(Y<2)!(Y>62) ""
 N CIAZ,CIAZ1
 S CIAZ1="",X=$S(X<0:-X,1:X)
 F  S CIAZ=X#Y,X=X\Y,CIAZ1=$C($S(CIAZ<10:CIAZ+48,CIAZ<36:CIAZ+55,1:CIAZ+61))_CIAZ1 Q:'X
 Q $S('$G(L):CIAZ1,1:$$REPEAT^XLFSTR(0,L-$L(CIAZ1))_$E(CIAZ1,1,L))
 ; Convert a string to its SOUNDEX equivalent
SOUNDEX(CIAVALUE) ;EP
 N CIACODE,CIASOUND,CIAPREV,CIACHAR,CIAPOS,CIATRANS
 S CIACODE="01230129022455012623019202"
 S CIASOUND=$C($A(CIAVALUE)-(CIAVALUE?1L.E*32))
 S CIAPREV=$E(CIACODE,$A(CIAVALUE)-64)
 F CIAPOS=2:1 S CIACHAR=$E(CIAVALUE,CIAPOS) Q:","[CIACHAR  D  Q:$L(CIASOUND)=4
 .Q:CIACHAR'?1A
 .S CIATRANS=$E(CIACODE,$A(CIACHAR)-$S(CIACHAR?1U:64,1:96))
 .Q:CIATRANS=CIAPREV!(CIATRANS=9)
 .S CIAPREV=CIATRANS
 .S:CIATRANS'=0 CIASOUND=CIASOUND_CIATRANS
 Q $E(CIASOUND_"000",1,4)
 ; Display formatted title
TITLE(CIATTL,CIAVER,CIAFN) ;EP
 I '$D(IOM) N IOM,IOF S IOM=80,IOF="#"
 S CIAVER=$G(CIAVER,"1.0")
 S:CIAVER CIAVER="Version "_CIAVER
 U $G(IO,$I)
 W @IOF,$S(IO=IO(0):$C(27,91,55,109),1:""),*13,$$ENTRY^CIAUDT(+$H_","),?(IOM-$L(CIATTL)\2),CIATTL,?(IOM-$L(CIAVER)),CIAVER,!,$S(IO=IO(0):$C(27,91,109),1:$$UND),!
 W:$D(CIAFN) ?(IOM-$L(CIAFN)\2),CIAFN,!
 Q
 ; Display required header for menus
MNUHDR(PKG,VER) ;EP
 Q:$D(ZTQUEUED)
 Q:$E($G(IOST),1,2)'="C-"
 N X,%ZIS,IORVON,IORVOFF,MNU
 S MNU=$P($G(XQY0),U,2),MNU(0)=$P($G(XQY0),U),VER=$G(VER)
 S X=$$GETPKG($S($L($G(PKG)):PKG,1:MNU(0)))
 I $L(X) D
 .S PKG=$P(X,U,2),X=$P(X,U,3)
 .I $L(X),'$L(VER) S VER=$$VERSION^XPDUTL(X)
 S:VER VER="Version "_VER
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF,!?(IOM-$L(MNU)\2),MNU,!
 Q
 ; Execute menu action, preserving menu headers
MNUEXEC(EXEC,PAUSE) ;EP
 D MNUHDR()
 X EXEC
 R:$G(PAUSE)&'$D(ZTQUEUED) !,"Press ENTER or RETURN to continue...",PAUSE:$G(DTIME,300),!
 Q
 ; Action for editing parameters from menu
MNUPARAM(PARAM) ;EP
 D MNUEXEC("D EDITPAR^XPAREDIT($G(PARAM,$P(XQY0,U)))")
 Q
 ; Action for editing parameter template from menu
MNUTEMPL(TMPL) ;EP
 D MNUEXEC("D TEDH^XPAREDIT($G(TMPL,$P(XQY0,U)),""BA"")")
 Q
 ; Return package reference from namespace
 ; Returns ien^pkg name^pkg namespace
GETPKG(NAME) ;EP
 N PKG,IEN
 S PKG=NAME
 F  S PKG=$O(^DIC(9.4,"C",PKG),-1) Q:$E(NAME,1,$L(PKG))=PKG
 S IEN=$S($L(PKG):+$O(^DIC(9.4,"C",PKG,0)),1:0)
 Q $S(IEN:IEN_U_$P(^DIC(9.4,IEN,0),U)_U_PKG,1:"")
 ; Create a unique 8.3 filename
UFN(Y) ;EP
 N X
 S Y=$E($G(Y),1,3),X=$$BASE($R(100)_$J_$TR($H,","),36,$S($L(Y):8,1:11))_Y
 Q $E(X,1,8)_"."_$E(X,9,11)
 ; Return formatted SSN
SSN(X) ;EP
 Q $S(X="":X,1:$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,12))
 ; Performs security check on patient access
DGSEC(Y) ;EP
 N DIC
 S DIC(0)="E"
 D ^DGSEC
 Q $S(Y<1:0,1:Y)
 ; Displays spinning icon to indicate progress
WORKING(CIAST,CIAP,CIAS) ;EP
 Q:'$D(IO(0))!$D(ZTQUEUED) 0
 N CIAZ
 S CIAZ(0)=$I,CIAS=$G(CIAS,"|/-\"),CIAST=+$G(CIAST)
 S CIAST=$S(CIAST<0:0,1:CIAST#$L(CIAS)+1)
 U IO(0)
 W:'$G(CIAP) *8,*$S(CIAST:$A(CIAS,CIAST),1:32)
 R *CIAZ:0
 U CIAZ(0)
 Q CIAZ=94
 ; Ask for Y/N response
ASK(CIAP,CIAD,CIAZ) ;EP
 S CIAD=$G(CIAD,"N")
 S CIAZ=$$GETCH(CIAP_"? ","YN",,,,CIAD)
 S:CIAZ="" CIAZ=$E(CIAD)
 W !
 Q $S(CIAZ[U:"",1:CIAZ="Y")
 ; Pause for user response
PAUSE(CIAP,CIAX,CIAY) ;EP
 Q $$GETCH($G(CIAP,"Press RETURN or ENTER to continue..."),U,.CIAX,.CIAY)
 ; Single character read
GETCH(CIAP,CIAV,CIAX,CIAY,CIAT,CIAD) ;EP
 N CIAZ,CIAC
 W:$D(CIAX)!$D(CIAY) $$XY($G(CIAX,$X),$G(CIAY,$Y))
 W $G(CIAP),$E($G(CIAD)_" "),*8
 S CIAT=$G(CIAT,$G(DTIME,99999999)),CIAD=$G(CIAD,U),CIAC=""
 S:$D(CIAV) CIAV=$$UP^XLFSTR(CIAV)_U
 F  D  Q:'$L(CIAZ)
 .R CIAZ#1:CIAT
 .E  S CIAC=CIAD Q
 .W *8
 .Q:'$L(CIAZ)
 .S CIAZ=$$UP^XLFSTR(CIAZ)
 .I $D(CIAV) D
 ..I CIAV[CIAZ S CIAC=CIAZ
 ..E  W *7,*32,*8 S CIAC=""
 .E  S CIAC=CIAZ
 W !
 Q CIAC
 ; Position cursor
XY(DX,DY) ;EP
 D:$G(IOXY)="" HOME^%ZIS
 S DX=$S(+$G(DX)>0:+DX,1:0),DY=$S(+$G(DY)>0:+DY,1:0),$X=0
 X IOXY
 S $X=DX,$Y=DY
 Q ""
 ; Parameterized calls to date routines
DT(CIAD,CIAX) ;EP
 N %D,%P,%C,%H,%I,%X,%Y,CIAZ
 D DT^DILF($G(CIAX),CIAD,.CIAZ)
 W:$D(CIAZ(0)) CIAZ(0),!
 Q $G(CIAZ,-1)
DTC(X1,X2) ;EP
 N X3
 S X2=$$DTF(X1)+X2,X1=X1\1,X3=X2\1,X2=X2-X3
 S:X2<0 X3=X3-1,X2=X2+1
 Q $$FMADD^XLFDT(X1,X3)+$J($$DTT(X2),0,6)
DTD(X1,X2) ;EP
 Q $$FMDIFF^XLFDT(X1\1,X2\1)+($$DTF(X1)-$$DTF(X2))
DTF(X) S X=X#1*100
 Q X\1*3600+(X*100#100\1*60)+(X*10000#100)/86400
DTT(X) S X=X*86400
 Q X\3600*100+(X#3600/3600*60)/10000
