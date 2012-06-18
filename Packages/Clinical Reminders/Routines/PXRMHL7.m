PXRMHL7 ; SLC/PKR - HL7 message handler. ;01/30/2001
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;This is based on the code in ORM.
 ;
 ;=======================================================================
HL7(HL7MSG) ;Main entry point for handling HL7 messages.
 N MSG,MSH,PKG
 S MSG=$S($L($G(HL7MSG)):HL7MSG,1:"HL7MSG")
 I '$O(@MSG@(0)) Q
 S MSH=0
 F  S MSH=$O(@MSG@(MSH)) Q:MSH'>0  Q:$E(@MSG@(MSH),1,3)="MSH"
 ;Get the package
 S PKG=$$PKG($P(@MSG@(MSH),"|",3))
 I PKG="PS" D
 .;Get the patient
 . N DFN,PXRMDFN
 . S DFN=$$PID(MSH,MSG)
 . S PXRMDFN="PXRMDFN"_DFN
 . D KILLPC^PXRMPINF(PXRMDFN)
 Q
 ;
 ;=======================================================================
PID(MSH,MSG) ;Process the PID segment and return the DFN.
 N DFN,DONE,IND,SEG
 S DONE=0
 S IND=MSH
 F  S IND=$O(@MSG@(IND)) Q:(IND'>0)!(DONE)  D
 . S SEG=$E(@MSG@(IND),1,3)
 . I SEG="PID" D  Q
 .. S DFN=+$P(@MSG@(IND),"|",4)
 .. S DONE=1
 Q DFN
 ;
 ;=======================================================================
PKG(NAME) ;Return the package namespace.
 I NAME="CONSULTS" Q "GMRC"
 I NAME="DIETETICS" Q "FH"
 I NAME="LABORATORY" Q "LR"
 I NAME="PHARMACY" Q "PS"
 I NAME="PROCEDURES" Q "GMRC"
 I NAME="ORDER ENTRY" Q "ORG"
 I NAME="RADIOLOGY"!(NAME="IMAGING") Q "RA"
 Q ""
 ;
