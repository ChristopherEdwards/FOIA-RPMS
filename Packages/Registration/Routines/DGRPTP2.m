DGRPTP2 ;ALB/RMO - Print 10-10T Registration Cont.;10 JAN 1997 09:06 am
 ;;5.3;Registration;**108**;08/13/93
 ;
EN(DFN,DFN1,DGNAM,DGSSN,DGLNE,DGPGE) ;Entry point to print 10-10T cont.
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGNAM    Patient name
 ;           DGSSN    Patient ssn
 ;           DGLNE    Line format array
 ;           DGPGE    Page number
 ; Output -- None
 D INS(DFN,.DGLNE) ;insurance
 D SER(DFN,.DGLNE) ;service branch and number, marital
 D SPO(DFN,.DGLNE) ;spouse, income
 S DGPGE=1 D FT^DGRPTP(DFN,$G(DFN1),.DGLNE,.DGPGE) ;end of first page of form
 D HD^DGRPTP(DGNAM,DGSSN,.DGLNE) ;header
 D EN^DGRPTP3(.DGLNE) ;consent, co-pay, signature block, burden, privacy act
 S DGPGE=2 D FT^DGRPTP(DFN,$G(DFN1),.DGLNE,.DGPGE) ;end of second page of form
 Q
 ;
INS(DFN,DGLNE) ;Insurance
 ; Input  -- DFN      Patient IEN
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGINS,DGRP,I,Y
 ;
 ;Insurance
 W !,"14A. Do You Have Health Coverage",?40,"|14B. Name of Health Insurance Carrier"
 S DGRP(.31)=$G(^DPT(DFN,.31)) ;insurance
 S Y=$P(DGRP(.31),U,11),C=$P(^DD(2,.3192,0),U,2) D Y^DIQ
 W !,?5,$S(Y'="":Y,1:"UNANSWERED")
 D ALL^IBCNS1(DFN,"DGINS",1,DT)
 S (C,I)=0 F  S I=$O(DGINS(I)) Q:'I  S DGINS=DGINS(I,0) D
 . S C=C+1
 . W:C>1 !
 . W ?40,"|     ",$$POINT^DG1010P0(DGINS,1,36)
 I '$D(DGINS) D
 . W ?40,"|     ","NO ACTIVE (UNEXPIRED) INSURANCE ON FILE FOR THIS APPLICANT"
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
SER(DFN,DGLNE) ;Service branch and number, marital status
 ; Input  -- DFN      Patient IEN
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGRP,Y
 ;
 ;Service branch and number
 W !,"15. Branch of Service",?33,"|16. Latest Service Number",?65,"|17. Marital Status"
 S DGRP(.32)=$G(^DPT(DFN,.32)) ;military service
 W !?4,$E($$POINT^DG1010P0(DGRP(.32),5,23),1,20)
 W ?33,"|    ",$$DISP^DG1010P0(DGRP(.32),8)
 ;
 ;Marital status
 S DGRP(0)=$G(^DPT(DFN,0)) ;patient
 S Y=$P(DGRP(0),U,5),C=$P(^DD(2,.05,0),U,2) D Y^DIQ
 W ?65,"|    ",$S(Y'="":Y,1:"UNANSWERED")
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 Q
 ;
SPO(DFN,DGLNE) ;Spouse and income
 ; Input  -- DFN      Patient IEN
 ;           DGLNE    Line format array
 ; Output -- None
 N C,DGDEP,DGINC,DGINR,DGLYINC,DGREL,DGSP,X,Y
 ;
 ;Spouse's name, ssn
 W !,"18A. Spouse's Name",?65,"|18B. Spouse's Social Security Number"
 D ALL^DGMTU21(DFN,"VS",DT,"IPR")
 S X=$P($G(DGREL("S")),U,2)
 S DGSP(0)=$S(X'="":$G(@(U_$P(X,";",2)_+X_",0)")),1:"")
 I DGSP(0)'="" D
 . W !?5,$$DISP^DG1010P0(DGSP(0),1)
 . S X=$P(DGSP(0),U,9)
 . W ?65,"|     ",$S(X'="":$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10),1:"")
 ELSE  D
 . W !?5,"NOT APPLICABLE"
 . W ?65,"|"
 W ?131,$C(13) W:DGLNE("ULC")="-" ! W DGLNE("UL")
 ;
 ;Year of marriage, number of dependents, income
 W !,"18C. Year of Marriage",?33,"|18D. Number of Dependents",?65,"|19. Last Year's Estimated ""Household"" Taxable Income",!
 I DGSP(0)'="" D
 . W ?5,$$DATENP^DG1010P0($G(^DGPR(408.12,+DGREL("S"),"E",1,0)),1)
 S DGLYINC=$P($G(^DGMT(408.21,+$G(DGINC("V")),0)),U,21)
 W ?33,"|"
 W ?65,"|    ",$S(DGLYINC'="":"$"_DGLYINC,1:"UNANSWERED")
 Q
