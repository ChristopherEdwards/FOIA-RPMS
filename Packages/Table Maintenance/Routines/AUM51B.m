AUM51B ; IHS/SD/SDR - New routine created in Serenji at 8/13/2004 9:19:42 AM
 ;;05.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
ICD9ENEW ;;ICD 9, NEW/REVISED E-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^Use only with sex(#9.5)
 ;;END
ICD9PREV ;;ICD OPERATION/PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^MDC(#80.12)-DRG(#80.12,1-6) (Multiple MDCs/DRGs separated by "~")
 ;;00.55^Inst drug-elut per vessl stent^Insertion of drug-eluting peripheral vessel stent(s)
 ;;01.22^Rem intracran neurostimul lead^Removal of intracranial neurostimulator lead(s)^^1-1,2,3~17-406,407,539,540
 ;;02.93^Imp/repl intracran neurostimul^Implantation or replacement of intracranial neurostimulator leads(s)^^1-1,2,3~17-406,407,539,540~21-442,443~24-486
 ;;03.93^Imp/repl spinal neurostimul^Implantation or replacement of spinal neurostimulator leads(s)^^1-531,532~8-499,500~11-315~12-344,345~13-365~17-406,407,539,540~21-442,443~24-486
 ;;03.94^Remove spinal neurostimul lead^Removal of spinal neurostimulator leads(s)^^1-531,532~8-499,500~11-315~12-344,345~13-365~21-442,443~24-486
 ;;04.92^Imp/repl periph neurostim lead^Implantation or replacement of peripheral neurostimulator lead(s)^^1-7,8~3-63~8-233,234~11-315~12-344,345~13-365~21-442,443~24-486
 ;;04.93^Remove periph neurostim lead^Removal of peripheral neurostimulator lead(s)^^1-7,8~3-63~8-233,234~11-315~12-344,345~13-365~21-442,443~24-486
 ;;36.11^Aorto/cornon byp 1 coron arter^(Aorto) cornonary bypass of one coronary artery^^5-106,107,109
 ;;36.12^Aorto/cornon byp 2 coron arter^(Aorto) cornonary bypass of two coronary arteries^^5-106,107,109
 ;;36.13^Aorto/cornon byp 3 coron arter^(Aorto) cornonary bypass of three coronary arteries^^5-106,107,109
 ;;36.14^Aorto/cornon byp 4+ artereries^(Aorto) cornonary bypass of four or more coronary arteries^^5-106,107,109
 ;;37.62^Insert non-implant hrt ast sys^Insertion of non-implantable heart assist system^^5-525
 ;;37.63^Repair of heart assist system^Repair of heart assist system^^5-525
 ;;37.65^Implant extl hrt assist system^Implant of external heart assist system^^5-525
 ;;37.66^Insert implant hrt assist sys^Insertion of implantable heart assist system^^5-103
 ;;39.50^Angio/ather non-coronary vessl^Angioplasty or atherectomy of other non-coronary vessel(s)^^1-533,534~4-76,77~5-478,479~6-170,171~7-201~8-233,234~9-269,270~10-292,293~11-315~21-442,443~24-486
 ;;39.90^Inst no-drug-elut periph stent^Insertion of non-drug-eluting peripheral vessel stent(s)
 ;;86.05^Remve foreign from skin/tissue^Incision with removal of foreign body of device from skin and subcutaneous tissue
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
