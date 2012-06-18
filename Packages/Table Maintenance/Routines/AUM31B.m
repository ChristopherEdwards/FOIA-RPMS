AUM31B ;IHS/ASDST/DMJ,SDR,GTH - ICD 9 E CODES FOR FY 2003 ; [ 09/11/2002  1:46 PM ]
 ;;03.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
ICD9ENEW ;;ICD 9, NEW/REVISED E-CODES: CODE NUMBER(#.01)^DIAGNOSIS(#3)^DESCRIPTION(#10)^Use only with sex(#9.5)
 ;;E885.0^FALL (NONMOTORIZED) SCOOTER^FALL FROM (NONMOTORIZED) SCOOTER^^
 ;;E922.5^ACCIDENTAL INJ PAINTBALL GUN^Accidental injury caused by paintball gun^
 ;;E955.7^SUICIDE/SELF-INFLIC PAINTBALL^Suicide/self-inflicted injury caused by paintball gun^
 ;;E979.0^TERRORISM EXPLOSION WEAPONS^Terrorism involving explosion of marine weapons^
 ;;E979.1^TERRORISM DESTRUCT AIRCRAFT^Terrorism involving destruction of aircraft^
 ;;E979.2^TERRORISM OTHER EXPLOSIONS^Terrorism involving other explosions and fragments^
 ;;E979.3^TERRORISM FIRES, CONFLAG, SUBS^Terrorism involving fires, conflagration and hot substances^
 ;;E979.4^TERRORISM INVOLVING FIREARMS^Terrorism involving firearms^
 ;;E979.5^TERRORISM NUCLEAR WEAPONS^Terrorism involving nuclear weapons^
 ;;E979.6^TERRORISM BIOLOGICAL WEAPONS^Terrorism involving biological weapons^
 ;;E979.7^TERRORISM CHEMICAL WEAPONS^Terrorism involving chemical weapons^
 ;;E979.8^TERRORISM OTHER MEANS^Terrorism involving other means^
 ;;E979.9^TERRORISM SECONDARY EFFECTS^Terrorism, secondary effects^
 ;;E985.6^INJURY AIR GUN UNDETER^Injury by firearms, air gun, and explosives, undetermined whether accidentally or purposely inflicted- BB gun, Pellet gun^
 ;;E985.7^INJURY PAINTBALL GUN UNDETER^Injury caused by paintball gun, undetermined whether accidentally or purposely inflicted^
 ;;E999.0^LATE EFFECT INJ WAR OPERATION^Late effect of injury due to war operations^
 ;;E999.1^LATE EFFECT INJURY TERRORISM^Late effect of injury due to terrorism^
 ;;END
ICD9PREV ;;ICD OPERATION/PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^OPERATION/PROCEDURE(#4)^DESCRIPTION(#10)^MDC(#80.12)-DRG(#80.12,1-6) (Multiple MDCs/DRGs separated by "~")
 ;;02.41^IRRIG/EXPLORATION VENTRI SHUNT^Irrigation and exploration of ventricular shunt^^
 ;;36.06^INSERT NON-DRUG  CORO STENTS^Insertion of non-drug-eluting coronary artery stents(s)^^5
 ;;39.79^OTH ENDOVAS REPAIR ANEURY VES^Other endovascular repair of aneurysm of other vessels^^5-110,111~11-315~21-442,443~24-486
 ;;39.90^INSERT NON-DRUG  NON-CORO STEN^Insertion of non-drug-eluting non-coronary artery stents(s)^^^
 ;;END
PRNT ;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
 ;
