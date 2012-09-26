BSDX37 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;  NS  = RETURN NO-SHOW DATA FOR GIVEN PATIENT - RPC
 ;  VAL = return boolean to represent that a clinic allows variable appointment length - RPC
 ;
 ;RETURN NO-SHOW DATA FOR GIVEN PATIENT - RPC
NS(BSDXY,DFN,SDCL) ;COLLECT NO-SHOW DATA
 ;  .BSDXY   = returned pointer to NO SHOW data
 ;   DFN = patient code - pointer to ^DPT(DFN)
 ;   SDCL = clinic code - pointer to Hospital Location file ^SC
 N BSDXI,NSC,SD2,SDCLN,SDT,SDTN
 D ^XBKVAR S X="ERROR^BSDX37",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 ;check for valid resource
 I '+DFN D ERR("Invalid Patient ID.") Q
 I '$D(^DPT(DFN,0)) D ERR("Invalid Patient ID.") Q
 ; data header
 ; TOO_MANY = flag  0=OK; 1=too many no shows
 S ^BSDXTMP($J,0)="I00020PATIENT_IEN^I00020CLINIC_IEN^I00020TOO_MANY^I00020ALLOWED_NO_SHOWS^I00020TOTAL_NO_SHOWS"_$C(30)
 ;get allowed number of no shows for clinic
 S SDCLN=$G(^SC(SDCL,"SDP"))
 ;loop thru schedule
 S NSC=0  ;no show counter
 S SDT=0
 F  S SDT=$O(^DPT(DFN,"S",SDT)) Q:SDT'>0  D
 . S SDTN=^DPT(DFN,"S",SDT,0)
 . I ($P(SDTN,U)=SDCL) D
 . . S SD2=$P(SDTN,U,2)
 . . I SD2["N",$$NOSHOW(DFN,SDT,$P(SDTN,U),SDTN) S NSC=NSC+1
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=DFN_U_SDCL_U_($P(SDCLN,U,1)<=NSC)_U_$P(SDCLN,U)_U_NSC
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
NOSHOW(DFN,SDT,CIFN,PAT) ;Input:  DFN=Patient IFN, SDT=Appointment D/T
 ;  CIFN=Clinic IFN, PAT=Zero node of pat. appt., DA=Clinic appt. IFN
 ;                        Output:  1 or 0 for noshow yes/no
 N NSQUERY,NS S NS=1,NSQUERY=$$STATUS^SDAM1(DFN,SDT,CIFN,PAT)
 I $P(NSQUERY,";",3)["ACTION REQ" S NS=0
NOSHOWQ Q NS
 ;
 ;return boolean to represent that a clinic allows variable appointment length - RPC
VAL(BSDXY,SDCL) ;return boolean to represent that a clinic allows variable appointment length - RPC
 ; BSDX CLINIC VAR APPT
 N BSDXI
 D ^XBKVAR S X="ERROR^BSDX37",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 ;check for valid clinic ID
 I '+SDCL D ERR("Invalid Clinic ID.") Q
 I '$D(^SC(SDCL,0)) D ERR("Invalid Clinic ID.") Q
 ; data header
 ; VAR_APPT_FLAG = flag  0=Clinic does not Allow Variable Appointment; 1=Clinic Allows Variable Appointment
 S ^BSDXTMP($J,0)="I00020VAR_APPT_FLAG"_$C(30)
 ;get VARIABLE APPOINTMENT FLAG for clinic
 S VAL=$$GET1^DIQ(44,SDCL_",",1913) ;Variable Appointment Length
 S VAL=$S(VAL["YES":1,1:0)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=VAL
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
ERROR ;
 D ERR("RPMS Error")
 Q
 ;
ERR(BSDXERR) ;Error processing
 I +BSDXERR S BSDXERR=ERRNO+134234112 ;vbObjectError
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
