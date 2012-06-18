ADE6P202 ;IHS/OIT/ENM - ADE6.0 PATCH 20 [ 09/25/2009  13:35 PM ]
 ;;6.0;ADE;**20**;SEP 25, 2009
 ;
MODCDT5 ;EP
 D UPDATE^ADEUPD20(9999999.31,".01,,.02,.06,8801",1101,"?+1,","MODADA^ADE6P202","SETX^ADE6P202")
 ;
 ;D MODEDT ;IHS/ENM NO NEED TO RUN THIS LINE IN P20
 Q
 ;
MODEDT ;EP Modify DENTAL CODE EDIT GROUP and Reindex DENTAL EDIT file
 Q
SETEDX ;
 S ADEN=$P(ADEX,U)
 Q
 ;
EDITX ;Data for DENTAL CODE EDIT GROUP modifications
 Q
 ;;PRIMARY TOOTH PROCEDURES^2121|2930|3230
 ;;
 ;;***END***
 Q
 ;
REINDX ;EP Kill and Re-index AC, AD AND B Cross References on DENTAL EDIT file
 ;
 N DIK
 K ^ADEDIT("AC"),^ADEDIT("AD"),^ADEDIT("B")
 S DIK="^ADEDIT("
 D IXALL^DIK
 Q
 ;
SETX ;EP
 I $G(ADERPEAT) D  Q:ADERPEAT
 .S:ADERPEAT=1 ADECURX=ADEX,ADERPEAT=2
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEX=ADECURX,ADEN="" Q
 .S ADEX=ADESVX,$P(ADEX,U)=ADEN,ADERPEAT=2
 Q:ADEDONE
 I $P(ADEX,U)["-" D  Q:'ADERPEAT
 .S ADERPEAT=1,ADESVX=ADEX,ADESTART=$P($P($P(ADEX,U),"-"),"D",2),ADEEND=$P($P($P(ADEX,U),"-",2),"D",2),ADEN=$O(^AUTTADA("B",ADESTART),-1)
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEN="" Q
 .S $P(ADEX,U)=ADEN
 I 'ADERPEAT S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN
 S $P(ADEX,U,3)=$TR($P(ADEX,U,3),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S:ADERPEAT ADESVX=ADEX
 Q
 ;
 ;Code(.01)^Countofp3^Nomenclature/desc(.02)^Synonym(.06)^Mnemonic(8801)^
 ;Recommended Use(1101)
MODADA ;
 ;;D0002^13^SBIRT Patient^SC BI REF^SBIRT^
 ;;Screening, Brief Intervention, and Referral for Treatment for patients at risk for substance abuse disorders
 ;;D0005^13^Trauma Recall^TR RECALL^TRREC^
 ;;Active recall for patient with injuries resulting from trauma
 ;;D0006^21^Hi Risk Caries Recall^HRCAR RECALL^HRCREC^
 ;;Active recall for patient at high risk for caries
 ;;***END***
