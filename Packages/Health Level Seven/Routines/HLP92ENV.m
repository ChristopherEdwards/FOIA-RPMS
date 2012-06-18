HLP92ENV ;OAKCIOFO/JG - HL*1.6*92 ENVIRONMENT CHECK ROUTINE;04/08/2002 [ 04/02/2003   8:37 AM ]
 ;;1.6;HEALTH LEVEL SEVEN;**1004**;APR 1, 2003
 ;;1.6;HEALTH LEVEL SEVEN;**92**;JUL 17, 1995
 ;Ensure that patch XM*999*148 is in place.
 N HLDIEN
 S HLDIEN=$$FIND1^DIC(4.2,"","MX","FHIE.MED.VA.GOV") ;IEN in DOMAIN (#4.2) file.
 I HLDIEN'>0 S XPDQUIT=2 G END  ;DOMAIN not there.
 ;Else we have an IEN for FHIE.MED.VA.GOV in the DOMAIN (#4.2) file.
END ;Kill variables and quit.
 I '$D(XPDQUIT) W !!," Environment check is ok.",!
 I $D(XPDQUIT) D  ;Print error message.
 .W !!," No DOMAIN (#4.2) file entry was found for FHIE.MED.VA.GOV."
 .W !," Follow the instructions in VA MailMan patch XM*999*148 to create"
 .W !," this new entry in the DOMAIN (#4.2) file.  After the new DOMAIN"
 .W !," has been created, re-install patch HL*1.6*92.",!
 K HLDIEN
 Q
 ;
