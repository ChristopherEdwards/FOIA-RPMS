APCLPDBL ; IHS/CMI/LAB - Routine to send bulletin if patient has certain PRE-DM test results ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 Q  ;not at top
EN(T,P,V,RES) ;EP - Called by PD mumps x-ref on Results Field (.04)of V Lab File
 NEW APCLTNAM,APCLIFGT,APCLIGTT,XMB
 S APCLTNAM=$P(^LAB(60,T,0),U)  ;test name
 S APCLIFGT=$O(^ATXLAB("B","DM AUDIT FASTING GLUCOSE TESTS",0))  ;FBS taxonomy ien
 S APCLIGTT=$O(^ATXLAB("B","DM AUDIT 75GM 2HR GLUCOSE",0))  ;2 hr GTT taxonomy ien
 Q:APCLIFGT=""
 Q:APCLIGTT=""
 I $D(^ATXLAB(APCLIFGT,21,"B",T)) S XMB="APCL IFG NOTIFICATION"
 I $D(^ATXLAB(APCLIGTT,21,"B",T)),RES>139 S XMB="APCL IGT NOTIFICATION"
 Q:$G(XMB)']""
 I 'P,$D(BLRVADFN) S P=BLRVADFN
 Q:$$DMDX(P)="Yes"  ;quit if pt has DM dx 
 I $G(P) S XMB(1)=$P(^DPT(P,0),U)
 I $D(^AUPNVSIT(V)) D
 .S D=$P(^AUPNVSIT(V,0),U),XMB(2)=$$FMTE^XLFDT(D)
 .S XMB(3)=$P(^DIC(4,$P(^AUPNVSIT(V,0),U,6),0),U)  ;location of visit
 .S XMB(4)=$$COMMRES^AUPNPAT(P,"E") ;current community
 .S XMB(5)=$P($G(^AUPNPAT(P,41,DUZ(2),0)),U,2)
 .S XMB(6)=$$DOB^AUPNPAT(P,"E")  ;DOB
 .S XMB(7)=APCLTNAM
 .S XMB(8)=RES
 .S XMDUZ=.5
 .S XMDT=DT
 .D ^XMB
 ;K XMB,V,D,COMM,HRN,DOB,T,APCLIFGT,APCLIGTT,RES,APCLTNAM,APCLX
 Q
 ;
DMDX(P) ;
 ;check problem list OR must have 3 diagnoses
 N Z S Z=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'Z Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Yes"
 NEW APCLX,E
 S APCLX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,"APCLX(") G:E DMX I $D(APCLX(3)) S APCLX="Yes"
 I $G(APCLX)="" S APCLX="No"
DMX ;
 Q APCLX
 ;
