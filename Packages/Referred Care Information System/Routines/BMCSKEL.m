BMCSKEL ; IHS/PHXAO/TMJ - SKELETON ROUTINE ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ; See ^BMCVDOC for system wide variables set by main menu
 ;
 ; Subscripted BMCREC is EXTERNAL form.
 ;   BMCREC("PAT NAME")=patient name
 ;   BMCREC("REF DATE")=referral date
 ;   BMCDFN=patient ien
 ;   BMCRDATE=referral date in internal FileMan form
 ;   BMCRNUMB=referral number
 ;   BMCRIEN=referral ien
 ;   BMCRTYPE=type of referral (.04 field)
 ;   BMCRIO=Inpatient or Outpatient (.14 field)
 ;
START ;
 D:$G(BMCPARM)="" PARMSET^BMC
 F  D MAIN Q:BMCQ  D HDR^BMC
 D EOJ
 Q
 ;
MAIN ;
 S BMCQ=0
 D INIT
 Q:BMCQ
 D XXXX
 Q
 ;
XXXX ;
 Q
 ;
INIT ; INITIALIZAION
 Q
 ;
EOJ ; END OF JOB
 D ^BMCKILL
 Q
