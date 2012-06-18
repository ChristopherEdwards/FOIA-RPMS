BGOIN002 ; IHS/MSC/DKM - Patient Education Bad Pointer Fix;26-May-2006 18:22;DKM
 ;;1.1;BGO;**2**;JUN 02, 2005
 ; Environment check
 ; Don't install BGOVPED routine if EHR 1.1 installed
EC N IEN
 S IEN=""
 F  S IEN=$O(^XPD(9.7,"B","EHR 1.1",IEN),-1) Q:'IEN  Q:$$GET1^DIQ(9.7,IEN,.02,"I")=3
 I IEN,$$RTNUP^XPDUTL("BGOVPED",2)
 Q
 ; Preinit
PRE Q
 ; Postinit
 ; Fixes bad ICD9 pointers in V PATIENT ED file
POST N IEN,N0,ICD1,ICD2,PTR,CNT
 D BMES^XPDUTL("Scanning V PATIENT ED file for bad ICD9 pointers...")
 S (CNT,IEN)=0
 F  S IEN=$O(^AUPNVPED(IEN)) Q:'IEN  S N0=$G(^(IEN,0)) D:$L(N0)
 .S ICD1=$P(N0,U,4)
 .Q:'ICD1
 .S ICD2=$P($G(^AUTTEDT(+N0,0)),U,4)
 .Q:'ICD2
 .Q:ICD1=ICD2
 .S PTR=+$$ICD(ICD1)
 .Q:'PTR
 .Q:PTR'=ICD2
 .S $P(^AUPNVPED(IEN,0),U,4)=PTR,CNT=CNT+1
 .D BMES^XPDUTL("  IEN #"_IEN_" modified: "_$$ICD(ICD1)_"-->"_$$ICD(ICD2))
 D BMES^XPDUTL("Total entries modified: "_CNT)
 Q
ICD(X) Q $P($G(^ICD9(+X,0)),U)
