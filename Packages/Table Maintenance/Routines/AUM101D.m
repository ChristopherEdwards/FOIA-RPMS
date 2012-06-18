AUM101D ;IHS/SD/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2010 ; [ 08/18/2003   4:01 PM ]
 ;;10.2;TABLE MAINTENANCE;;MAR 09, 2010
 ;
 ;aum 10.1 - Added codes 282.20-282.29 from Heat3559
 ;
ICD9PNEW ;;ICD OPERATION/PROCEDURE, NEW PROCEDURE CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^Use with Sex(#9.5)^MDC(#80.12)-DRG(#80.12,1-6) (multiples are separated by "~"
 ;;17.51^Implant CCM,total system^Implantation of rechargeable cardiac contractility modulation [CCM], total system^^5-222,223,224,225,226,227
 ;;17.52^Implant CCM pulse genrtr^Implantation or replacement of cardiac contractility modulation [CCM] rechargeable pulse generator only^^5-245
 ;;17.61^LITT lesn brain,guidance^Laser interstitial thermal therapy [LITT] of lesion or tissue of brain under guidance^^1-23,24,25,26,27
 ;;17.62^LITT les hd/nck,guidance^Laser interstitial thermal therapy [LITT] of lesion or tissue of head and neck under guidance^^10-625,626,627~17-820,821,822,826,827,828
 ;;17.63^LITT lesn liver,guidance^Laser interstitial thermal therapy [LITT] of lesion or tissue of liver under guidance^^6-356,357,358~7-405,406,407
 ;;17.69^LITT lesn guide oth/unsp^Laser interstitial thermal therapy [LITT] of lesion or tissue of other and unspecified site under guidance^^4-163,164,165~9-584,585~12-715,716,717,718~17-820,821,822,826,827,828
 ;;17.70^IV infusion clofarabine^Intravenous infusion of clofarabine
 ;;33.73^Endo ins/re brn val,mult^Endoscopic insertion or replacement of bronchial valve(s), multiple lobes
 ;;38.24^Intravas img cor ves OCT^Intravascular imaging of coronary vessel(s) by optical coherence tomography [OCT]
 ;;38.25^Intravas img non-cor OCT^Intravascular imaging of non-coronary vessel(s) by optical coherence tomography [OCT]
 ;;39.75^Endo emb hd/nk,bare coil^Endovascular embolization or occlusion of vessel(s) of head or neck using bare coils^^1-20,21,22,23,24,25~5-237,238~11-673,674,675~21-907,908,909~24-957,958,959
 ;;39.76^Endo em hd/nk,bioac coil^Endovascular embolization or occlusion of vessel(s) of head or neck using bioactive coils^^1-20,21,22,23,24,25~5-237,238~11-673,674,675~21-907,908,909~24-957,958,959
 ;;46.86^Endo insrt colonic stent^Endoscopic insertion of colonic stent(s)
 ;;46.87^Oth insert colonic stent^Other insertion of colonic stent(s)
 ;;END
ICD9DINA ;;ICD 9 DIAGNOSIS, INACTIVE CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)^INACTIVE DATE(#102)
 ;;239.8^Neoplasm of unspecified nature of other specified sites
 ;;274.0^Gouty arthropathy
 ;;279.4^Autoimmune disease, not elsewhere classified
 ;;282.20^6-PHOSPHOGLUCONIC DEHYDROGENAS^OCT 1, 2008
 ;;282.21^ENZYME, DRUG-INDUCED ANEMIA^OCT 1, 2008
 ;;282.22^ERYTHROCYTIC GLUTATHIONE ANEM^OCT 1, 2008
 ;;282.23^G-6-PD DEFICIENCY ANEMIA^OCT 1, 2008
 ;;282.24^GLUTATHIONE-REDUCTASE ANEMIA^OCT 1, 2008
 ;;282.25^HEMOLYTIC NONSPHEROCYTIC, I^OCT 1, 2008
 ;;282.26^DISORDER OF PENTOSE PHOSPHATE^OCT 1, 2008
 ;;282.27^FAVISM^OCT 1, 2008
 ;;282.29^ANEMIA-GLUTATHIONE METAB OTHER^OCT 1, 2008
 ;;348.8^Other conditions of brain^OCT 1, 2009
 ;;453.8^Other venous embolism and thrombosis of other specified veins^OCT 1, 2009
 ;;488^Influenza due to identified avian influenza virus^OCT 1, 2009
 ;;768.7^Hypoxic-ischemic encephalopathy (HIE)^OCT 1, 2009
 ;;779.3^Feeding problems in newborn^OCT 1, 2009
 ;;784.5^Other speech disturbance^OCT 1, 2009
 ;;799.2^Nervousness^OCT 1, 2009
 ;;969.0^Poisoning by antidepressants^OCT 1, 2009
 ;;969.7^Poisoning by psychostimulants^OCT 1, 2009
 ;;V10.9^Unspecified personal history of malignant neoplasm^OCT 1, 2009
 ;;V53.5^Fitting and adjustment of other intestinal appliance^OCT 1, 2009
 ;;V60.8^Other specified housing or economic circumstances^OCT 1, 2009
 ;;V72.6^Laboratory examination^OCT 1, 2009
 ;;V80.0^Special screening for neurological conditions^OCT 1, 2009
 ;;END
ICD9EINA ;;ICD 9 DIAGNOSIS, INACTIVATED E-CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)^INACTIVE DATE(#102)
 ;;E992.^Injury due to war operations by explosion of marine weapons^OCT 1, 2009
 ;;E993.^Injury due to war operations by other explosion^OCT 1, 2009
 ;;E994.^Injury due to war operations by destruction of aircraft^OCT 1, 2009
 ;;E995.^Injury due to war operations by other and unspecified forms of conventional warfare^OCT 1, 2009
 ;;E996.^Injury due to war operations by nuclear weapons^OCT 1, 2009
 ;;E998.^Injury due to war operations but occurring after cessation of hostilities^OCT 1, 2009
 ;;END
 ;
ICD9OINA ;;ICD 9 DIAGNOSIS, OTHER INACTIVATED CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)^INACTIVE DATE(#102)
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
