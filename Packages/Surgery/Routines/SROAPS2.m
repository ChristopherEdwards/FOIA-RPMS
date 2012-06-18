SROAPS2 ;B'HAM ISC/MAM - PREOP INFO (PAGE 2) ; 25 MAR 1992 11:45 am
 ;;3.0; Surgery ;**38,47**;24 Jun 93
 S SRA(200)=$G(^SRF(SRTN,200))
 S NYUK=$P(SRA(200),"^",18) D YN S SRAO(1)=SHEMP_"^210",NYUK=$P(SRA(200),"^",44) D YN S SRAO(2)=SHEMP_"^245"
 S NYUK=$P(SRA(200),"^",19) D YN S SRAO("1A")=SHEMP_"^332",NYUK=$P(SRA(200),"^",21) D YN S SRAO("1B")=SHEMP_"^333"
 S NYUK=$P(SRA(200),"^",24) D YN S SRAO("1C")=SHEMP_"^400",NYUK=$P(SRA(200),"^",25) D YN S SRAO("1D")=SHEMP_"^334",NYUK=$P(SRA(200),"^",26) D YN S SRAO("1E")=SHEMP_"^335"
 S NYUK=$P(SRA(200),"^",27) D YN S SRAO("1F")=SHEMP_"^336",NYUK=$P(SRA(200),"^",29) D YN S SRAO("1G")=SHEMP_"^401"
 S NYUK=$P(SRA(200),"^",45) D YN S SRAO("2A")=SHEMP_"^338",NYUK=$P(SRA(200),"^",46) D YN S SRAO("2B")=SHEMP_"^218",NYUK=$P(SRA(200),"^",47) D YN S SRAO("2C")=SHEMP_"^339",NYUK=$P(SRA(200),"^",48) D YN S SRAO("2D")=SHEMP_"^215"
 S NYUK=$P(SRA(200),"^",49) D YN S SRAO("2E")=SHEMP_"^216",NYUK=$P(SRA(200),"^",50) D YN S SRAO("2F")=SHEMP_"^217"
 S SRA(206)=$G(^SRF(SRTN,206)),NYUK=$P(SRA(206),"^",3) D YN S SRAO("2G")=SHEMP_"^338.1",NYUK=$P(SRA(206),"^",4) D YN S SRAO("2H")=SHEMP_"^338.2",NYUK=$P(SRA(206),"^",8) D YN S SRAO("2I")=SHEMP_"^218.1" K SRA
 S SRPAGE="PAGE: 2 OF 2" D HDR^SROAUTL
 W !,"1. CENTRAL NERVOUS SYSTEM:",?34,$P(SRAO(1),"^"),?39,"2. NUTRITIONAL/IMMUNE/OTHER:",?76,$P(SRAO(2),"^")
 W !,"   A. Impaired Sensorium: ",?34,$P(SRAO("1A"),"^"),?39,"   A. Disseminated Cancer:",?76,$P(SRAO("2A"),"^")
 W !,"   B. Coma:",?34,$P(SRAO("1B"),"^"),?39,"   B. Open Wound:",?76,$P(SRAO("2B"),"^")
 W !,"   C. Hemiplegia:",?34,$P(SRAO("1C"),"^"),?39,"   C. Steroid Use for Chronic Cond.:",?76,$P(SRAO("2C"),"^")
 W !,"   D. History of TIAs:",?34,$P(SRAO("1D"),"^"),?39,"   D. Weight Loss > 10%:",?76,$P(SRAO("2D"),"^")
 W !,"   E. CVA/Residual Neuro Deficit:",?34,$P(SRAO("1E"),"^"),?39,"   E. Bleeding Disorders:",?76,$P(SRAO("2E"),"^")
 W !,"   F. CVA/No Neuro Deficit:",?34,$P(SRAO("1F"),"^"),?39,"   F. Transfusion > 4 RBC Units:",?76,$P(SRAO("2F"),"^")
 W !,"   G. Tumor Involving CNS:",?34,$P(SRAO("1G"),"^"),?39,"   G. Chemotherapy W/I 30 Days:",?76,$P(SRAO("2G"),"^")
 W !,?39,"   H. Radiotherapy W/I 90 Days:",?76,$P(SRAO("2H"),"^"),!,?39,"   I. Preoperative Sepsis:",?76,$P(SRAO("2I"),"^")
 W !! F MOE=1:1:80 W "-"
 Q
YN ; set answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
