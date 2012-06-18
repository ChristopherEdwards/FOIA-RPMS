DGRP11 ;ALB/MRL,RTK - REGISTRATION SCREEN 11/VERIFICATION INFORMATION ;06 JUN 88@2300
 ;;5.3;Registration;**327**;Aug 13, 1993
 S DGRPS=11 D H^DGRPU F I=.3,.32,.361,"TYPE","VET" S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
 S (DGRPW,Z)=1 D WW^DGRPV W " Eligibility Status: " S DGRPX=DGRP(.361),X=$P(DGRPX,"^",1),Z=$S(X']"":"NOT VERIFIED",X="V":"VERIFIED",X="R":"PENDING RE-VERIFICATION",1:"PENDING VERIFICATION"),Z1=28 D WW1^DGRPV S DGRPVR=$S(X]"":1,1:0)
 W "Status Date: " S Y=$P(DGRPX,"^",2) X:Y]"" ^DD("DD") W $S(Y]"":Y,DGRPVR:DGRPU,1:DGRPNA),!?5,"Status Entered By: ",$S($D(^VA(200,+$P(DGRPX,"^",6),0)):$P(^(0),"^",1)_" (#"_+$P(DGRPX,"^",6)_")",DGRPVR:DGRPU,1:DGRPNA)
 W !?6,"Interim Response: " S Y=$P(DGRPX,"^",4) X:Y]"" ^DD("DD") W $S(Y]"":Y,1:DGRPU_" (NOT REQUIRED)"),!?9,"Verif. Method: ",$S($P(DGRPX,"^",5)]"":$P(DGRPX,"^",5),DGRPVR:DGRPU,1:DGRPNA)
 ;Added display of ELIGIBILITY VERIF. SOURCE for Ineligible Project:
 W !?9,"Verif. Source: ",$S($P(DGRPX,"^",3)="H":"HEC",$P(DGRPX,"^",3)="V":"VISTA",1:"NOT AVAILABLE")
 S Z=2 D WW^DGRPV W "     Money Verified: " S Y=$P(DGRP(.3),"^",6) X:Y]"" ^DD("DD") W $S(Y]"":Y,1:"NOT VERIFIED") S Z=3 D WW^DGRPV W "   Service Verified: " S Y=$P(DGRP(.32),"^",2) X:Y]"" ^DD("DD") W $S(Y]"":Y,1:"NOT VERIFIED")
 S Z=4 D WW^DGRPV W " Rated Disabilities: " I $P(DGRP("VET"),"^",1)'="Y",$S('$D(^DG(391,+DGRP("TYPE"),0)):1,$P(^(0),"^",2):0,1:1) W DGRPNA," - NOT A VETERAN" G Q
 S I3=0 F I=0:0 S I=$O(^DPT(DFN,.372,I)) Q:'I  S I1=^(I,0),I2=$S($D(^DIC(31,+I1,0)):$P(^(0),"^",1)_" ("_+$P(I1,"^",2)_"%-"_$S($P(I1,"^",3):"SC",$P(I1,"^",3)']"":"not specified",1:"NSC")_")",1:""),I3=I3+1 W:I3>1 !?24 W I2
 W:'I3 "NONE STATED"
Q G ^DGRPP
