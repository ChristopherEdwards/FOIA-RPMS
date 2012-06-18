%ZIBRUN ; IHS/ADC/GTH - CHECK FOR ACTIVE ROUTINE IN A SPECIFIC UCI ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
EN ;
 Q:'($ZV?1"MSM".E!($ZV?1"DSM".E))  ; Only works for MSM or DSM.
 ; Name of routine to be checked is passed in X.
 S %ZIB("PARM")=X
 S:$P(%ZIB("PARM"),"^",2)="" $P(%ZIB("PARM"),"^",2)=$ZU(0) ; If no UCI set to current UCI.
 S %ZIB("OP SYS")=$ZV ; Set operating system.
 D @$S(%ZIB("OP SYS")?1"DSM".E:"DSM",1:"MSM") ; Active JOB lookup per operating system.
 D CK
 D OUT ; KILL off variables and exit gracefully.
 Q
 ;
MSM ; MSM specific look up active JOBs.
 S $ZT="MER"
 V 44:$J:$ZB($V(44,$J,2),1,7):2
 S %ZIB("SYS TBL")=$V(44),%ZIB("JOB TBL")=$V(%ZIB("SYS TBL")+8,-3,2)+%ZIB("SYS TBL"),%ZIB("MAX JOBS")=$V($V(%ZIB("SYS TBL")+284),-3,4),%ZIB("PARTITION")=$V(3*4+%ZIB("JOB TBL"))
 ; Build active JOB table (%ZIB("ACT JOB")
 F %ZIB("ACT JOB")=1:1:%ZIB("MAX JOBS") S:$V(%ZIB("ACT JOB")*4+%ZIB("PARTITION")) $P(%ZIB("JOB TABLE",%ZIB("ACT JOB")),"^",2)=$ZU(($V(2,%ZIB("ACT JOB"),2)#32),($V(2,%ZIB("ACT JOB"),2)\32))
 Q
 ;
MER ; MSM error trap.
 V 44:$J:$ZB($V(44,$J,2),#FFFE,1):2
 ZQ
 ;
DSM ; DSM specific look up active JOBs.
 S %ZIB("SYS TBL")=$V(44),%ZIB("JOB TBL")=$V(%ZIB("SYS TBL")+4)
 ; Build active JOB table (%ZIB("JOB TABLE"))
 F %ZIB("JOB OFFSET")=%ZIB("JOB TBL")+2:2:%ZIB("JOB TBL")+126 I $V(%ZIB("JOB OFFSET")+1),$V(%ZIB("JOB OFFSET")+1)'=244 D
 . S %ZIB("ACT JOB")=%ZIB("JOB OFFSET")-%ZIB("JOB TBL")\2
 . I %ZIB("ACT JOB")]"" D
 .. S %ZIB("UCI NBR")=$V(149,%ZIB("ACT JOB"))
 .. I %ZIB("UCI NBR")]"" D
 ... S $P(%ZIB("JOB TABLE",%ZIB("ACT JOB")),"^",2)=$ZU(%ZIB("UCI NBR"))
 ... S %ZIB("ACT RTN")=""
 ... F %ZIB("LOC")=502:1:509 Q:$V(%ZIB("LOC"),%ZIB("ACT JOB"))#256>127!'$V(%ZIB("LOC"),%ZIB("ACT JOB"))  S %ZIB("ACT RTN")=%ZIB("ACT RTN")_$C($V(%ZIB("LOC"),%ZIB("ACT JOB"))#128)
 ... S $P(%ZIB("JOB TABLE",%ZIB("ACT JOB")),"^",1)=%ZIB("ACT RTN")
 Q
 ;
CK ; Check %ZIB("JOB TABLE) for match of ROUTINE^UCI.
 S %ZIB("$T")=0,%ZIB("JOB NBR")=""
 F  S %ZIB("JOB NBR")=$O(%ZIB("JOB TABLE",%ZIB("JOB NBR"))) Q:%ZIB("JOB NBR")=""  I %ZIB("JOB TABLE",%ZIB("JOB NBR"))=%ZIB("PARM") S %ZIB("$T")=1 Q
 Q
 ;
OUT ;
 I $ZV?1"MSM".E V 44:$J:$ZB($V(44,$J,2),#FFFE,1):2
 I %ZIB("$T")
 Q
 ;
