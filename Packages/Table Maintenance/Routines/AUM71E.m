AUM71E ;IHS/ASDST/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2007 ; [ 08/18/2003   4:01 PM ]
 ;07.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
DRGS ;EP
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC^AUM71("^ICD(","ILX","B","DRG"_$P(AUMLN,U),80.2,$P(AUMLN,U))
 . I Y=-1 Q
 . S DA=+Y
 . S DR=".01///DRG"_$P(AUMLN,U)       ;title
 . S DR=DR_";.06///"_$P(AUMLN,U,3)   ;surgery?
 . S DR=DR_";5///"_$P(AUMLN,U,2)     ;MDC
 . S DIE="^ICD("
 . S AUMDA=DA
 . D DIE^AUM71
 . S DA(1)=AUMDA
 . S DIC(0)="LOX"
 . S X=1
 . S DIC("P")=$P(^DD(80.2,1,0),"^",2)
 . S DIC="^ICD("_DA(1)_",1,"
 . S DIC("DR")=".01///"_$P(AUMLN,U,4)  ;description
 . D ^DIC
 Q
DRG ;;DRG^MDC^SURGERY?^DRG TITLE
 ;;543^1^1^CRANIOTOMY W MAJOR DEVICE IMPLANT
 ;;544^8^1^MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY
 ;;547^5^1^CORONARY BYPASS W CARDIAC CATH W MAJOR CV DX
 ;;549^5^1^CORONARY BYPASS W/O CARDIAC CATH W MAJOR CV DX
 ;;556^5^1^PERCUTANEOUS CARDIOVASC PROC W NON-DRUG-ELUTING STENT W/O MAJ CV DX
 ;;557^5^1^PERCUTANEOUS CARDIOVASCULAR PROC W DRUG-ELUTING STENT W MAJ CV DX
 ;;558^5^1^PERCUTANEOUS CARDIOVASCULAR PROC W DRUG-ELUTING STENT W/O MAJ CV DX
 ;;561^1^^MON-BACTERIAL INFECTIONS OF NERVOUS SYSTEM EXCEPT VIRAL MENINGITIS
 ;;562^1^^SEIZURE AGE>17 W CC
 ;;563^1^^SEIZURE AGE>17 W/O CC
 ;;574^16^^MAJOR HEMATOLOGIC/IMMUNOLOGIC DIAG EXC SICKLE CELL CRISIS & COAGUL
 ;;575^18^^SEPTICEMIA W MV96 PLUS + HOURS AGE >17
 ;;576^18^^SEPTICEMIA W/O MV96 PLUS + HOURS AGE >17
 ;;END
 Q
ICD9PINA ;;ICD 9 PROCEDURE, INACTIVE CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)^INACTIVE DATE(#102)
 ;;13.9^Other operations on lens^OCT 1, 2006
 ;;68.4^Total abdominal hysterectomy^OCT 1, 2006
 ;;68.6^Radical abdominal hysterectomy^OCT 1, 2006
 ;;68.7^Radical vaginal hysterectomy^OCT 1, 2006
 ;;END
ICD9VNEW ;;ICD 9 DIAGNOSIS, NEW V-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#5)^DRG(#60-65)
 ;;V18.51^Family history Colonic polyps^Family history, Colonic polyps^^23^467
 ;;V18.59^Family hist digest disorders^Family history, Other digestive disorders^^23^467
 ;;V26.34^Test male genetic disease^Testing of male for genetic disease carrier status^^23^467
 ;;V26.35^Encounter test male partner^Encounter for testing of male partner of habitual aborter^^23^467
 ;;V26.39^Other genetic testing of male^Other genetic testing of male^^23^467
 ;;V45.86^Bariatric surgery status^Bariatric surgery status^^23^467
 ;;V58.30^Encount change nonsurg dres^Encounter for change or removal of nonsurgical wound dressing^^23^467
 ;;V58.31^Encounter change surg dress^Encounter for change or removal of surgical wound dressing^^23^467
 ;;V58.32^Encounter removal of sutures^Encounter for removal of sutures^^23^467
 ;;V72.11^Encounter hear exam screen^Encounter for hearing examination following failed hearing screening^^23^467
 ;;V72.19^Other exam ears and hearing^Other examination of ears and hearing^^23^467
 ;;V82.71^Screen genetic disease carr^Screening for genetic disease carrier status^^23^467
 ;;V82.79^Other genetic screening^Other genetic screening^^23^467
 ;;V85.51^Body Mass Ind ped less 5th^Body Mass Index, pediatric, less than 5th percentile for age^^23^467
 ;;V85.52^BMIndex ped less than 85th^Body Mass Index, pediatric, 5th percentile to less than 85th percentile for age^^23^467
 ;;V85.53^BMIndex ped less than 95th^Body Mass Index, pediatric, 85th percentile to less than 95th percentile for age^^23^467
 ;;V85.54^BMIndex ped equal 95th percen^Body Mass Index, pediatric, greater than or equal to 95th percentile for age^^23^467
 ;;V86.0^Estrogen receptor positive^Estrogen receptor positive status [ER+]^^23^467
 ;;V86.1^Estrogen receptor negative^Estrogen receptor negative status [ER-]^^23^467
 ;;END
ICD9NEW2 ;
 ;;649.31^Coag def preg deliv antepart^Coagulation defects complicating pregnancy, childbirth, or the puerperium, delivered, with or without mention of antepartum condition^F^14^370,371,372,373,374,375
 ;;649.32^Coag def preg deliv postpart^Coagulation defects complicating pregnancy, childbirth, or the puerperium, delivered, with mention of postpartum complication^F^14^370,371,372,373,374,375
 ;;649.33^Coag defects preg antepart^Coagulation defects complicating pregnancy, childbirth, or the puerperium, antepartum condition or complication^F^14^383,384
 ;;649.34^Coag defects preg postpartum^Coagulation defects complicating pregnancy, childbirth, or the puerperium, postpartum condition or complication^F^14^376,377
 ;;649.40^Epilepsy preg unspec care^Epilepsy complicating pregnancy, childbirth, or the puerperium, unspecified as to episode of care or not applicable^F^14^469
 ;;649.41^Epilepsy preg deliv antepart^Epilepsy complicating pregnancy, childbirth, or the puerperium, delivered, with or without mention of antepartum condition^F^14^370,371,372,373,374,375
 ;;649.42^Epilepsy preg deliv postpart^Epilepsy complicating pregnancy, childbirth, or the puerperium, delivered, with mention of postpartum complication^F^14^370,371,372,373,374,375
 ;;649.43^Epilepsy complic preg antepar^Epilepsy complicating pregnancy, childbirth, or the puerperium, antepartum condition or complication^F^14^383,384
 ;;649.44^Epilepsy compli preg postpar^Epilepsy complicating pregnancy, childbirth, or the puerperium, postpartum condition or complication^F^14^376,377
 ;;649.50^Spotting complic preg unspec^Spotting complicating pregnancy, unspecified as to episode of care or not applicable^F^14^469
 ;;649.51^Spotting preg deliv antepart^Spotting complicating pregnancy, delivered, with or without mention of antepartum condition^F^14^370,371,372,373,374,375
 ;;649.53^Spotting compli preg antepart^Spotting complicating pregnancy, antepartum condition or complication^F^14^383,384
 ;;649.60^Uterine size discrep unspec^Uterine size date discrepancy, unspecified as to episode of care or not applicable^F^14^469
 ;;649.61^Uterine size deliv antepart^Uterine size date discrepancy, delivered, with or without mention of antepartum condition^F^14^370,371,372,373,374,375
 ;;649.62^Uterine size deliv postpart^Uterine size date discrepancy, delivered, with mention of postpartum complication^F^14^370,371,372,373,374,375
 ;;649.63^Uterine size discrep antepart^Uterine size date discrepancy, antepartum condition or complication^F^14^383,384
 ;;649.64^Uterine size discrep postpart^Uterine size date discrepancy, postpartum condition or complication^F^14^376,377
 ;;729.71^Nontrauma compar upper extrem^Nontraumatic compartment syndrome of upper extremity^^8^248
 ;;729.72^Nontrauma compar lower extrem^Nontraumatic compartment syndrome of lower extremity^^8^248
 ;;729.73^Nontraumatic compart abdomen^Nontraumatic compartment syndrome of abdomen^^8^248
 ;;729.79^Nontrauma compart oth sites^Nontraumatic compartment syndrome of other sites^^8^248
 ;;731.3^Major osseous defects^Major osseous defects^^8^244,245
 ;;768.7^Hypoxic-ischem encephalopath^Hypoxic-ischemic encephalopathy (HIE)^^15^390
 ;;770.87^Respiratory arrest newborn^Respiratory arrest of newborn^^15^390
 ;;770.88^Hypoxemia of newborn^Hypoxemia of newborn^^15^390
 ;;775.81^Other acidosis of newborn^Other acidosis of newborn^^15^390
 ;;775.89^Oth neonat endocrine/metabol^Other neonatal endocrine and metabolic disturbances^^15^390
 ;;779.85^Cardiac arrest of newborn^Cardiac arrest of newborn^^15^387,389
 ;;780.32^Complex febrile convulsions^Complex febrile convulsions^^1^26,562,563
 ;;780.96^Generalized pain^Generalized pain^^23^463,464
 ;;780.97^Altered mental status^Altered mental status^^23^463,464
 ;;784.91^Postnasal drip^Postnasal drip^^3^73,74
 ;;784.99^Oth sympt head and neck^Other symptoms involving head and neck^^3^73,74
 ;;788.64^Urinary hesitancy^Urinary hesitancy^^11^325,326,327
 ;;788.65^Straining on urination^Straining on urination^^11^325,326,327
 ;;793.91^Image test inconclu body fat^Image test inconclusive due to excess body fat^^23^463,464
 ;;793.99^Nonspec abnorm radiolog exam^Other nonspecific abnormal findings on radiological and other examinations of body structure^^23^463,464
 ;;795.06^Pap smear cervix cytolo malig^Papanicolaou smear of cervix with cytologic evidence of malignancy^^13^358,359,369
 ;;795.81^Elevated carcinoembryonic^Elevated carcinoembryonic antigen [CEA]^^23^463,464
 ;;795.82^Elevated cancer antigen 125^Elevated cancer antigen 125 [CA 125]^^23^463,464
 ;;795.89^Oth abnormal tumor markers^Other abnormal tumor markers^^23^463,464
 ;;958.90^Compartment syndrome unspec^Compartment syndrome, unspecified^^21^454,455
 ;;958.91^Traum cmprtmt synd uppr ext^Traumatic compartment syndrome of upper extremity^^21^454,455
 ;;958.92^Traumatic compart low extrem^Traumatic compartment syndrome of lower extremity^^21^454,455
 ;;958.93^Traumatic compart abdomen^Traumatic compartment syndrome of abdomen^^21^454,455
 ;;958.99^Traumatic compart other sites^Traumatic compartment syndrome of other sites^^21^454,455
 ;;995.20^Unspec advers effect substanc^Unspecified adverse effect of unspecified drug, medicinal and biological substance^^15^387,389
 ;;995.21^Arthus phenomenon^Arthus phenomenon^^15^387,389
 ;;995.22^Unspec adverse eff anesthesia^Unspecified adverse effect of anesthesia^^15^387,389
 ;;995.23^Unspec adverse effect insulin^Unspecified adverse effect of insulin^^15^387,389
 ;;995.27^Other drug allergy^Other drug allergy^^15^387,389
 ;;995.29^Unspec adverse eff oth substan^Unspecified adverse effect of other drug, medicinal and biological substance^^15^387,389
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
