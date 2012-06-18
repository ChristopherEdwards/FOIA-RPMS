ASUCODAY ; IHS/ITSC/LMH -DAILY CLOSEOUT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine controls a daily Closeout.
 S ASUP("HLT")=0
 D CLS^ASUUHDG
 W !?15,"Daily Closeout Procedure Running",!
 D:'$D(ASUK("DT","FM")) DATE^ASUUDATE
 S ASUP("TYP")=0
 D SETCTRL^ASUCOSTS
 D ^ASUCORUN Q:'ASUP("OK")  D SETRUN^ASUUDATE
 I ASUP("RE*") I ASUP("IVR")="Y",ASUP("CKI")=0 S ASUP("RE*")=2
 G:ASUP("RE*") UPDT
 I $E(ASUP("LSMO"),1,2)="09",ASUP("LSTY")=1 D  Q
 .W *7,!?27,"**** ERROR ****",!
 .W *7,!,"You have chosen a 'daily closeout' but the most recent run was for September",!,"'monthly closeout'.  You should run a 'yearly closeout' before additional daily closeouts."
 .W *7,!,"Run a 'yearly closeout' or contact your Supervisor to resolve this problem"
 .N DIR S DIR(0)="E" D ^DIR S ASUP("HLT")=1
 I $E(ASUP("LSMO"),1,2)'=ASUK("DT","MO") D
 .S ASUP("MO")=ASUP("NXMO")_$S(ASUP("NXMO")="09":ASUK("DT","PFY"),1:ASUK("DT","CFY"))
 .I ASUP("MOL")<ASUK("DT","DA"),ASUP("MO")=ASUK("DT","MO") D  Q
 ..W *7,!!?30,"**ERROR**",!!!
 ..W *7,"You have choosen a 'daily closeout' and you have not run a 'monthly closeout'"
 ..W !,"for the month of ",ASUP("MO")," and it is past the cutoff date for that month!!",!
 ..W *7,!!?22,"Daily closeout will not be Allowed",!!,*7 S ASUP("HLT")=1
 ..N DIR S DIR(0)="E",DIR("A")="Run a 'monthly closeout' or contact your Supervisor to resolve this problem" D ^DIR
 .S X=ASUK("DT","MO")_ASUK("DT","DA") I X>ASUP("MOW") D
 ..W *7,!!?30,"**WARNING**",!!,"You have choosen a 'daily closeout' and you have not run a 'monthly closeout' for the month of ",ASUK("DT","RUNMY") N DIR S DIR(0)="E" D ^DIR
 ..K ASUP("MO")
 ..I $D(DTOUT)!($D(DUOUT)) S ASUP("HLT")=1 Q
 ..S:'Y ASUP("HLT")=1
 I ASUP("HLT") K ASUP Q
 I $E(ASUP("LSDT"),1,2)=ASUK("DT","FM")
UPDT ;
 I ASUP("A13") D
 .I ASUP("A13")=2 D
 ..D P0^ASURD13P,MENU^ASURD13P
 .E  D
 ..S DIR(0)="Y",DIR("A")="Do you want a Requirements Analysis report (13) included with standard reports" D ^DIR
 ..K DIR
 ..Q:$D(DTOUT)  Q:$D(DUOUT)
 ..I Y D P0^ASURD13P,MENU^ASURD13P
 G:$D(DTOUT) END G:$D(DUOUT) END G:$G(ASUP("HLT"))=1 END
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
 S ASUK("PTR")="IRPT"
 I ASUP("AIV")>0 D
 .S %ZIS("A")="Select Invoice Reports Printer (80 Characters/line) "
 .K XBRC S XBRP="^ASURDPRT"
 .D S^ASUUZIS
 E  D
 .S IOP=ASUK("IRPT","IOP"),%ZIS("IOPAR")=$G(ASUK("IRPT","IOPAR"))
 .K XBRC S XBRP="^ASURDPRT"
 .D S^ASUUZIS
 G:$D(DTOUT) END G:$D(DUOUT) END
 I POP W " for Invoice Reports" G END
 S ASUP("CKP")=$G(ASUP("CKP"))
 S (ASUP("STP"),ASUP("IVS"),ASUP("SRP"))="N"
 D SETTY^ASUCOSTS
 I ASUK("SRPT","Q")=1 D
 .W !!,"Since you have queued these reports, make sure that proper forms are mounted"
 .W !,"Mount 8 1/2 X 11 Paper on Printer ",ASUK("IRPT","ION")
 .W !,"Mount Standard Computer Paper on Printer ",ASUK("SRPT","ION")
 .S XBRP="^ASURDPRT"
 .S XBRC="^ASUCOUTP"
 .S XBRX="^ASUCOKIL"
 .S XBIOP=ASUK("IRPT","IOP")
 .S ASUK("PTR")="IRPT"
 .D Q^ASUUZIS
 E  D
 .D:ASUP("CKP")<6 ^ASUCOUTP Q:$G(ASUS("HLT"))  Q:ASUP("CKP")'=6
 .D:ASUP("CKP")=6 IV^ASURDPRT ;Print Invoice Reports
 .I $G(ASUP("HLT"))=1 D ^ASUCOKIL Q  ;Quit run if error has occured
 .D:ASUP("CKP")>6 ST^ASURDPRT ;Print Standard Reports
 .I $G(ASUP("HLT"))=1 D ^ASUCOKIL Q  ;Quit run if error has occured
 .S ASUP("CKP")=0 D SETSTAT^ASUCOSTS ;Set Status to run sucessfully completed
 D STAT^ASUCOKIL ;Kill all normal variables
END ;
 K ASUP,ASUF,DTOUT,DUOUT
 Q
