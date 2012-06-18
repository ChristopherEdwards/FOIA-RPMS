AUM81DRG ;IHS/ASDST/DMJ,SDR,GTH - MS-DRGS FOR FY 2008 ; [ 08/18/2003   4:01 PM ]
 ;;8.1;TABLE MAINTENANCE;**2**;SEP 17,2007
 ;
DRGS ;EP
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI),";;",2) Q:AUMLN="END"  D PROCESS
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI^AUM81DR2),";;",2) Q:AUMLN="END"  D PROCESS
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI^AUM81DR3),";;",2) Q:AUMLN="END"  D PROCESS
 F AUMI=1:1 S AUMLN=$P($T(DRG+AUMI^AUM81DR4),";;",2) Q:AUMLN="END"  D PROCESS
 Q
PROCESS ;
 S Y=$$IXDIC^AUM81("^ICD(","ILX","B","DRG"_$P(AUMLN,U),80.2,$P(AUMLN,U))
 I Y=-1 Q
 S DA=+Y
 S DR=".01///DRG"_$P(AUMLN,U)       ;title
 S DR=DR_";.06///"_$S($P(AUMLN,U,3)=1:$P(AUMLN,U,3),1:"/@")   ;surgery?
 S DR=DR_";5///"_$P(AUMLN,U,2)     ;MDC
 S DIE="^ICD("
 S AUMDA=DA
 D DIE^AUM81
 K ^ICD(AUMDA,1)  ;remove any existing desc.
 S DA(1)=AUMDA
 S DIC(0)="LOX"
 S X=1
 S DIC("P")=$P(^DD(80.2,1,0),"^",2)
 S DIC="^ICD("_DA(1)_",1,"
 S DIC("DR")=".01///"_$$UPC($P(AUMLN,U,4))  ;description
 D ^DIC
 I Y=-1 D RSLT^AUM81("ERROR:  Addition of DRG '"_$P(AUMLN,U,1)_"' FAILED.") Q
 D RSLT^AUM81($J("",8)_$P(^ICD(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD(AUMDA,1,1,0),U),1,60))
 Q
UPC(X) ;UPPER CASE
 N Y
 S Y=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q Y
DRG ;;DRG^MDC^SURGERY?^DRG TITLE
 ;;1^^1^Heart transplant or implant of heart assist system w MCC
 ;;2^^1^Heart transplant or implant of heart assist system w/o MCC
 ;;3^^1^ECMO or trach w MV 96+ hrs or PDX exc face, mouth & neck w maj O.R.
 ;;4^^1^Trach w MV 96+ hrs or PDX exc face, mouth & neck w/o maj O.R.
 ;;5^^1^Liver transplant w MCC or intestinal transplant
 ;;6^^1^Liver transplant w/o MCC
 ;;7^^1^Lung transplant
 ;;8^^1^Simultaneous pancreas/kidney transplant
 ;;9^^1^Bone marrow transplant
 ;;10^^1^Pancreas transplant
 ;;11^^1^Tracheostomy for face,mouth & neck diagnoses w MCC
 ;;12^^1^Tracheostomy for face,mouth & neck diagnoses w CC
 ;;13^^1^Tracheostomy for face,mouth & neck diagnoses w/o CC/MCC
 ;;20^1^1^Intracranial vascular procedures w PDX hemorrhage w MCC
 ;;21^1^1^Intracranial vascular procedures w PDX hemorrhage w CC
 ;;22^1^1^Intracranial vascular procedures w PDX hemorrhage w/o CC/MCC
 ;;23^1^1^Cranio w major dev impl/acute complex CNS PDX w MCC or chemo implant
 ;;24^1^1^Cranio w major dev impl/acute complex CNS PDX w/o MCC
 ;;25^1^1^Craniotomy & endovascular intracranial procedures w MCC
 ;;26^1^1^Craniotomy & endovascular intracranial procedures w CC
 ;;27^1^1^Craniotomy & endovascular intracranial procedures w/o CC/MCC
 ;;28^1^1^Spinal procedures w MCC
 ;;29^1^1^Spinal procedures w CC or spinal neurostimulators
 ;;30^1^1^Spinal procedures w/o CC/MCC
 ;;31^1^1^Ventricular shunt procedures w MCC
 ;;32^1^1^Ventricular shunt procedures w CC
 ;;33^1^1^Ventricular shunt procedures w/o CC/MCC
 ;;34^1^1^Carotid artery stent procedure w MCC
 ;;35^1^1^Carotid artery stent procedure w CC
 ;;36^1^1^Carotid artery stent procedure w/o CC/MCC
 ;;37^1^1^Extracranial procedures w MCC
 ;;38^1^1^Extracranial procedures w CC
 ;;39^1^1^Extracranial procedures w/o CC/MCC
 ;;40^1^1^Periph/cranial nerve & other nerv syst proc w MCC
 ;;41^1^1^Periph/cranial nerve & other nerv syst proc w CC or periph neurostim
 ;;42^1^1^Periph/cranial nerve & other nerv syst proc w/o CC/MCC
 ;;52^1^^Spinal disorders & injuries w CC/MCC
 ;;53^1^^Spinal disorders & injuries w/o CC/MCC
 ;;54^1^^Nervous system neoplasms w MCC
 ;;55^1^^Nervous system neoplasms w/o MCC
 ;;56^1^^Degenerative nervous system disorders w MCC
 ;;57^1^^Degenerative nervous system disorders w/o MCC
 ;;58^1^^Multiple sclerosis & cerebellar ataxia w MCC
 ;;59^1^^Multiple sclerosis & cerebellar ataxia w CC
 ;;60^1^^Multiple sclerosis & cerebellar ataxia w/o MCC/CC
 ;;61^1^^Acute ischemic stroke w use of thrombolytic agent w MCC
 ;;62^1^^Acute ischemic stroke w use of thrombolytic agent w CC
 ;;63^1^^Acute ischemic stroke w use of thrombolytic agent w/o CC/MCC
 ;;64^1^^Intracranial hemorrhage or cerebral infarction w MCC
 ;;65^1^^Intracranial hemorrhage or cerebral infarction w CC
 ;;66^1^^Intracranial hemorrhage or cerebral infarction w/o CC/MCC
 ;;67^1^^Nonspecific cva & precerebral occlusion w/o infarct w MCC
 ;;68^1^^Nonspecific cva & precerebral occlusion w/o infarct w/o MCC
 ;;69^1^^Transient ischemia
 ;;70^1^^Nonspecific cerebrovascular disorders w MCC
 ;;71^1^^Nonspecific cerebrovascular disorders w CC
 ;;72^1^^Nonspecific cerebrovascular disorders w/o CC/MCC
 ;;73^1^^Cranial & peripheral nerve disorders w MCC
 ;;74^1^^Cranial & peripheral nerve disorders w/o MCC
 ;;75^1^^Viral meningitis w CC/MCC
 ;;76^1^^Viral meningitis w/o CC/MCC
 ;;77^1^^Hypertensive encephalopathy w MCC
 ;;78^1^^Hypertensive encephalopathy w CC
 ;;79^1^^Hypertensive encephalopathy w/o CC/MCC
 ;;80^1^^Nontraumatic stupor & coma w MCC
 ;;81^1^^Nontraumatic stupor & coma w/o MCC
 ;;82^1^^Traumatic stupor & coma, coma >= 1 hr w MCC
 ;;83^1^^Traumatic stupor & coma, coma >= 1 hr w CC
 ;;84^1^^Traumatic stupor & coma, coma >= 1 hr w/o CC/MCC
 ;;85^1^^Traumatic stupor & coma, coma < 1 hr w MCC
 ;;86^1^^Traumatic stupor & coma, coma < 1 hr w CC
 ;;87^1^^Traumatic stupor & coma, coma <1 hr w/o CC/MCC
 ;;88^1^^Concussion w MCC
 ;;89^1^^Concussion w CC
 ;;90^1^^Concussion w/o CC/MCC
 ;;91^1^^Other disorders of nervous system w MCC
 ;;92^1^^Other disorders of nervous system w CC
 ;;93^1^^Other disorders of nervous system w/o CC/MCC
 ;;94^1^^Bacterial & tuberculous infections of nervous system w MCC
 ;;95^1^^Bacterial & tuberculous infections of nervous system w CC
 ;;96^1^^Bacterial & tuberculous infections of nervous system w/o CC/MCC
 ;;97^1^^Non-bacterial infect of nervous sys exc viral meningitis w MCC
 ;;98^1^^Non-bacterial infect of nervous sys exc viral meningitis w CC
 ;;99^1^^Non-bacterial infect of nervous sys exc viral meningitis w/o CC/MCC
 ;;100^1^^Seizures w MCC
 ;;101^1^^Seizures w/o MCC
 ;;102^1^^Headaches w MCC
 ;;103^1^^Headaches w/o MCC
 ;;113^2^1^Orbital procedures w CC/MCC
 ;;114^2^1^Orbital procedures w/o CC/MCC
 ;;115^2^1^Extraocular procedures except orbit
 ;;116^2^1^Intraocular procedures w CC/MCC
 ;;117^2^1^Intraocular procedures w/o CC/MCC
 ;;121^2^^Acute major eye infections w CC/MCC
 ;;122^2^^Acute major eye infections w/o CC/MCC
 ;;123^2^^Neurological eye disorders
 ;;124^2^^Other disorders of the eye w MCC
 ;;125^2^^Other disorders of the eye w/o MCC
 ;;129^3^1^Major head & neck procedures w CC/MCC or major device
 ;;130^3^1^Major head & neck procedures w/o CC/MCC
 ;;131^3^1^Cranial/facial procedures w CC/MCC
 ;;132^3^1^Cranial/facial procedures w/o CC/MCC
 ;;133^3^1^Other ear, nose, mouth, & throat O.R. procedures w CC/MCC
 ;;134^3^1^Other ear, nose, mouth, & throat O.R. procedures w/o CC/MCC
 ;;135^3^1^Sinus & mastoid procedures w CC/MCC
 ;;136^3^1^Sinus & mastoid procedures w/o CC/MCC
 ;;137^3^1^Mouth procedures w CC/MCC
 ;;138^3^1^Mouth procedures w/o CC/MCC
 ;;139^3^1^Salivary gland procedures
 ;;146^3^^Ear, nose, mouth, & throat malignancy w MCC
 ;;147^3^^Ear, nose, mouth, & throat malignancy w CC
 ;;148^3^^Ear, nose, mouth, & throat malignancy w/o CC/MCC
 ;;149^3^^Disequillibrium
 ;;150^3^^Epistaxis w MCC
 ;;151^3^^Epistaxis w/o MCC
 ;;152^3^^Otitis media & URI w MCC
 ;;153^3^^Otitis media & URI w/o MCC
 ;;154^3^^Nasal trauma & deformity w MCC
 ;;155^3^^Nasal trauma & deformity w CC
 ;;156^3^^Nasal trauma & deformity w/o CC/MCC
 ;;157^3^^Dental & oral diseases w MCC
 ;;158^3^^Dental & oral diseases w CC
 ;;159^3^^Dental & oral diseases w/o CC/MCC
 ;;163^4^1^Major chest procedures w MCC
 ;;164^4^1^Major chest procedures w CC
 ;;165^4^1^Major chest procedures w/o CC/MCC
 ;;166^4^1^Other resp system O.R. procedures w MCC
 ;;167^4^1^Other resp system O.R. procedures w CC
 ;;168^4^1^Other resp system O.R. procedures w/o CC/MCC
 ;;175^4^^Pulmonary embolism w MCC
 ;;176^4^^Pulmonary embolism w/o MCC
 ;;177^4^^Respiratory infections & inflammations w MCC
 ;;178^4^^Respiratory infections & inflammations w CC
 ;;179^4^^Respiratory infections & inflammations w/o CC/MCC
 ;;180^4^^Respiratory neoplasms w MCC
 ;;181^4^^Respiratory neoplasms w CC
 ;;182^4^^Respiratory neoplasms w/o CC/MCC
 ;;183^4^^Major chest trauma w MCC
 ;;184^4^^Major chest trauma w CC
 ;;185^4^^Major chest trauma w/o CC/MCC
 ;;186^4^^Pleural effusion w MCC
 ;;187^4^^Pleural effusion w CC
 ;;188^4^^Pleural effusion w/o CC/MCC
 ;;189^4^^Pulmonary edema & respiratory failure
 ;;190^4^^Chronic obstructive pulmonary disease w MCC
 ;;191^4^^Chronic obstructive pulmonary disease w CC
 ;;192^4^^Chronic obstructive pulmonary disease w/o CC/MCC
 ;;193^4^^Simple pneumonia & pleurisy w MCC
 ;;194^4^^Simple pneumonia & pleurisy w CC
 ;;195^4^^Simple pneumonia & pleurisy w/o CC/MCC
 ;;196^4^^Interstitial lung disease w MCC
 ;;197^4^^Interstitial lung disease w CC
 ;;198^4^^Interstitial lung disease w/o CC/MCC
 ;;199^4^^Pneumothorax w MCC
 ;;200^4^^Pneumothorax w CC
 ;;201^4^^Pneumothorax w/o CC/MCC
 ;;202^4^^Bronchitis & asthma w CC/MCC
 ;;203^4^^Bronchitis & asthma w/o CC/MCC
 ;;204^4^^Respiratory signs & symptoms
 ;;205^4^^Other respiratory system diagnoses w MCC
 ;;206^4^^Other respiratory system diagnoses w/o MCC
 ;;207^4^^Respiratory system diagnosis w ventilator support 96+ hours
 ;;208^4^^Respiratory system diagnosis w ventilator support 96 hours
 ;;215^5^1^Other heart assist system implant
 ;;216^5^1^Cardiac valve & oth maj cardiothoracic proc w card cath w MCC
 ;;217^5^1^Cardiac valve & oth maj cardiothoracic proc w card cath w CC
 ;;218^5^1^Cardiac valve & oth maj cardiothoracic proc w card cath w/o CC/MCC
 ;;219^5^1^Cardiac valve & oth maj cardiothoracic proc w/o card cath w MCC
 ;;220^5^1^Cardiac valve & oth maj cardiothoracic proc w/o card cath w CC
 ;;221^5^1^Cardiac valve & oth maj cardiothoracic proc w/o card cath w/o CC/MCC
 ;;222^5^1^Cardiac defib implant w cardiac cath w AMI/HF/shock w MCC
 ;;223^5^1^Cardiac defib implant w cardiac cath w AMI/HF/shock w/o MCC
 ;;224^5^1^Cardiac defib implant w cardiac cath w/o AMI/HF/shock w MCC
 ;;225^5^1^Cardiac defib implant w cardiac cath w/o AMI/HF/shock w/o MCC
 ;;226^5^1^Cardiac defibrillator implant w/o cardiac cath w MCC
 ;;227^5^1^Cardiac defibrillator implant w/o cardiac cath w/o MCC
 ;;228^5^1^Other cardiothoracic procedures w MCC
 ;;229^5^1^Other cardiothoracic procedures w CC
 ;;230^5^1^Other cardiothoracic procedures w/o CC/MCC
 ;;231^5^1^Coronary bypass w PTCA w MCC
 ;;232^5^1^Coronary bypass w PTCA w/o MCC
 ;;233^5^1^Coronary bypass w cardiac cath w MCC
 ;;234^5^1^Coronary bypass w cardiac cath w/o MCC
 ;;235^5^1^Coronary bypass w/o cardiac cath w MCC
 ;;236^5^1^Coronary bypass w/o cardiac cath w/o MCC
 ;;237^5^1^Major cardiovasc procedures w MCC or thoracic aortic anuerysm repair
 ;;238^5^1^Major cardiovasc procedures w/o MCC
 ;;239^5^1^Amputation for circ sys disorders exc upper limb & toe w MCC
 ;;240^5^1^Amputation for circ sys disorders exc upper limb & toe w CC
 ;;241^5^1^Amputation for circ sys disorders exc upper limb & toe w/o CC/MCC
 ;;242^5^1^Permanent cardiac pacemaker implant w MCC
 ;;243^5^1^Permanent cardiac pacemaker implant w CC
 ;;244^5^1^Permanent cardiac pacemaker implant w/o CC/MCC
 ;;245^5^1^AICD lead & generator procedures
 ;;246^5^1^Perc cardiovasc proc w drug-eluting stent w MCC or 4+ vessels/stents
 ;;247^5^1^Perc cardiovasc proc w drug-eluting stent w/o MCC
 ;;248^5^1^Perc cardiovasc proc w non-drug-eluting stent w MCC or 4+ ves/stents
 ;;249^5^1^Perc cardiovasc proc w non-drug-eluting stent w/o MCC
 ;;250^5^1^Perc cardiovasc proc w/o coronary artery stent or AMI w MCC
 ;;251^5^1^Perc cardiovasc proc w/o coronary artery stent or AMI w/o MCC
 ;;252^5^1^Other vascular procedures w MCC
 ;;253^5^1^Other vascular procedures w CC
 ;;254^5^1^Other vascular procedures w/o CC/MCC
 ;;255^5^1^Upper limb & toe amputation for circ system disorders w MCC
 ;;256^5^1^Upper limb & toe amputation for circ system disorders w CC
 ;;257^5^1^Upper limb & toe amputation for circ system disorders w/o CC/MCC
 ;;258^5^1^Cardiac pacemaker device replacement w MCC
 ;;259^5^1^Cardiac pacemaker device replacement w/o MCC
 ;;260^5^1^Cardiac pacemaker revision except device replacement w MCC
 ;;261^5^1^Cardiac pacemaker revision except device replacement w CC
 ;;262^5^1^Cardiac pacemaker revision except device replacement w/o CC/MCC
 ;;263^5^1^Vein ligation & stripping
 ;;264^5^1^Other circulatory system O.R. procedures
 ;;280^5^^Acute myocardial infarction, discharged alive w MCC
 ;;281^5^^Acute myocardial infarction, discharged alive w CC
 ;;282^5^^Acute myocardial infarction, discharged alive w/o CC/MCC
 ;;283^5^^Acute myocardial infarction, expired w MCC
 ;;284^5^^Acute myocardial infarction, expired w CC
 ;;285^5^^Acute myocardial infarction, expired w/o CC/MCC
 ;;286^5^^Circulatory disorders except AMI, w card cath w MCC
 ;;287^5^^Circulatory disorders except AMI, w card cath w/o MCC
 ;;288^5^^Acute & subacute endocarditis w MCC
 ;;289^5^^Acute & subacute endocarditis w CC
 ;;290^5^^Acute & subacute endocarditis w/o CC/MCC
 ;;291^5^^Heart failure & shock w MCC
 ;;292^5^^Heart failure & shock w CC
 ;;293^5^^Heart failure & shock w/o CC/MCC
 ;;294^5^^Deep vein thrombophlebitis w CC/MCC
 ;;295^5^^Deep vein thrombophlebitis w/o CC/MCC
 ;;296^5^^Cardiac arrest, unexplained w MCC
 ;;297^5^^Cardiac arrest, unexplained w CC
 ;;298^5^^Cardiac arrest, unexplained w/o CC/MCC
 ;;299^5^^Peripheral vascular disorders w MCC
 ;;300^5^^Peripheral vascular disorders w CC
 ;;END
 Q
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
