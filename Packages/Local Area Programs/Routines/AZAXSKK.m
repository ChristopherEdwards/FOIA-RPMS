AZAXSKK	;IHS/PHXAO/AEF - REPAIR SECURITY KEYS
	;;1.0;PHXAO UTILITY ROUTINES;;MAR 19, 2009
	;
DESC	;----- ROUTINE DESCRIPTION
	;;This routine will remove keys assigned to users before the
	;;specified date.
	;;It will then remove the keys contained in the ^XUSEC
	;;global and rebuild the ^XUSEC global based on the
	;;keys belonging to users in the New Person file #200.
	;; 
	;;It is recommended that you obtain a backup copy of the
	;;^XUSEC global before running this routine.
	;;
	;;$$END
	;
	N I,X F I=1:1 S X=$T(DESC+I) Q:X["$$END"  D EN^DDIOL($P(X,";;",2))
	Q
EN	;EP -- MAIN ENTRY POINT
	;
	N DATE,OUT
	;
	D ^XBKVAR
	D HOME^%ZIS
	;
	S OUT=0
	S DATE=""
	D DESC
	D PAWS(.OUT)
	Q:OUT
	D DATE(.DATE)
	Q:'DATE
	D USR(DATE)
	Q:OUT
	D KILL
	D RBLD
	Q
USR(DATE)	;
	;----- REMOVE OLD KEYS FROM USERS
	;
	N CNT,D0
	;
	D EN^DDIOL("REMOVING OLD KEYS FROM USERS...")
	;
	S CNT=0
	S D0=0
	F  S D0=$O(^VA(200,D0)) Q:'D0  D
	. D USR1(D0,DATE,.CNT)
	Q
USR1(D0,DATE,CNT)	;
	;----- REMOVE OLD KEYS FROM ONE USER
	;
	N D1,DA,DIK,X,Y
	;
	S D1=0
	F  S D1=$O(^VA(200,D0,51,D1)) Q:'D1  D
	. S CNT=$G(CNT)+1
	. W:'(CNT#100) "."
	. Q:$P($G(^VA(200,D0,51,D1,0)),U,3)>DATE
	. S DA=D1
	. S DA(1)=D0
	. S DIK="^VA(200,"_DA(1)_",51,"
	. D ^DIK
	Q
KILL	;----- KILL KEYS IN ^XUSEC GLOBAL
	;
	N X
	;
	D EN^DDIOL("REMOVING KEYS FROM ^XUSEC GLOBAL...")
	S X="A"
	F  S X=$O(^XUSEC(X)) Q:X']""  D
	. K ^XUSEC(X)
	Q
RBLD	;----- REBUILD ^XUSEC GLOBAL
	;
	D EN^DDIOL("REBUILDING ^XUSEC GLOBAL...")
	D IXKEY^XUSMGR
	Q
PAWS(OUT) ;
	;----- ISSUE 'RETURN' PROMPT
	;
	N DIR,X,Y
	S OUT=0
	I $E($G(IOST))="C"  D
	. W !
	. S DIR(0)="E"
	. D ^DIR
	. I 'Y S OUT=1
	Q
DATE(DATE)	;
	;----- ASK WHICH DATE
	;
	N DIR,DIRUT,DTOUT,DUOUT,X,Y
	;
	S DATE=""
	D EN^DDIOL("","","!")
	S DIR(0)="DO^::E"
	S DIR("A")="Delete keys assigned before which DATE"
	S DIR("?")="Enter a date or '^' to quit."
	D ^DIR
	Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
	Q:Y=""
	S DATE=Y
	Q                
