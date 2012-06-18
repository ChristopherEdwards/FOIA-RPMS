BWMDE ;IHS/ANMC/MWR - EXPORT MDE'S FOR CDC.;29-Oct-2003 21:28;PLS
 ;;2.0;WOMEN'S HEALTH;**3,5,7,8,9**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CDC EXPORT, MAIN DRIVER FOR COLLECTION AND EXPORT OF DATA TO
 ;;  HOST FILE SERVER.
 ;
 ;IHS/CMI/LAB - patch 3 9/30/98 added age cutoff parameters
 ;IHS/CMI/THL - patch 5 new cde export format
 ;IHS/CMI/THL - patch 8 new cde export content
 ;
 D EXPORT
 Q
 ;
 ;
START ;EP
 ;---> CALLED FROM EXPORT^BWMDE (BELOW).
 D SETVARS^BWUTL5
 D CHECKS^BWMDE4 G:BWPOP EXIT
 D SELECT
 G:BWPOP EXIT
 S DIR(0)="YO",DIR("A")=" Queue EXPORT to run in background",DIR("B")="YES"
 D ^DIR
 K DIR
 I $D(DIRUT) W !!,"EXPORT aborted..." H 3 Q
 I Y=1 D  Q
 . S BWPATH=$P(^BWSITE(DUZ(2),0),U,14)  ;K IO(1)
 . S BWFLNM=$P(^BWSITE(DUZ(2),0),U,13)_$E(DT,4,5)_$E(DT,2,3)_$S($G(BWXPORT):"",1:"LC")_BWCDCV
 . W !!?5,"The file ",BWFLNM," will be available in ",BWPATH
 . W !?5,"after the export is complete which could take up to an hour."
 . D DIRZ^BWUTL3
 . D LOAD(BWBEGDT,BWENDDT,.BWLOC,.BWHCF,.BWCC,.BWPRV,BWCUTF,BWCUTO)
S2 ;FOR SILENT CALL
 D DATA
 G:BWPOP EXIT
 D HFS^BWMDEU1
EXIT ;
 D KILLALL^BWUTL8
 Q
 ;
 ;
LOAD(BWBEGDT,BWENDDT,BWLOC,BWHCF,BWCC,BWPRV,BWCUTF,BWCUTO) ;EP;TO QUEUE EXPORT TO RUN IN BACKGROUND
 ; BWBEGDT - BEGINNING DATE FOR EXPORT
 ; BWENDDT - ENDING DATE FOR EXPORT
 ; BWLOC   - ARRAY OF LOCATIONS TO INCLUDE
 ; BWHCF   - ARRAY OF HEALTH CARE FACILITIES TO INCLUDE
 ; BWCC    - ARRAY OF COMMUNITIES TO INCLUDE
 ; BWPRV   - ARRAY OF PROVIDERS TO INCLUDE
 ; BWCUTF  - YOUNGEST AGE TO INCLUDE
 ; BWCUTO  - OLDEST AGE TO INCLUDE
 S (BWLOC,BWHCF,BWCC,BWPRV)=""
 Q:'$G(BWBEGDT)!'$G(BWENDDT)!'$G(BWCUTF)!'$G(BWCUTO)
 S:'$G(BWLOC) BWLOC("ALL")=""
 S:'$G(BWHCF) BWHCF("ALL")=""
 S:'$G(BWCC) BWCC("ALL")=""
 S:'$G(BWPRV) BWPRV("ALL")=""
 S BWSILENT=""
 S ZTRTN="S1^BWMDE",ZTDESC=$G(BWTITLE,"EXPORT MDE DATA FOR CDC"),ZTDTH=$H,ZTIO=""
 S ZTSAVE("BW*")=""
 D ^%ZTLOAD
 Q
 ;
 ;
S1 ;EP;TO RUN EXPORT IN BACKGROUND
 D SETVARS^BWUTL5
 D CHECKS^BWMDE4 G:BWPOP EXIT
 D S2
 Q
 ;
 ;
SELECT ;EP
 ;---> EXPORT DATA.
 D TITLE^BWUTL5(BWTITLE)
 ;
DATES ;EP
 ; Select data range for export.
 W !!?3,"Select the Date Range for this export."
 W !?5,"The Begin Date may not precede the Date CDC Funding Began,"
 W !?5,"as set on page 2 of the Edit Site Parameters screen."
 W !?5,"The End Date should be the cutoff date for this MDE Submission."
 S BWSTTDT=$P(^BWSITE(DUZ(2),0),U,17)
 D ASKDATES^BWUTL3(.BWBEGDT,.BWENDDT,.BWPOP,BWSTTDT)
 Q:BWPOP
 I BWBEGDT<BWSTTDT D  G DATES
 . W !!?5,"* The Begin Date you have selected is before the Date CDC"
 . W " Funding Began.",!?7,"Please begin again."
 ;
 ; Select cases for one or more ward/clinic/locations (or ALL).
 D SELECT^BWSELECT("Ward/Clinic/Location",44,"BWLOC","","",.BWPOP)
 Q:BWPOP
 ;
 ; Select cases for one or more health care facilities (or ALL).
 D SELECT^BWSELECT("Health Care Facility",9999999.06,"BWHCF","",DUZ(2),.BWPOP)
 Q:BWPOP
 ;
 ; Select cases for one or more current community (or ALL).
 ; Do not prompt for a current community if this is a VA site.
 I $$AGENCY^BWUTL5(DUZ(2))'="i" S BWCC("ALL")=""  ;VAMOD
 E  D SELECT^BWSELECT("Current Community",9999999.05,"BWCC","","",.BWPOP)
 Q:BWPOP
 ;
 ; Select cases for one or more providers ( or ALL).
 D SELECT^BWSELECT("Provider",200,"BWPRV","","",.BWPOP)
 Q:BWPOP
 ;IHS/CMI/LAB - patch 3 added lower and higher age cutoffs 9/30/98
 ;IHS/CMI/LAB - next 17 or so lines added patch 3
 ; Enter an age cutoff.
 N DIR
 W !!,"   Enter a patient age for youngest patient to be exported."
 S DIR("?")="     Procedures for patients under the age you enter will NOT be exported"
 S DIR(0)="N^0:99",DIR("A")="   Enter an age (0-99)",DIR("B")=18 ;IHS/CMI/THL PATCH 8 YOUNGEST AGE 18
 D ^DIR
 K DIR
 W !
 I $D(DIRUT) S BWPOP=1 Q
 S BWCUTF=Y
 N DIR
 W !!,"   Enter a patient age for the oldest patient to be exported."
 S DIR("?")="     Procedures for patients under the age you enter will"
 S DIR("?")=DIR("?")_" NOT be exported"
 S DIR(0)="N^0:99",DIR("A")="   Enter an age (0-99)",DIR("B")=99
 D ^DIR K DIR W !
 I $D(DIRUT) S BWPOP=1 Q
 S BWCUTO=Y
 ;===> IHS/CMI/LAB patch 3  MODS END
 ;
 ; If this is an export, get final okay to continue.
 I BWXPORT D  Q:BWPOP
 . N DIR
 . W !!,"   Do you REALLY wish to export records for CDC now?"
 . S DIR("?")="     Enter YES to export records, enter NO to abort this"
 . S DIR("?")=DIR("?")_" process."
 . S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="YES"
 . D ^DIR W !
 . I $D(DIRUT)!(Y=0) W !?25,"* NO RECORDS EXPORTED. *" D DIRZ^BWUTL3  S BWPOP=1
 Q
 ;
 ;
DATA ;EP
 ; Retreive data and store in ^BWTMP(.
 ;
 I '$D(BWSILENT),'$D(ZTQUEUED) W @IOF,!!?3,"Please hold while records are scanned.  This may take several minutes..."
 ;
 ; CDC MDE version# for this export.
 S BWCDCV=$S($P(^BWSITE(DUZ(2),0),U,18):$P(^BWSITE(DUZ(2),0),U,18),1:41)
 ; Test host file access.
 ; If not valid path, will fail with a <MODER>.
 ; Purpose here is to test host file access before flagging procedures as exported.
 S BWPATH=$P(^BWSITE(DUZ(2),0),U,14)  ;K IO(1)
 S BWFLNM=$P(^BWSITE(DUZ(2),0),U,13)_$E(DT,4,5)_$E(DT,2,3)_$S($G(BWXPORT):"",1:"LC")_BWCDCV
 S BWPOP=$$OPEN^%ZISH(BWPATH,BWFLNM,"W")
 D ^%ZISC
 I BWPOP D ERROR^BWMDEU1 S BWPOP=1
 ;
 ;IHS/CMI/THL - patch 5 to use alternate method for cbe/mams
 K ^BWTMP($J)
 S (BWNOFAC,BWOFAC)=0,BWDT=BWBEGDT-.00001,BWENDT=BWENDDT+.99999
 ; Loop through "D" XREF to pickup PCDS to be exported.
 F  S BWDT=$O(^BWPCD("D",BWDT)) Q:'BWDT!(BWDT>BWENDDT)  D
 . S BWIEN=0
 . F  S BWIEN=$O(^BWPCD("D",BWDT,BWIEN)) Q:'BWIEN  D
 . . I '$D(^BWPCD(BWIEN,0)) K ^BWPCD("D",BWDT,BWIEN) Q
 . . Q:$P($G(^BWPCD(BWIEN,3)),U,2)
 . . S BW0=^BWPCD(BWIEN,0),BW2=$G(^BWPCD(BWIEN,2))
 . . ; Quit if this is not a PAP (IEN=1) and not a screening MAM (IEN=28).
 . . ;IHS/CMI/THL - patch 5 to use this section for pap data only
 . . ;Q:$P(BW0,U,4)'=1&($P(BW0,U,4)'=28)  ;IHS/CIM/THL PATCH 8
 . . Q:"^1^28^25^26^"'[(U_$P(BW0,U,4)_U)  ;IHS/CIM/THL PATCH 8
 . . Q:"^25^26^"[(U_$P(BW0,U,4)_U)&($P(BW2,U,32)="")  ;IHS/CIM/THL PATCH 8
 . . I $P(BW0,U,4)=1 S BWPAP=1,BWMAM=0 ;IHS/CIM/THL PATCH 8
 . . I $P(BW0,U,4)'=1 S BWMAM=1,BWPAP=0 ;IHS/CIM/THL PATCH 8
 . . ;
 . . ;; Quit if this procedure has a result of "ERROR/DISREGARD".
 . . Q:$P(BW0,U,5)=8
 . . ;
 . . ; Quit if not selecting all clincs/wards and if this procedure was not performed in one of the clincs/wards selected.
 . . I '$D(BWLOC("ALL")) Q:'$P(BW0,U,11)  Q:'$D(BWLOC($P(BW0,U,11)))
 . . ;
 . . ; Quit if this procedure has no health care facility (store total rejected for no facility in BWNOFAC).
 . . I '$P(BW0,U,10) S BWNOFAC=BWNOFAC+1 Q
 . . ;
 . . ; Quit if not selecting all health care facilities and if this
 . . ; procedure was not performed in one of the facilities selected.
 . . I '$D(BWHCF("ALL")),'$D(BWHCF($P(BW0,U,10))) S BWOFAC=BWOFAC+1 Q
 . . ;
 . . ;IHS/CMI/LAB - patch 3 added age cutoff logic 9/30/97
 . . ; Quit is this patient is below the age cutoff
 . . N BWDFN,AGE
 . . S BWDFN=$P(BW0,U,2)
 . . I $D(BWTSEL),'$D(BWTSEL(+BWDFN)) Q  ; export for selected patients
 . . Q:$G(^DPT(BWDFN,0))["DEMO,"  ;IHS/CMI/THL PATCH 8
 . . Q:'$$INCCHK(BWDFN,$P(BW0,U,12))
 . . ; Retrieve patient's current age or age at time of death
 . . S AGE=+$$AGEAT^BWUTL1(BWDFN,$S(+$$DOD^AUPNPAT(BWDFN):$$DOD^AUPNPAT(BWDFN),1:DT))
 . . Q:BWCUTF>AGE
 . . Q:BWCUTO<AGE
 . . ; Quit if not selecting all current communities and if this
 . . ; procedure was not on a patient in one of the CC's selected.
 . . I '$D(BWCC("ALL")) D  Q:'BWCUR  Q:'$D(BWCC(BWCUR))
 . . . S BWCUR=$$CURCOM^BWUTL1($P(BW0,U,2))
 . . ;
 . . ; Quit if not selecting all providers and if this procedure
 . . ; was not performed by one of the providers selected.
 . . I '$D(BWPRV("ALL")) Q:'$P(BW0,U,7)  Q:'$D(BWPRV($P(BW0,U,7)))
 . . ;
 . . ; Go build the record for this patient
 . . D BUILD^BWMDE1(BWIEN,BWCDCV)
 . . ;
 . . I $P(BW0,U,4)'=1 S ^TMP("BWTPCD",$J,BWIEN)="" ;IHS/CIM/THL PATCH 8
 . . ;
 . . ; Not currently used. Retained in case IMS goes back
 . . ; If this is an export for CDC then update the CDC EXPORT DATE (#.16) and STATUS (#.17) fields.
 . . ; If callled from the "BW CDC EXTRACT FOR LOCAL" option, do not update these fields.
 . . ;D:BWXPORT CDCUPDT^BWPROC(BWIEN)
 ;D ^BWMDET
 Q
 ;
 ; Return Income exclusion flag
INCCHK(BWDFN,PROCDT) ; EP
 ; Input: PROCDT - Date of procedure
 ; Returns: 0=exclude procedure; 1=include procedure
 N ELGV,ELGDT
 Q:'$G(BWDFN)!('$G(PROCDT)) 1  ; include procedure by default
 S ELGV=+$P($G(^BWP(BWDFN,0)),U,29)  ; Income Eligible
 S ELGDT=+$P($G(^BWP(BWDFN,0)),U,30)  ; Income Eligible Date
 Q:'ELGV!('ELGDT) 1  ; include procedure by default
 Q $S(((ELGV=2)&(PROCDT'<ELGDT)):0,1:1)
 ;
 ;
EXPORT ;EP
 ; Called by option "BW CDC EXPORT DATA" exports data.
 ;
 N BWCDCV,BWCUTF,BWCUTO,BWBEGDT,BWENDDT,BWPOP,BWSILENT,BWSTTDT,BWTITLE,BWXPORT
 S BWTITLE="EXPORT MDE DATA FOR CDC",BWXPORT=1
 ; CDC MDE version# for this export.
 S BWCDCV=$S($P(^BWSITE(DUZ(2),0),U,18):$P(^BWSITE(DUZ(2),0),U,18),1:41)
 D START
 Q
 ;
 ;
EXTRACT ;EP
 ;---> * !!NOT USED AT THIS POINT, IMS (CDC CONTRACTOR) DECIDED NOT
 ;---> USE FLAGS.  RETAIN FOR FUTURE, IN CASE THEY SWITCH BACK!!
 N BWCDCV,BWCUTF,BWCUTO,BWBEGDT,BWENDDT,BWPOP,BWSILENT,BWSTTDT,BWTITLE,BWXPORT
 W !!?5,"NOT CURRENTLY FUNCTIONAL." Q
 ;---> CALLED BY OPTION "BW CDC EXTRACT FOR LOCAL", MERELY EXTRACTS
 ;---> CDC DATA TO HOST FILE FOR EVALUATION OR STATISTICAL ANALYSIS
 ;---> LOCALLY, WITHOUT UPDATING BW PROCEDURE CDC STATUS AND DATE
 ;---> FIELDS.
 S BWTITLE="EXTRACT MDE DATA FOR LOCAL ANALYSIS"
 ; CDC MDE version# for this export.
 S BWCDCV=$S($P(^BWSITE(DUZ(2),0),U,18):$P(^BWSITE(DUZ(2),0),U,18),1:41)
 S BWXPORT=0
 D START
 Q
