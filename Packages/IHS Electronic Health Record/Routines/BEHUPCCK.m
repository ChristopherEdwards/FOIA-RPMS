BEHUPCCK ;MSC/IND/DKM - Verifies that visit patient matches V file entries ;04-May-2006 08:19;DKM
 ;;1.2;BEH UTILITIES;;Mar 20, 2007
 ;=================================================================
 N DAT,DFN,IEN,X,VFIL,GBL,PCC,CNT,TOT,FLG,XRF
 W !!,"Lists V file entries whose patient does not match parent visit.",!!
 W "Output format is:",!
 W ?5,"VISIT IEN,VFIL,VFIL IEN,VISIT DFN,VFIL DFN",!!
 S CNT=0,TOT=0,XRF="B"  ; OR "APCIS"
 S %DT="AE",%DT("A")="Search all visits on or after: "
 D ^%DT
 Q:Y<1
 D ^%ZIS
 Q:POP
 W !!
 U IO
 F DAT=Y:0 D  S DAT=$O(^AUPNVSIT(XRF,DAT)) Q:'DAT
 .F IEN=0:0 S IEN=$O(^AUPNVSIT(XRF,DAT,IEN)) Q:'IEN  D
 ..S X=^AUPNVSIT(IEN,0),DFN=$P(X,U,5),FLG=0
 ..F VFIL=9000010:0 S VFIL=$O(^DIC(VFIL)) Q:VFIL\1'=9000010  D
 ...S GBL=$$ROOT^DILFD(VFIL,,1),VFIL(0)=$P(@GBL@(0),U)
 ...F PCC=0:0 S PCC=$O(@GBL@("AD",IEN,PCC)) Q:'PCC  D
 ....S X=@GBL@(PCC,0)
 ....Q:$P(X,U,2)=DFN
 ....W IEN,U,VFIL(0),U,PCC,U,$$PATNAM(DFN),U,$$PATNAM($P(X,U,2)),!
 ....S TOT=TOT+1
 ....S:'FLG CNT=CNT+1,FLG=1
 W !!,"Visits: ",CNT,!,"Total: ",TOT,!!
 R:$E(IOST,1,2)="C-" !!,"Press ENTER to continue...",X:DTIME,!
 D ^%ZISC
 Q
PATNAM(DFN) Q $P($G(^DPT(+DFN,0),"Unknown"),U)
