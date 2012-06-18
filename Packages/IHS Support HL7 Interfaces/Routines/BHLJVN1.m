BHLJVN1 ;SSI/EJN - Manual and Nightly Routine for JVN GIS Interface [ 10/10/2002  10:43 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**3**;FEB 15, 2001
 ;
 ; Program to transmit GIS O01 HL7 Messages manually or
 ; through a nightly TaskMan batch process via the 
 ; IHS Scheduling file (#44).  HL7 Messages are transmitted 
 ; to Cloverleaf for the Joslin Vision Network.
 ;
 N BHLJDFN,BHLJNAME,BHLJDOB,BHLJSSN,BHLJCNAM,BHLJCLIN
 ;
MAN ; Manual transmission of O01 Messages to Cloverleaf for JVN
 ;
 D RES
 ;
 S (BHLJDFN,BHLJNAME,BHLJDOB,BHLJSSN,BHLJCNAM,BHLJCLIN)=""
 ;
 K ^TMP("BHLJVN")
 ; Call standard RPMS patient lookup code
 D EN^DDIOL("","","!!!!!")
 S DIC="^DPT(",DIC(0)="AEMQ"
 D ^AUPNLK
 K DIC
 ;
 G EXIT:Y<0
 ; Check if patient is dead, if so then ask for another selection
 I $P($G(^DPT(DFN,.35)),U,1)'="" D
 . D EN^DDIOL("This patient is no longer living, please select another patient.","","!!")
 . S DIC="^DPT(",DIC(0)="AEMQ" D ^AUPNLK
 K DIC
 ;
 G EXIT:Y<0
 ; Set variables from buffer
 S BHLJNAME=$P($G(^DPT(DFN,0)),U)
 S BHLJDFN=DFN,BHLJDOB=$$FMTE^XLFDT(DOB),BHLJSSN=SSN
 ;
 ; Select Clinic for appointment
 D EN^DDIOL("","","!!")
 S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: ",DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC
 K DIC
 ;
 G EXIT:Y<0
 ; Set variables from buffer
 S BHLJCLIN=$P($G(Y),U,1),BHLJCNAM=$P($G(Y),U,2)
 ;
 ; Display selected patient information, ask if want to transmit to JVN
 D EN^DDIOL("The following patient has been selected:","","!!")
 D EN^DDIOL("     Name: "_BHLJNAME,"","!")
 D EN^DDIOL("     DOB: "_BHLJDOB,"","!")
 D EN^DDIOL("     SSN: "_BHLJSSN,"","!")
 D EN^DDIOL("     HRN: "_$$HRN^AUPNPAT(BHLJDFN,DUZ(2)),"","!")
 D EN^DDIOL("     Scheduled Date/Time: "_$$FMTE^XLFDT($$NOW^XLFDT()),"","!")
 D EN^DDIOL("     Location: "_BHLJCNAM,"","!")
 D EN^DDIOL("","","!!")
 K DIR
 S DIR(0)="YA"
 S DIR("A")="Transmit information to Joslin Vision Network NOW?  "
 S DIR("B")="No"
 D ^DIR
 G EXIT:Y<0!(Y="")!(Y["^")
 K DIR
 ;
 ; Set ^TMP("BHLJVN") global with variables for HL7
 S ^TMP("BHLJVN",$J,1)=BHLJDFN_U_BHLJCLIN_U_$E($$NOW^XLFDT(),1,12)  ;maw
 ;
 ; Call GIS to send HL7 message for patient to Cloverleaf for JVN
 I Y=1 D VAR
 G MAN
 Q
NJOB ; Nightly Job
 ;
 ; This can be queued as a nightly job in TaskMan to loop through the
 ; IHS Scheduling file (#44) to create and transmit GIS O01 HL7
 ; messages for the next days Retinal Imaging-JVN clinic appointments.
 ;
 ;
 D RES
 S BHLJBDT=$$NOW^XLFDT() ;ITSC/JCM 5/22/02
 S BHLJEDT=$$FMADD^XLFDT(BHLJBDT,1) ;ITSC/JCM 5/22/02
 ;
 D LOOP
 D VAR
 G EXIT
 Q
LOOP ; Loops through File 44
 ; Finds all patients with scheduled appointments for JVN
 ;
 K ^TMP("BHLJVN")
 N BHLJCIEN,BHLJSCDT,BHLJSIEN,BHLJDFN,BHLJCNT
 S (BHLJSCDT,BHLJSIEN,BHLJDFN)="",(BHLJCIEN,BHLJCNT)=0
 F  S BHLJCIEN=$O(^SC(BHLJCIEN)) Q:'BHLJCIEN  D
 . I $P(^SC(BHLJCIEN,0),U)'["JVN" Q
 . S BHLJSCDT=""
 . F  S BHLJSCDT=$O(^SC(BHLJCIEN,"S",BHLJSCDT),-1) Q:'BHLJSCDT!(BHLJSCDT<BHLJBDT)  D  ;ITSC/JCM 5/19/02
 .. Q:(BHLJSCDT<BHLJBDT)!(BHLJSCDT>BHLJEDT)
 .. S BHLJSIEN=0
 .. F  S BHLJSIEN=$O(^SC(BHLJCIEN,"S",BHLJSCDT,1,BHLJSIEN)) Q:'BHLJSIEN  D
 ... S BHLJDFN=$P($G(^SC(BHLJCIEN,"S",BHLJSCDT,1,BHLJSIEN,0)),U,1)
 ... S BHLJCNT=BHLJCNT+1
 ... S ^TMP("BHLJVN",$J,BHLJCNT)=BHLJDFN_U_BHLJCIEN_U_BHLJSCDT
 ;
 Q
VAR ; Set up variables for JVN Interface O01 Message
 ;
 Q:'$D(^TMP("BHLJVN",$J))
 ;
 ; Variables:
 ;      INDA = DFN
 ;      INDA(44,1) = IEN of Clinic
 ;      INDA(44,2) = Scheduled Date/Time of Appointment
 ;
 S BHLJCNT=0
 F  S BHLJCNT=$O(^TMP("BHLJVN",$J,BHLJCNT)) Q:'BHLJCNT  D
 . S INDA=$P($G(^TMP("BHLJVN",$J,BHLJCNT)),U,1)
 . S INDA(44,1)=$P($G(^TMP("BHLJVN",$J,BHLJCNT)),U,2)
 . S INDA(44,2)=$P($G(^TMP("BHLJVN",$J,BHLJCNT)),U,3)
 . D HL7
 ;
 Q
 ;
HL7 ; Send O01 HL7 Messages to Cloverleaf for PACS Broker
 ;
 S X="BHL JVN SCHEDULED APPT INFO",DIC=101 D EN^XQOR
 Q
FILL(BHLJDT) ; Filler Order (ORC-3)
 ; This function will return the Fill Order value 
 ; based on the INDA(44,2) variable passed from GIS
 ;
 ;     BHLJDT = INDA(44,2)
 ;     Filler Order = Date_"-"_HRN
 ;     (Date will not include time)
 ;
 I $G(BHLJDT)'="" D
 . S BHLJDT=$E($P($$FMTHL7^XLFDT(BHLJDT),"-"),1,8)
 E  S BHLJDT=$E($P($$FMTHL7^XLFDT($$NOW^XLFDT()),"-"),1,8)
 ;S X=BHLJDT_"-"_$$LZERO^BHLPID($$HRN^AUPNPAT(INDA,DUZ(2)),6)
 S X=BHLJDT_"-"_$G(BHLRN)  ;cmi/maw 
 Q X
EXIT ;
 K BHLJBDT,BHLJEDT,DIC,DIR,BHLJCNT,BHLJCIEN,BHLJSCDT,INDA,BHLJDFN,BHLJNAME,BHLJDOB,BHLJSSN,BHLJCNAM,BHLJCLIN,BHLJDT,BHLJBP,BHLJMSG
 Q
 ;
RES ;-- check the interface and restart if necessary
 I '$D(ZTQUEUED) W !,"Checking Interfaces..."
 F BHLJBP="FORMAT CONTROLLER","OUTPUT CONTROLLER","HL IHS JVN PACS TRANSMITTER" D
 . S BHLJMSG=$$CHK^BHLBCK(BHLJBP,"")
 Q
 ;
