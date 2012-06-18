DGRPTP1 ;ALB/RMO - Print 10-10T Registration Cont.;06 JAN 1997 3:15 pm ; 8/18/00 2:48pm
 ;;5.3;Registration;**108,343**;Aug 13, 1993
 ;
EN(DFN,DFN1,DGNAM,DGSSN,DGLNE,DGPGE) ;Entry point to print 10-10T cont.
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGNAM    Patient name
 ;           DGSSN    Patient ssn
 ;           DGLNE    Line format array
 ;           DGPGE    Page number
 ; Output -- None
 N X
 W ?116,"VA FORM 10-10T",!,DGLNE("DD"),!?35,"D E P A R T M E N T   O F   V E T E R A N S   A F F A I R S",!,DGLNE("DD")
 S X=$$SITE^VASITE W !,"FACILITY: ",$S($G(X):$P(X,U,2)_" ("_$P(X,U,3)_")")
 W ?96,"APPLICATION FOR MEDICAL BENEFITS",!,DGLNE("DD")
 D DEM(DFN,DGNAM,DGSSN,.DGLNE) ;patient demographics
 D EMC(DFN,.DGLNE) ;emergency contact
 D BEN(DFN,$G(DFN1),.DGLNE) ;benefit applying for
 D APS(DFN,.DGLNE) ;applicant status
 D EXP(DFN,.DGLNE) ;exposure
 D MCR(DFN,$G(DFN1),.DGLNE) ;medical care related to
 D EN^DGRPTP2(DFN,$G(DFN1),DGNAM,DGSSN,.DGLNE,DGPGE) ;print cont.
 Q
 ;
DEM(DFN,DGNAM,DGSSN,DGLNE) ;Patient demographics
 ; Input  -- DFN      Patient IEN
 ;           DGNAM    Patient name
 ;           DGSSN    Patient ssn
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGRP,I,Y
 ;
 ;Name, ssn, dob
 S DGRP(0)=$G(^DPT(DFN,0)) ;patient
 W !,"1. Applicant's Name",?60,"|2. Social Security Number",?98,"|3. Date of Birth"
 W !?3,DGNAM,?60,"|   ",DGSSN,?98,"|   ",$$DATENP^DG1010P0(DGRP(0),3)
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;Street Address
 W !,"4A. Applicant's Mailing Street Address"
 S DGRP(.11)=$G(^DPT(DFN,.11)) ;address
 W !?4,$$DISP^DG1010P0(DGRP(.11),1)
 F I=2:1:3 W:$P(DGRP(.11),U,I)'="" !?4,$$DISP^DG1010P0(DGRP(.11),I)
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;City, county, zip, state
 W !,"4B. City",?33,"|4C. County",?65,"|4D. Zip Code",?95,"|4E. State"
 W !?4,$$DISP^DG1010P0(DGRP(.11),4)
 W ?33,"|    ",$$POINT^DG1010P0(DGRP(.11),7,"^DIC(5,"_+$P(DGRP(.11),U,5)_",1,")
 S Y=$P(DGRP(.11),U,12) ;zip code
 D:Y'="" ZIPOUT^VAFADDR ;output transform
 W ?65,"|    ",$S(Y'="":Y,1:"UNANSWERED")
 W ?95,"|    ",$$POINT^DG1010P0(DGRP(.11),5,5)
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;Sex, phone
 W !,"5. Patient's Sex",?33,"|6. Home Telephone Number",?65,"|7. Work Telephone Number"
 S Y=$P(DGRP(0),U,2),C=$P(^DD(2,.02,0),U,2) D Y^DIQ
 W !,?3,$S(Y'="":Y,1:"UNANSWERED")
 S DGRP(.13)=$G(^DPT(DFN,.13)) ;phone
 W ?33,"|   ",$$DISP^DG1010P0(DGRP(.13),1)
 W ?65,"|   ",$$DISP^DG1010P0(DGRP(.13),2)
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
EMC(DFN,DGLNE) ;Emergency contact
 ; Input  -- DFN      Patient IEN
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGA,DGA1,DGA2,DGAD,DGADI,DGEMCF,DGRP,Y
 ;
 ;Name, relationship, phone
 S DGRP(.33)=$G(^DPT(DFN,.33)) ;emergency contact
 S DGEMCF=$S($P(DGRP(.33),U,1)'="":1,1:0)
 W !,"8A. Emergency Contact",?40,"|8B. Relationship",?65,"|8C. Home Telephone Number",?95,"|8D. Work Telephone Number"
 W !?4,$$DISP^DG1010P0(DGRP(.33),1)
 W ?40,"|    " W:DGEMCF $$DISP^DG1010P0(DGRP(.33),2)
 W ?65,"|    " W:DGEMCF $$DISP^DG1010P0(DGRP(.33),9)
 W ?95,"|    " W:DGEMCF $$DISP^DG1010P0(DGRP(.33),11)
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;Address, Is emergency contact also NOK
 W !,"8E. Mailing Address of Emergency Contact",?95,"|9. Is Emergency Contact"
 I DGEMCF D
 . S DGAD=.33,DGA1=3,DGA2=1 D A^DGRPU
 S DGADI=+$O(DGA(0))
 W !?4,$S(DGADI:DGA(DGADI),1:"")
 W ?95,"|Also Next of Kin"
 S DGADI=+$O(DGA(DGADI))
 W !?4,$S(DGADI:DGA(DGADI),1:"")
 S Y=$P(DGRP(.33),U,10),C=$P(^DD(2,.3305,0),U,2) D Y^DIQ
 W ?95,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 F  S DGADI=$O(DGA(DGADI)) Q:DGADI=""  D
 . W !?4,DGA(DGADI)
 . W ?95,"|"
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
BEN(DFN,DFN1,DGLNE) ;Benefit applying for
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGDIS,Y
 ;
 W !,"10. Benefit Applying For:   "
 S DGDIS(0)=$G(^DPT(DFN,"DIS",+$G(DFN1),0))
 I $P(DGDIS(0),U,20) D
 . S Y=$P(DGDIS(0),U,3),C=$P(^DD(2.101,2,0),U,2) D Y^DIQ
 . W $S("^1^3^"[(U_$P(DGDIS(0),U,3)_U):"HOSPITAL/OUTPATIENT TREATMENT",Y'="":Y,1:"UNANSWERED")
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
APS(DFN,DGLNE) ;Applicant status
 ; Input  -- DFN      Patient IEN
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGADI,DGRP,Y
 ;
 W !,"11. Applicant Status: ",!,DGLNE("D")
 ;
 ;Service connected, pow, a&a, mil disab
 W !,"A. Service Connected",?33,"|B. Prisoner of War",?65,"|C. Aid and Attendance",?95,"|D. Military Disability Retired"
 S DGRP(.3)=$G(^DPT(DFN,.3)) ;service connected
 S Y=$P(DGRP(.3),U,1),C=$P(^DD(2,.301,0),U,2) D Y^DIQ
 W !?3,$S(Y'="":Y,1:"UNANSWERED")
 S DGRP(.52)=$G(^DPT(DFN,.52)) ;pow
 S Y=$P(DGRP(.52),U,5),C=$P(^DD(2,.525,0),U,2) D Y^DIQ
 W ?33,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 S DGRP(.362)=$G(^DPT(DFN,.362)) ;a&a, pension
 S Y=$P(DGRP(.362),U,12),C=$P(^DD(2,.36205,0),U,2) D Y^DIQ
 W ?65,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 S DGRP(.36)=$G(^DPT(DFN,.36)) ;mil disab
 S Y=$P(DGRP(.36),U,2),C=$P(^DD(2,.362,0),U,2) D Y^DIQ
 W ?95,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 W !,DGLNE("D")
 ;
 ;VA pension, eligibility, other elig
 W !,"E. VA Pension",?33,"|F. Primary Eligibility Code",?65,"|G. Other Eligibility Code",?95,"|H. Purple Heart Recipient"
 S Y=$P(DGRP(.362),U,14),C=$P(^DD(2,.36235,0),U,2) D Y^DIQ
 W !?3,$S(Y'="":Y,1:"UNANSWERED")
 W ?33,"|   ",$$ELIG^DG1010P5(+DGRP(.36))
 S (C,DGADI)=0 F  S DGADI=$O(^DPT(DFN,"E",DGADI)) Q:'DGADI  I DGADI'=+DGRP(.36) D
 . S C=C+1
 . W:C>1 !?33,"|"
 . W ?65,"|   ",$$ELIG^DG1010P5(DGADI)
 W:'C ?65,"|"
 S DGRP(.53)=$G(^DPT(DFN,.53)) ;purple heart
 S Y=$P(DGRP(.53),U,1),C=$P(^DD(2,.531,0),U,2) D Y^DIQ
 W ?95,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
EXP(DFN,DGLNE) ;Exposure
 ; Input  -- DFN      Patient IEN
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGRP,Y
 ;
 W !,"12. Exposure To: "
 ;
 ;Agent orange, radiation, env contam
 W ?33,"|A. Agent Orange",?65,"|B. Radiation",?95,"|C. Environmental Contaminants"
 S DGRP(.321)=$G(^DPT(DFN,.321)) ;ao/ir exposure
 S Y=$P(DGRP(.321),U,2),C=$P(^DD(2,.32102,0),U,2) D Y^DIQ
 W !?33,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 S Y=$P(DGRP(.321),U,3),C=$P(^DD(2,.32103,0),U,2) D Y^DIQ
 W ?65,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 S DGRP(.322)=$G(^DPT(DFN,.322)) ;env contam
 S Y=$P(DGRP(.322),U,13),C=$P(^DD(2,.322013,0),U,2) D Y^DIQ
 W ?95,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
MCR(DFN,DFN1,DGLNE) ;Medical care related to
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGDIS,Y
 ;
 W !,"13. Medical Care Related To: "
 ;
 ;Injury, accident
 W ?33,"|A. On-The-Job-Injury",?65,"|B. Accident"
 S DGDIS(0)=$G(^DPT(DFN,"DIS",+$G(DFN1),0))
 I $P(DGDIS(0),U,20) D
 . S DGDIS(2)=$G(^DPT(DFN,"DIS",+$G(DFN1),2))
 . S Y=$P(DGDIS(2),U,1),C=$P(^DD(2.101,20,0),U,2) D Y^DIQ
 . W !?33,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 . S Y=$P(DGDIS(2),U,4),C=$P(^DD(2.101,23,0),U,2) D Y^DIQ
 . W ?65,"|   ",$S(Y'="":Y,1:"UNANSWERED")
 ELSE  D
 . W !?33,"|"
 . W ?65,"|"
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
