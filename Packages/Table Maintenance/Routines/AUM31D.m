AUM31D ;IHS/ASDST/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2003 ; [ 01/29/2002   4:01 PM ]
 ;;03.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
ICD9PNEW ;;ICD OPERATION/PROCEDURE, NEW PROCEDURE CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^Use with Sex(#9.5)^MDC(#80.12)-DRG(#80.12,1-6) (multiples are separated by "~"
 ;;00.01^ULTRASOUND VESSELS HEAD/NECK^Therapeutic ultrasound of vessels of head and neck^^
 ;;00.02^THERAPEU ULTRASOUND HEART^Therapeutic ultrasound of heart^^
 ;;00.03^ULTRASOUND PERI VASCU VESSELS^Therapeutic ultrasound of peripheral vascular vessels^^
 ;;00.09^OTH THERAPEUTIC ULTRASOUND^Other therapeutic ultrasound^^
 ;;00.10^IMPLANTATION CHEMOTHERA AGT^Implantation of chemotherapeutic agent^^
 ;;00.11^INFUSION DROTRECOGIN ALFA^Infusion of drotrecogin alfa (activated)^^
 ;;00.12^ADMIN INHALED NITRIC OXIDE^Administration of inhaled nitric oxide^^
 ;;00.13^INJECTION/INFUSION NESIRITIDE^Injection or infusion of nesiritide^^
 ;;00.14^INJ/INFUS OXAZOLIDIN ANTIBIO^Injection or infusion of oxazolidinone class of antibiotics^^
 ;;00.50^IMPLANT PACEMAK W/O DEFIBRIL^Implantation of cardiac resynchronization pacemaker without mention of  defibrillation, total system^^5-115,116
 ;;00.51^IMPLANT CARDI RESYNCH DEFIB^Implantation of cardiac resynchronization defibrillation, total system^^5
 ;;00.52^IMPLANT TRANSVENOUS CORON^Implantation or replacement of transvenous lead (electrode) into left ventricular coronary venous system^^5-115,116
 ;;00.53^IMPLANT CARDI PULSE GENER^Implantation or replacement of cardiac resynchronization pacemaker pulse generator only^^5-115,116,118
 ;;00.54^IMPLANT CARDI DEFIBR PULSE^Implantation or replacement of cardiac resynchronization defibrillator pulse^^5-115
 ;;00.55^INSERT DRUG-ELUT NON-CORO^Insertion of drug-eluting non-coronary artery stent(s)^^
 ;;36.07^INSERT DRUG-ELUT CORO^Insertion of drug-eluting coronary artery stents(s)^^5
 ;;39.72^ENDOVAS REPAIR HEAD/NECK^Endovascular repair or occlusion of head and neck vessels^^1-1,2,3~5-110,111~11-315~21-442,443~24-486
 ;;49.75^IMPLANT ARTIF ANAL SPINCHCT^Implantation or revision of artificial anal sphincter^^6-157,158~9-267~21-442,443~24-486
 ;;49.76^REMOV ARTIF ANAL SPINCHCT^Removal of artificial anal sphincter^^6-157,158~9-267~21-442,443~24-486
 ;;81.61^360 DEGREE SPINAL FUSION^360 degree spinal fusion single incision approach^^1-4~8-496~21-442,443~24-486
 ;;84.51^INSERT INTER SPINAL FUSION DEV^Insertion of interbody spinal fusion device^^
 ;;84.52^INSERT BONE MORPHOGEN PROTEIN^Insertion of recombinant bone morphogenetic protein^^
 ;;88.96^INTRAOPER MAGNETIC IMAGING^Other intraoperative magnetic resonance imaging^^
 ;;89.60^CONT ART BLOOD GAS MONITOR^Continuous intra-arterial blood gas monitoring^^
 ;;99.76^EXTRACORP IMMUNOADSORPT^Extracorporeal immunoadsorption^^
 ;;99.77^ADMIN ADHESION BARRIER SUBST^Application or administration of an adhesion barrier substance^^
 ;;END
 ;
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
 ;
