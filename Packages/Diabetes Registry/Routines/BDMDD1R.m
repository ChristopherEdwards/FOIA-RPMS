BDMDD1R ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT 03 Feb 2014 5:38 PM ; 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
SDPI16 ;EP
 K BDMCUML
 S BDMCUML(10)="Aspirin or Other Antiplatelet Therapy in Cardiovascular Disease"
 S BDMCUML(10,1)="In patients with diagnosed CVD, aspirin "
 S BDMCUML(10,2)="or other antiplatelet/anticoagulant "
 S BDMCUML(10,3)="therapy prescribed"
 ;
 S BDMCUML(20)="Blood Pressure Control"
 S BDMCUML(20,1)="Mean blood prssure <140/<90 mmHg"
 S BDMCUML(20,2)="(Mean of last 2, or 3 if available)"
 ;
 S BDMCUML(30)="Chronic Kidney Disease Screening and Monitoring"
 S BDMCUML(30,1)="In age 18+, both UACR & eGFR done"
 ;
 S BDMCUML(40)="Dental Exam"
 S BDMCUML(40,1)="Dental exam received"
 ;
 S BDMCUML(50)="Depression Screening"
 S BDMCUML(50,1)="In patients without active depression,"
 S BDMCUML(50,2)="screened for depression"
 ;
 S BDMCUML(60)="Diabetes-related Education"
 S BDMCUML(60,1)="Any diabetes topic (nutrition,"
 S BDMCUML(60,2)="physical activity, or other)"
 ;eye exam
 S BDMCUML(70)="Eye Exam - Retinopathy Screening"
 S BDMCUML(70,1)="Eye exam - dilated or retinal imaging"
 ;foot exam
 S BDMCUML(80)="Foot Exam"
 S BDMCUML(80,1)="Foot exam - comprehensive"
 ;glycemic control
 S BDMCUML(90)="Glycemic Control"
 S BDMCUML(90,1)="A1C <8.0%"
 ;HEP B
 S BDMCUML(100)="Immunizations: Hepatitis B"
 S BDMCUML(100,1)="Hepatitis B 3-dose series complete - ever"
 ;FLU
 S BDMCUML(110)="Immunizations: Influenza"
 S BDMCUML(110,1)="Influenza vaccine during report period"
 ;
 ;PNEUMO
 S BDMCUML(120)="Immunizations: Pneumococcal"
 S BDMCUML(120,1)="Pneumococcal vaccine - ever"
 ;TETANUS
 S BDMCUML(130)="Immunizations: Tetanus/Diphtheria"
 S BDMCUML(130,1)="Tetanus/diphtheria - past 10 years"
 ;lipid man
 S BDMCUML(140)="Lipid Management in Cardiovascular Disease"
 S BDMCUML(140,1)="In patients aged 40-75 and/or with"
 S BDMCUML(140,2)="diagnosed CVD, statin prescribed"
 ;
 S BDMCUML(150)="Nutrition Education"
 S BDMCUML(150,1)="Nutrition education - by any provider"
 ;
 S BDMCUML(160)="Physical activity education"
 S BDMCUML(160,1)="Physical activity education"
 ;
 S BDMCUML(170)="Tobacco Use Screening"
 S BDMCUML(170,1)="Screened for tobacco use during "
 S BDMCUML(170,2)="report period"
 ;
 S BDMCUML(180)="Tuberculosis Screening"
 S BDMCUML(180,1)="TB test done (skin or blood)"
 ;
PROCESS ;
 S BDMNOGO=0
 S BDMPD=0 F  S BDMPD=$O(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD  D CUML1
 Q
 ;
CUML1 ;
ASPIRIN ;
 I $$DODX^BDMDD16(BDMPD,BDMDMRG,"I")>BDMADAT S BDMNOGO=BDMNOGO+1 Q
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,116))  ;CVD
 I $E(V)=1 S $P(BDMCUML(10,1),U,3)=$P(BDMCUML(10,1),U,3)+1  ;CVD DENOM
 ;CVD AND ASPIRIN
 S A=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,62))
 I $E(V)=1,$E(A)=1 S $P(BDMCUML(10,1),U,2)=$P(BDMCUML(10,1),U,2)+1
BPC ;blood pressure control
 ;take last 3 bp's and get mean systolic and mean diastolic
 S $P(BDMCUML(20,1),U,3)=$P(BDMCUML(20,1),U,3)+1
 S S=$$SYSMEAN^BDMDD15(BDMPD,BDMRBD,BDMRED)
 S D=$$DIAMEAN^BDMDD15(BDMPD,BDMRBD,BDMRED)
 D
 .I S=""!(D="") Q
 .I S<140&(D<90) S $P(BDMCUML(20,1),U,2)=$P(BDMCUML(20,1),U,2)+1 Q
CKD ;
 I $$AGE^AUPNPAT(BDMPD,BDMADAT)<18 G DENT
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,79)),V=$$STV^BDMDD18($P(V,U,2),5)
 S T=$P($G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,92)),U,5)  ;type of test
 S $P(BDMCUML(30,1),U,3)=$P(BDMCUML(30,1),U,3)+1
 I V]"",T=1 S $P(BDMCUML(30,1),U,2)=$P(BDMCUML(30,1),U,2)+1
DENT ;
 S $P(BDMCUML(40,1),U,3)=$P(BDMCUML(40,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,42))
 I $E(V)="1" S $P(BDMCUML(40,1),U,2)=$P(BDMCUML(40,1),U,2)+1
DEP ;
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,200))
 I $E(V)'="1" S $P(BDMCUML(50,1),U,3)=$P(BDMCUML(50,1),U,3)+1 D
 .S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,210))
 .I $E(V)="1" S $P(BDMCUML(50,1),U,2)=$P(BDMCUML(50,1),U,2)+1
EDUC ;
 S G=0
 S $P(BDMCUML(60,1),U,3)=$P(BDMCUML(60,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,44))  ;NUTR
 I $E(V)="1"!($E(V)=2)!($E(V)=3) S G=1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,46))
 I $E(V)="1" S G=1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,48))
 I $E(V)="1" S G=1
 I G S $P(BDMCUML(60,1),U,2)=$P(BDMCUML(60,1),U,2)+1
EYE ;
 S $P(BDMCUML(70,1),U,3)=$P(BDMCUML(70,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,40))
 I $E(V)="1" S $P(BDMCUML(70,1),U,2)=$P(BDMCUML(70,1),U,2)+1
FOOT ;
 S $P(BDMCUML(80,1),U,3)=$P(BDMCUML(80,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,38))
 I $E(V)="1" S $P(BDMCUML(80,1),U,2)=$P(BDMCUML(80,1),U,2)+1
GLYCTRL ;
 S $P(BDMCUML(90,1),U,3)=$P(BDMCUML(90,1),U,3)+1
 S V=$P($G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,78)),U,2)
 S P="",BDMA18=0
 I V=""!(V="?") G IMM
 I V["<" S P=1
 I V[">" S P=2
 S V=$$STV^BDMDD18(V,5)
 I V="" G IMM
 S V=+V
 I 'P S P=$S(V="":0,V<8.0:1,V>8.9:2,1:"")
 I P=1 S $P(BDMCUML(90,1),U,2)=$P(BDMCUML(90,1),U,2)+1
IMM ;
HEPB ;
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,115))
 I V'=4 S $P(BDMCUML(100,1),U,3)=$P(BDMCUML(100,1),U,3)+1
 I $E(V)="1" S $P(BDMCUML(100,1),U,2)=$P(BDMCUML(100,1),U,2)+1
FLU ;
 S $P(BDMCUML(110,1),U,3)=$P(BDMCUML(110,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,64))
 I $E(V)="1" S $P(BDMCUML(110,1),U,2)=$P(BDMCUML(110,1),U,2)+1
PNEUM ;
 S $P(BDMCUML(120,1),U,3)=$P(BDMCUML(120,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,66))
 I $E(V)="1" S $P(BDMCUML(120,1),U,2)=$P(BDMCUML(120,1),U,2)+1
TD ;
 S $P(BDMCUML(130,1),U,3)=$P(BDMCUML(130,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,68))
 I $E(V)="1" S $P(BDMCUML(130,1),U,2)=$P(BDMCUML(130,1),U,2)+1
LIPID ;
 S V=$E($G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,300)))  ;STATIN
 S C=0
 S A=$$AGE^AUPNPAT(BDMPD,BDMADAT)
 I $E($G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,116)))=1 S C=1  ;CVD
 I C=1!(A>39&(A<76)) D
 .I V'=3 S $P(BDMCUML(140,1),U,3)=$P(BDMCUML(140,1),U,3)+1  ;DENOM
 .I V=1 S $P(BDMCUML(140,1),U,2)=$P(BDMCUML(140,1),U,2)+1  ;NUM
NUTR ;
 S $P(BDMCUML(150,1),U,3)=$P(BDMCUML(150,1),U,3)+1
 S G=0,V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,44))
 I $E(V)="1"!($E(V)=2)!($E(V)=3) S $P(BDMCUML(150,1),U,2)=$P(BDMCUML(150,1),U,2)+1
PHY ;
 S $P(BDMCUML(160,1),U,3)=$P(BDMCUML(160,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,46))
 I $E(V)="1" S $P(BDMCUML(160,1),U,2)=$P(BDMCUML(160,1),U,2)+1
TOB ;
 S $P(BDMCUML(170,1),U,3)=$P(BDMCUML(170,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,215))
 I +V=1!(+V=2) S $P(BDMCUML(170,1),U,2)=$P(BDMCUML(170,1),U,2)+1
TB ;
 S $P(BDMCUML(180,1),U,3)=$P(BDMCUML(180,1),U,3)+1
 S V=$G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,70))
 I $E(V)=1!($E(V)=2) S $P(BDMCUML(180,1),U,2)=$P(BDMCUML(180,1),U,2)+1
 Q
