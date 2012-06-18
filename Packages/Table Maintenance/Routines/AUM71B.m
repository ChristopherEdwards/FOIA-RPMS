AUM71B ; IHS/ASDST/DMJ,SDR - ICD 9 E CODES FOR FY 2007 ; [ 09/21/2004  10:27 AM ]
 ;;07.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
ICD9ENEW ;;ICD 9, NEW/REVISED E-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^Use only with sex(#9.5)
 ;;END
ICD9PREV ;;ICD OPERATION/PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^MDC(#80.12)-DRG(#80.12,1-6) (Multiple MDCs/DRGs separated by "~")
 ;;01.26^Ins cathtr cranial cav tissue^Insertion of catheter(s) into cranial cavity or tissue
 ;;01.27^Remv cathtr cranial cav tissue^Removal of catheter(s) from cranial cavity or tissue
 ;;35.53^Rpr vent sptl def prosth open^Repair of ventricular septal defect with prosthesis, open technique^^5-108
 ;;37.26^Cath based invsv ectrphys tstg^Catheter based invasive electrophysiologic testing^^5-104,518,555,556,557,558
 ;;68.39^Othr unspec sbttl abd hystrtmy^Other and unspecified subtotal abdominal hysterectomy^^13-354,355,357,358,359~14-375
 ;;68.59^Othr unspec vag hystrtmy^Other and unspecified vaginal hysterectomy^^13-354,355,357,358,359~14-375
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
