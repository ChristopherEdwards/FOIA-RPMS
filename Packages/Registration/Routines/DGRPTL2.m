DGRPTL2 ;ALB/RMO - 10-10T Registration - Build List Area Cont.;26 DEC 1996 08:00 am ; 8/22/00 12:37pm
 ;;5.3;Registration;**108,343**;Aug 13, 1993
 ;
EN(DGARY,DFN,DGLINE,DGCNT) ;Entry point to build list area cont.
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N C,DGRP,DGSTART,Y
 ;
 ;Military service
 S DGSTART=DGLINE ;starting line number
 D SET^DGRPTL1(DGARY,DGLINE,"Military Service",31,.DGCNT,IORVON,IORVOFF)
 ;
 ;Service branch and number
 S DGLINE=DGLINE+1
 S DGRP(.32)=$G(^DPT(DFN,.32)) ;military service
 D SET^DGRPTL1(DGARY,DGLINE,"Service Branch [Last]: "_$S($D(^DIC(23,+$P(DGRP(.32),U,5),0)):$P(^(0),U,1),1:"UNANSWERED"),1,.DGCNT)
 D SET^DGRPTL1(DGARY,DGLINE,"Number [Last]: "_$S($P(DGRP(.32),U,8)'="":$P(DGRP(.32),U,8),1:"UNANSWERED"),49,.DGCNT)
 ;
 ;POW
 S DGLINE=DGLINE+1
 S DGRP(.52)=$G(^DPT(DFN,.52)) ;pow
 S Y=$P(DGRP(.52),U,5),C=$P(^DD(2,.525,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"POW: "_Y,19,.DGCNT)
 ;
 ;Agent orange
 S DGLINE=DGLINE+1
 S DGRP(.321)=$G(^DPT(DFN,.321)) ;ao/ir exposure
 S Y=$P(DGRP(.321),U,2),C=$P(^DD(2,.32102,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"A/O Exp.: "_Y,14,.DGCNT)
 ;
 ;Ionizing radiation
 S DGLINE=DGLINE+1
 S Y=$P(DGRP(.321),U,3),C=$P(^DD(2,.32103,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"ION Rad.: "_Y,14,.DGCNT)
 ;
 ;Environmental contaminants
 S DGLINE=DGLINE+1
 S DGRP(.322)=$G(^DPT(DFN,.322)) ;env contam exposure
 S Y=$P(DGRP(.322),U,13),C=$P(^DD(2,.322013,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Env Contam: "_Y,12,.DGCNT)
 ;
 ;Military disability
 S DGLINE=DGLINE+1
 S DGRP(.36)=$G(^DPT(DFN,.36)) ;mil disab
 S Y=$P(DGRP(.36),U,2),C=$P(^DD(2,.362,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Mil Disab: "_$S(Y'="":Y,1:"UNANSWERED"),13,.DGCNT)
 ;
 ;Purple Heart
 S DGLINE=DGLINE+1
 S DGRP(.53)=$G(^DPT(DFN,.53)) ;purple heart
 S Y=$P(DGRP(.53),U,1),C=$P(^DD(2,.531,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Purple Heart: "_Y,10,.DGCNT)
 ;
 ;Eligibility
 D ELG(DGARY,DFN,.DGLINE,.DGCNT) ;eligibility
 ;
 ;Set line to start on next page
 F DGLINE=DGLINE+1:1:DGSTART+VALM("LINES") D SET^DGRPTL1(DGARY,DGLINE,"",1,.DGCNT)
 Q
 ;
ELG(DGARY,DFN,DGLINE,DGCNT) ;Eligibility
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N C,DGRP,DGRPENM,Y
 ;
 ;Eligibility
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"Eligibility",31,.DGCNT,IORVON,IORVOFF)
 ;
 ;Patient type and veteran
 S DGLINE=DGLINE+1
 S DGRP("TYPE")=$G(^DPT(DFN,"TYPE")) ;patient type
 D SET^DGRPTL1(DGARY,DGLINE,"Patient Type: "_$S($D(^DG(391,+DGRP("TYPE"),0)):$P(^(0),U,1),1:"UNANSWERED"),10,.DGCNT)
 S DGRP("VET")=$G(^DPT(DFN,"VET")) ;veteran
 S Y=$P(DGRP("VET"),U,1),C=$P(^DD(2,1901,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Veteran: "_$S(Y'="":Y,1:"UNANSWERED"),55,.DGCNT)
 ;
 ;Service connected and percentage
 S DGLINE=DGLINE+1
 S DGRP(.3)=$G(^DPT(DFN,.3)) ;service connected, percentage
 S Y=$P(DGRP(.3),U,1),C=$P(^DD(2,.301,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Svc Connected: "_$S(Y'="":Y,1:"UNANSWERED"),9,.DGCNT)
 D SET^DGRPTL1(DGARY,DGLINE,"SC Percent: "_$S($P(DGRP(.3),U,2)'="":+$P(DGRP(.3),U,2)_"%",$P(DGRP(.3),U,1)'="Y":"N/A",1:"UNANSWERED"),52,.DGCNT)
 ;
 ;Aid & attendance and housebound
 S DGLINE=DGLINE+1
 S DGRP(.362)=$G(^DPT(DFN,.362)) ;a&a, housebound, pension
 S Y=$P(DGRP(.362),U,12),C=$P(^DD(2,.36205,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Aid & Attendance: "_$S(Y'="":Y,1:"UNANSWERED"),6,.DGCNT)
 S Y=$P(DGRP(.362),U,13),C=$P(^DD(2,.36215,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Housebound: "_$S(Y'="":Y,1:"UNANSWERED"),52,.DGCNT)
 ;
 ;VA pension
 S DGLINE=DGLINE+1
 S Y=$P(DGRP(.362),U,14),C=$P(^DD(2,.36235,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"VA Pension: "_$S(Y'="":Y,1:"UNANSWERED"),12,.DGCNT)
 ;
 ;Primary elig code
 S DGLINE=DGLINE+1
 S DGRP(.36)=$G(^DPT(DFN,.36)) ;eligibility
 D SET^DGRPTL1(DGARY,DGLINE,"Primary Elig Code: "_$S($D(^DIC(8,+DGRP(.36),0)):$P(^(0),U,1),1:"UNANSWERED"),5,.DGCNT)
 ;
 ;Other elig codes
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"Other Elig Code(s): ",4,.DGCNT)
 S (C,I)=0 F  S I=$O(^DPT("AEL",DFN,I)) Q:'I  I I'=+DGRP(.36),$D(^DIC(8,+I,0)) S DGRPENM=$P(^(0),U,1) D
 . S C=C+1
 . S:C>1 DGLINE=DGLINE+1
 . D SET^DGRPTL1(DGARY,DGLINE,DGRPENM,24,.DGCNT)
 D:'C SET^DGRPTL1(DGARY,DGLINE,"NO ADDITIONAL ELIGIBILITIES IDENTIFIED",24,.DGCNT)
 ;
 ;Period of service
 S DGLINE=DGLINE+1
 S DGRP(.32)=$G(^DPT(DFN,.32)) ;period of service
 D SET^DGRPTL1(DGARY,DGLINE,"Period of Service: "_$S($D(^DIC(21,+$P(DGRP(.32),U,3),0)):$P(^(0),U,1),1:"UNANSWERED"),5,.DGCNT)
 Q
