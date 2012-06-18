AZX1SMOD	;IHS/PAO/AEF - COMPARE KIDS TRANSPORT GLOBAL WITH LOCAL SOFTWARE MODS
	;;1.0;ANNE'S SPECIAL ROUTINES;;JUN 26, 2007
	;
DESC	;----- ROUTINE DESCRIPTION
	;;  
	;;This routine checks the contents of the specified KIDS transport
	;;patch or package file against the contents of the AZX1 LOCAL
	;;SOFTWARE MODIFICATIONS to see if any mods will be clobbered by the
	;;patch/package installation.
	;;  
	;;$$END
	;
	N I,X F I=1:1 S X=$T(DESC+I) Q:X["$$END"  W !,$P(X,";;",2)
	Q
EN	;EP -- MAIN ENTRY POINT
	;
	N FILE,OUT,PATH
	;
	D DESC
	;
	D GETFILE(.PATH,.FILE)
	;
	D LOOP
	;
	D PAWS(.OUT)
	;
	K ^TMP("AZX1",$J)
	Q
LOOP	;----- LOOP THROUGH ^XTMP("XPDI") GLOBAL
	;
	N CNT,D0,D1,D2,ITEM,X
	;
	Q:'$D(^TMP("AZX1",$J))
	;
	W !!,"Checking AZX1 LOCAL SOFTWARE MODIFICATIONS file...",!!
	;
	S CNT=0
	S D0=0
	F  S D0=$O(^TMP("AZX1",$J,"BLD",D0)) Q:'D0  D
	. S D1=0
	. F  S D1=$O(^TMP("AZX1",$J,"BLD",D0,"KRN",D1)) Q:'D1  D
	. . S ITEM=""
	. . F  S ITEM=$O(^TMP("AZX1",$J,"BLD",D0,"KRN",D1,"NM","B",ITEM)) Q:ITEM']""  D
	. . . S X=ITEM
	. . . I "^.4^.401^.402^.403"[D1 S X=$P(X,"    FILE")
	. . . D PRT(D1,X,.CNT)
	;
	W !!,CNT," modifications found!"
	Q
PRT(D1,X,CNT)	;
	;----- PRINT ONE ITEM
	;
	;      D1  =  ITEM TYPE
	;      X   =  ITEM NAME
	;
	N TYPE
	;
	Q:'$D(^AZX1SMOD("D",D1,X))
	;
	S CNT=$G(CNT)+1
	S TYPE=$$SOC(D1,1993001,.04)
	W !,TYPE," '",ITEM,"' appears to have a local modification."
	Q
SOC(X,FIL,FLD)	;
	;---- RESOLVE SET OF CODES
	;
	;     X   = CODE TO RESOLVE
	;     FIL = FILE CONTAINING SOC FIELD
	;     FLD = SOC FIELD
	; 
	N Y,Z
	;
	S Y=""
	I X]"" D
	. S Z=$G(^DD(FIL,FLD,0))
	. I Z[X D
	. . S Y=$P($P(Z,X_":",2),";")
	Q Y
ASK(D0)	;
	;----- PROMPT FOR INSTALL NAME
	;
	N DIC,X,Y
	;
	S DIC="^XPD(9.7,"
	S DIC(0)="AEMQ"
	S DIC("A")="Enter INSTALL NAME: "
	D ^DIC
	S D0=+Y
	Q
GETFILE(PATH,FILE)	;
	;----- READ CONTENTS OF KIDS TRANSPORT FILE AND PUT IN ^TMP GLOBAL
	;
	S OUT=0
	;
	D PATH(.PATH,.OUT)
	Q:OUT
	D FILE(.FILE,.OUT)
	Q:OUT
	;
	D READ(PATH,FILE,.OUT)
	Q:OUT
	;
	Q
READ(PATH,FILE,OUT) ;
	;----- READ CONTENTS OF DATA FILE AND PUT INTO ^TMP GLOBAL
	;
	N CNT,END,GR,I,POP,X,Y
	;
	K ^TMP("AZX1",$J)
	S GR="^TMP(""AZX1"","_$J_","
	S OUT=0
	S END=0
	S CNT=0
	W !,"READING FILE "_PATH_FILE_" ..."
	D OPEN^%ZISH("FILE",PATH,FILE,"R")
	I POP D
	. W !?5,"UNABLE TO OPEN FILE '"_PATH_FILE_"'"
	. S OUT=1
	Q:OUT
	U IO R X,Y
	Q:X'["KIDS Distribution"
	U IO R X,Y
	Q:X'["**KIDS**"
	U IO R X,Y
	Q:X'["**INSTALL NAME**"
	F I=1:1 D  Q:END
	. U IO R X,Y:DTIME
	. I $$STATUS^%ZISH S END=1
	. Q:END
	. I X["**END**" S END=1
	. Q:END
	. I Y["**END**" S END=1
	. Q:END
	. Q:X']""
	. Q:$E(X,$L(X))'=")"
	. S CNT=CNT+1
	. S @(GR_X)=Y
	. I '(CNT#100) U 0 W "."
	;
	D CLOSE^%ZISH("FILE")
	Q
PATH(PATH,OUT) ;
	;----- PROMPT FOR DIRECTORY PATH WHERE DATA FILE RESIDES
	;
	N DIR,DIRUT,DTOUT,DUOUT,X,Y
 	;
	S PATH=""
	S OUT=0
	S DIR(0)="FA"
	S DIR("A")="Select DIRECTORY: "
	S DIR("?")="Enter the PATH or DIRECTORY where the data file resides, e.g., D:\EXPORT\"
	D ^DIR
	I $D(DTOUT)!($D(DIRUT))!($D(DUOUT)) S OUT=1
	Q:OUT
	S X=Y
	D DF^%ZISH(.X)
	S PATH=X
	Q
FILE(FILE,OUT) ;
	;----- PROMPT FOR DATA FILE
	;
	N DIR,DIRUT,DIROUT,DTOUT,DUOUT,X,Y
	;
	S FILE=""
	S DIR(0)="FA"
	S DIR("A")="Select FILE: "
	S DIR("?")="Enter the name of the data file"
	D ^DIR
	I $D(DTOUT)!($D(DIRUT))!($D(DUOUT))!($D(DIROUT))!(Y[U) S OUT=1
	Q:$G(OUT)
	S FILE=Y
	Q
PAWS(OUT) ;
	;----- ISSUE 'RETURN' PROMPT
	;
	N DIR,X,Y
	Q:$E($G(IOST),1,2)'="C-"
	W !
	S DIR(0)="E"
	D ^DIR
	I 'Y S OUT=1
	Q    
