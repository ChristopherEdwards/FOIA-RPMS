DGRPTL3 ;ALB/RMO - 10-10T Registration - Build List Area Cont.;26 DEC 1996 08:00 am
 ;;5.3;Registration;**108**;08/13/93
 ;
EN(DGARY,DFN,DGLINE,DGCNT) ;Entry point to build list area cont.
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N C,DGDEP,DGINC,DGINR,DGLYINC,DGREL,DGSP,DGSTART,X,Y
 ;
 ;Marital/Spouse
 S DGSTART=DGLINE ;starting line number
 D SET^DGRPTL1(DGARY,DGLINE,"Marital/Spouse",31,.DGCNT,IORVON,IORVOFF)
 ;
 ;Married last year
 S DGLINE=DGLINE+1
 D ALL^DGMTU21(DFN,"VS",DT,"IPR")
 S Y=$P($G(^DGMT(408.22,+$G(DGINR("V")),0)),U,5),C=$P(^DD(408.22,.05,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Married Last Year: "_$S(Y'="":Y,1:"UNANSWERED"),1,.DGCNT)
 ;
 ;Spouse's name, ssn, dob
 S DGLINE=DGLINE+1
 S X=$P($G(DGREL("S")),U,2)
 S DGSP(0)=$S(X'="":$G(@(U_$P(X,";",2)_+X_",0)")),1:"")
 D SET^DGRPTL1(DGARY,DGLINE,"Spouse's Name: "_$E($P(DGSP(0),U),1,20),5,.DGCNT)
 S X=$P(DGSP(0),U,9) D SET^DGRPTL1(DGARY,DGLINE,"SS: "_$S(X'="":$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10),1:""),42,.DGCNT)
 D SET^DGRPTL1(DGARY,DGLINE,"DOB: "_$S(DGSP(0)'="":$$FTIME^VALM1($P(DGSP(0),U,3)),1:""),59,.DGCNT)
 ;
 ;Income
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"",1,.DGCNT)
 S DGLINE=DGLINE+1
 S DGLYINC=$P($G(^DGMT(408.21,+$G(DGINC("V")),0)),U,21)
 D SET^DGRPTL1(DGARY,DGLINE,"Income",31,.DGCNT,IORVON,IORVOFF)
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"Last Year's Estimated ""Household"" Taxable Income: "_$S(DGLYINC'="":"$"_DGLYINC,1:"UNANSWERED"),1,.DGCNT)
 ;
 ;Insurance
 D INS(DGARY,DFN,.DGLINE,.DGCNT)
 Q
 ;
INS(DGARY,DFN,DGLINE,DGCNT) ;Insurance
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N C,DGINS,DGRP,I,X,Y
 ;
 ;Insurance
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"",1,.DGCNT)
 S DGLINE=DGLINE+1
 S DGRP(.31)=$G(^DPT(DFN,.31)) ;insurance
 D SET^DGRPTL1(DGARY,DGLINE,"Insurance",31,.DGCNT,IORVON,IORVOFF)
 S DGLINE=DGLINE+1
 S Y=$P(DGRP(.31),U,11),C=$P(^DD(2,.3192,0),U,2) D Y^DIQ
 D SET^DGRPTL1(DGARY,DGLINE,"Covered by Health Insurance: "_$S(Y'="":Y,1:"UNANSWERED"),1,.DGCNT)
 ;
 ;List insurance
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"",1,.DGCNT)
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"Insurance Co.      Subscriber ID     Group       Holder  Effective Expires",1,.DGCNT)
 S DGLINE=DGLINE+1
 D SET^DGRPTL1(DGARY,DGLINE,"============================================================================",1,.DGCNT)
 D ALL^IBCNS1(DFN,"DGINS")
 S I=0 F  S I=$O(DGINS(I)) Q:'I  S DGINS=DGINS(I,0) D
 . S DGLINE=DGLINE+1
 . D SET^DGRPTL1(DGARY,DGLINE,$S($D(^DIC(36,+DGINS,0)):$E($P(^(0),U,1),1,16),1:"UNKNOWN"),1,.DGCNT)
 . D SET^DGRPTL1(DGARY,DGLINE,$E($P(DGINS,U,2),1,16),20,.DGCNT)
 . D SET^DGRPTL1(DGARY,DGLINE,$E($$GRP^IBCNS($P(DGINS,U,18)),1,10),38,.DGCNT)
 . S X=$P(DGINS,U,6) D SET^DGRPTL1(DGARY,DGLINE,$S(X="v":"SELF",X="s":"SPOUSE",1:"OTHER"),50,.DGCNT)
 . D SET^DGRPTL1(DGARY,DGLINE,$S($P(DGINS,U,8)'="":$$FDATE^VALM1($P(DGINS,U,8)),1:""),58,.DGCNT)
 . D SET^DGRPTL1(DGARY,DGLINE,$S($P(DGINS,U,4)'="":$$FDATE^VALM1($P(DGINS,U,4)),1:""),67,.DGCNT)
 I '$D(DGINS) D
 . S DGLINE=DGLINE+1
 . D SET^DGRPTL1(DGARY,DGLINE,"No Insurance Information",1,.DGCNT)
 Q
