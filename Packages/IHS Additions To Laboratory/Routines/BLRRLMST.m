BLRRLMST ;ihs/cmi/maw - BLR Reference Lab Monitor Utilities; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 01, 1997
 ;;1.0;BLR REFERENCE LAB;**1033**;NOV 01, 1997
 Q
 ;
 ;
SITE(RETVAL,BLRSTR) ;-- get site paramters
 N P,BLRUSR,BLRSITE,BLRI,BLRPRD
 S RETVAL="^BLRTMP("_$J_")"
 S P="|"
 S BLRSITE=$P(BLRSTR,P)
 S BLRUSR=$P(BLRSTR,P,2)
 S BLRI=0
 S @RETVAL@(BLRI)="T00020EnsembleProduction"_$C(30)
 S BLRI=BLRI+1
 S @RETVAL@(BLRI)=$O(^BLRRLMST("APRD",BLRSITE,BLRUSR,0))_$C(30)
 S BLRI=BLRI+1
 S @RETVAL@(BLRI+1)=$C(31)
 Q
 ;
INT(RETVAL,BLRSTR) ;-- lets start/stop/recover or monitor
 N P,CNS,NS,PROD,BLRI,VQR,VQRI,VQRT,VQRR,VQT,VQRT,TCPL,OF,IF
 S P="|"
 ;S CNS=$ZU(5)
 S CNS=$NAMESPACE
 S NS=$P(BLRSTR,P)
 S PROD=$P(BLRSTR,P,2)
 S VQT=$P(BLRSTR,P,3)
 S VQR=$P(BLRSTR,P,4)
 S TCPL=$P(BLRSTR,P,5)
 S OF=$P(BLRSTR,P,7)
 S IF=$P(BLRSTR,P,6)
 S RETVAL="^BLRTMP("_$J_")"
 S BLRI=0
 S @RETVAL@(BLRI)="T00001Value"_$C(30)
 ; I (CNS'=NS) ZN NS
 I (CNS'=NS) S $NAMESPACE=NS
 I PROD=1 D
 . Do ##class(Ens.Director).StartProduction("LR.VALediIII")
 I PROD=2 D
 . Do ##class(Ens.Director).StopProduction()
 I PROD=3 D
 . Do ##class(Ens.Director).RecoverProduction()
 . Do ##class(Ens.Director).StartProduction("LR.VALediIII")
 S tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.tState)
 ; I (CNS'=NS) ZN CNS
 I (CNS'=NS) S $NAMESPACE=CNS
 I VQR=1 D
 . D STRTLLP("LA7VQR")
 I VQR=2 D
 . D STOPLLP("LA7VQR")
 I VQR=3 D
 . D STOPLLP("LA7VQR")
 . H 3
 . D STRTLLP("LA7VQR")
 I VQT=1 D
 . D STRTLLP("LA7VQT")
 I VQT=2 D
 . D STOPLLP("LA7VQT")
 I VQT=3 D
 . D STOPLLP("LA7VQT")
 . H 3
 . D STRTLLP("LA7VQT")
 I TCPL=1 D
 . D TASKLM^HLCSLM
 I TCPL=2 D
 . D STOPLM^HLCSLM
 I TCPL=3 D
 . D STOPLM^HLCSLM
 . H 3
 . D TASKLM^HLCSLM
 I OF=1 D
 . Q:'$$FILERCNT(2)
 . D STARTOUT^HLCS1
 I OF=2 D
 . D STOPOUT^HLCS1
 I OF=3 D
 . D STOPOUT^HLCS1
 . H 3
 . D STARTOUT^HLCS1
 I IF=1 D
 . Q:'$$FILERCNT(1)
 . D STARTIN^HLCS1
 I IF=2 D
 . D STOPIN^HLCS1
 I IF=3 D
 . D STOPIN^HLCS1
 . H 3
 . D STARTIN^HLCS1
 S @RETVAL@(BLRI+1)=$C(31)
 Q
 ;
FILERCNT(INOUT) ;-- return filer counts
 N IN,OUT,NODE,DEFIN,DEFOUT
 S (IN,OUT)=0
 S NODE=+$O(^HLCS(869.3,0))
 S DEFIN=$P($G(^HLCS(869.3,NODE,1)),U)
 S DEFOUT=$P($G(^HLCS(869.3,NODE,1)),U,2)
 I INOUT=1,$$CNTFLR^HLCSUTL2("IN")<DEFIN S IN=1
 I INOUT=2,$$CNTFLR^HLCSUTL2("OUT")<DEFOUT S OUT=1
 Q $S(INOUT=1:IN,1:OUT)
 ;
STATUS(RETVAL,BLRSTR) ;-- lets get the status of all interfaces
 ;1-production, 2-LA7VQR, 3-LA7VQT, 4-TCP Link Manager, 5-Inbound Filer, 6-Outbound Filer, 9-All
 N P,R,CNS,NS,STAT,BLRI,PRODI,PROD,VQR,VARI,VQT,VQTI,TCPL,IF,OF
 S (PROD,VQR,VQT,TCPL,IF,OF)=0
 S P="|"
 S R="~"
 S NS=$P(BLRSTR,P)
 S STAT=$P(BLRSTR,P,2)
 ; S CNS=$ZU(5)
 S CNS=$NAMESPACE
 S RETVAL="^BLRTMP("_$J_")"
 S BLRI=0
 S @RETVAL@(BLRI)="T00080Status"_$C(30)
 I (STAT=1)!(STAT=9) D
 . ; I (CNS'=NS) ZN NS
 . I (CNS'=NS) S $NAMESPACE=NS
 . S tSC=##class(Ens.Director).GetProductionStatus(.tProductionName,.tState)
 . S PRODI=$G(tState)
 . S PROD=$S(PRODI=2:"Stopped",PRODI=3:"Suspended",PRODI=4:"Troubled",1:"Running")
 . ; I (CNS'=NS) ZN CNS
 . I (CNS'=NS) S $NAMESPACE=CNS
 I (STAT=2)!(STAT=9) D
 . S VQRI=$O(^HLCS(870,"B","LA7VQR",0))
 . I $P($G(^HLCS(870,VQRI,0)),U,15) S VQR="Stopped" Q
 . S VQR="Running"
 . ;S VQR=$P($G(^HLCS(870,VQRI,0)),U,5)
 I (STAT=3)!(STAT=9) D
 . S VQTI=$O(^HLCS(870,"B","LA7VQT",0))
 . I $P($G(^HLCS(870,VQTI,0)),U,15) S VQT="Stopped" Q
 . S VQT="Running"
 . ;S VQT=$P($G(^HLCS(870,VQTI,0)),U,5)
 I (STAT=4)!(STAT=9) D
 . S TCPL="Stopped"
 . I $$STAT^HLCSLM S TCPL="Running"
 I (STAT=5)!(STAT=9) D
 . I '$$CNTFLR^HLCSUTL2("IN") S IF="Stopped" Q
 . S IF="Running"
 I (STAT=6)!(STAT=9) D
 . I '$$CNTFLR^HLCSUTL2("OUT") S OF="Stopped" Q
 . S OF="Running"
 S BLRI=BLRI+1
 S @RETVAL@(BLRI)=$G(PROD)_R_$G(VQT)_R_$G(VQR)_R_$G(TCPL)_R_$G(IF)_R_$G(OF)_$C(30)
 S @RETVAL@(BLRI+1)=$C(31)
 ;
 Q
 ;
STOPLLP(PAT) ;Stop Logical Links
 ;PAT=link to stop
 N HLDP,HLDP0,HLPARM0,HLPARM4,HLJ,X,Y S HLDP=0
 F  S HLDP=$O(^HLCS(870,HLDP)) Q:'HLDP  S HLDP0=$G(^(HLDP,0)),X=+$P(HLDP0,U,3) D:X
 .;skip this link if not stopping all and Autostart not enabled
 . ;I 'ALL&('$P(HLDP0,U,6)) Q
 . I PAT]"",$P(HLDP0,U)'=PAT Q  ;only stop patterned LLP
 . S HLPARM4=$G(^HLCS(870,HLDP,400))
 . ;TCP Multi listener for non-Cache uses UCX
 . I $P(HLPARM4,U,3)="M" Q:^%ZOSF("OS")'["OpenM"  Q:$$OS^%ZOSV["VMS"
 . ;4=status,10=Time Stopped,9=Time Started,11=Task Number,3=Device Type,14=shutdown?
 . S X="HLJ(870,"""_HLDP_","")",@X@(4)="Halting",@X@(10)=$$NOW^XLFDT,(@X@(11),@X@(9))="@",@X@(14)=1
 . I $P(HLPARM4,U,3)="C"&("N"[$P(HLPARM4,U,4)),'$P(HLDP0,U,12) S @X@(4)="Shutdown"
 . D FILE^HLDIE("","HLJ","","LLP","HLCS2") ;HL*1.6*109
 . ;Cache system, need to open TCP port to release job
 . I ^%ZOSF("OS")["OpenM",($P(HLPARM4,U,3)="M"!($P(HLPARM4,U,3)="S")) D
 .. ;pass task number to stop listener
 .. S:$P(HLDP0,U,12) X=$$ASKSTOP^%ZTLOAD(+$P(HLDP0,U,12))
 .. D CALL^%ZISTCP($P(HLPARM4,U),$P(HLPARM4,U,2),10)
 .. I POP D HOME^%ZIS Q
 .. D CLOSE^%ZISTCP
 Q
 ;
STRTLLP(PAT) ;Start Links
 N HLDP,HLDP0,HLDAPP,HLTYPTR,HLBGR,HLENV,HLPARAM0,HLPARM4,HLQUIT,ZTRTN,ZTDESC,ZTSK,ZTCPU
 S HLDP=0
 F  S HLDP=$O(^HLCS(870,HLDP)) Q:HLDP<1  S HLDP0=$G(^(HLDP,0)) D
 . S HLPARM4=$G(^HLCS(870,HLDP,400))
 . ;quit if no parameters or AUTOSTART is disabled
 . ;Q:'$P(HLDP0,U,6)
 . I PAT]"",$P(HLDP0,U)'=PAT Q  ;only stop patterned LLP
 . ;HLDAPP=LL name, HLTYPTR=LL type, HLBGR=routine, HLENV=environment check
 . S HLDAPP=$P(HLDP0,U),HLTYPTR=+$P(HLDP0,U,3),HLBGR=$G(^HLCS(869.1,HLTYPTR,100)),HLENV=$G(^(200))
 . ;quit if no LL type or no routine
 . Q:'HLTYPTR!(HLBGR="")
 . I HLENV'="" K HLQUIT X HLENV Q:$D(HLQUIT)
 . ;TCP Multi listener for non-Cache uses UCX
 . I $P(HLPARM4,U,3)="M" Q:^%ZOSF("OS")'["OpenM"  Q:$$OS^%ZOSV["VMS"
 . I $P(HLPARM4,U,3)="C"&("N"[$P(HLPARM4,U,4)) D  Q
 .. ;4=status 9=Time Started, 10=Time Stopped, 11=Task Number 
 .. ;14=Shutdown LLP, 3=Device Type, 18=Gross Errors
 .. N HLJ,X
 .. I $P(HLDP0,U,15)=0 Q
 .. L +^HLCS(870,HLDP,0):2
 .. E  Q
 .. S X="HLJ(870,"""_HLDP_","")"
 .. S @X@(4)="Enabled",@X@(9)=$$NOW^XLFDT,@X@(14)=0
 .. D FILE^HLDIE("","HLJ","","STRT","HLCS2") ; HL*1.6*109
 .. L -^HLCS(870,HLDP,0)
 .. Q
 . S ZTRTN=$P(HLBGR," ",2),ZTIO="",ZTDTH=$H,HLTRACE=""
 . S ZTDESC=HLDAPP_" Low Level Protocol",ZTSAVE("HLDP")=""
 . ;get startup node
 . I $P(HLPARM4,U,6),$D(^%ZIS(14.7,+$P(HLPARM4,U,6),0)) S ZTCPU=$P(^(0),U)
 . D ^%ZTLOAD
 Q
 ;
