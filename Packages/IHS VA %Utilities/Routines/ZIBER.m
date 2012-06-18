ZIBER ;BFH;MSM ERROR REPORT; [ 07/17/91  12:19 PM ]
 ;COPYRIGHT MICRONETICS DESIGN CORP @1982
 S $ZT="ERROR^ZIBER",%DEV=$I
 W !?10,$P($P($ZV,","),"-")," - Error Report Utility"
 I '$D(^UTILITY("%ER")) W !!,"NO ERRORS HAVE BEEN LOGGED" G EXIT
 D ^%GUCI K %,%UCN
 G PACKAGE
OPT I $D(%AZ("PACKAGE")) K %AZ G PACKAGE
 U 0 W !!,?5,"1 - Display errors",!,?5,"2 - Print errors",!,?5,"3 - Erase errors",!,?5,"4 - Summarize errors"
 R !!,"Enter option: ",%X G EXIT:"^Q"=%X!("^"[%X) 
 I %X="?" S %XQF="7,8,9,6,3,4" D QUE^ZIBER1 G OPT
 I $E("Display",1,$L(%X))=%X W $E("Display",$L(%X)+1,99) S %SUM=0 G DAT
 I %X=1 W " - Display" S %SUM=0 G DAT
 I $E("Print",1,$L(%X))=%X W $E("Print",$L(%X)+1,99) G PRINT^ZIBER1
 I %X=2 W " - Print" G PRINT^ZIBER1
 I $E("Erase",1,$L(%X))=%X W $E("Erase",$L(%X)+1,99) G DELETE^ZIBER1
 I %X=3 W " - Erase" G DELETE^ZIBER1
 I $E("Summarize",1,$L(%X))=%X W $E("Summarize",$L(%X)+1,99) G DAT1
 I %X=4 W " - Summarize" G DAT1
 W *7," ..Invalid" G OPT
 ;
PACKAGE W ! K DIC S DIC(0)="QEAM",DIC=9.4 D ^DIC G EXIT:Y<1!$D(DTOUT)!$D(DUOUT)  S %AZ("PACKAGE")=$P(^DIC(9.4,+Y,0),U,2) D ^%GUCI K %,%UCN G DAT1
 ;
DAT S %DIS=1,FLG=0 R !!,"Enter date > ",%X G OPT:"^"[%X,EXIT:%X="^Q",DINFO:%X="?" D DCHK^ZIBER1 G DAT:%QF,NE
 ;
DAT1 S %DEL=0,%DIS=0,%SUM=1 ;ENTRY POINT TO SUMMARIZE ERRORS
 G DAT^ZIBER1
DINFO S %J=$N(^UTILITY("%ER",-1)) I %J<0 W !!,"No errors have been logged for this UCI" G EXIT
 W !!,"Errors have been logged for the following days: "
 F %J=$N(^UTILITY("%ER",-1)):0 Q:%J<0  S %I=%J W "T",$P(",-",",",%I<+$H+1) W:+$H-%I +$H-%I,"," S %J=$N(^(%J))
 S %XQF="1,2,11" D QUE^ZIBER1 G DAT
DINFO1 S %J=$N(^UTILITY("%ER",-1)) I %J<0 W !!,"No errors have been logged for this UCI" G EXIT
 W !!,"Errors have been logged for the following days: "
 F %J=$N(^UTILITY("%ER",-1)):0 Q:%J<0  S %I=%J W "T",$P(",-",",",%I<+$H+1) W:+$H-%I +$H-%I,"," S %J=$N(^(%J))
 S %XQF="1,2,11,12,20" D QUE^ZIBER1 G DAT1:%SUM,DAT^ZIBER1
NE S %NE=$D(^UTILITY("%ER",%DAT,0)) I '%NE D E1 G DAT1:%SUM,DAT
 S %NE=^(0) D E1
ERR K %LIST R !!,"Error # > ",%X G DAT:"^"[%X,EXIT:%X="^Q" I %X="^L" G:%NE>0 LIST D E1 G ERR
 I %X="?" D E1 S %XQF="1,2,14,18" D QUE^ZIBER1 G ERR
 I %X'?1N.N!(%X>%NE) W *7," ..Invalid" G ERR
 S %NUM=%X
 I '$D(^UTILITY("%ER",%DAT,%NUM,0)) W !!,"Error not on file" G ERR
WRT R !!,"Symbol > ",%X G ERR:"^"[%X,EXIT:%X="^Q",PMODE:%X="^S"
 I %X="?" S %XQF="1,2,13,10,15,16" D QUE^ZIBER1 G WRT
 S %FND=1,%Q=0 I %X="^L" S %SYM="" G WF^ZIBER1
 S %SYM=%X G WF^ZIBER1
E1 S %A=%NE S:'%A %A="NO" W !,%A," ERROR" W:%A'=1 "S" W " LOGGED ON ",$ZD(%DAT) Q
E2 W !!,"No errors logged between ",$ZD(%DAT)," and "
 S %DAT=%D2 W $ZD(%DAT) Q
EXIT U 0 S $ZT="" C:%DEV'=$I %DEV
KILL K %A,%B,%CASE,%D,%D1,%D2,%DAT,%DEL,%DEV,%DIS,%DUM,%FND,%I,%J,%K,%L,%M,%LIST,%NE,%NE1,%NUM,%PG,%Q,%QF,%RDTE,%RTME,%SYM,%TAG,%UCI,%SUM,%X,%XQF,%Y,%Z,FLG,X,%AZ Q
LIST S %LIST=1,%J=0,FLG=0 W ! S $Y=0
L1 S %J=%J+1 G:%J>%NE ERR
 I $D(%AZ("PACKAGE")) S %AZ("P")=%J D TMD2^ZIBER1 I '%AZ("PHIT") S %J=%J-1 G L1
 I $D(^UTILITY("%ER",%DAT,%J,0)) D:$Y>20 NPAGE^ZIBER1 G:FLG=1 ERR W %J,")  ",^(0),!! G L1
LIST1 S %LIST=1,%J=0 W !
L2 S %J=%J+1 Q:%J>%NE  
 I $D(%AZ("PACKAGE")) S %AZ("P")=%J D TMD2^ZIBER1 I '%AZ("PHIT") S %J=%J-1 G L2
 I $D(^UTILITY("%ER",%DAT,%J,0)) W %J,")  ",^(0),!! G L2  
PMODE S %(1)=%DAT,%(2)=%NUM K (%) F %=$N(^(100)):0 Q:%<0!(%>1E5)  D SET S %=$N(^(%))
 W !!,"Symbols have been set into this partition",!!,"You are exiting this utility" K % W !!,"Error defined as: ",^(0) S $ZT="" S:$D(^(7)) %=$P(^(7),"=",2) I $D(%) I %'="" I $D(@%)
 K % Q
SET ;
 I ^(%)'?1";".E S @($P(^(%),"=",1))=$P(^(%),"=",2,999) Q
 I $D(^(1E8+99-%))<10 S @($P($E(^(%),2,999),"=",1))=^(1E8+99-%) Q
 S %(3)="" F %(4)=1:1 Q:'$D(^UTILITY("%ER",%(1),%(2),1E8+99-%,%(4)))  S %(3)=%(3)_^(%(4))
 S @($P($E(^UTILITY("%ER",%(1),%(2),%),2,999),"=",1))=%(3)
 Q
ERROR U 0
 I $F($ZE,"<INRPT>") U 0 W !!,"...Aborted." D EXIT V 0:$J:$ZB($V(0,$J,2),#0400,7):2
 ZQ
