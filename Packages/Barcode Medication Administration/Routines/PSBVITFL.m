PSBVITFL ;BIRMINGHAM/TEJ-BCMA VITAL MEASUREMENT FILER ;02-Nov-2007 13:39;SM
 ;;3.0;BAR CODE MED ADMIN;**1005,1006**;Mar 2004
 ; Reference/IA
 ; STORE^GMRVPCE0/1589
 ; 44/908
 ; 42/10039
 ;
 ; Modified - IHS/MSC/PLS - 08/08/2006
 ;                          10/30/2007 - Corrected issue with visit linkage
 ;
 ; Description:
 ; This routine is to service BCMA 3.0 functionality and store VITALs'
 ; data into the VITAL MEASUREMENT FILE - ^GMR(120.5  using the API
 ; GMRVPCE0
 ;
 ; Parameters:
 ;       Input  -        DFN     (r) Pointer to the PATIENT (#2) file
 ;                       RATE    (r) BCMA trigger event/transaction
 ;                       VTYPE   (o) Pointer to GMRV VITAL TYPE FILE (#120.51)
 ;                                    (default = Pain ["PN"])
 ;                       DTTKN   (o) Date/time (FileMan) measurment was taken
 ;                                    (default = $$NOW^XLFDT())
 ;
 ;       Output -        RESULTS(0) = 1
 ;                       RESULTS(1) ="1^*** comment ***"
 ;                 or    RESULTS(1) ="-1^ERROR * Pain Score NOT filed
 ;                                    successfully"
 ;
 ;       Process results in the storing of VITAL Measurement rate into the VITAL
 ;       MEASUREMENT FILE per the given patient and vital type.
 ;
RPC(RESULTS,PSBDFN,PSBRATE,PSBVTYPE,PSBDTTKN) ;
 ;
 ; Set up the input array for the API
 ;
 S RESULTS(0)=1,RESULTS(1)="-1^ERROR * "_$S($G(PSBVTYPE)']""!$G(PSBVTYPE)="PN":"Pain Score",1:"Vital Measurement")_" NOT filed successfully"
 S:$G(PSBVTYPE)']"" PSBVTYPE="PN"
 S:$G(PSBDTTKN)']"" PSBDTTKN=$$NOW^XLFDT()
 N DFN S DFN=$G(PSBDFN),VAIP("D")="" D IN5^VADPT S PSBHLOC=^DIC(42,+$G(VAIP(13,4)),44)
 I $G(DUZ("AG"))="I" D
 .N VTYP,XREF,VSIT,VDAT
 .S XREF("T")="TMP",XREF("P")="PU",XREF("BP")="BP",XREF("R")="RS",XREF("PN")="PA"
 .S VTYP=+$$FIND1^DIC(9999999.07,"","BX",$$UP^XLFSTR($G(XREF(PSBVTYPE))))
 .Q:'VTYP
 .;IHS/MSC/PLS - 10/30/07
 .S VSIT=$P($G(^DGPM(+$G(VAIP(13)),0)),U,27)
 .S VDAT=$P($G(^AUPNVSIT(+VSIT,0)),U)
 .;S PCC(1)="HDR^^^"_PSBHLOC_";"_PSBDTTKN_";H"
 .S PCC(1)="HDR^^^"_PSBHLOC_";"_$S(VDAT:VDAT,1:PSBDTTKN)_";H;"_VSIT
 .;S PCC(2)="VST^DT^"_PSBDTTKN
 .S PCC(2)="VST^DT^"_$S(VDAT:VDAT,1:PSBDTTKN)
 .S PCC(3)="VST^PT^"_PSBDFN
 .S PCC(4)="VIT+^"_VTYP_"^0^^"_PSBRATE_"^^^"_PSBDTTKN
 .I $T(SAVE^BEHOENPC)]"" D  ; Delivered with EHR v1.1
 ..D SAVE^BEHOENPC(.RESULTS,.PCC)
 .E  D SAVE^CIAVCXPC(.RESULTS,.PCC)  ; Delivered with EHR v1.0
 .S:'RESULTS RESULTS(1)="1^"_$S($G(PSBVTYPE)="PN":"Pain Score",1:PSBVTYPE)_" entered in Vitals via BCMA taken "_$$FMTE^XLFDT(PSBDTTKN,"Z5")
 E  D
 .S GMRVDAT("ENCOUNTER")=U_PSBDFN_U_$G(PSBHLOC)
 .S GMRVDAT("SOURCE")=U_$G(DUZ)
 .S GMRVDAT("VITALS",$G(DUZ),1)=PSBVTYPE_U_$G(PSBRATE)_U_$G(PSBUNTS)_U_PSBDTTKN
 .D STORE^GMRVPCE0(.GMRVDAT)
 .I '$D(GMRVDAT("ERROR")) D NOW^%DTC,YX^%DTC S RESULTS(0)=1,RESULTS(1)="1^"_$S($G(PSBVTYPE)="PN":"Pain Score",1:PSBVTYPE)_" entered in Vitals via BCMA taken "_Y
 Q
 ;
