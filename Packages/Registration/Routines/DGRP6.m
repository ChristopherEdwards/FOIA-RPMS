DGRP6 ;ALB/MRL - REGISTRATION SCREEN 6/SERVICE INFORMATION ;06 JUN 88@2300
 ;;5.3;Registration;**161,247,343,397,342**;Aug 13, 1993
 S DGRPS=6 D H^DGRPU F I=.32,.321,.322,.36,.52,.53 S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
 S (DGRPW,Z)=1 D WW^DGRPV S Z=" Service Branch",Z1=24 D WW1^DGRPV S Z="Service #",Z1=19 D WW1^DGRPV S Z="Entered",Z1=12 D WW1^DGRPV S Z="Separated",Z1=12 D WW1^DGRPV W "Discharge"
 W !?4,"--------------",?27,"---------",?46,"-------",?58,"---------",?70,"---------"
 S DGRPX=DGRP(.32),DGRPSV=4 D S I $P(DGRPX,"^",19)="Y" S DGRPSV=9 D S I $P(DGRPX,"^",20)="Y" S DGRPSV=14 D S
 S Z=2,DGRPX=DGRP(.52) D WW^DGRPV W "           POW: " S X=5,Z1=6 D YN W "From: " S X=7,Z1=13 D DAT W "To: " S X=8,Z1=12 D DAT W "War: ",$S($D(^DIC(22,+$P(DGRPX,"^",6),0)):$P(^(0),"^",2),1:"")
 S Z=3 D WW^DGRPV W "        Combat: " S X=11,Z1=6 D YN W "From: " S X=13,Z1=13 D DAT W "To: " S X=14,Z1=12 D DAT W "Loc: ",$S($D(^DIC(22,+$P(DGRPX,"^",12),0)):$P(^(0),"^",2),1:"")
 S Z=4,DGRPX=DGRP(.321) D WW^DGRPV W "       Vietnam: " S X=1,Z1=6 D YN W "From: " S X=4,Z1=13 D DAT W "To: " S X=5,X1=13 D DAT
 S Z=5 D WW^DGRPV W "      A/O Exp.: " S X=2,Z1=7 D YN W "Reg: " S X=7,Z1=11 D DAT W "Exam: " S X=9,Z1=11 D DAT W "A/O#: " S Z=$P(DGRPX,"^",10),Z1=8 D WW1^DGRPV S Z=$P(DGRPX,"^",13) W $S(Z="K":" DMZ",Z="V":"VIET",1:"")
 S Z=6 D WW^DGRPV W "      ION Rad.: " S X=3,Z1=7 D YN W "Reg: " S X=11,Z1=9 D DAT W "Method: " S X=$P(DGRPX,"^",12) W $S(X="B":"BOTH",X="T":"NUCLEAR TESTING",X="N":"NAGASAKI/HIROSHIMA",1:"")
 S DGRPX=DGRP(.322)
 F DGX=1,4,7,10 S X=DGX,Z=DGX-1/3+7 D WW^DGRPV W:DGX<10 " " W $S(DGX=1:"      Lebanon",DGX=4:"      Grenada",DGX=7:"       Panama",1:"     Gulf War"),": " S Z1=6 D YN W "From: " S X=DGX+1,Z1=13 D DAT W "To: " S X=DGX+2,Z1=12 D DAT
 S Z=11 D WW^DGRPV W "      Somalia: " S (DGX,X)=16,Z1=6 D YN W "From: " S X=17,Z1=13 D DAT W "To: " S X=18,Z1=12 D DAT
 S Z=12 D WW^DGRPV W "   Env Contam: " S X=13,Z1=7 D YN W "Reg: " S X=14,Z1=11 D DAT W "Exam: " S X=15,Z1=10 D DAT
 S Z=13 D WW^DGRPV S X=$P(DGRP(.36),"^",2)
 W "    Mil Disab: ",$S(X=0:"NO",X=1:"YES",X=2:"YES",X=3:"UNK",1:"UNANSWERED") I X]"",(X'=3) W ", Applicant is ",$S('X:"NOT ",1:""),"retired from military due to disability." I X=2 D MR
 ;W !
 S Z=14 D WW^DGRPV W "     Dent Inj: " S DGRPX=DGRP(.36),X=8,Z1=28 D YN W "Teeth Extracted: " S X=9,Z1=9 D YN S DGRPD=0 I $P(DGRPX,"^",8)="Y",$P(DGRPX,"^",9)="Y" S DGRPD=1
 I DGRPD S I1="" F I=0:0 S I=$O(^DPT(DFN,.37,I)) Q:'I  S I1=1,DGRPX=^(I,0) D DEN
 S DGRPX=DGRP(.322)
 S Z=15 D WW^DGRPV W "   Yugoslavia: " S (DGX,X)=19,Z1=6 D YN W "From: " S X=20,Z1=13 D DAT W "To: " S X=21,Z1=12 D DAT
 S Z=16 D WW^DGRPV W " Purple Heart: " S DGRPX=DGRP(.53),X=1 D YN D
 . I $P($G(DGRPX),U)="Y",($P($G(DGRPX),U,2)]"") W ?26,"PH Status: "_$S($P($G(DGRPX),U,2)="1":"Pending",$P($G(DGRPX),U,2)="2":"In Process",$P($G(DGRPX),U,2)="3":"Confirmed",1:"")
 I $P($G(DGRPX),U)="N" D
 . S DGX=$P(DGRPX,U,3)
 . S DGX=$S($G(DGX)=1:"UNACCEPTABLE DOCUMENTATION",$G(DGX)=2:"NO DOCUMENTATION REC'D",$G(DGX)=3:"ENTERED IN ERROR",$G(DGX)=4:"UNSUPPORTED PURPLE HEART",$G(DGX)=5:"VAMC",$G(DGX)=6:"UNDELIVERABLE MAIL",1:"")
 . I $G(DGX)]"" W ?26,"PH Remarks: "_$S($G(DGX)]"":$G(DGX),1:"")
 S Z=17 D WW^DGRPV W "   N/T Radium: " D     ;N/T Radium Treatment expos.
 . N DGNT S DGRPX=$$GETCUR^DGNTAPI(DFN,"DGNT") W $G(DGNT("INTRP"))
Q K DGRPD,DGRPSV
 G ^DGRPP
YN S Z=$S($P(DGRPX,"^",X)="Y":"YES",$P(DGRPX,"^",X)="N":"NO",$P(DGRPX,"^",X)="U":"UNK",1:"") D WW1^DGRPV Q
DAT S Z=$P(DGRPX,"^",X) I Z']"" S Z=""
 E  S Z=$$FMTE^XLFDT(Z,"5DZ")
 D WW1^DGRPV Q
DEN W !?3," Trt Date: " S X=1,Z1=10 D DAT W "Cond.: ",$E($P(DGRPX,"^",2),1,45) Q
S W !?4,$S($D(^DIC(23,+$P(DGRPX,"^",DGRPSV+1),0)):$E($P(^(0),"^",1),1,24),1:DGRPU),?27,$S($P(DGRPX,"^",DGRPSV+4)]"":$P(DGRPX,"^",DGRPSV+4),1:DGRPU)
 F I=2,3 S X=$P(DGRPX,"^",DGRPSV+I),X=$S(X]"":$$FMTE^XLFDT(X,"5DZ"),1:"UNKNOWN") W ?$S(I=2:46,1:58),X
 W ?70,$S($D(^DIC(25,+$P(DGRPX,"^",DGRPSV),0)):$E($P(^(0),"^",1),1,9),1:"UNKNOWN") Q
MR W !?19,"Receiving Military retirement in lieu of VA Compensation." Q
