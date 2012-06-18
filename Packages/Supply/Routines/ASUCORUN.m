ASUCORUN ; IHS/ITSC/LMH -UPDATE UTILITY FUNCTIONS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is the primary control routine for assuring that
 ;closeouts are run in logical sequence. Based on flags set in the
 ;Site file, daily closeouts may run only if the previous monthly
 ;closeout was completed within a selected time frame. A yearly
 ;closeout is allowed only if the previous closeout was for the month
 ;of September.
 ;The status of the previous closeout is also checked to assure
 ;that it was correctly completed before a new closeout is allowed.
 ;All of these functions are controlled by flags in the Site file.
 I ASUP("STS")="N"!(ASUP("CKP")>0) D  Q:'ASUP("OK")
 .I ASUP("TYP")'=ASUP("LSTY") D  Q
 ..D EN2^ASUCOSTS
 ..W *7,!!,"You have selected a '",$S(ASUP("TYP")=1:"monthly closeout",ASUP("TYP")=2:"yearly closeout",1:"daily closeout"),"'. The earlier run must first be completed."
 ..W !!,"Contact your Supervisor or select a '",ASUP("LSTN"),"' to resolve the problem.",*7,!
 ..K DIR S DIR(0)="E" D ^DIR
 ..S ASUP("HLT")=1,ASUP("OK")=0
 .S ASUP("RE*")=1
 .D EN2^ASUCOSTS
 .S DIR("?")="Enter 'Y' to restart or 'N' to cancel this closeout run."
 .S DIR("A")="This will 'RESTART' that run, OK"
 .S DIR("B")="Y"
 .S DIR(0)="Y"
 .D ^DIR
 .I $D(DUOUT)!($D(DTOUT)) S ASUP("HLT")=1,ASUP("RE*")=0,ASUP("OK")=0 Q
 .S ASUP("OK")=Y
 .I ASUP("OK") D
 ..S ASUP("HLT")=0,ASUP("RE*")=1
 ..S:ASUP("TYP")=1 ASUP("MO")=$E(ASUP("LSMO"),1,2),ASUP("MOYR")=ASUP("LSMO"),ASUP("YR")=$E(ASUP("MOYR"),3,4)
 .E  D
 ..S ASUP("HLT")=1,ASUP("RE*")=0
 S ASUP("RE*")=+$G(ASUP("RE*"))
 I ASUP("RE*") Q
 I ASUP("STR")="N"!(ASUP("CKS")>0) D
 .W !,"Standard Reports from Previous Closeout not Sucessfully Printed I will now print them",!,"You will then need to run this Closeout again after they have printed"
 .S ASUP("OK")=1,ASUP("RE*")=1
 I ASUP("IVR")="N"!(ASUP("CKI")>0) D
 .W !,"Invoice Reports from Previous Closeout not Sucessfully Printed",!,"Print them and run this Closeout after they are printed"
 .S ASUP("OK")=1,ASUP("RE*")=1
 I ASUP("HLT") S ASUP("OK")=0
 S ASUP("OK")=$G(ASUP("OK")) S:ASUP("OK")="" ASUP("OK")=1
 Q
ASK ;EP ;GET RUN DATE
 K DIR S DIR(0)="P^9002039.98",DIR("A")="Enter Run Date" D ^DIR
 I $D(DUOUT)!($D(DTOUT)) S ASUP("HLT")=1 Q
 S ASUP("MO")=$E($P(Y,U,2),4,5),ASUP("YR")=$E($P(Y,U,2),2,3),ASUP("MOYR")=ASUP("MO")_ASUP("YR")
 Q
SETRUN ;EP ; -SET RUN DATE EQUAL DATE
 I '$D(ASUP("NXMO")) D SETCTRL^ASUCOSTS
 S X=(ASUP("NXMO")*.01)+.01,ASUP("MO")=$P(X,".",2)
 S:ASUP("MO")="13" ASUP("MO")=12
 I ASUP("MO")="09",9'=+ASUK("DT","MO") D
 .S ASUP("YR")=ASUK("DT","PFY")
 E  D
 .S ASUP("YR")=ASUK("DT","CFY")
 S ASUP("MOYR")=ASUP("MO")_ASUP("YR")
 Q
KILL ;EP; COMMON TRANSACTION PROCESSING ROUTINE VARIABLE KILL
 K ASU,ASUM,ASUS,ASUT,ASUV,ASUSV
 K DA,DIC,DIE,DR,X,Y
 Q
