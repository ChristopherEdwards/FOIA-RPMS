ZIBVSS ; IHS/ADC/GTH - VENDOR SPECIFIC SUBROUTINES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;XB*3*9 fixed LG,CG,GCH,GSZE,GR,GS,RCMP,RR,RS,RDEL,RSE,RSAND,NEWED,RCHANGE,RCOPY,RPRT,ER to work with Cache'
 ;XB*3*9 GSE,GE,GCHR,GDEL,REDIT don't currently work with Cache'
 ;
LG ;EP - List global
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%GL",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GL",$G(^%ZOSF("OS"))["OpenM":"^%G",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
CG ;EP - Copy global to another UCI
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%GCOPY",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%GCOPY",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
GSE ;EP - Search global for value
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GSE",1:"OSNO^XB")
 Q
 ;
GE ;EP - Global edit
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GEDIT",1:"OSNO^XB")
 Q
 ;
GCH ;EP - Change global value
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%GCHANGE",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%GCHANGE",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
GSZE ;EP - Global size/efficiency
 ;D @$S(^%ZOSF("OS")["MSM":"^%GE",1:"^%ZTBKC") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%GSIZE",1:"^%ZTBKC")
 Q
 ;
GCHR ;EP - Global characteristics
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GCH",1:"OSNO^XB")
 Q
 ;
GDEL ;EP - Global delete
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GDEL",1:"OSNO^XB")
 Q
 ;
GR ;EP - Global restore
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%GR",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GR",$G(^%ZOSF("OS"))["OpenM":"^%GI",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
GS ;EP - Global save
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%GS",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%GS",$G(^%ZOSF("OS"))["OpenM":"^%GO",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RCMP ;EP - Compare routines in two UCIs
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RCMP",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%RCMP",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RR ;EP - Restore routines
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RR",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%RR",$G(^%ZOSF("OS"))["OpenM":"^%RI",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RS ;EP - Save routines
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RS",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%RS",$G(^%ZOSF("OS"))["OpenM":"^%RO",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RDEL ;EP - Delete routines
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RDEL",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%RDEL",$G(^%ZOSF("OS"))["OpenM":"^%RDELETE",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RSE ;EP - Search routines for values (OR)
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RSE",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%RSE",$G(^%ZOSF("OS"))["OpenM":"^%RFIND",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RSAND ;EP - Search routines for values (AND)
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RSAND",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%RSAND",$G(^%ZOSF("OS"))["OpenM":"^%RFIND",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
NEWED ;EP - Find routines by edit date
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%NEWED",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%NEWED",$G(^%ZOSF("OS"))["OpenM":"^%RD",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
REDIT ;EP - Full screen editor
 ;Q:'($G(^%ZOSF("OS"))["MSM") ;IHS/SET/GTH XB*3*9 10/29/2002
 I '($G(^%ZOSF("OS"))["MSM") D OSNO^XB Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 X "ZR  NEW (XB) X ^%E"
 Q
 ;
RCHANGE ;EP - Routine change
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RCHANGE",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%RCHANGE",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RCOPY ;EP - Routine copy
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RCOPY",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%RCOPY",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
RPRT ;EP - List routines
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%RPRT",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM":"^%RPRT",$G(^%ZOSF("OS"))["OpenM":"^ZIBRPRTD",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
ER ;EP - Error report
 ;D @$S($G(^%ZOSF("OS"))["MSM":"^%ER",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 D @$S($G(^%ZOSF("OS"))["MSM"!($G(^%ZOSF("OS"))["OpenM"):"^%ER",1:"OSNO^XB") ;IHS/SET/GTH XB*3*9 10/29/2002
 Q
 ;
