AUM91E ;IHS/SD/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2009 ; [ 08/18/2003   4:01 PM ]
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
 ;;45.8^Total intra-abdominal colectomy^OCT 1, 2008
 ;;48.5^Abdominoperineal resection of rectum^OCT 1, 2008
 ;;53.7^Repair of diaphragmatic hernia, abdominal approach^OCT 1, 2008
 ;;END
ICD9VNEW ;;ICD 9 DIAGNOSIS, NEW V-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^USE ONLY WITH SEX(#9.5)^MDC(#5)^DRG(#60-65)
 ;;V02.53^Meth suscpt Staph aur MSSA col^Methicillin susceptible Staphylococcus aureus MSSA colonization
 ;;V02.54^Meth resist Staph aur MRSA col^Methicillin resistant Staphylococcus aureus MRSA colonization
 ;;V07.51^Proph use slct estg rectr mods^Prophylactic use of selective estrogen receptor modulators (SERMs)^^23^951
 ;;V07.52^Proph use aromatase inhibitors^Prophylactic use of aromatase inhibitors^^23^951
 ;;V07.59^Prop oth agnts aff est rec/est^Prophylactic use of other agents affecting estrogen receptors and estrogen levels^^23^951
 ;;V12.04^Meth resist Staph aureus MRSA^Methicillin resistant Staphylococcus aureus MRSA
 ;;V13.51^Pers hist,pathologic fracture^Personal history of pathologic fracture^^23^951
 ;;V13.52^Pers hist,stress fracture^Personal history of stress fracture^^23^951
 ;;V13.59^Pers hst oth muscloskel disrds^Personal history of other musculoskeletal disorders^^23^951
 ;;V15.21^Prs hst undrgo in uter pro prg^Personal history of undergoing in utero procedure during pregnancy^^23^951
 ;;V15.22^Prs hst undgo in utr prc fetus^Personal history of undergoing in utero procedure while a fetus^^23^951
 ;;V15.29^Persnl hist surg to oth orgns^Personal history of surgery to other organs^^23^951
 ;;V15.51^Persnl hist traumatic fracture^Personal history of traumatic fracture^^23^951
 ;;V15.59^Personal hist of other injury^Personal history of other injury^^23^951
 ;;V23.85^Preg reslt frm asst repro tech^Pregnancy resulting from assisted reproductive technology^F^14^998
 ;;V23.86^Prg w/hist in uter prc prv prg^Pregnancy with history of in utero procedure during previous pregnancy^F^14^998
 ;;V28.81^Encountr,fetal anatomic survey^Encounter for fetal anatomic survey^F^23^951
 ;;V28.82^Screening,risk pre-term labor^Encounter for screening for risk of pre-term labor^F^23^951
 ;;V28.89^Oth specif antenatal screening^Other specified antenatal screening^F^23^951
 ;;V45.11^Renal dialysis status^Renal dialysis status^^23^951
 ;;V45.12^Noncompliance w renal dialysis^Noncompliance with renal dialysis^^23^951
 ;;V45.87^Transplnted organ remvl status^Transplanted organ removal status^^23^951
 ;;V45.88^Tpa/rtPA admin,diff fac,24 hr^Status post administration of tPA (rtPA) in a different facility within the last 24 hours prior to admission to current facility
 ;;V46.3^Wheelchair dependence^Wheelchair dependence^^23^951
 ;;V51.0^Brst recon follwng mastectomy^Encounter for breast reconstruction following mastectomy^^9^606,607
 ;;V51.8^Oth aftcare invlv plastic surg^Other aftercare involving the use of plastic surgery^^9^606,607
 ;;V61.01^Fam disrupt-fam memb,mil depl^Family disruption due to family member on military deployment
 ;;V61.02^Fam disrpt-ret fam mem,mil dep^Family disruption due to return of family member from military deployment
 ;;V61.03^Fam disrupt-divorce/legal sep^Family disruption due to divorce or legal separation
 ;;V61.04^Fam disrpt-parent-child estrng^Family disruption due to parent-child estrangement
 ;;V61.05^Fam disrupt-child,welfare cust^Family disruption due to child in welfare custody
 ;;V61.06^Fam disrupt-child,foster care^Family disruption due to child in foster care or in care of non-parental family member
 ;;V61.09^Other family disruption^Other family disruption
 ;;V62.21^Pers cur militry deplymnt stat^Personal current military deployment status
 ;;V62.22^Pers hist,ret-military deploy^Personal history of return from military deployment
 ;;V62.29^Oth occ circumst or maladjust^Other occupational circumstances or maladjustment
 ;;V87.01^Cntct w/and susp exp to arsenc^Contact with and (suspected) exposure to arsenic^^23^951
 ;;V87.09^Cntct w/susp exp oth haz metls^Contact with and (suspected) exposure to other hazardous metals^^23^951
 ;;V87.11^Contact w/susp exp arom amines^Contact with and (suspected) exposure to aromatic amines^^23^951
 ;;V87.12^Contact w/susp exp to benzene^Contact with and (suspected) exposure to benzene^^23^951
 ;;V87.19^Conct w/expos oth haz aromatic^Contact with and (suspected) exposure to other hazardous aromatic compounds^^23^951
 ;;V87.2^Cnct w/expos oth haz chemicals^Contact with and (suspected) exposure to other potentially hazardous chemicals^^23^951
 ;;V87.31^Contct w/susp exposure to mold^Contact with and (suspected) exposure to mold^^23^951
 ;;V87.39^Cntct w/susp exp oth haz subst^Contact with and (suspected) exposure to other potentially hazardous substances^^23^951
 ;;V87.41^Pers hist antineoplstc chemotx^Personal history of antineoplastic chemotherapy^^23^949,950
 ;;V87.42^Personal hist monoclon drug tx^Personal history of monoclonal drug therapy^^23^949,950
 ;;V87.49^Personal hist oth drug therapy^Personal history of other drug therapy^^23^949,950
 ;;V88.01^Acq absence both cervix uterus^Acquired absence of both cervix and uterus^F^13^742,743,760,761
 ;;V88.02^Acq absnce uterus w/cerv stump^Acquired absence of uterus with remaining cervical stump^F^13^742,743,760,761
 ;;V88.03^Acq absence cervix with uterus^Acquired absence of cervix with remaining uterus^F^13^742,743,760,761
 ;;V89.01^Susp prob w/amn cav/mem not fd^Suspected problem with amniotic cavity and membrane not found^F^23^951
 ;;V89.02^Susp placen prob not found^Suspected placental problem not found^F^23^951
 ;;V89.03^Susp fetal anomaly not found^Suspected fetal anomaly not found^F^23^951
 ;;V89.04^Susp prob w/fetl grwth not fnd^Suspected problem with fetal growth not found^F^23^951
 ;;V89.05^Susp cerv shortenng not found^Suspected cervical shortening not found^F^23^951
 ;;V89.09^Oth susp mat/fet cond not fnd^Other suspected maternal and fetal condition not found^F^23^951
 ;;END
ICD9NEW2 ;
 ;;339.12^Chronic tension type headache^Chronic tension type headache^^1^102,103
 ;;339.20^Post-traumatic headache,unspec^Post-traumatic headache, unspecified^^1^102,103
 ;;339.21^Acute post-traumatic headache^Acute post-traumatic headache^^1^102,103
 ;;339.22^Chr post-traumatic headache^Chronic post-traumatic headache^^1^102,103
 ;;339.3^Drug induc headache, NEC^Drug induced headache, not elsewhere classified^^1^102,103
 ;;339.41^Hemicrania continua^Hemicrania continua^^1^102,103
 ;;339.42^New daily persistent headache^New daily persistent headache^^1^102,103
 ;;339.43^Primary thunderclap headache^Primary thunderclap headache^^1^102,103
 ;;339.44^Oth comp headache syndrome^Other complicated headache syndrome^^1^102,103
 ;;339.81^Hypnic headache^Hypnic headache^^1^102,103
 ;;339.82^Headache assoc w/sexual actvty^Headache associated with sexual activity^^1^102,103
 ;;339.83^Primary cough headache^Primary cough headache^^1^102,103
 ;;339.84^Primary exertional headache^Primary exertional headache^^1^102,103
 ;;339.85^Primary stabbing headache^Primary stabbing headache^^1^102,103
 ;;339.89^Other headache syndromes^Other headache syndromes^^1^102,103
 ;;346.02^Migraine w/aur w/o intr migrne^Migraine with aura, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.03^Migraine w/aur w/intrct migrne^Migraine with aura, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;346.12^Migrne w/o aur w/o intra mgrne^Migraine without aura, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.13^Migrne w/o aur w/intrc migrne^Migraine without aura, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;346.22^Var of migr NEC w/o intr migr^Variants of migraine, not elsewhere classified, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.23^Var of migr NEC w/intr migr^Variants of migraine, not elsewhere classified, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;346.30^Hemipl migrne w/o intr migrne^Hemiplegic migraine, without mention of intractable migraine without mention of status migrainosus^^1^102,103
 ;;346.31^Hemipl migrne w/intr migrne^Hemiplegic migraine, with intractable migraine, so stated, without mention of status migrainosus^^1^102,103
 ;;346.32^Hemipl migrne w/o intr migrne^Hemiplegic migraine, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.33^Hemipl migraine w/intr migrne^Hemiplegic migraine, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;346.40^Mens migrne w/o intrac migrne^Menstrual migraine, without mention of intractable migraine without mention of status migrainosus^F^1^102,103
 ;;346.41^Mens migraine w/intract migrne^Menstrual migraine, with intractable migraine, so stated, without mention of status migrainosus^F^1^102,103
 ;;346.42^Mens migrne w/o intrac migrne^Menstrual migraine, without mention of intractable migraine with status migrainosus^F^1^102,103
 ;;346.43^Mens migraine w/intract migrne^Menstrual migraine, with intractable migraine, so stated, with status migrainosus^F^1^102,103
 ;;346.50^Prst mig aur w/o cerbrl infrct^Persistent migraine aura without cerebral infarction, without mention of intractable migraine without mention of status migrainosus^^1^102,103
 ;;346.51^Prt mig au w/o cr inf w/intrac^Persistent migraine aura without cerebral infarction, with intractable migraine, so stated, without mention of status migrainosus^^1^102,103
 ;;346.52^Prst mig au w/o cr inf w/o int^Persistent migraine aura without cerebral infarction, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.53^Prst mig aur w/o cer inf w/int^Persistent migraine aura without cerebral infarction, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;346.60^Prst mig au w/cr inf w/o intra^Persistent migraine aura with cerebral infarction, without mention of intractable migraine without mention of status migrainosus^^1^102,103
 ;;346.61^Prst migr aura w/cer inf w/int^Persistent migraine aura with cerebral infarction, with intractable migraine, so stated, without mention of status migrainosus^^1^102,103
 ;;346.62^Prst mig au w/cer inf w/o intr^Persistent migraine aura with cerebral infarction, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.63^Persist migr aura w/cer infrct^Persistent migraine aura with cerebral infarction, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;346.70^Chr migrne w/o aura/intra mig^Chronic migraine without aura, without mention of intractable migraine without mention of status migrainosus^^1^102,103
 ;;346.71^Chr migrne w/o aura w/intr mig^Chronic migraine without aura, with intractable migraine, so stated, without mention of status migrainosus^^1^102,103
 ;;346.72^Chr mgrne w/o aura/intra migrn^Chronic migraine without aura, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.73^Chr migrne w/o aura/intra mig^Chronic migraine without aura, with intractable migraine, so stated, with status migrainosus
 ;;346.82^Oth frms migrne w/o intr migra^Other forms of migraine, without mention of intractable migraine with status migrainosus^^1^102,103
 ;;346.83^Oth frms migrne w/intr migrne^Other forms of migraine, with intractable migraine, so stated, with status migrainosus^^1^102,103
 ;;349.31^Acc punct/Lacer-dura dur proc^Accidental puncture or laceration of dura during a procedure
 ;;349.39^Other dural tear^Other dural tear
 ;;346.92^Migraine,unsp w/o intra migrne^Migraine, unspecified, without mention of intractable migraine with status migrainosus
 ;;346.93^Migraine,unsp w intract migrne^Migraine, unspecified, with intractable migraine, so stated, with status migrainosus
 ;;362.20^Retinopthy,prematurty,unspec^Retinopathy of prematurity, unspecified^^2^124,125
 ;;362.22^Retinopthy,prematurty,stage 0^Retinopathy of prematurity, stage 0^^2^124,125
 ;;362.23^Retinopthy,prematurity,stage 1^Retinopathy of prematurity, stage 1^^2^124,125
 ;;362.24^Retinopthy,prematurity,stage 2^Retinopathy of prematurity, stage 2^^2^124,125
 ;;362.25^Retinopthy,prematurity,stage 3^Retinopathy of prematurity, stage 3^^2^124,125
 ;;362.26^Retinopthy,prematurity,stage 4^Retinopathy of prematurity, stage 4^^2^124,125
 ;;362.27^Retinopthy,prematurity,stage 5^Retinopathy of prematurity, stage 5^^2^124,125
 ;;364.82^Plateau iris syndrome^Plateau iris syndrome^^2^124,125
 ;;372.34^Pingueculitis^Pingueculitis^^2^124,125
 ;;414.3^Cor ather due lipid rich plaq^Coronary atherosclerosis due to lipid rich plaque^^5^302,303
 ;;482.42^Meth resist pneum-Staph aureus^Methicillin resistant pneumonia due to Staphylococcus aureus
 ;;511.81^Malignant pleural effusion^Malignant pleural effusion^^4^180,181,182
 ;;511.89^Oth spec forms effsion excptTB^Other specified forms of effusion, except tuberculous^^4^186,187,188
 ;;530.13^Eosinophilic esophagitis^Eosinophilic esophagitis
 ;;535.70^Eosino gastritis, w/o hemorr^Eosinophilic gastritis, without mention of hemorrhage
 ;;535.71^Eosinophilic gastritis,hemorr^Eosinophilic gastritis, hemorrhage
 ;;558.41^Eosinophilic gastroenteritis^Eosinophilic gastroenteritis
 ;;558.42^Eosinophilic colitis^Eosinophilic colitis
 ;;569.44^Dysplasia of anus^Dysplasia of anus^^6^393,394,395
 ;;571.42^Autoimmune hepatitis^Autoimmune hepatitis^^7^441,442,443
 ;;599.70^Hematuria, unspecified^Hematuria, unspecified^^11^695,696
 ;;599.71^Gross hematuria^Gross hematuria^^11^695,696
 ;;599.72^Microscopic hematuria^Microscopic hematuria^^11^695,696
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
