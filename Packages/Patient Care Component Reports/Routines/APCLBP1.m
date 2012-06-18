APCLBP1 ; IHS/CMI/LAB - CALC WEIGHT REPORT ;
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;
 ; APCLBTYP - blood pressure type measurement (4)
 ; APCLOCTL - Blood pressure out of control flag
START ;
 S APCLBTYP=$O(^AUTTMSR("B","BP",0))
 S Y=DT D DD^%DT S APCLDT=Y
 S APCLJOB=$J,APCLBTH=$H,APCLPTOT=0,APCLTPOC=0
 D XTMP^APCLOSUT("APCLBP","PCC BLOOD PRESSURE - OUT OF CONTROL - REPORT")
 ; If Search Template used
 I APCLSEAT'="" D  Q
 .S DFN=0 F  S DFN=$O(^DIBT(APCLSEAT,1,DFN)) Q:'DFN   I $D(^DPT(DFN,0)),'$P(^DPT(DFN,0),U,19) D PROC
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  I $D(^DPT(DFN,0)),'$P(^DPT(DFN,0),U,19) D PROC
 D KILL
 Q
 ;
PROC ;
 Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 S Y=DFN D ^AUPNPAT
 Q:AUPNSEX=""
 I APCLSEX'="B",APCLSEX'=AUPNSEX Q  ;quit if want only one sex and this patient isn't that sex
 ;
 ; Quit if communities are selected and the patient's community is blank
 ; or the patient's community is not one of the ones selected
 ;
 S APCLCMTY=$$COMMRES^AUPNPAT(DFN,"E") S:"-1"[APCLCMTY APCLCMTY=$P($G(^AUPNPAT(DFN,11)),U,18)
 I $D(APCLCOMM) Q:APCLCMTY=""  Q:'$D(APCLCOMM(APCLCMTY))
 S:APCLCMTY="" APCLCMTY="~UNKNOWN" ; the ~ puts it last in the sort
 ; Quit if no birth date
 Q:AUPNDOB=""
 S APCLAGE=(AUPNDAYS\365.25)
 S APCLCLAS=$$BEN^AUPNPAT(DFN,"C") ; returns classifications/beneficiary in format F
 Q:APCLCLAS=""
 I APCLIBEN=1,APCLCLAS'="01" Q
 S X1=DT,X2=AUPNDOB D ^%DTC S APCLAGE=(X\365.25) ;recalculate age based on date of weight
 I $D(APCLAGER) Q:APCLAGE<$P(APCLAGER,"-")  Q:APCLAGE>$P(APCLAGER,"-",2)
 ;
 ; APCLOCTL - Blood pressure out of control flag
 ;
 S (APCLOCTL,APCLTSBP,APCLTDBP,APCLBPC)=0
 S APCLDT=APCLED-1 F  S APCLDT=$O(^AUPNVMSR("AA",DFN,APCLBTYP,APCLDT)) Q:'APCLDT  Q:APCLDT>APCLSD  D
 .S APCLMIEN=0 F  S APCLMIEN=$O(^AUPNVMSR("AA",DFN,APCLBTYP,APCLDT,APCLMIEN)) Q:'APCLMIEN  D:$D(^AUPNVMSR(APCLMIEN))
 ..Q:$P($G(^AUPNVMSR(APCLMIEN,2)),U,1)  ;entered in error
 ..S APCLVSIT=$P(^AUPNVMSR(APCLMIEN,0),U,3),APCLCLIN=$P(^AUPNVSIT(APCLVSIT,0),U,8)
 ..I $D(APCLCLNT) Q:APCLCLIN=""  Q:'$D(APCLCLNT(APCLCLIN))
 ..S APCLVCLN=APCLCLIN,APCLBPC=APCLBPC+1,APCLSBP=$P(^AUPNVMSR(APCLMIEN,0),U,4),APCLDBP=$P(APCLSBP,"/",2),APCLSBP=+APCLSBP,APCLTSBP=APCLTSBP+APCLSBP,APCLTDBP=APCLTDBP+APCLDBP
 ;
 ; If blood pressure count (APCLPBC) > 0 then the patient meets the selection criteria
 ; APCLPTOT - Total patients that were checked
 ; APCLTPOC - Total patients with BP out of control
 ; APCLTOCTL  blood pressure out of control flag
 ;           =  1 or 11 Systolic out of control (#10>0)
 ;           = 10 or 11 Diastolic out of control (> 1)
 D:APCLBPC
 .S APCLOCTL=0,APCLMSBP=APCLTSBP\APCLBPC
 .S:APCLMSBP>129 APCLOCTL=1
 .I APCLRTYP="S" S APCLBPTY=1,APCLSORT=APCLCMTY,APCLTBP=APCLTSBP D COUNT1 S APCLSORT=0 D COUNT1
 .S APCLMDBP=APCLTDBP\APCLBPC S:APCLMDBP>79 APCLOCTL=APCLOCTL+10
 .I APCLOCTL,APCLRTYP="C" S ^DIBT(APCLSTMP,1,DFN)="" Q
 .I APCLRTYP="S" S APCLBPTY=2,APCLSORT=APCLCMTY,APCLTBP=APCLTDBP D COUNT1 S APCLSORT=0 D COUNT1
 Q:APCLRTYP="C"
 D
 .;If the report type is Detail save patient data and B/P readings only,
 .; otherwise collect summary statistics data
 .;
 .I APCLRTYP="D" D:APCLOCTL SET Q
 .S APCLSORT=APCLCMTY D COUNT ; do count for community
 .S APCLSORT=0 D COUNT ; do count for total
 Q
 ;
 ; APCLSORT - is the community name, it's set to zero when summing stats
 ;            for the grand total
 ;
 ; stored at the APCLSORT level:
 ;Piece
 ; 1    APCLCPT - Patient count
 ; 2    APCLCBC - count of blood pressures taken
 ; APCLTYP = 1  used to store systolic values
 ;         = 2  used to store diastolic values
 ; Pieces stored at this level pertaining to the specific type
 ; 1    Sum total of values of blood pressure readings
 ; 2    total out of countrol patients
 ; 3    total out of control counts of B/P
 ; 4    Sum total of values of blood pressures readings for
 ;      out of control blood pressures
 ;
 ; Used for setting data for the statistical summary report
COUNT ;
 S APCLPTOT=APCLPTOT+1
 S APCLX=$G(^XTMP("APCLBP",APCLJOB,APCLBTH,"STATS",APCLSORT))
 S APCLCPT=$P(APCLX,U)+1,APCLTOPT=$P(APCLX,U,2)+(APCLOCTL>0),APCLCBC=$P(APCLX,U,3)+APCLBPC
 S ^XTMP("APCLBP",APCLJOB,APCLBTH,"STATS",APCLSORT)=APCLCPT_U_APCLTOPT_U_APCLCBC
 Q
 ;
COUNT1 ;
 S APCLX=$G(^XTMP("APCLBP",APCLJOB,APCLBTH,"STATS",APCLSORT,APCLBPTY))
 S APCLCTB=$P(APCLX,U,1)+APCLTBP,APCLTOP=$P(APCLX,U,2),APCLTOBC=$P(APCLX,U,3),APCLTOBP=$P(APCLX,U,4)
 I APCLOCTL,$S(APCLBPTY=1:APCLOCTL#10,1:APCLOCTL>1) S APCLTOP=APCLTOP+1,APCLTOBC=APCLTOBC+APCLBPC,APCLTOBP=APCLTOBP+APCLTBP
 S ^XTMP("APCLBP",APCLJOB,APCLBTH,"STATS",APCLSORT,APCLBPTY)=APCLCTB_U_APCLTOP_U_APCLTOBC_U_APCLTOBP
 Q
 ;
 ; Collects data for the detail report
SET ;
 S APCLPTOT=APCLPTOT+1
 S APCLNAME=$P(^DPT(DFN,0),U)
 S APCLHRN=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"NONE")
 ; If sort is neither Patient or Age then the report type must be
 ; Summary, not Detail, therefore community will be used for the sort
 S APCLSRT=$S(APCLSORT="P":APCLNAME,APCLSORT="A":APCLAGE,1:APCLCMTY)
 S:APCLVCLN'="" APCLVCLN=$P(^DIC(40.7,APCLVCLN,0),U,1)
 S ^XTMP("APCLBP",APCLJOB,APCLBTH,"PATS",APCLSRT,DFN)=APCLNAME_U_APCLHRN_U_APCLAGE_U_AUPNSEX_U_APCLCMTY_U_APCLVCLN_U_APCLBPC_U_$J(APCLMSBP,3)_"/"_APCLMDBP
 Q
 ;
KILL ;
 K APCLAGE,APCLBPC,APCLBPTY,APCLBTYP,APCLCBC,APCLCLAS,APCLCMTY,APCLCPT,APCLCTB,APCLDT,APCLGRAN,APCLHRN,APCLMBP,APCLMDBP,APCLMIEN,APCLMSBP,APCLNAME,APCLOCTL,APCLSORT,APCLSRT,APCLTBP
 K APCLTDBP,APCLTOBC,APCLTOBP,APCLTOP,APCLTOPT,APCLTPOC,APCLTSBP,APCLVCLN,APCLX,DFN,X1,X2,Y
 D KILL^AUPNPAT
 Q
