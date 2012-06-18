ACRFCA1 ;IHS/OIRM/DSD/THL,AEF - COMPACT AWARD CON'T; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;UTILITY TO PRINT COMPACT AWARD
EN D EN1
EXIT K ACR,ACRAPP
 Q
EN1 N X
 S X="NOTICE OF SELF-GOVERNANCE COMPACT AWARD"
 W !?(80-$L(X))\2,X
 D 81
 W !,"COMPACT NO."
 W ?18,"| DATE ISSUED"
 W ?35,"| AWARDEE: ",$G(ACR(81))
 W !,$G(ACR(2))
 W ?18,"|  "
 W $G(ACR(1))
 W ?35,"|",?44,$G(ACR(82))
 W !?18,"|",?35,"|",?44,$G(ACR(84))
 D 81
 W !,"28. Budget Detail by Approp"
 W ?28,"| SERIVCES"
 W ?41,"| FACILITIES"
 W ?54,"| CONTRACT HLTH"
 W ?67,"| ISD"
 D 81
 W !,"Appropriation No."
 W ?28,$G(ACRAPP(1))
 W ?41,$G(ACRAPP(2))
 W ?54,$G(ACRAPP(3))
 W ?67,$G(ACRAPP(4))
 D 81
 W !,"A. Fin Asst By Approp",?28,$J($FN($G(ACR("28A1")),"P,",0),12),?41,$J($FN($G(ACR("28A2")),"P,",0),12),?54,$J($FN($G(ACR("28A3")),"P,",0),12),?67,$J($FN($G(ACR("28A4")),"P,",0),12)
 W !,"B. Dir Asst By Approp",?28,$J($FN($G(ACR("28B1")),"P,",0),12),?41,$J($FN($G(ACR("28B2")),"P,",0),12),?54,$J($FN($G(ACR("28B3")),"P,",0),12),?67,$J($FN($G(ACR("28B4")),"P,",0),12)
 W !,"C. Fed Funds Approved",?28,$J($FN($G(ACR("28C1")),"P,",0),12),?41,$J($FN($G(ACR("28C2")),"P,",0),12),?54,$J($FN($G(ACR("28C3")),"P,",0),12),?67,$J($FN($G(ACR("28C4")),"P,",0),12)
 W !,"D. Current Years Funds"
 W !,"  1) Financial Asst",?28,$J($FN($G(ACR("28D11")),"P,",0),12),?41,$J($FN($G(ACR("28D12")),"P,",0),12),?54,$J($FN($G(ACR("28D13")),"P,",0),12),?67,$J($FN($G(ACR("28D14")),"P,",0),12)
 W !,"  2) Direct Asst",?28,$J($FN($G(ACR("28D21")),"P,",0),12),?41,$J($FN($G(ACR("28D22")),"P,",0),12),?54,$J($FN($G(ACR("28D23")),"P,",0),12),?67,$J($FN($G(ACR("28D24")),"P,",0),12)
 W !,"  3) Amt THIS ACTION",?28,$J($FN($G(ACR("28D31")),"P,",0),12),?41,$J($FN($G(ACR("28D32")),"P,",0),12),?54,$J($FN($G(ACR("28D33")),"P,",0),12),?67,$J($FN($G(ACR("28D34")),"P,",0),12)
 W !,"E. Cumulative Awards"
 W !,"  1) Financial Asst",?28,$J($FN($G(ACR("28E11")),"P,",0),12),?41,$J($FN($G(ACR("28E12")),"P,",0),12),?54,$J($FN($G(ACR("28E13")),"P,",0),12),?67,$J($FN($G(ACR("28E14")),"P,",0),12)
 W !,"  2) Direct Asst",?28,$J($FN($G(ACR("28E21")),"P,",0),12),?41,$J($FN($G(ACR("28E22")),"P,",0),12),?54,$J($FN($G(ACR("28E23")),"P,",0),12),?67,$J($FN($G(ACR("28E24")),"P,",0),12)
 W !,"  3) Amt THIS ACTION",?28,$J($FN($G(ACR("28E31")),"P,",0),12),?41,$J($FN($G(ACR("28E32")),"P,",0),12),?54,$J($FN($G(ACR("28E33")),"P,",0),12),?67,$J($FN($G(ACR("28E34")),"P,",0),12)
 W !,"F. Unawarded Balance",?28,$J($FN($G(ACR("28F1")),"P,",0),12),?41,$J($FN($G(ACR("28F2")),"P,",0),12),?54,$J($FN($G(ACR("28F3")),"P,",0),12),?67,$J($FN($G(ACR("28F4")),"P,",0),12)
 W !,"G. Carry Forward",?28,$J($FN($G(ACR("28G1")),"P,",0),12),?41,$J($FN($G(ACR("28G2")),"P,",0),12),?54,$J($FN($G(ACR("28G3")),"P,",0),12),?67,$J($FN($G(ACR("28G4")),"P,",0),12)
 D PAUSE^ACRFWARN
 D 81
 W !,"29. Budget Detail by Approp"
 W ?28,"| SERIVCES"
 W ?41,"| FACILITIES"
 W ?54,"| CONTRACT HLTH"
 W ?67,"| ISD"
 D 81
 W !,"Appropriation No."
 W ?28,$G(ACRAPP(5))
 W ?41,$G(ACRAPP(6))
 W ?54,$G(ACRAPP(7))
 W ?67,$G(ACRAPP(8))
 D 81
 W !,"A. Fin Asst By Approp",?28,$J($FN($G(ACR("29A1")),"P,",0),12),?41,$J($FN($G(ACR("29A2")),"P,",0),12),?54,$J($FN($G(ACR("29A3")),"P,",0),12),?67,$J($FN($G(ACR("29A4")),"P,",0),12)
 W !,"B. Dir Asst By Approp",?28,$J($FN($G(ACR("29B1")),"P,",0),12),?41,$J($FN($G(ACR("29B2")),"P,",0),12),?54,$J($FN($G(ACR("29B3")),"P,",0),12),?67,$J($FN($G(ACR("29B4")),"P,",0),12)
 W !,"C. Fed Funds Approved",?28,$J($FN($G(ACR("29C1")),"P,",0),12),?41,$J($FN($G(ACR("29C2")),"P,",0),12),?54,$J($FN($G(ACR("29C3")),"P,",0),12),?67,$J($FN($G(ACR("29C4")),"P,",0),12)
 W !,"D. Current Years Funds"
 W !,"  1)) Financial Asst",?28,$J($FN($G(ACR("29D11")),"P,",0),12),?41,$J($FN($G(ACR("29D12")),"P,",0),12),?54,$J($FN($G(ACR("29D13")),"P,",0),12),?67,$J($FN($G(ACR("29D14")),"P,",0),12)
 W !,"  2)) Direct Asst",?28,$J($FN($G(ACR("29D21")),"P,",0),12),?41,$J($FN($G(ACR("29D22")),"P,",0),12),?54,$J($FN($G(ACR("29D23")),"P,",0),12),?67,$J($FN($G(ACR("29D24")),"P,",0),12)
 W !,"  3)) Amt THIS ACTION",?28,$J($FN($G(ACR("29D31")),"P,",0),12),?41,$J($FN($G(ACR("29D32")),"P,",0),12),?54,$J($FN($G(ACR("29D33")),"P,",0),12),?67,$J($FN($G(ACR("29D34")),"P,",0),12)
 W !,"E. Cumulative Awards"
 W !,"  1) Financial Asst",?28,$J($FN($G(ACR("29E11")),"P,",0),12),?41,$J($FN($G(ACR("29E12")),"P,",0),12),?54,$J($FN($G(ACR("29E13")),"P,",0),12),?67,$J($FN($G(ACR("29E14")),"P,",0),12)
 W !,"  2) Direct Asst",?28,$J($FN($G(ACR("29E21")),"P,",0),12),?41,$J($FN($G(ACR("29E22")),"P,",0),12),?54,$J($FN($G(ACR("29E23")),"P,",0),12),?67,$J($FN($G(ACR("29E24")),"P,",0),12)
 W !,"  3) Amt THIS ACTION",?28,$J($FN($G(ACR("29E31")),"P,",0),12),?41,$J($FN($G(ACR("29E32")),"P,",0),12),?54,$J($FN($G(ACR("29E33")),"P,",0),12),?67,$J($FN($G(ACR("29E34")),"P,",0),12)
 W !,"F. Unawarded Balance",?28,$J($FN($G(ACR("29F1")),"P,",0),12),?41,$J($FN($G(ACR("29F2")),"P,",0),12),?54,$J($FN($G(ACR("29F3")),"P,",0),12),?67,$J($FN($G(ACR("29F4")),"P,",0),12)
 W !,"G. Carry Forward",?28,$J($FN($G(ACR("29G1")),"P,",0),12),?41,$J($FN($G(ACR("29G2")),"P,",0),12),?54,$J($FN($G(ACR("29G3")),"P,",0),12),?67,$J($FN($G(ACR("29G4")),"P,",0),12)
 Q
1 W ?40,"|"
 Q
40 W $$DASH^ACRFMENU(40)
 Q
41 W $$DASH1^ACRFMENU(39)
 Q
81 W $$DASH^ACRFMENU
 Q
REMARKS ;PRINT REMARKS
 Q
TC ;PRINT TERMS AND CONDITIONS
 Q
