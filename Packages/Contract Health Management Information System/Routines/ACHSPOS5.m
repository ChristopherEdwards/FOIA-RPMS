ACHSPOS5 ; IHS/ITSC/PMF - DATA FOR MEDICAL PRIORITY FILE FORCE ENTRY ;   [ 10/19/2001  11:00 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 S $ZT="ERROR^"_$ZN
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"ENTERED")=NOW
 ;
 I $D(ACHSINST(ACHSVERS,"ERROR")) S ^ACHSINST(ACHSVERS,"ERROR","PREVIOUS ERRORS HAVE NOT BEEN CLEARED")=NOW S ERROR=1,XPDABORT=1 D START^ACHSPOSM(ERROR) Q
 ;
 ;IF FILE CHECKSOK THEN FILE HAS ENTRIES DON'T OVERWRITE
 I $$CHECKSOK("") S %H=$H D YX^%DTC S NOW=Y S ^ACHSINST(ACHSVERS,$ZN,"CHS MEDICAL PRIORITY DATA FOUND")=NOW W !?15,"'MEDICAL PRIORITY' data found! Not overwriting!" D END Q
 ;
 ;
 N A,B,C
 F A=1:2 S B=$P($T(TAG+A),";;",2) Q:B=""  S @B=$P($T(TAG+(A+1)),";;",2)
 D ENTER
 ;
END S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"FINISHED")=NOW
 ;
 Q
 ;
 ;PLACE CODE FOR FORCE ENTRY INTO ^ACHSMPRI HERE
ENTER ;
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"ENTER^"_$ZN,"ENTERED")=NOW
 ;
 W !?15,"Cannot find 'CHS MEDICAL PRIORITY' data not found....."
 W !?15,"Adding now........"
 S X="^TMP("_$J_",""MPRI"")"
 F  S X=$Q(@X) Q:X=""!(X'[("""MPRI"""))  D
 .S GLOBAL="^ACHSMPRI("_$P(X,",",3,99)
 .S @GLOBAL=@X
 S DIK="^ACHSMPRI(" D IXALL^DIK
 W !,"Done."
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"ENTER^"_$ZN,"FINISHED")=NOW
 Q
 ;
 ;RESET O NODE AND RETURN NUMBER OF ENTRIES
CHECKSOK(X) ;
 I '$D(^ACHSMPRI(0)) S ACHSMPRI(0)="CHS MEDICAL PRIORITY^9002073.1^0^0"
 S XBCFIXFL=9002073.1
 D XBCFIXFL^XBCFIX
 Q $G(XBCFIXC)
 ;
ERROR S ^ACHSINST(ACHSVERS,"ERROR",$ZN,"ERROR TRAP CALLED")=NOW
 G ^%ET
 Q
TAG ;
 ;;^TMP($J,"MPRI",1,0)
 ;;I EMERGENT/ACUTELY URGENT CARE^EMERGENT/ACUTELY URGENT CARE
 ;;^TMP($J,"MPRI",1,1,0)
 ;;^9002073.12^7^7^
 ;;^TMP($J,"MPRI",1,1,1,0)
 ;;I - EMERGENT/ACUTELY URGENT CARE:  Diagnostic or therapeutic services
 ;;^TMP($J,"MPRI",1,1,2,0)
 ;;which are necessary to prevent the immediate death or serious impairment
 ;;^TMP($J,"MPRI",1,1,3,0)
 ;;of the health of the individual, and which, because of the threat to the
 ;;^TMP($J,"MPRI",1,1,4,0)
 ;;life or health of the individual, necessitate the use of the most
 ;;^TMP($J,"MPRI",1,1,5,0)
 ;;accessible health care available and capable of furnishing such services.
 ;;^TMP($J,"MPRI",1,1,6,0)
 ;;Diagnosis and treatment of injuries or medical conditions that, if left
 ;;^TMP($J,"MPRI",1,1,7,0)
 ;;untreated, would result in uncertain but potentially grave outcomes.
 ;;^TMP($J,"MPRI",2,0)
 ;;II PREVENTIVE CARE^PREVENTIVE CARE
 ;;^TMP($J,"MPRI",2,1,0)
 ;;^9002073.12^6^6^
 ;;^TMP($J,"MPRI",2,1,1,0)
 ;;II - PREVENTIVE CARE:  Primary health care that is aimed at the prevention
 ;;^TMP($J,"MPRI",2,1,2,0)
 ;;of long term disability.  This includes services proven effective in
 ;;^TMP($J,"MPRI",2,1,3,0)
 ;;avoiding the occurrence of a disease (primary prevention) and services
 ;;^TMP($J,"MPRI",2,1,4,0)
 ;;proven effective in mitigating the consequences of an illness or condition
 ;;^TMP($J,"MPRI",2,1,5,0)
 ;;(secondary prevention).  Level II services are available at most IHS
 ;;^TMP($J,"MPRI",2,1,6,0)
 ;;facilities.
 ;;^TMP($J,"MPRI",3,0)
 ;;III PRIMARY AND SECONDARY CARE^PRIMARY AND SECONDARY CARE
 ;;^TMP($J,"MPRI",3,1,0)
 ;;^9002073.12^8^8^
 ;;^TMP($J,"MPRI",3,1,1,0)
 ;;III - PRIMARY AND SECONDARY CARE:  Inpatient and outpatient care services
 ;;^TMP($J,"MPRI",3,1,2,0)
 ;;that involve the treatment of prevalent illnesses or conditions that have
 ;;^TMP($J,"MPRI",3,1,3,0)
 ;;a significant impact on morbidity and mortality.  This involves treatment
 ;;^TMP($J,"MPRI",3,1,4,0)
 ;;for conditions that may be delayed without progressive loss of function or
 ;;^TMP($J,"MPRI",3,1,5,0)
 ;;risk of life, limb or senses.  It includes services that may not be
 ;;^TMP($J,"MPRI",3,1,6,0)
 ;;available at many IHS facilities and/or may require specialty
 ;;^TMP($J,"MPRI",3,1,7,0)
 ;;consultation.  Level III referrals should be approved by the local CHS
 ;;^TMP($J,"MPRI",3,1,8,0)
 ;;committee or clinical director before the services are rendered.
 ;;^TMP($J,"MPRI",4,0)
 ;;IV CHRONIC TERTIARY AND EXTENDED CARE^CHRONIC TERTIARY AND EXTENDED CARE
 ;;^TMP($J,"MPRI",4,1,0)
 ;;^9002073.12^14^14^
 ;;^TMP($J,"MPRI",4,1,1,0)
 ;;IV - CHRONIC TERTIARY AND EXTENDED CARE:  Inpatient and outpatient care
 ;;^TMP($J,"MPRI",4,1,2,0)
 ;;services
 ;;^TMP($J,"MPRI",4,1,3,0)
           ;;(1) that require sophisticated specialists or equipment and
 ;;^TMP($J,"MPRI",4,1,4,0)
 ;;tertiary care facilities,
 ;;^TMP($J,"MPRI",4,1,5,0)
           ;;(2) that are not essential for initial/emergent diagnosis or
 ;;^TMP($J,"MPRI",4,1,6,0)
 ;;therapy, or
 ;;^TMP($J,"MPRI",4,1,7,0)
           ;;(3) that are high cost, are elective, and have less impact on
 ;;^TMP($J,"MPRI",4,1,8,0)
 ;;mortality than morbidity.
 ;;^TMP($J,"MPRI",4,1,9,0)
 ;; 
 ;;^TMP($J,"MPRI",4,1,10,0)
      ;;These services are not readily available from direct care IHS
 ;;^TMP($J,"MPRI",4,1,11,0)
 ;;facilities.  Careful case management by the service unit CHS committee is
 ;;^TMP($J,"MPRI",4,1,12,0)
 ;;a requirement, as is monitoring by the Area Chief Medical Officer, or
 ;;^TMP($J,"MPRI",4,1,13,0)
 ;;his/her designee.  Depending on cost, the referral may require concurrence
 ;;^TMP($J,"MPRI",4,1,14,0)
 ;;by the Chief Medical Officer.
 ;;^TMP($J,"MPRI",5,0)
 ;;V EXCLUDED^EXCLUDED
 ;;^TMP($J,"MPRI",5,1,0)
 ;;^9002073.12^2^2
 ;;^TMP($J,"MPRI",5,1,1,0)
 ;;V - EXCLUDED CARE: Services and procedures that are considered purely cosmetic
 ;;^TMP($J,"MPRI",5,1,2,0)
 ;;in nature, experimental or investigational, or have no proven medical benefit.
