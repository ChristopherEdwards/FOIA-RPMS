SROAPCA4 ;B'HAM ISC/SJA - CARDIAC COMPLIANCE DATA ; [ 08/31/00  9:12 AM ]
 ;;3.0; Surgery ;**95**;24 Jun 93
 ;
 ; Reference to ^DGPM("APTT1" supported by DBIA #565
 ; Reference to File #405 supported by DBIA #3029
 ;
 S SRA(201)=$G(^SRF(SRTN,201)),SRA(202)=$G(^SRF(SRTN,202)),SRA(208)=$G(^SRF(SRTN,208)),SRA(0)=$G(^SRF(SRTN,0))
 N SRREF,SRREFP,SRFOL,SRFOLP,SRSOUT,SRY S (SRREF,SRREFP,SRFOL,SRFOLP)="",SRSOUT=0,(VAIP("D"),SRSDATE)=$P(SRA(0),"^",9) D IN5^VADPT
 I 'VAIP(13) S X1=$P($G(^SRF(SRTN,.2)),"^",12),X2=1 D C^%DTC S SR24=X,SRDT=$O(^DGPM("APTT1",DFN,SRSDATE)) G:'SRDT!(SRDT>SR24) TS S VAIP("D")=SRDT D IN5^VADPT
TS I VAIP(13) K DA,DIC,DIQ,DR S DIC=405,DR=.05,DA=VAIP(13),DIQ="SRY",DIQ(0)="IE" D EN^DIQ1 S SRREF=SRY(405,VAIP(13),.05,"E"),SRREFP=SRY(405,VAIP(13),.05,"I") I SRREFP S SRREFP=$$GET1^DIQ(4,SRREFP,99)
 I VAIP(17) K DA,DIC,DIQ,DR,SRY S DIC=405,DR=.05,DA=VAIP(17),DIQ="SRY",DIQ(0)="IE" D EN^DIQ1 S SRFOL=SRY(405,VAIP(17),.05,"E"),SRFOLP=SRY(405,VAIP(17),.05,"I") I SRFOLP S SRFOLP=$$GET1^DIQ(4,SRFOLP,99)
 I $Y+7>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !!,"VII. Guideline Compliance Indicators: Background Data"
 W !,?5,"Primary care or referral VAMC identification code: ",SRREFP
 W !,?5,"Follow-up VAMC identification code: ",SRFOLP
 ;
 I $Y+17>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !!,"VIII. Detailed Laboratory Information - Assessment at Patient Discharge"
 W !,"Note: Laboratory data is collected at the time of assessment completion and",!,"      can not be edited by the nurse!!"
 N SROUN S SROUN=" mg/dl"
 W !,?2,"HDL: ",?27,$P(SRA(201),U,21),SROUN,?40,"LDL: ",?67,$P(SRA(201),U,25),SROUN
 S Y=$P(SRA(202),"^",22) D DT W !,?2,"Date of HDL: ",?27,$E(X,1,8)
 S Y=$P(SRA(202),"^",25) D DT W ?40,"Date of LDL: ",?67,$E(X,1,8)
 W !!,?2,"Serum Triglyceride: ",?27,$P(SRA(201),U,22),SROUN,?40,"Total Cholesterol: ",?67,$P(SRA(201),U,26),SROUN
 S Y=$P(SRA(202),"^",22) D DT W !,?2,"Date of Serum Trig.: ",?27,$E(X,1,8)
 S Y=$P(SRA(202),"^",26) D DT W ?40,"Date of Total Cholesterol: ",?67,$E(X,1,8)
 W !!,?2,"Serum Potassium: ",?27,$P(SRA(201),U,23)," mg/L" S Y=$P(SRA(202),"^",23) D DT W !,?2,"Date of Serum Potassium: ",?27,$E(X,1,8)
 W !!,?2,"Serum Bilirubin: ",?27,$P(SRA(201),U,24),SROUN S Y=$P(SRA(202),"^",24) D DT W !,?2,"Date of Serum Bilirubin: ",?27,$E(X,1,8)
DD ;Detailed Discharge Information
 N VAINDT,SRPTF,SRRES
 S X=$P(SRA(208),"^",15) I X S X=X-.0001
 S VAINDT=X D INP^VADPT S SRPTF=VAIN(10)
 S SRRES="" D RPC^DGPTFAPI(.SRRES,SRPTF)
 I $Y+9>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !!,"IX. Detailed Discharge Information",!,"   Discharge ICD-9 Codes: " I $G(SRRES(0))>0 S SRRES="" D
 .S SRRES=$P(SRRES(1),U,3)_"  " I $D(SRRES(2)) F I=1:1:9 S:$P(SRRES(2),"^",I)'="" SRRES=SRRES_$P(SRRES(2),"^",I)_"  " I $L(SRRES)>45 W SRRES S SRRES=""
 .W:$D(SRRES) !,?26,SRRES
 W !!,"   Discharge Disposition: ",$P($G(SRRES(1)),U,1)
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
DT S X="NS" I Y>1 D DT^SROAPCA1
 Q
