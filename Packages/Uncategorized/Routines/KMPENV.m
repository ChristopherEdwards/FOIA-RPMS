KMPENV ;SF/KAK - Environment Check Routine ;16 JUL 1998  3:33 pm [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003
 ;;1.0;CAPACITY MANAGEMENT;;Jul 21, 1998
 ;
EN ;
 S:+$G(XPDENV) XPDDIQ("XPZ1","B")="NO"
 D RTNUP
 K I,KMPSOS,KMPSRTN
 Q
 ;      
RTNUP ; Tell KIDS to skip installing certain system specific routines
 ;
 S KMPSOS=$P($G(^%ZOSF("OS")),"^")
 Q:KMPSOS=""
 ;
 I KMPSOS["VAX DSM" F I="M","O" D UPDATE
 I KMPSOS["MSM" F I="O","V" D UPDATE
 I KMPSOS["OpenM-NT" F I="M","V" D UPDATE
 Q
 ;
UPDATE ;
 F KMPSRTN="ZOSVKR"_I,"ZOSVKS"_I_"E","ZOSVKS"_I_"S" D
 .S Y=$$RTNUP^XPDUTL(KMPSRTN,2)
 Q
 ;
