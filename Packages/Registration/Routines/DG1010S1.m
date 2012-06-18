DG1010S1 ;ALB/MRL - SUPPLEMENTAL DATA SHEET FOR 10-10 ; 19 JUN 86
 ;;5.3;Registration;;Aug 13, 1993
 ;;MAS VERSION 5.1;
 ;
 ;INPUT: DFN  = IEN OF PATIENT FILE
 ;       DFN1 = INVERSE DISPOSTION TIME
EN ;
 S DGLDOUBL="",$P(DGLDOUBL,"=",132)=""
 S DGLSUP="",$P(DGLSUP,"- ",62)="",$P(DGLSUP,"- ",43)=" |"
 S DGLSUP1="",$P(DGLSUP1,"-",123)="",$P(DGLSUP1,"-",86)="|"
 F I="INE","DIS",0,.15,.24,.361 S DGP(I)=$G(^DPT(DFN,I))
 S DGD=$G(^DPT(DFN,"DIS",DFN1,0)),Y=$P(DGD,U,1) X ^DD("DD") S DGAP=Y,DGCLK=$S($D(^VA(200,+$P(DGD,U,5),0)):$S($P(^(0),U,2)]"":$P(^(0),U,2)_"/"_$P(DGD,U,5),1:"unk/"_$P(DGD,U,5)),1:"unspecified"),DGNAM=$P(DGP(0),U,1)
 S DGSS=$P(DGP(0),U,9),DGSS=$E(DGSS,1,3)_"-"_$E(DGSS,4,5)_"-"_$E(DGSS,6,10)
 S DGLDOUBL=$E(DGLDOUBL,1,127)
 I $$FIRST^DGUTL G Q^DG1010S2
 W !?5,DGLDOUBL,!?5
 S X=$$SITE^VASITE W $S((+X=-1):"FACILITY NOT IDENTIFIED",1:$P(X,U,2)_" ("_$P(X,U,3)_")")
 W ?105,"SUPPLEMENTAL DATA SHEET",!?5,DGLDOUBL,!?5,"1.  Applicant's Name:  ",DGNAM,?90,"| 2.  SSN:  ",DGSS,!?5,DGLSUP1,!?5,"3.  Other Name(s):  "
 S I1="" F I=0:0 S I=$O(^DPT(DFN,.01,I)) Q:I'>0  S I1=1,DGD=$P(^(I,0),U,1),DGD(1)=$P(^(0),U,2),DGD=DGD_$S($L(DGD(1)):" ("_$E(DGD(1),1,3)_"-"_$E(DGD(1),4,5)_"-"_$E(DGD(1),6,10)_")",1:"")_"; " W:(128-$X)<$L(DGD) !?9 W DGD
 W:'I1 "NO ALIAS' ON FILE" K DGD,I,I1 S DGD=$S($L($P(DGP(0),U,10)):$P(DGP(0),U,10),1:"NO REMARKS CURRENTLY ENTERED FOR THIS APPLICANT") W !?5,DGLSUP1,!?5,"4.  Remarks:  ",DGD,!?5,DGLSUP1
 S DGD=DGP(.24) W !?5,"5.  Fathers Name:  ",$S($L($P(DGD,U,1)):$P(DGD,U,1),1:"NOT SPECIFIED"),?90,"|"
 W !?9,"Mothers Name:  ",$S($L($P(DGD,U,2)):$P(DGD,U,2),1:"NOT SPECIFIED"),?90,"|",!?9,"Mothers Maiden Name:  ",$S($L($P(DGD,U,3)):$P(DGD,U,3),1:"NOT SPECIFIED"),?90,"|",!?5,DGLSUP1
 W !?5,"6a. Enrollment Clinic(s):  " S I1="" F I=0:0 S I=$O(^DPT(DFN,"DE",I)) Q:I'>0  I $P(^(I,0),U,2)'="I" S I1=I1+1,DGD=$S($D(^SC(+^(0),0)):$P(^(0),U,1)_", ",1:"") W:(128-$X)<$L(DGD) !?9 W DGD
 W:'I1 "NOT ACTIVELY ENROLLED IN ANY CLINICS AT THIS TIME" K DGD,I,I1 W !?5,DGLSUP,!?5,"6b. Future Appointments:  " S I1="",I2=DT_".9999"
 F J=0:0 S I2=$O(^DPT(DFN,"S",I2)) Q:I2=""  I $S($P(^(I2,0),U,2)']"":1,$P(^(0),U,2)="I":1,1:0) S DGD(1)=+$P(^(0),U,1),Y=I2 X ^DD("DD") S DGD=$S($D(^SC(+DGD(1),0)):$P(^(0),U,1),1:"UNKNOWN")_" ("_Y_"), ",I1=1 W:(128-$X)<$L(DGD) !?9 W DGD
 W:'I1 "NO PENDING APPOINTMENTS ON FILE" W !?5,DGLSUP1,!?5,"7a. Last Admission:  "
 S DGAD=$S('$D(^DPT(DFN,.1)):0,'$L(^DPT(DFN,.1)):0,1:1),DGD=$O(^DGPM("ATID1",DFN,+$S(DGAD:$O(^DGPM("ATID1",DFN,0)),1:0))) I DGD'>0 W "NO PREVIOUS ADMISSIONS TO THIS FACILITY ON FILE" G EL
 S DGD=$O(^DGPM("ATID1",DFN,DGD,0)) I $S('$D(^DGPM(+DGD,0)):1,'$D(^DGPT(+$P(^(0),"^",16),0)):1,1:0) W "LAST ADMISSION PTF DATA NO LONGER STORED" G EL
 S DGD=+$P(^DGPM(+DGD,0),"^",16),Y=+^(0)
 X ^DD("DD") W Y S Y=$P($S($D(^DGPT(DGD,70)):^(70),1:0),U,1) X ^DD("DD") W:Y]"" "   (DISCHARGED '"_Y_"')" W !?5,DGLSUP,!?5,"7b. Discharge Diagnosis(es):  " S I1=$S($D(^DGPT(DGD,"M",1,0)):^(0),1:0)
 S I3="" F I=5:1:15 I I'=10 S I2=$P(I1,U,I) Q:'I2  S I3=1,I2=$S($D(^ICD9(I2,0)):"("_$P(^(0),U,1)_")-"_$P(^(0),U,3)_"; ",1:"") W:(128-$X)<$L(I2) !?9 W I2
 W:'I3 "NO DIAGNOSES ON FILE FOR THIS ADMISSION PERIOD YET",!?5,DGLSUP S DGD(1)=$S($D(^DGPT(DGD,70)):^(70),1:0),X="UNSPECIFIED",X=$S('DGD(1):X,$D(^ICD9(+$P(DGD(1),U,11),0)):"("_$P(^(0),U,1)_")-"_$P(^(0),U,3),1:X)
 W !?5,"7c. Admit Diagnosis:  ",X,!?5,DGLSUP,!?5,"7d. Diagnosis Responsible for Greatest Length of Stay:  " S X="UNSPECIFIED",X=$S('DGD(1):X,$D(^ICD9(+$P(DGD(1),U,10),0)):"("_$P(^(0),U,1)_")-"_$P(^(0),U,3),1:X) W X
EL W !?5,DGLSUP1 S DGD=DGP(.361),DGD(1)=$P(DGD,U,5),DGD(2)=$P(DGD,U,6),Y=$P(DGD,U,2),DGD=$P(DGD,U,1),DGD(1)=$S($L(DGD(1)):DGD(1),'$L(DGD):"NOT APPLICABLE",1:"NOT VERIFIED")
 S DGD(2)=$S(+DGD(2):$S($D(^VA(200,+DGD(2),0)):$P(^(0),U,1),1:"UNKNOWN"),'$L(DGD):"NOT APPLICABLE",1:"NOT SPECIFIED") X:+Y ^DD("DD") S Y=$S($L(Y):Y,'$L(DGD):"NOT APPLICABLE",1:"NOT SPECIFIED")
 W !?5,"8.  Eligibility Status:  ",$S(DGD="P":"PENDING VERIFICATION",DGD="R":"PENDING RE-VERIFICATION",DGD="V":"VERIFIED",1:"UNKNOWN OR NONE"),?90,"| Status Date:  ",Y,!?9,"Verification Method:  ",DGD(1),?90,"| By:  ",DGD(2)
 S Y=$P(DGP(.15),U,2),DGD=DGP("INE") X:+Y ^DD("DD") S DGEL=$S('$L(Y)!(Y=0):1,1:0),Y=$S('DGEL:Y,1:"ELIGIBLE APPLICANT -- NOT APPLICABLE") W !?9,"Ineligible Date:  ",Y I DGEL F I=1:1:4 S DGD(I)="NOT APPLICABLE"
 G:DGEL C S DGD(1)=$P(DGD,U,1),DGD(1)=$S(DGD(1)=1:"VAMC",DGD(1)=2:"REGIONAL OFFICE",DGD(2)=3:"RPC",1:"UNKNOWN"),DGD(2)=$S($L($P(DGD,U,3)):$P(DGD,U,3),1:"CITY UNKNOWN"),DGD(3)=$S($D(^DIC(5,+$P(DGD,U,4),0)):$P(^(0),U,1),1:"STATE UNKNOWN")
 S DGD(4)=$S($P(DGD,U,6)]"":$P(DGD,U,6),1:"VARO DECISION UNKNOWN")
C W ?90,"| TWX Source:  ",DGD(1),!?9,"TWX City:  ",DGD(2),?90,"| TWX State:  ",$E(DGD(3),1,26),!?9,"VARO Decision:  ",DGD(4),!?5,DGLSUP1
 K DGAD,DGD,DGEL,I,I1,I2,Y G ^DG1010S2
