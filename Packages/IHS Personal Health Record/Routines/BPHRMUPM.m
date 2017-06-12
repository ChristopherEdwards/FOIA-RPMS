BPHRMUPM ;GDIT/HS/ALA-PHR MU Performance Measure ; 20 Aug 2013  9:54 AM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**1**;Apr 01, 2014;Build 23
 ;
PHR(DFN,BDT,EDT,RESULT,PROV) ;PEP - API call for Performance Measure
 ; Input Parameters
 ;  DFN - Patient Internal Entry Number
 ;  BDT - Begining Date
 ;  EDT - Ending Date
 ;
 ; Output - RESULT format below
 ;          Signed up for PHR (0=No, 1=Yes)^date^accessed PHR (0=No, 1=Yes)^last date^used secure messaging (0=No, 1=Yes)^last date^direct address
 ;
 ; Get Patient ICN
 NEW BPHREUID,BPARRAY,BPHRP,BPHRR,EXEC,STS,RETRY,MAX,CONNEC,TRY,FAIL,DA,PROD
 S RESULT="0^^0^^0^^"
 I $G(DT)="" D DT^DICRW
 I $G(BDT)="" S BDT=DT
 I $G(EDT)="" S EDT=DT
 ;
 S BPHREUID=$P($G(^DPT(DFN,"MPI")),U,1)
 I BPHREUID="" Q
 ;
 I $P($G(^AUTTLOC(DUZ(2),21)),"^",5)="" S $P(RESULT,"^",10)="Location does not have DIRECT email address" Q
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BPHRMUPM D UNWIND^%ZTER"
 ;
 S PROD=$$PROD^XUPROD()
 I 'PROD S DA=1
 I PROD S DA=2
 ; Get web service information
 K BPARRAY
 D GETS^DIQ(90670.2,DA_",","**","E","BPARRAY")
 S BPHRP("URLROOT")=$G(BPARRAY(90670.2,DA_",",.02,"E"))
 S BPHRP("SERVICEPATH")=$G(BPARRAY(90670.2,DA_",",.11,"E"))
 S BPHRP("PORT")=$G(BPARRAY(90670.2,DA_",",.03,"E"))
 S BPHRP("TIMEOUT")=$G(BPARRAY(90670.2,DA_",",.05,"E"))
 S BPHRP("USER")=$G(BPARRAY(90670.2,DA_",",.07,"E"))
 S BPHRP("PASS")=$G(BPARRAY(90670.2,DA_",",.08,"E"))
 ; Pass Patient ICN and BDT and EDT to web service call
 S BPHRP("EUID")=BPHREUID
 ; Change BDT and EDT to appropriate dates from FileMan date
 S BPHRP("FROM")=$$DATE(BDT)_"T00:00:00"_$$TMZ()
 S BPHRP("TO")=$$DATE(EDT)_"T23:59:59"_$$TMZ()
 I $G(PROV)="" S BPHRP("ADDR")=""
 ;I $G(PROV)'="" S BPHRP("ADDR")=$S($$AGNT^BPHRUPD(DFN)="":"",1:$$AGNT^BPHRUPD(DFN)_",")_$$PROV^BPHRUPD($G(PROV))
 I $G(PROV)'="" S BPHRP("ADDR")=$S($$AGNT^BPHRUPD(DFN)="":"",1:$$AGNT^BPHRUPD(DFN))_$$PROV^BPHRUPD($G(PROV))
 S BPHRP("SSL")=$G(BPARRAY(90670.2,DA_",",2.01,"E"))
 S RETRY=$G(BPARRAY(90670.2,DA_",",4.01,"E"))
 S MAX=$G(BPARRAY(90670.2,DA_",",4.02,"E"))
 S CONNEC=$G(BPARRAY(90670.2,DA_",",.12,"E"))
 ;
 ; Returns data
 S QFL=0,TRY=0,FAIL=0,OK=0
 F  D  Q:OK  Q:QFL
 . S EXEC="S STS=##class(BPHR.WebServiceCalls).PMQueryRequest(.BPHRP,.BPHRR)" X EXEC
 . I $P($G(STS),U,1)=1 S OK=1 Q
 . I $P($G(STS),U,1)=0 D
 .. S TRY=TRY+1 I TRY>RETRY S FAIL=FAIL+1,TRY=0
 .. I FAIL>MAX S $P(RESULT,U,1)=-1,$P(RESULT,U,10)=$P($G(STS),U,2),QFL=1 Q
 .. HANG CONNEC
 ;
 I QFL Q
 ;
 I $G(BPHRR("ACCESS"))="" S $P(RESULT,U,1)=0
 I $G(BPHRR("ACCESS"))'="" D
 . NEW VAL
 . S VAL=$G(BPHRR("ACCESS"))
 . S $P(RESULT,U,1)=1,$P(RESULT,U,2)=$$GMT(VAL)
 I $G(BPHRR("LOGIN"))="" S $P(RESULT,U,3)=0
 I $G(BPHRR("LOGIN"))'="" D
 . NEW VAL
 . S VAL=$G(BPHRR("LOGIN"))
 . S $P(RESULT,U,3)=1,$P(RESULT,U,4)=$$GMT(VAL)
 I $G(BPHRR("SMESSAGE"))="" S $P(RESULT,U,5)=0
 I $G(BPHRR("SMESSAGE"))'="" D
 . NEW VAL
 . S VAL=$G(BPHRR("SMESSAGE"))
 . S $P(RESULT,U,5)=1,$P(RESULT,U,6)=$$GMT(VAL)
 I $G(BPHRR("SDIRECT"))="" S $P(RESULT,U,7)=""
 I $G(BPHRR("SDIRECT"))'="" D
 . NEW VAL
 . S VAL=$G(BPHRR("SDIRECT")),$P(RESULT,U,7)=VAL
 ;
 Q
 ;
DATE(BPX) ;EP
 NEW BPY,BPM,BPD
 S BPY=$$FMTE^XLFDT(BPX,"7Z")
 S BPY=$TR(BPY,"/","-")
 Q BPY
 ;
FMDT(BPX) ;EP
 NEW X,Y,TMZ,DATE,TIME
 S BPX=$TR(BPX,"T","@")
 S TMZ=$E(BPX,$L(BPX)-4,$L(BPX)),BPX=$E(BPX,1,$L(BPX)-5)
 S TIME=$P(BPX,"@",2),DATE=$P(BPX,"@",1)
 S X=$P(DATE,"-",2)_"/"_$P(DATE,"-",3)_"/"_$P(DATE,"-",1)_"  "_TIME_" "_TMZ
 S Y=$$CONVERT^XMXUTIL1(X,1)
 I Y=-1 S Y=""
 Q Y
 ;
TMZ() ;EP - System Timezone
 NEW TMZ,VAL
 S VAL="S TMZ=$ZTZ\60"
 X VAL
 S TMZ=$$TIMEDIFF^XMXUTIL1(-TMZ)
 Q TMZ
 ;
ERR ;EP - Error Trap
 NEW ERRAY,EXEC
 I $ZE["ZSOAP" D
 . S EXEC="Set ERRAY=$System.Status.DecomposeStatus(%objlasterror,.ERRAY)" X EXEC
 . S $P(RESULT,"^",1)=-1,$P(RESULT,"^",10)=$S($G(ERRAY(1))'="":$G(ERRAY(1)),1:$ZE)
 D ^%ZTER
 Q
 ;
GMT(DATE) ;EP - Convert GMT time to Local time
 NEW TLG,LG,OFF,NDATE,%DT,HDATE,NHDATE,Y,X,OP,I
 ; Find the Offset value
 S TLG=$L(DATE) F I=TLG:-1:1 S OP=$E(DATE,I,I) I OP="-"!(OP="+") S LG=I Q
 S OFF=$E(DATE,LG,TLG),OFF=+OFF,OFF=$$STRIP^XLFSTR(OFF,0),OFF=OFF*60
 ; translate the date to a $H date
 S NDATE=$E(DATE,1,LG),NDATE=$TR(NDATE,"T","@"),%DT="TS",X=NDATE
 D ^%DT I Y=-1 Q ""
 S HDATE=$$FMTH^XLFDT(Y)
 ; adjust the $H date with the offset
 S NHDATE=$$HADD^XLFDT(HDATE,,,OFF)
 ; translate date to FileMan date
 Q $$HTFM^XLFDT(NHDATE)
