SROAPRT2 ;B'HAM ISC/MAM - PRINT PREOP INFO (PAGE 2) ; 18 MAR 1992 9:35 am
 ;;3.0; Surgery ;**38**;24 Jun 93
 S NYUK=$P(SRA(200),"^",18) D YN S SRAO(1)=SHEMP_"^210",NYUK=$P(SRA(200),"^",44) D YN S SRAO(2)=SHEMP_"^245"
 S NYUK=$P(SRA(200),"^",19) D YN S SRAO("1A")=SHEMP_"^332",NYUK=$P(SRA(200),"^",21) D YN S SRAO("1B")=SHEMP_"^333"
 S NYUK=$P(SRA(200),"^",24) D YN S SRAO("1C")=SHEMP_"^400",NYUK=$P(SRA(200),"^",25) D YN S SRAO("1D")=SHEMP_"^334",NYUK=$P(SRA(200),"^",26) D YN S SRAO("1E")=SHEMP_"^335"
 S NYUK=$P(SRA(200),"^",27) D YN S SRAO("1F")=SHEMP_"^336",NYUK=$P(SRA(200),"^",29) D YN S SRAO("1G")=SHEMP_"^401"
 S NYUK=$P(SRA(200),"^",45) D YN S SRAO("2A")=SHEMP_"^338",NYUK=$P(SRA(200),"^",46) D YN S SRAO("2B")=SHEMP_"^218",NYUK=$P(SRA(200),"^",47) D YN S SRAO("2C")=SHEMP_"^339",NYUK=$P(SRA(200),"^",48) D YN S SRAO("2D")=SHEMP_"^215"
 S NYUK=$P(SRA(200),"^",49) D YN S SRAO("2E")=SHEMP_"^216",NYUK=$P(SRA(200),"^",50) D YN S SRAO("2F")=SHEMP_"^217"
 S SRA(206)=$G(^SRF(SRTN,206)),NYUK=$P(SRA(206),"^",3) D YN S SRAO("2G")=SHEMP_"^338.1",NYUK=$P(SRA(206),"^",4) D YN S SRAO("2H")=SHEMP_"^338.2",NYUK=$P(SRA(206),"^",8) D YN S SRAO("2I")=SHEMP_"^218.1"
 I $E(IOST)'="P" W !,?28,"PREOPERATIVE INFORMATION",!
 W !!,"CENTRAL NERVOUS SYSTEM:",?29,$P(SRAO(1),"^"),?40,"NUTRITIONAL/IMMUNE/OTHER:",?72,$P(SRAO(2),"^")
 W !,"Impaired Sensorium: ",?29,$P(SRAO("1A"),"^"),?40,"Disseminated Cancer:",?72,$P(SRAO("2A"),"^")
 W !,"Coma:",?29,$P(SRAO("1B"),"^"),?40,"Open Wound:",?72,$P(SRAO("2B"),"^")
 W !,"Hemiplegia:",?29,$P(SRAO("1C"),"^"),?40,"Steroid Use for Chronic Cond.:",?72,$P(SRAO("2C"),"^")
 W !,"History of TIAs:",?29,$P(SRAO("1D"),"^"),?40,"Weight Loss > 10%:",?72,$P(SRAO("2D"),"^")
 W !,"CVA/Residual Neuro Deficit:",?29,$P(SRAO("1E"),"^"),?40,"Bleeding Disorders:",?72,$P(SRAO("2E"),"^")
 W !,"CVA/No Neuro Deficit:",?29,$P(SRAO("1F"),"^"),?40,"Transfusion > 4 RBC Units:",?72,$P(SRAO("2F"),"^")
 W !,"Tumor Involving CNS:",?29,$P(SRAO("1G"),"^"),?40,"Chemotherapy W/I 30 Days:",?72,$P(SRAO("2G"),"^")
 W !,?40,"Radiotherapy W/I 90 Days:",?72,$P(SRAO("2H"),"^"),!,?40,"Preoperative Sepsis:",?72,$P(SRAO("2I"),"^")
 I $E(IOST)="P" W !
 Q
YN ; set answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
