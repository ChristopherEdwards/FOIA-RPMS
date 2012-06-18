ADGCEN30 ; IHS/ADC/PDW/ENM - CENSUS AID-PATIENT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 N N,N0,N6,NAME,WARD,DGDT,DFN,IFN,TS,TY,TSNB
 K ^TMP($J)
 S TSNB=$S($O(^DIC(45.7,"B","NEWBORN",0)):$O(^(0)),1:"NEW")
A ; -- main
 D LP1,LP3,LP2,LP6
 G ^ADGCEN31  ;print report
 Q
 ;
LP1 ; -- loop admissions
 S DGDT=DGBDT-.0001
 F  S DGDT=$O(^DGPM("AMV1",DGDT)) Q:'DGDT!(DGDT>DGEDT)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV1",DGDT,DFN,IFN)) Q:'IFN  D ADM
 Q
 ;
ADM ; -- admission
 S N=$G(^DGPM(IFN,0)),N0=$G(^DPT(DFN,0)),N6=$G(^DGPM(+$$TS,0))
 S NAME=$P(N0,U),WARD=$P($G(^DIC(42,+$P(N,U,6),0)),U),TS=$P(N6,U,9)
 ; -- screen (selected ward? "A"=all wards)
 I DGWD'="A",$P(N,U,6)'=DGWD Q
 ; -- newborn
 I TS=TSNB D  Q
 . S ^TMP($J,"NEWA",WARD,DGDT,NAME,DFN)=""
 ; -- other
 S ^TMP($J,"AA",WARD,DGDT,NAME,DFN)=""
 Q
 ;
LP3 ; -- loop discharges
 S DGDT=DGBDT-.0001
 F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>DGEDT)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV3",DGDT,DFN,IFN)) Q:'IFN  D DSC
 Q
 ;
DSC ; -- discharge
 S N=$G(^DGPM(IFN,0)),N0=$G(^DPT(DFN,0)),N6=$G(^DGPM(+$$TS,0))
 S NAME=$P(N0,U),WARD=$P($G(^DIC(42,+$P($G(^DGPM(+$$MP,0)),U,6),0)),U)
 S TY=$P(N,U,4),TS=$P(N6,U,9)
 ; -- screen (selected ward? "A"=all wards)
 I DGWD'="A",$P($G(^DGPM(+$$MP,0)),U,6)'=DGWD Q
 ; -- newborn
 I TS=TSNB D  Q
 . S ^TMP($J,"NEWD",WARD,DGDT,NAME,DFN)=""
 ; -- death
 I $$DEATH D  Q
 . S ^TMP($J,"DT",WARD,DGDT,NAME,DFN)=""
 ; -- other
 S ^TMP($J,"AD",WARD,DGDT,NAME,DFN)=""
 Q
 ;
LP2 ; -- loop ward transfers
 S DGDT=DGBDT-.0001
 F  S DGDT=$O(^DGPM("AMV2",DGDT)) Q:'DGDT!(DGDT>DGEDT)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV2",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV2",DGDT,DFN,IFN)) Q:'IFN  D TRN
 Q
 ;
TRN ; -- ward transfers
 S N=$G(^DGPM(IFN,0)),N0=$G(^DPT(DFN,0)),N6=$G(^DGPM(+$$TS,0))
 S NAME=$P(N0,U),WARD=$P($G(^DIC(42,+$P(N,U,6),0)),U),TS=$P(N6,U,9)
 ; -- screen (selected ward? "A"=all wards)
 ; -- xfr in
 I DGWD="A"!($P(N,U,6)=DGWD) D  Q:DGWD'="A"
 . S ^TMP($J,"TI",WARD,DGDT,NAME,DFN)=""
 ; -- ward transfer, previous
 S CA=$P(N,U,14),ID=9999999.9999999-N
 S N6=$G(^DGPM(+$$TSP,0)),TS=$P(N6,U,9)
 S NAME=$P($G(^DPT(DFN,0)),U)
 S N=$G(^DGPM($$MP,0)),WARD=$P($G(^DIC(42,+$P(N,U,6),0)),U)
 I DGWD'="A",$P(N,U,6)'=DGWD Q
 ; -- xfr out
 S ^TMP($J,"TO",WARD,DGDT,NAME,DFN)=""
 Q
 ;
LP6 ; -- loop treating specialty transfers
 S DGDT=DGBDT-.0001
 F  S DGDT=$O(^DGPM("AMV6",DGDT)) Q:'DGDT!(DGDT>DGEDT)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV6",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV6",DGDT,DFN,IFN)) Q:'IFN  D TSC
 Q
 ;
TSC ; -- transfers from newborn service
 S N=$G(^DGPM(IFN,0)),TS=$P(N,U,9)
 I TS'=TSNB Q
 Q:'$$M6A
 S NAME=$P($G(^DPT(DFN,0)),U)
 S WARD=$P($G(^DIC(42,+$P($G(^DGPM(+$P(N,U,24),0)),U,6),0)),U)
 S ^TMP($J,"NEWT",WARD,DGDT,NAME,DFN)=""
 ; -- ward xfr too?
 I +$P($G(^DGPM(+N,0)),U,24) S ^TMP($J,"TI",WARD,DGDT,NAME,DFN)=""
 Q
 ;
MP() ; -- movement, previous
 Q $O(^DGPM("APID",DFN,+$O(^DGPM("APID",DFN,9999999.9999999-DGDT)),0))
 ;
DEATH() ; -- type of discharge death
 Q $S((+$G(^DG(405.1,+TY,"IHS"))>3)&(+$G(^DG(405.1,+TY,"IHS"))<8):1,1:0)
 ;
M6A() ; -- movement, ts, next
 Q $O(^DGPM("APTT6",DFN,+$O(^DGPM("APTT6",DFN,DGDT)),0))
 ;
TS() ; -- t.s. ifn
 Q:$O(^DGPM("APHY",+IFN,0)) $O(^DGPM("APHY",+IFN,0))
 Q $O(^($O(^DGPM("ATS",DFN,+$P(N,U,14),9999999.9999999-N)),0))
 ;
TSP() ; -- t.s, previous
 Q $O(^($O(^DGPM("ATS",DFN,CA,ID)),0))
