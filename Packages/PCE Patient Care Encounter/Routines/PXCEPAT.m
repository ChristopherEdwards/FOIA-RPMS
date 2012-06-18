PXCEPAT ;ISL/dee,ISA/KWP - Creates the List Manager display of visit for a patient ;04/30/99
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**1,5,14,30,70**;Aug 12, 1996
 Q
 ;
NEWPAT2 ;Entry point of changing patient from Update Encounter
 N PXCENEWP
 D PATIENT(.PXCENEWP)
 Q:PXCENEWP'>0
 D PATKILL
 S PXCEPAT=+PXCENEWP
NEWPAT1 ;Entry point for initial selection of patient
 D PATINFO(.PXCEPAT)
 I $P(PXCEVIEW,"^",1)'="P" D
 . S $P(PXCEVIEW,"^",1)="P"
 . D SETDATES^PXCE
 S SDAMTYP="P"
 I PXCEVIEW["A" K PXCEHLOC
 Q
 ;
NEWPAT ; -- init variables and list array
 N PXCENEWP
 D PATIENT(.PXCENEWP)
 I PXCENEWP'>0,("~H~P~"'[("~"_$P(PXCEVIEW,"^")_"~")) S VALMQUIT=1 Q
 I PXCENEWP'>0 Q
 D PATKILL
 S PXCEPAT=+PXCENEWP
 D NEWPAT1
 D MAKELIST^PXCENEW
 Q
 ;
MAKELIST ;
 N PXCEDATE,PXCELOC,PXCESTAT,PXCEDT,PXCEIEN,PXCEVSIT,PXCEPRIM
 D CHGCAP^VALM("LOCATION","Clinic")
 K VALMHDR S VALMBCK="R"
 S PXCEDT=PXCE9END
 D CLEAN^VALM10
 K ^TMP("PXCEIDX",$J)
 S VALMBG=1
 S VALMCNT=0
 F  S PXCEDT=$O(^AUPNVSIT("AA",PXCEPAT,PXCEDT)) Q:PXCEDT'>0!(PXCEDT>PXCE9BEG)  D
 . S PXCEIEN=""
 . F  S PXCEIEN=$O(^AUPNVSIT("AA",PXCEPAT,PXCEDT,PXCEIEN)) Q:PXCEIEN'>0  D
 .. S PXCEVSIT=^AUPNVSIT(PXCEIEN,0)
 .. I $D(PXCEHLOC),$P(PXCEVSIT,"^",22)'=PXCEHLOC Q
 .. S PXCEPRIM=$P($G(^AUPNVSIT(PXCEIEN,150)),"^",3)
 .. ;+do not show encounter if the encounter type is S,C or null
 .. Q:"SC"[PXCEPRIM
 .. I PXCEKEYS'["S",PXCEKEYS'["V","A"=PXCEPRIM Q  ;+let supervisor and viewer see ancillary encounters
 .. I PXCEKEYS'["V",$$DISPOSIT^PXUTL1(PXCEPAT,+PXCEVSIT,PXCEIEN) Q  ;+let viewer see disposition
 .. S VALMCNT=VALMCNT+1
 .. S Y=$P(PXCEVSIT,"^",1)
 .. S PXCEDATE=$$DATE^PXCEDATE($P(PXCEVSIT,"^",1))
 .. S PXCEDATE=$E(PXCEDATE,1,18)_$J("",(19-$L(PXCEDATE)))
 .. I $P(PXCEVSIT,"^",7)="E" D
 ... S PXCELOC="  Historical Encounter at "
 ... I $P(PXCEVSIT,"^",6)]"" D
 .... N PXCEDELF
 .... S PXCESTAT=$E($$EXTERNAL^DILFD(9000010,.06,"",$P(PXCEVSIT,"^",6),"PXCEDILF"),1,30)
 ... E  S PXCESTAT=$E($P($G(^AUPNVSIT(PXCEIEN,21)),"^"),1,30)
 .. E  D
 ... S PXCELOC=$S($P(PXCEVSIT,"^",22)>0:$P(^SC($P(PXCEVSIT,"^",22),0),"^"),$P(PXCEVSIT,"^",7)="E":"   Historical",1:"")
 ... S PXCELOC=$E(PXCELOC,1,26)_$J("",(28-$L(PXCELOC)))
 ... S PXCESTAT=$P($$STATUS^SDPCE(PXCEIEN),"^",2)
 .. S ^TMP("PXCE",$J,VALMCNT,0)=$J(VALMCNT,4)_" "_PXCEDATE_PXCELOC_PXCESTAT
 .. S ^TMP("PXCEIDX",$J,VALMCNT)=PXCEIEN
 S ^TMP("PXCEIDX",$J,0)=VALMCNT
 I VALMCNT'>0 D
 . S ^TMP("PXCE",$J,1,0)=" "
 . S ^TMP("PXCE",$J,2,0)="    No encounter found that satisfy the above criteria."
 . S VALMCNT=2
 Q
 ;
SDSALONE ;Get the patient for standalone from the appointment/hospital
 ;location screen
 Q:$G(PXCEPAT)>0
 D PATIENT(.PXCEPAT)
 I PXCEPAT>0 D PATINFO(.PXCEPAT) S PXCEJPAT=1
 Q
 ;
SDKALONE ;Kill the patient info if it was created above
 Q:'$D(PXCEJPAT)
 D PATKILL
 K PXCEJPAT
 Q
 ;
JUSTDFN ;Just set DFN for other packages.
 Q
 Q:$G(DFN)>0
 N X,Y,DIC,DA
 S DIC=2,DIC(0)="AEMQ"
 D ^DIC
 I +Y>0 S DFN=+Y,PXCEJDFN=1
 Q
 ;
JUSTDFNK ;Kill DFN if it was set above
 I $G(PXCEJDFN) K DFN,PXCEJDFN
 I $G(PXCEPAT)>0 S DFN=PXCEPAT
 Q
 ;
PATIENT(PXCEDATA) ; Select a patient
 N X,Y,DIC,DA
 D FULL^VALM1
 S DIC=2,DIC(0)="AEMQ"
 D ^DIC
 S PXCEDATA=+Y
 Q
 ;
PATINFO(PXCEDATA) ;
 Q:PXCEDATA'>0
 N Y
 S (DFN,SDFN,ORVP,Y)=PXCEDATA
 ;Set IHS patient variables
 D START^AUPNPAT
 D PATNAME(.PXCEDATA)
 N VAERR,VAROOT,PXCEVA,PXCEINDX
 S VAROOT="PXCEVA"
 D ELIG^VADPT
 S PXCEDATA("ELIG")=$P($G(PXCEVA(1)),"^",1,99)
 S PXCEINDX=""
 F  S PXCEINDX=$O(PXCEVA(1,PXCEINDX)) Q:'PXCEINDX  S PXCEDATA("ELIG",PXCEINDX)=$P(PXCEVA(1,PXCEINDX),"^",1,99)
 Q
 ;
PATNAME(PXCEDATA) ;
 S PXCEDATA("NAME")=$P($G(^DPT(+PXCEDATA,0)),"^",1)
 N VAPTYP,VA,VAERR,DFN
 S DFN=+PXCEDATA
 D PID^VADPT6
 I 'VAERR S PXCEDATA("SSN")=VA("PID"),PXCEDATA("SSN_BRIEF")=VA("BID")
 E  S (PXCEDATA("SSN"),PXCEDATA("SSN_BRIEF"))=""
 Q
 ;
PATKILL ;
 K PXCEPAT,DFN,SDFN,ORVP
 ; Kill IHS patient variables
 D KILL^AUPNPAT
 Q
 ;
APPOINT(DFN,DATETIME,HOSLOC) ;See if there is an appointment.
 ;Input:
 ;  DFN       ien of the patient
 ;  DATETIME  the date and time of the appointment
 ;  HOSLOC    optional, is the Hospital Location (#44)
 ;Returns the clinic ien or -1 if no appointement.
 ;
 N VASD,HL,INDEX,VAERR
 K ^UTILITY("VASD",$J)
 S VASD("T")=DATETIME
 S VASD("F")=DATETIME-.00000001
 S VASD("W")=129 ;1)Active/Kept 2)Inpatient appts. only 9)No action taken
 S:$G(HOSLOC) VASD("C",HOSLOC)=""
 D SDA^VADPT
 I VAERR S HL=-1 G QAPPOINT
 S INDEX=$O(^UTILITY("VASD",$J,0))
 I INDEX>0 S HL=$P(^UTILITY("VASD",$J,INDEX,"I"),"^",2)
 E  S HL=-1
QAPPOINT K ^UTILITY("VASD",$J)
 Q HL
 ;
