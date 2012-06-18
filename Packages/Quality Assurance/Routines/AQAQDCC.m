AQAQDCC ;IHS/ANMC/LJF - DELINQUENT CHARTS BY PROVIDER; [ 05/27/92  11:14 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;>>> FIND INCOMPLETE CHARTS & GET COUNTS BY PROVIDER <<<
 ;
 K ^UTILITY("AQAQDC",$J) S AQAQDTOT=0   ;total delq charts
 ;***> loop thru incomplete chart file by provider
 S AQAQPRV=0 K AQAQ
 F  S AQAQPRV=$O(^ADGIC("AC",AQAQPRV)) Q:AQAQPRV=""  D
 .S AQAQPRVN=$P(^DIC(16,AQAQPRV,0),U)    ;provider name
 .S DFN=0 F AQAQI=1:1:7 S AQAQ(AQAQI)=0  ;reset counts
 .F  S DFN=$O(^ADGIC("AC",AQAQPRV,DFN)) Q:DFN=""  D
 ..S AQAQDS=0
 ..F  S AQAQDS=$O(^ADGIC("AC",AQAQPRV,DFN,AQAQDS)) Q:AQAQDS=""  D
 ...S AQAQPM=0
 ...F  S AQAQPM=$O(^ADGIC("AC",AQAQPRV,DFN,AQAQDS,AQAQPM)) Q:AQAQPM=""  D
 ....;
 ....Q:'$D(^ADGIC(DFN,"D",AQAQDS,"P",AQAQPM,"C",0))  Q:$P(^(0),U,4)<1
 ....Q:'$D(^ADGIC(DFN,"D",AQAQDS,0))
 ....S AQAQSTR=^(0),AQAQDSD=$P(AQAQSTR,U)    ;discharge date for chart
 ....;
 ....;**> find all chart deficiencies for this prov for this discharge
 ....S AQAQCD="",AQAQX=0
 ....F  S AQAQX=$O(^ADGIC(DFN,"D",AQAQDS,"P",AQAQPM,"C",AQAQX)) Q:AQAQX'=+AQAQX  D
 .....S AQAQX1=$P(^(AQAQX,0),U)
 .....S AQAQCD=$S(AQAQCD="":AQAQX1,1:AQAQCD_U_AQAQX1)
 ....D COUNT        ;increment counts
 .;
 .;**> for each provider, set ^utility
 .S AQAQSTR=AQAQ(3) F AQAQI=4:1:7 S AQAQSTR=AQAQSTR_U_AQAQ(AQAQI)
 .S ^UTILITY("AQAQDC",$J,AQAQPRVN)=AQAQSTR
 .I AQAQADD D FILE       ;stuff data into credentials file
 ;
 ;**> find total delq charts for facility by patient
 S (DFN,AQAQDTOT)=0
 F  S DFN=$O(^UTILITY("AQAQDC","ZZ",DFN)) Q:DFN=""  S AQAQDTOT=AQAQDTOT+1
 I AQAQADD D DLQTOT     ;stuff facility delq total into entries
 ;
 ;>>> end of calculate <<<
NEXT ;***> if adding to file, kill vars then quit
 I AQAQADD=1 K ^UTILITY("AQAQDC") G KILL^AQAQUTIL
 ;***> else, go to print rtn
 E  G ^AQAQDCP
 ;
 ;>>> END OF MAIN CALCULATE RTN <<<
 ;
COUNT ;***> SUBRTN to increment chart counts for each provider
 S AQAQFLG=0 F AQAQI=4,5,6,7 S AQAQZ(AQAQI)=0
 F AQAQY=1:1 S AQAQX=$P(AQAQCD,U,AQAQY) Q:AQAQX=""  D
 .S AQAQG=$P(^ADGCD(AQAQX,0),U,3)    ;deficiency grouping
 .I AQAQG="ASH" S AQAQZ(5)=1,AQAQFLG=1 Q  ;a sheet always delq
 .I AQAQG="SIG" S AQAQZ(7)=1,AQAQFLG=1 Q        ;delq for sig
 .I AQAQG="OPR" S AQAQZ(4)=1,AQAQFLG=1 Q  ;delq for op report
 .I AQAQG="SUM" S AQAQZ(6)=1,AQAQFLG=1 Q  ;delq for summary
 .Q
 F AQAQY=4,5,6,7 S AQAQ(AQAQY)=AQAQ(AQAQY)+AQAQZ(AQAQY)
 I AQAQFLG S AQAQ(3)=AQAQ(3)+1,^UTILITY("AQAQDC","ZZ",DFN)=""  ;dlqnt
 Q
 ;
 ;
FILE ;***> SUBRTN to stuff # of delinquent charts into credentials file
 Q:'$D(^AQAQC(AQAQPRV,0))   ;provider not in credentials file
 I '$D(^AQAQC(AQAQPRV,"DLQ",0)) S ^AQAQC(AQAQPRV,"DLQ",0)="^9002165.04DA"
 S DIC="^AQAQC("_AQAQPRV_",""DLQ"",",DIC(0)="L",DA(1)=AQAQPRV,X=DT
 S DIC("DR")="1////^S X=AQAQ(3)" D FILE^DICN
 Q
 ;
 ;
DLQTOT ;***> SUBRTN to stuff total delq charts for facility into prov entries
 S AQAQPRV=0
 F  S AQAQPRV=$O(^AQAQC(AQAQPRV)) Q:AQAQPRV'=+AQAQPRV  D
 .Q:'$D(^AQAQC(AQAQPRV,"DLQ","B",DT))
 .S AQAQX=0
 .F  S AQAQX=$O(^AQAQC(AQAQPRV,"DLQ","B",DT,AQAQX)) Q:AQAQX=""  D
 ..S DIE="^AQAQC("_AQAQPRV_",""DLQ"",",DA(1)=AQAQPRV
 ..S DA=AQAQX,DR="2////^S X=AQAQDTOT" D ^DIE
 Q
 ;
 ;
JOB ;EP; >>> entry point for background job to add data to file
 ;
 ;***> set # of working days
 S X1=DT,X2=-30 D C^%DTC S AQAQDEL=X
 ;***> let calculate know this is rtn to add data to file
 S AQAQADD=1
 ;***> go to claculate rtn
 G ^AQAQDCC
