ASUCOMTH ; IHS/ITSC/LMH -MONTHLY CLOSEOUT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine controls a monthly closeout run.
 D CLS^ASUUHDG
 W !?15,"S.A.M.S Monthly Closeout Process Running",!!
 S ASUP("TYP")=1
 S DIR(0)="Y",DIR("A")="Are you sure this is the Last Processing for the Month" D ^DIR
 K DIR
 G:$D(DTOUT)!(X="N") KILL G:$D(DUOUT) KILL
 I Y D
 .D SETCTRL^ASUCOSTS
 E  D
 .W *13,!,"If a monthly closeout isn't needed, select either a daily or a yearly closeout"
 .S DIR(0)="E" D ^DIR K DIR
 .S DUOUT=1
 G:$D(DTOUT) KILL G:$D(DUOUT) KILL
 I ($D(ASUK("DT"))#10)'=1 D DATE^ASUUDATE
 D ^ASUCORUN I 'ASUP("OK") K ASUP Q
 D SETRUN^ASUUDATE
 G:ASUP("RE*") UPDT
 D SETMO^ASUUDATE(ASUP("NXMO")) G:ASUP("ERR")>0 ERR
UPDT ;
 D DT^DILF("E",ASUP("MOYR"),.X)
 W !,"Monthly closeout will be made for Month and FISCAL year ",!?30,X(0)
 K DIR S DIR(0)="Y",DIR("B")="Y",DIR("A")="Is that correct" D ^DIR
 I 'Y G KILL
 I 'ASUP("RE*") S ASUP("LSMO")=ASUP("MOYR") D SETLM^ASUCOSTS
 S $P(^ASUSITE(1,1),U,8)=$P($G(^ASUSITE(1,3)),U,8)
 S ASUP("RE*")=+$G(ASUP("RE*"))
 S ASUK("PTR")="SRPT"
 I ASUP("AST")>0 D
 .S %ZIS("A")="Select Standard Reports Printer (132 Characters/line) "
 .D S^ASUUZIS
 E  D
 .S IOP=ASUK("SRPT","IOP"),%ZIS("IOPAR")=$G(ASUK("SRPT","IOPAR"))
 .D S^ASUUZIS
 G:$D(DTOUT) END G:$D(DUOUT) END
 I POP W " for Standard Reports" G END
 S ASUP("CKP")=$G(ASUP("CKP"))
 S (ASUP("STP"),ASUP("SRP"))="N"
 D SETTY^ASUCOSTS
 I ASUK("SRPT","Q")=1 D
 .W !!,"Since you have queued these reports, make sure that proper forms are mounted"
 .W !,"Mount Standard Computer Paper on Printer ",ASUK("SRPT","ION")
 .S XBRP="^ASURMSTD"
 .S XBRC="^ASUCOMOR"
 .S XBRX="^ASUCOKIL"
 .S XBIOP=ASUK("IRPT","IOP")
 .S ASUK("PTR")="IRPT"
 .D Q^ASUUZIS
 E  D
 .S ASUP("CKP")=7
 .D ^ASUCOMOR ;Monthly closeout update and report extract
 .D ^ASURMSTD ;Monthly Standard Reports print
 .I $G(ASUP("HLT"))=1 D ^ASUCOKIL Q  ;Quit run if error has occured
 .S ASUP("CKP")=0 D SETSTAT^ASUCOSTS ;Set Status to run sucessfully completed
 D STAT^ASUCOKIL ;Kill all normal variables
END ;
 K ASUP,ASUF,DTOUT,DUOUT
KILL ;
 K DUOUT,ASUP
 Q
ERR ;
 W !!?25,"**** ERROR ****",*7,!
 W !,"The Run Control table ASUTBL SITE indicates that month ",ASUP("MO")," should"
 W !,"be the month for the monthly closeout, but the current date of ",ASUK("DT")," is",!,"not consistent."
 I ASUP("ERR")=2 D
 .W "It appears that the current month has already been",!,"closed out and it is too early for next month's run."
 I ASUP("ERR")=1 D
 .W "It appears that the you are attempting to closeout the",!,"current month before the earliest closeout date allowed."
 W !!,"The computer program is unable to determine correct Month to closeout."
 W *7,!!?10,"***** Notify your Supervisor to correct the problem *****",*7,!!
 K DIR S DIR(0)="E" D ^DIR
 Q
