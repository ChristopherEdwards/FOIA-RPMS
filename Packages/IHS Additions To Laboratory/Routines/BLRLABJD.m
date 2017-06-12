BLRLABJD ;IHS/MSC/MKK - Display Lab Job(s) (including HLZTCP) detail, if running; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1034**;NOV 01, 1997;Build 88
 ;
EEP ; EP - Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
EP ; EP
PEP ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D BLRHLZTI
 ;
 F  Q:'RSET.Next()  D BLRHLZTL
 ;
 W !!,?4,CNTJOBS," Jobs analyzed."
 W !!,?9,$S(CNT<1:"No",1:CNT)," Lab Job"_$S(CNT>1:"s.",1:".")
 W !!,?14,$S(CNTTCP<1:"No HLZTCP Jobs found on the system.",1:CNTTCP_" HLZTCP Job"_$S(CNTTCP>1:"s.",1:"."))
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
BLRHLZTI ; EP -- Initialization
 S BLRVERN=$$TRIM^XLFSTR($P($T(+1),";"),"LR"," ")
 ;
 ; The following line of code will determine the MAJOR version of
 ; Cache that is running.  If it's > 2007, then it's known 
 ; that the %SYSTEM.Process class has been superseded by the
 ; %SYS.ProcessQuery class.
 S WOTSYS=$system.Version.GetMajor()
 ;
 S:WOTSYS<2008 SYSCALL="##class(%SYSTEM.Process).%OpenId(PID)."
 S:WOTSYS>2007 SYSCALL="##class(%SYS.ProcessQuery).%OpenId(PID)."
 ;
 S DEFUCI=$NAMESPACE
 ;
 S HEADER(1)="Lab Job Processes"
 S HEADER(2)=" "
 D HEADERDT^BLRGMENU
 W ?4,"Job Analysis"
 ;
 S (CNT,CNTJOBS,CNTTCP)=0
 ;
 S RSET=##class(%ResultSet).%New("%SYS.ProcessQuery:ListPids")
 D RSET.Execute()
 ;
 Q
 ;
RESTHEAD ; EP - Rest of HEADER array
 S HEADER(3)="PID/User"
 S $E(HEADER(3),10)="Routine"
 S $E(HEADER(3),20)="Port #"
 S $E(HEADER(3),28)="IP Address"
 S $E(HEADER(3),44)="UCI"
 ;
 D HEADERDT^BLRGMENU
 Q
 ;
BLRHLZTL ; EP - Line of Data
 S PID=RSET.GetData(1)
 Q:PID<1
 ;
 S CNTJOBS=CNTJOBS+1
 ;
 I CNT<1  W "."  I $X>74 W !,?4
 ;
 S RTN=$$GETSYS("Routine")
 Q:RTN'["HLZTCP"&($E(RTN,1,3)'="BLR")&($E(RTN,1,2)'="LA")&($E(RTN,1,3)'="LR")
 ;
 S:RTN["HLZTCP" CNTTCP=CNTTCP+1
 ;
 D JOBVBRKO
 ;
 D:CNT<1 RESTHEAD
 ;
 W PID
 W ?9,$E(RTN,1,8)
 W ?19,$E($G(PORT),1,6)
 W ?27,$E($G(IPADDR),1,17)
 W ?43,$G(UCI)
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 ;
 Q
 ;
GETSYS(WOTDETAIL) ; EP -- Get System Information
 S GETWOT=SYSCALL_WOTDETAIL_"Get()"
 Q @GETWOT
 ;
JOBVBRKO ; EP -- JOB Variables BReaKOut 
 D JOBVBRKS
 ;
 S PORT=$P(PORT,"|",3)
 S:$P(PORT,":",2)'="" PORT=$P(PORT,":",2)
 ;
 S LOOKHERE="NO"
 S:RTN="HLZTCP" LOOKHERE="YES",HLZTCPCNT=1+$G(HLZTCPCNT)
 Q
 ;
JOBVBRKS ; EP -- JOB Variables BReaKOut -- System variables
 S UCI=$$GETSYS("NameSpace")
 S IPADDR=$$GETSYS("ClientIPAddress")
 S PORT=$$GETSYS("CurrentDevice")
 S USERNAME=$$GETSYS("UserName")
 S USERNAME=$S(USERNAME="SYSTEM":"",USERNAME=UCI:"",1:USERNAME)
 Q
