BSDX38 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;  DAP = return appointment data for given patient - RPC
 ;
 ;return appointment data for given patient - RPC
DAP(BSDXY,DFN) ;return appointment data for given patient - RPC
 ; RPC Name is BSDX APPT EVENT LOG
 ;  .BSDXY   = returned pointer to appointment data
 ;   DFN = patient code - pointer to ^DPT(DFN)
 N AMN,AMT,AMU,APN,APT,BSDXI,BSDXTMP,CIN,CIT,CIU,COE,COF,CON,COT,COU,CRM,CRS
 N DPTS,DPTSR,NSN,NST,NSU,PAT,PN,RBD,RSD,S,SC,SDCL,SDCLS,SDCLSC,SDW
 D ^XBKVAR S X="ERROR^BSDXERR",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 ;check for valid Patient
 I '+DFN D ERR^BSDXERR("Invalid Patient ID.") Q
 I '$D(^DPT(DFN,0)) D ERR^BSDXERR("Invalid Patient ID.") Q
 ; data header
 S BSDXTMP="T00020PATIENT_IEN^T00020PATIENT_NAME^T00020CLINIC_IEN^T00020WARD_IEN^T00020APPT_TIME^T00020APPT_NUMBER"
 S BSDXTMP=BSDXTMP_"^T00020APPT_MADE_TIME^T00020APPT_MADE_USER^T00020APPT_MADE_USER_NAME^T00020ROUT_SLIP_DATE"
 S BSDXTMP=BSDXTMP_"^T00020CHECKIN_TIME^T00020CHECKIN_USER^T00020CHECKIN_USER_NAME"
 S BSDXTMP=BSDXTMP_"^T00020CHECKOUT_TIME^T00020CHECKOUT_USER^T00020CHECKOUT_USER_NAME^T00020CHECKOUT_FILED_TIME"
 S BSDXTMP=BSDXTMP_"^T00020NO_SHO_CANCEL_TIME^T00020NO_SHO_CANCEL_USER^T00020NO_SHO_CANCEL_USER_NAME^T00020CHECKED_OUT"
 S BSDXTMP=BSDXTMP_"^T00020REBOOK_DATE^T00100CANCEL_REASON^T00100CANCEL_REMARK"_$C(30)
 S ^BSDXTMP($J,0)=BSDXTMP
 S PN=$$GET1^DIQ(2,DFN_",",.01)
 S APN=0
 S SDCLS=""
 S SDCLSC=""
 ;loop thru patient appointments
 S S=0 F  S S=$O(^DPT(DFN,"S",S)) Q:S'>0  D
 . S DPTS=$G(^DPT(DFN,"S",S,0))
 . S DPTSR=$G(^DPT(DFN,"S",S,"R"))
 . S SDCL=$P(DPTS,U)        ;get clinic
 . S PAT="",SC=0 F  S SC=$O(^SC(SDCL,"S",S,1,SC)) Q:SC'>0  D  Q:PAT=DFN  ;get appt record from clinic
 . . S SDCLS=$G(^SC(SDCL,"S",S,1,SC,0))
 . . S SDCLSC=$G(^SC(SDCL,"S",S,1,SC,"C"))
 . . S PAT=$P(SDCLS,U)
 . . I PAT=DFN Q
 . S BSDXTMP=DFN_U                                 ;01 PATIENT_IEN
 . S BSDXTMP=BSDXTMP_PN_U                          ;02 PATIENT_NAME
 . S BSDXTMP=BSDXTMP_SDCL_U                        ;03 CLINIC_IEN
 . S SDW=$S($D(^DPT(DFN,.1)):^(.1),1:"Outpatient") ;04 WARD_IEN
 . S BSDXTMP=BSDXTMP_SDW_U
 . S APT=$TR($$FMTE^XLFDT(S),"@"," ")              ;05 APPT_TIME
 . S BSDXTMP=BSDXTMP_APT_U
 . S APN=APN+1                                     ;06 APPT_NUMBER
 . S BSDXTMP=BSDXTMP_APN_U
 . S AMT=$P(DPTS,U,19)                             ;07 APPT_MADE_TIME
 . S:AMT'="" AMT=$TR($$FMTE^XLFDT(AMT),"@"," ")
 . S BSDXTMP=BSDXTMP_AMT_U
 . S AMU=$P(DPTS,U,18)                             ;08 APPT_MADE_USER
 . S BSDXTMP=BSDXTMP_AMU_U
 . S AMN=$$GET1^DIQ(200,AMU_",",.01)               ;09 APPT_MADE_USER_NAME
 . S BSDXTMP=BSDXTMP_AMN_U
 . S RSD=$P(DPTS,U,13)                             ;10 ROUT_SLIP_DATE
 . S:RSD'="" RSD=$TR($$FMTE^XLFDT(RSD),"@"," ")
 . S BSDXTMP=BSDXTMP_RSD_U
 . S CIT=$P(SDCLSC,U)                              ;11 CHECKIN_TIME
 . S:CIT'="" CIT=$TR($$FMTE^XLFDT(CIT),"@"," ")
 . S BSDXTMP=BSDXTMP_CIT_U
 . S CIU=$P(SDCLSC,U,2)                            ;12 CHECKIN_USER
 . S BSDXTMP=BSDXTMP_CIU_U
 . S CIN=$$GET1^DIQ(200,CIU_",",.01)               ;13 CHECKIN_USER_NAME
 . S BSDXTMP=BSDXTMP_CIN_U
 . S COT=$P(SDCLSC,U,3)                            ;14 CHECKOUT_TIME
 . S:COT'="" COT=$TR($$FMTE^XLFDT(COT),"@"," ")
 . S BSDXTMP=BSDXTMP_COT_U
 . S COU=$P(SDCLSC,U,4)                            ;15 CHECKOUT_USER
 . S BSDXTMP=BSDXTMP_COU_U
 . S CON=$$GET1^DIQ(200,COU_",",.01)               ;16 CHECKOUT_USER_NAME
 . S BSDXTMP=BSDXTMP_CON_U
 . S COE=$P(SDCLSC,U,6)                            ;17 CHECKOUT_FILED_TIME
 . S:COE'="" COE=$TR($$FMTE^XLFDT(COE),"@"," ")
 . S BSDXTMP=BSDXTMP_COE_U
 . S NST=$P(DPTS,U,14)                             ;18 NO_SHO_CANCEL_TIME
 . S:NST'="" NST=$TR($$FMTE^XLFDT(NST),"@"," ")
 . S BSDXTMP=BSDXTMP_NST_U
 . S NSU=$P(DPTS,U,12)                             ;19 NO_SHO_CANCEL_USER
 . S BSDXTMP=BSDXTMP_NSU_U
 . S NSN=$$GET1^DIQ(200,NSU_",",.01)               ;20 NO_SHO_CANCEL_USER_NAME
 . S BSDXTMP=BSDXTMP_NSN_U
 . S COF=$S($P(SDCLSC,U,3)'="":"YES",SDCLSC'="":"NO",1:"") ;21 CHECKED_OUT
 . S BSDXTMP=BSDXTMP_COF_U
 . S RBD=$P(DPTS,U,10)                             ;22 REBOOK_DATE
 . S:RBD'="" RBD=$TR($$FMTE^XLFDT(RBD),"@"," ")
 . S BSDXTMP=BSDXTMP_RBD_U
 . S BSDXI=BSDXI+1
 . S ^BSDXTMP($J,BSDXI)=BSDXTMP
 . S CRS=$P(DPTS,U,15)                             ;23 CANCEL_REASON
 . S BSDXI=BSDXI+1
 . S ^BSDXTMP($J,BSDXI)=CRS_U
 . S CRM=$P(DPTSR,U)                               ;24 CANCEL_REMARK
 . S BSDXI=BSDXI+1
 . S ^BSDXTMP($J,BSDXI)=CRM
 . S BSDXI=BSDXI+1
 . S ^BSDXTMP($J,BSDXI)=$C(30)
 ;
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
 D ^XBKVAR S X="ERROR^BSDXERR",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00020ERRORID"_$C(30)
 ;check for valid clinic ID
 I '+SDCL D ERR^BSDXERR("Invalid Clinic ID.") Q
 I '$D(^SC(SDCL,0)) D ERR^BSDXERR("Invalid Clinic ID.") Q
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
