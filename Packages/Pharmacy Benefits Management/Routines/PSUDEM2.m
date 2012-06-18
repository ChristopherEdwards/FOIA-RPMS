PSUDEM2 ;BIR/DAM - Outpatient Visits Extract ; 20 DEC 2001
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**19**;Oct 15, 1998
 ;
 ;DBIA's
 ; Reference to file 2            supported by DBIA 10035
 ; Reference to file 9000010.07   supported by DBIA 3094
 ; Reference to file 9000010      supported by DBIA 3512
 ; Reference to file 4.3          supported by DBIA 2496
 ; Reference to file 80           supported by DBIA 10082
 ;
EN ;EN Called from PSUCP
 D DAT1
 I '$D(^XTMP("PSU_"_PSUJOB,"PSUOPV")) D NODATA
 D XMD
 K ^XTMP("PSU_"_PSUJOB,"PSUPDFLAG")
 K ^XTMP("PSU_"_PSUJOB,"PSUOPV")
 K ^XTMP("PSU_"_PSUJOB,"PSUXMD")
 Q
 ;
 ;
DAT1 ;Find visits from V POV file that fall within the date range
 ;of the extract by $O through the ^AUPNVPOV("AA" cross reference
 ;
 S PSUPT=0
 F  S PSUPT=$O(^AUPNVPOV("AA",PSUPT)) Q:'PSUPT  D   ;PSUPT is Pt. IEN
 .S PSUDT=0
 .F  S PSUDT=$O(^AUPNVPOV("AA",PSUPT,PSUDT)) Q:'PSUDT  D
 ..N PSUDTE
 ..S PSUDTE=10000000-PSUDT
 ..I (PSUDTE>PSUSDT)!(PSUDTE=PSUSDT) D
 ...I (PSUDTE<PSUEDT)!(PSUDTE=PSUEDT) D DAT2
 Q
 ;
DAT2 ;DAT1 continued
 S PSUPOV=0
 F  S PSUPOV=$O(^AUPNVPOV("AA",PSUPT,PSUDT,PSUPOV)) Q:'PSUPOV  D
 .N PSUVIEN,PSUICD0,PSUICD1
 .S PSUVIEN=$P($G(^AUPNVPOV(PSUPOV,0)),U,3) D   ;Visit file IEN
 .Q:PSUVIEN=""
 .S PSUMR=$P($G(^AUPNVSIT(PSUVIEN,0)),U)
 .I PSUMR S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,4)=$E($P(PSUMR,U),1,7)
 .D FAC
 .D SSNICN
 .S PSUICD0=$P($G(^AUPNVPOV(PSUPOV,0)),U,1)
 .I $G(PSUICD0) S PSUICD1=$P($G(^ICD9(PSUICD0,0)),U,1)
 .I $G(PSUICD1) S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,7)=PSUICD1
 .I '$G(PSUICD1) S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,7)=""
 .D EN^PSUDEM3
 Q
 ;
FAC ;Find facility sending message
 ;
 ;I PSUVIEN'="" D
 S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,2)=PSUSNDR
 Q
 ;
SSNICN ;Find patient SSN and ICN for outpatient visit
 ;
 N PSUIENP
 ;I PSUVIEN'="" D
 S PSUIENP=$P($G(^AUPNVSIT(PSUVIEN,0)),U,5)     ;Pt pointer to ^DPT file
 ;
 N PSUREC,PSUICN,PSUICN1
 I $G(PSUIENP) D
 .S PSUREC=$P($G(^DPT(PSUIENP,0)),U,9) D REC
 .S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,5)=PSUREC     ;Pt SSN
 .S PSUICN=$$GETICN^MPIF001(PSUIENP)
 .I PSUICN'[-1 S PSUICN1=$TR(PSUICN,"V","^") D
 ..S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,6)=$P(PSUICN1,U,1)
 .D ENC
 Q
 ;
ENC ;Find Encounter Patient Status  O=Outpatient  I=Inpatient
 ;
 S PSUREC=$P($G(^AUPNVSIT(PSUVIEN,150)),U,2)
 I PSUREC=1 S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,3)="I"  ;Encnter status
 I PSUREC=0 S $P(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUVIEN),U,3)="O"  ;Encnter status
 Q
 ;
REC ;EN    If "^" is contained in any record, replace it with "'"
 ;
 I $G(PSUREC)["^" S PSUREC=$TR(PSUREC,"^","'")
 Q
 ;
XMD ;Format mailman message and send.
 ;
 S PSUAB=0,PSUPL=1
 F  S PSUAB=$O(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUAB)) Q:PSUAB=""  D
 .M ^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUPL)=^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUAB)  ;Global numerical order
 .S PSUPL=PSUPL+1
 ;
 NEW PSUMAX,PSULC,PSUTMC,PSUTLC,PSUMC
 S PSUMAX=$$VAL^PSUTL(4.3,1,8.3)
 S PSUMAX=$S(PSUMAX="":10000,PSUMAX>10000:10000,1:PSUMAX)
 S PSUMC=1,PSUMLC=0
 F PSULC=1:1 S X=$G(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSULC)) Q:X=""  D
 .S PSUMLC=PSUMLC+1
 .I PSUMLC>PSUMAX S PSUMC=PSUMC+1,PSUMLC=0,PSULC=PSULC-1 Q  ; +  message
 .I $L(X)<235 S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=X Q
 .F I=235:-1:1 S Z=$E(X,I) Q:Z="^"
 .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=$E(X,1,I)
 .S PSUMLC=PSUMLC+1
 .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)="*"_$E(X,I+1,999)
 ;
 ;   Count Lines sent
 S PSUTLC=0
 F PSUM=1:1:PSUMC S X=$O(^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,""),-1),PSUTLC=PSUTLC+X
 ;
 F PSUM=1:1:PSUMC D OPV^PSUDEM5
 D CONF
 Q
CONF ;Construct globals for confirmation message
 ;
 I $G(NONE) S PSUTLC=0
 N PSUDIVIS
 S PSUDIVIS=$P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)
 S PSUSUB="PSU_"_PSUJOB
 S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,8,"M")=PSUMC
 S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,8,"L")=PSUTLC
 Q
 ;
NODATA ;Generate a 'No data' message if there is no data in the extract
 ;
 S NONE=1
 M PSUXMYH=PSUXMYS1
 S PSUM=1
 S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,1)="No data to report"
 Q
