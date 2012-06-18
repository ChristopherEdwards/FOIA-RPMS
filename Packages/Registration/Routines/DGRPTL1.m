DGRPTL1 ;ALB/RMO - 10-10T Registration - Build List Area;26 DEC 1996 08:00 am
 ;;5.3;Registration;**108**;08/13/93
 ;
EN(DGARY,DFN,DGCNT) ;Entry point to build list area
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ; Output -- DGCNT    Number of lines in the list
 N DGLINE
 S DGLINE=1,DGCNT=0
 D DEM(DGARY,DFN,.DGLINE,.DGCNT) ;patient demographics
 D EMC(DGARY,DFN,.DGLINE,.DGCNT) ;emergency contact
 D EN^DGRPTL2(DGARY,DFN,.DGLINE,.DGCNT) ;military service, elig
 D EN^DGRPTL3(DGARY,DFN,.DGLINE,.DGCNT) ;marital, spouse, income, insurance
 Q
 ;
DEM(DGARY,DFN,DGLINE,DGCNT) ;Patient demographics
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N C,DGA,DGA1,DGA2,DGAD,DGELCKF,DGRP,DGSTART,I,X,Y
 ;
 ;Patient demographics
 S DGSTART=DGLINE ;starting line number
 D SET(DGARY,DGLINE,"Patient Demographics",31,.DGCNT,IORVON,IORVOFF)
 ;
 ;Name, ssn, dob
 S DGLINE=DGLINE+1
 S DGRP(0)=$G(^DPT(DFN,0)) ;patient
 S DGELCKF=$$ELGCHK^DGRPTU(DFN) ;elig check for editing
 D SET(DGARY,DGLINE,$S(DGELCKF:"",1:"<")_"Name: "_$P(DGRP(0),U),4,.DGCNT)
 S X=$P(DGRP(0),U,9) D SET(DGARY,DGLINE,"SS: "_$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10),42,.DGCNT)
 D SET(DGARY,DGLINE,"DOB: "_$$FTIME^VALM1($P(DGRP(0),U,3))_$S(DGELCKF:"",1:">"),59,.DGCNT)
 ;
 ;Sex
 S DGLINE=DGLINE+1
 S Y=$P(DGRP(0),U,2),C=$P(^DD(2,.02,0),U,2) D Y^DIQ
 D SET(DGARY,DGLINE,"Sex: "_$S(Y'="":Y,1:"UNANSWERED"),5,.DGCNT)
 ;
 ;Marital
 S DGLINE=DGLINE+1
 S Y=$P(DGRP(0),U,5),C=$P(^DD(2,.05,0),U,2) D Y^DIQ
 D SET(DGARY,DGLINE,"Marital: "_$S(Y'="":Y,1:"UNANSWERED"),1,.DGCNT)
 ;
 ;Address
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"",1,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Permanent Address:",1,.DGCNT)
 S DGLINE=DGLINE+1
 S DGRP(.11)=$G(^DPT(DFN,.11)) ;address
 S DGAD=.11,(DGA1,DGA2)=1 D A^DGRPU
 D SET(DGARY,DGLINE,$S($G(DGA(1))'="":DGA(1),1:"NONE ON FILE"),9,.DGCNT)
 S I=2 F  S I=$O(DGA(I)) Q:I=""  D
 . S DGLINE=DGLINE+1
 . D SET(DGARY,DGLINE,DGA(I),9,.DGCNT)
 ;
 ;County
 S DGLINE=DGLINE+1
 ; Get the county name and the VA county code using the
 ; County sub-file (#5.01) in the State file (#5)
 S X=$S($D(^DIC(5,+$P(DGRP(.11),U,5),1,+$P(DGRP(.11),U,7),0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)'="":" ("_$P(^(0),U,3)_")",1:""),1:"UNANSWERED")
 D SET(DGARY,DGLINE,"County: "_X,1,.DGCNT)
 ;
 ;Phone
 S DGLINE=DGLINE+1
 S DGRP(.13)=$G(^DPT(DFN,.13)) ;phone
 D SET(DGARY,DGLINE,"Phone: "_$S($P(DGRP(.13),U,1)'="":$P(DGRP(.13),U,1),1:"UNANSWERED"),2,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Office: "_$S($P(DGRP(.13),U,2)'="":$P(DGRP(.13),U,2),1:"UNANSWERED"),1,.DGCNT)
 ;
 ;Set line to start on next page
 F DGLINE=DGLINE+1:1:DGSTART+VALM("LINES") D SET(DGARY,DGLINE,"",1,.DGCNT)
 Q
 ;
EMC(DGARY,DFN,DGLINE,DGCNT) ;Emergency contact
 ; Input  -- DGARY    Global array subscript
 ;           DFN      Patient IEN
 ;           DGLINE   Line number
 ; Output -- DGCNT    Number of lines in the list
 N DGRP,DGSTART,I
 ;
 ;Emergency contact
 S DGSTART=DGLINE ;starting line number
 D SET(DGARY,DGLINE,"Emergency Contact",31,.DGCNT,IORVON,IORVOFF)
 ;
 ;Next of kin
 S DGLINE=DGLINE+1
 S DGRP(.21)=$G(^DPT(DFN,.21)) ;next of kin
 D SET(DGARY,DGLINE,"NOK: "_$S($P(DGRP(.21),U,1)'="":$P(DGRP(.21),U,1),1:"UNANSWERED"),8,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Relation: "_$S($P(DGRP(.21),U,2)'="":$P(DGRP(.21),U,2),1:"UNANSWERED"),3,.DGCNT)
 ;
 ;Next of kin address
 I $P(DGRP(.21),U,1)'="" D
 . N DGA,DGA1,DGA2,DGAD
 . S DGAD=.21,DGA1=3,DGA2=1 D A^DGRPU
 . S I=0 F  S I=$O(DGA(I)) Q:I=""  D
 . . S DGLINE=DGLINE+1
 . . D SET(DGARY,DGLINE,DGA(I),13,.DGCNT)
 S DGLINE=DGLINE+1
 ;
 ;Next of kin phone
 D SET(DGARY,DGLINE,"Phone: "_$S($P(DGRP(.21),U,9)'="":$P(DGRP(.21),U,9),1:"UNANSWERED"),6,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Work Phone: "_$S($P(DGRP(.21),U,11)'="":$P(DGRP(.21),U,11),1:"UNANSWERED"),1,.DGCNT)
 ;
 ;Emergency contact
 S DGLINE=DGLINE+1
 S DGRP(.33)=$G(^DPT(DFN,.33)) ;emergency contact
 D SET(DGARY,DGLINE,"E-Cont.: "_$S($P(DGRP(.33),U,1)'="":$P(DGRP(.33),U,1),1:"UNANSWERED"),4,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Relation: "_$S($P(DGRP(.33),U,2)'="":$P(DGRP(.33),U,2),1:"UNANSWERED"),3,.DGCNT)
 ;
 ;Emergency contact address
 I $P(DGRP(.33),U,1)'="" D
 . N DGA,DGA1,DGA2,DGAD
 . S DGAD=.33,DGA1=3,DGA2=1 D A^DGRPU
 . S I=0 F  S I=$O(DGA(I)) Q:I=""  D
 . . S DGLINE=DGLINE+1
 . . D SET(DGARY,DGLINE,DGA(I),13,.DGCNT)
 S DGLINE=DGLINE+1
 ;
 ;Emergency contact phone
 D SET(DGARY,DGLINE,"Phone: "_$S($P(DGRP(.33),U,9)'="":$P(DGRP(.33),U,9),1:"UNANSWERED"),6,.DGCNT)
 S DGLINE=DGLINE+1
 D SET(DGARY,DGLINE,"Work Phone: "_$S($P(DGRP(.33),U,11)'="":$P(DGRP(.33),U,11),1:"UNANSWERED"),1,.DGCNT)
 ;
 ;Set line to start on next page
 F DGLINE=DGLINE+1:1:DGSTART+VALM("LINES") D SET(DGARY,DGLINE,"",1,.DGCNT)
 Q
 ;
SET(DGARY,DGLINE,DGTEXT,DGCOL,DGCNT,DGON,DGOFF) ; -- set display array
 ; Input  -- DGARY    Global array subscript
 ;           DGLINE   Line number
 ;           DGTEXT   Text
 ;           DGCOL    Column to start at  (optional)
 ;           DGON     Highlighting on     (optional)
 ;           DGOFF    Highlighting off
 ; Output -- DGCNT    Number of lines in the list
 N X
 S:DGLINE>DGCNT DGCNT=DGLINE
 S X=$S($D(^TMP(DGARY,$J,DGLINE,0)):^(0),1:"")
 S ^TMP(DGARY,$J,DGLINE,0)=$$SETSTR^VALM1(DGTEXT,X,DGCOL,$L(DGTEXT))
 D:$G(DGON)]""!($G(DGOFF)]"") CNTRL^VALM10(DGLINE,DGCOL,$L(DGTEXT),$G(DGON),$G(DGOFF))
 Q
