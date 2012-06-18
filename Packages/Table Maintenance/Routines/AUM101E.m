AUM101E ;IHS/SD/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2010 ; [ 08/18/2003   4:01 PM ]
 ;;10.2;TABLE MAINTENANCE;;MAR 09, 2010
 ;
DRGS ;EP
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI),";;",2) Q:AUMLN="END"  D
 .S Y=$$IXDIC^AUM81("^ICD(","ILX","B","DRG"_$P(AUMLN,U),80.2,$P(AUMLN,U))
 .I Y=-1 Q
 .S DA=+Y
 .S DR=".01///DRG"_$P(AUMLN,U)       ;title
 .S DR=DR_";.06///"_$P(AUMLN,U,3)   ;surgery?
 .S DR=DR_";5///"_$P(AUMLN,U,2)     ;MDC
 .S DIE="^ICD("
 .S AUMDA=DA
 .D DIE^AUM81
 .S DA(1)=AUMDA
 .S DIC(0)="LOX"
 .S X=1
 .S DIC("P")=$P(^DD(80.2,1,0),"^",2)
 .S DIC="^ICD("_DA(1)_",1,"
 .S DIC("DR")=".01///"_$P(AUMLN,U,4)  ;description
 .D ^DIC
 Q
DRG ;;DRG^MDC^SURGERY?^DRG TITLE
 ;;END
 Q
ICD9PINA ;;ICD 9 PROCEDURE, INACTIVE CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)^INACTIVE DATE(#102)
 ;;END
ICD9VNEW ;;ICD 9 DIAGNOSIS, NEW V-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#5)^DRG(#60-65)
 ;;V10.90^Hx unspec malig neoplasm^Personal history of unspecified malignant neoplasm^^17^826,827,828,829,830,843
 ;;V10.91^Hx malig neuroendo tumor^Personal history of malignant neuroendocrine tumor^^17^826,827,828,829,830,843
 ;;V15.52^Hx traumatc brain injury^Personal history of traumatic brain injury^^23^951
 ;;V15.80^Hx failed mod sedation^Personal history of failed moderate sedation^^23^951
 ;;V15.83^Hx underimmunizn status^Personal history of underimmunization status^^23^951
 ;;V20.31^Health supvsn NB <8 days^Health supervision for newborn under 8 days old^^15^795
 ;;V20.32^Health supv NB 8-28 days^Health supervision for newborn 8 to 28 days old^^15^795
 ;;V26.42^Fertlity preserv counsel^Encounter for fertility preservation counseling^^23^951
 ;;V26.82^Fertility preserv proc^Encounter for fertility preservation procedure^^23^951
 ;;V53.50^Fit/adjust intestinl app/dev^Fitting and adjustment of intestinal appliance and device^^6^393,394,395
 ;;V53.51^Fit/adj gastric lap band^Fitting and adjustment of gastric lap band^^6^393,394,395
 ;;V53.59^Fit/adjust GI app/device^Fitting and adjustment of other gastrointestinal appliance and device^^6^393,394,395
 ;;V60.81^Foster care (status)^Foster care (status)^^23^951
 ;;V60.89^Oth housing/econo circumst^Other specified housing or economic circumstances^^23^951
 ;;V61.07^Family dsrpt-death fam membr^Family disruption due to death of family member^^23^951
 ;;V61.08^Fmly dsrp-ext fam mbr absnce^Family disruption due to other extended absence of family member^^23^951
 ;;V61.23^Counsl prnt-biol chld prob^Counseling for parent-biological child problem^^23^951
 ;;V61.24^Counsl prnt-adpt chld prob^Counseling for parent-adopted child problem^^23^951
 ;;V61.25^Counsl prnt-fstr chld prob^Counseling for parent (guardian)-foster child problem^^23^951
 ;;V61.42^Substance abuse-family^Substance abuse in family^^23^951
 ;;V72.60^Laboratory exam unspec^Laboratory examination, unspecified^^23^951
 ;;V72.61^Antibody response exam^Antibody response examination^^23^951
 ;;V72.62^Lab exam routine med exam^Laboratory examination ordered as part of a routine general medical examination^^23^951
 ;;V72.63^Pre-procedure lab exam^Pre-procedural laboratory examination^^23^951
 ;;V72.69^Oth Laboratory exam^Other laboratory examination^^23^951
 ;;V80.01^Screen-traumtc brain inj^Special screening for traumatic brain injury^^23^951
 ;;V80.09^Screen oth neuro condition^Special screening for other neurological conditions^^23^951
 ;;V87.32^Contact/exp algae bloom^Contact with and (suspected) exposure to algae bloom^^23^951
 ;;V87.43^Hx estrogen therapy^Personal history of estrogen therapy^^23^949,950
 ;;V87.44^Hx inhaled steroid thrpy^Personal history of inhaled steroid therapy^^23^949,950
 ;;V87.45^Hx systemc steroid thrpy^Personal history of systemic steroid therapy^^23^949,950
 ;;V87.46^Hx immunosuppres thrpy^Personal history of immunosuppressive therapy^^23^949,950
 ;;END
ICD9NEW2 ;
 ;;END
ICD9PREV ;;ICD OPERATION/PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#80.12)-DRG(#80.12,1-6) (Multiple MDCs/DRGs separated by "~")
 ;;00.56^Ins/rep impl sensor lead^Insertion or replacement of implantable pressure sensor (lead) for intracardiac or great vessel hemodynamic monitoring^^5-260,261,262,264
 ;;00.57^Imp/rep subcu device^Implantation or replacement of subcutaneous device for intracardiac or great vessel hemodynamic monitoring^^5-258,259
 ;;33.71^Endo ins/re bron val,one^Endoscopic insertion or replacement of bronchial valve(s), single lobe
 ;;39.72^Endovs embo head/nck ves^Endovascular embolization or occlusion of head and neck vessels^^1-20,21,22,23,24,25~5-237,238~11-673,674,675~21-907,908,909~24-957,958,959
 ;;39.79^Oth endo proc oth vessel^Other endovascular procedures on other vessels^^1-20,21,22,23,24,25~5-237,238~11-673,674,675~21-907,908,909~24-957,958,959
 ;;39.90^Ins NDE perp vess stent^Insertion of non-drug-eluting peripheral (non-coronary) vessel stent(s)
 ;;80.00^Arth/pros rem wo rep uns^Arthrotomy for removal of prosthesis without replacement, unspecified site^^8-495,496,497~21-907,908,909~24-957,958,959
 ;;80.01^Arth/pros rem wo re-shld^Arthrotomy for removal of prosthesis without replacement, shoulder^^8-495,496,497~21-907,908,909~24-957,958,959
 ;;80.02^Arth/pros rem wo rep-elb^Arthrotomy for removal of prosthesis without replacement, elbow^^8-495,496,497~21-907,908,909~24-957,958,959
 ;;80.03^Arth/pros rem wo re-wrst^Arthrotomy for removal of prosthesis without replacement, wrist^^8-495,496,497~21-906~24-957,958,959
 ;;80.04^Arth/pros rem wo rep-hnd^Arthrotomy for removal of prosthesis without replacement, hand and finger^^8-495,496,497~21-906~24-957,958,959
 ;;80.05^Arth/pros rem wo rep-hip^Arthrotomy for removal of prosthesis without replacement, hip^^8-463,464,465~21-907,908,909~24-956
 ;;80.06^Arth/pros rem wo re-knee^Arthrotomy for removal of prosthesis without replacement, knee^^8-463,464,465~21-907,908,909~24-957,958,959
 ;;80.07^Arth/pros rem wo rep-ank^Arthrotomy for removal of prosthesis without replacement, ankle^^8-495,496,497~21-907,908,909~24-957,958,959
 ;;80.08^Arth/pros rem wo re-foot^Arthrotomy for removal of prosthesis without replacement, foot and toe^^8-495,496,497~21-907,908,909~24-957,958,959
 ;;80.09^Arth/pros rem wo rep oth^Arthrotomy for removal of prosthesis without replacement, other specified sites^^8-495,496,497~21-907,908,909~24-957,958,959
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
