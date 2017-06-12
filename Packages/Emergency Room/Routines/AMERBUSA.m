AMERBUSA ;GDIT/HS/BEE - BUSA AUDITING ROUTINE FOR AMER ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**5,6**;MAR 03, 2009;Build 30
 ;
 Q
 ;
LOG(AMCAT,AMACT,AMCALL,AMDESC,AMERVDFN) ;EP - Log the AMER Audit entry
 ;
 NEW AMERDFN,X,RES
 ;
 ;See if BUSA has been installed
 S X="BUSAAPI" X ^%ZOSF("TEST") I '$T Q "BUSA has not been installed"
 ;
 ;Check the input
 I ",S,P,D,O,"'[(","_$G(AMCAT)_",") Q "Invalid Audit Category"
 I (AMCAT="P"),(",A,D,Q,P,E,C,"'[(","_$G(AMACT)_",")) Q "Invalid Audit Action"
 I $G(AMDESC)="" Q "Invalid Audit Log Description"
 S:$G(AMCALL)="" AMCALL="AMER Audit API Call"
 ;
 ;Handle single patients passed in
 I $D(AMERVDFN)=1,$G(AMERVDFN)]"" D
 . S AMERDFN(1)=AMERVDFN
 ;
 ;Handle multiple patients passed in
 I $D(AMERVDFN)>9 D
 . NEW II,CNT
 . S II="",CNT=0 F  S II=$O(AMERVDFN(II)) Q:II=""  S CNT=CNT+1,AMERDFN(CNT)=AMERVDFN(II)
 ;
 ;Perform the audit call
 S RES=$$LOG^BUSAAPI("A",AMCAT,AMACT,AMCALL,AMDESC,"AMERDFN")
 Q RES
 ;
DIR ;EP - Perform logging on ^DIR lookup
 Q
