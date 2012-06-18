BSDSCPRM ;cmi/anch/maw - BSD IHS SCHEDULING PARAMETER BSD PARAM FORM VALIDATOR 10/20/2008 10:46:00 AM
 ;;5.3;PIMS;**1010**;MAY 28, 2004
 ;
 ;cmi/anch/maw 10/20/2008 PATCH 1010 RQMT45
 ;
 ;this routine will check data upon exit of the IHS SCHEDULING PARAMETERS FORM under the ESP option
 ;
CHK(BSDPDA) ;-- check the data
 I $G(@DDSREFT@("F9009020.2","1,",.03,"D")),$G(@DDSREFT@("F9009020.2","1,",.16,"D"))="D" D  Q
 . D MSG^DDSUTL("If Routing Slip Format is Duplicate, then Print Extra Routing Slip cannot be set to Yes")
 . S DDSERROR=1
 . S DDSBR="ROUTING SLIP FORMAT"
 Q
 ;
