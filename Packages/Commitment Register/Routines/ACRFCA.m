ACRFCA ;IHS/OIRM/DSD/THL,AEF - COMPACT AWARD; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;UTILITY TO PRINT COMPACT AWARD
EN D EN1
EXIT K ACR
 Q
EN1 D GATHER
 W !,"1. DATE ISSUED: "
 W ?20,"|2. Compact No:"
 D 1
 W ?45,"Dep of Health and Human Services"
 W !?5,$G(ACR(1))
 W ?20,"|  "
 W $G(ACR(2))
 D 1
 D 40
 D 1
 W ?49,"PHS/Indian Health Service"
 W !,"3. Admin Code:"
 W ?15,"Cat Fed Domestic Asst No."
 D 1
 W !?5,$G(ACR(3))
 D 1
 W ?49,"NOTICE OF SELF-GOVERNANCE"
 D 40
 D 1
 W ?56,"COMPACT AWARD"
 W !,"5. Award Period:"
 D 1
 W ?56,"SUPPLEMENT"
 W !?3,"FROM: ",$G(ACR(51))
 W ?30,"TO: ",$G(ACR(52))
 D 1
 D 40
 D 1
 D 41
 W !,"6. Program Title:"
 D 1
 W "8. Compact Recipient/Address:"
 W !?3,$G(ACR(6))
 D 1
 W ?42,$G(ACR(81))
 D 40
 D 1
 W ?42,$G(ACR(82))
 W !,"7. Authorization (Legislative):"
 D 1
 W ?42,$G(ACR(83))
 W !?3,$G(ACR(7))
 D 1
 W ?42,$G(ACR(84))
 W !
 D 1
 W ?42,$G(ACR(85))
 D PAUSE^ACRFWARN
 D 80
 W !,"9. Fed Funds Approved (Current Period)"
 D 1
 W "13. Payment Information:"
 W !?3,"A. Financial Assistance:"
 W ?28,$J($FN($G(ACR(91)),"P,",0),12)
 D 1
 W ?42,"A. Frequency of Payment:"
 W !?3,"B. Direct Assistance...:"
 W ?28,$J($FN($G(ACR(92)),"P,",0),12)
 D 1
 W ?45,$G(ACR(13))
 W !?3,"C. Carry Forward.......:"
 W ?28,$J($FN($G(ACR(93)),"P,",0),12)
 D 1
 W !?3,"A. Financial Assistance:"
 W ?28,$J($FN($G(ACR(94)),"P,",0),12)
 D 1
 W !,"10. Fed Funds Awarded (This Action)"
 D 1
 W ?42,"B. Fed Payment Office:"
 W !?3,"A. Financial Assistance:"
 W ?28,$J($FN($G(ACR(101)),"P,",0),12)
 D 1
 W ?45,$G(ACR(131))
 W !?3,"B. Direct Assistance...:"
 W ?28,$J($FN($G(ACR(102)),"P,",0),12)
 D 1
 W ?45,$G(ACR(132))
 W !?3,"C. Carry Forward.......:"
 W ?28,$J($FN($G(ACR(103)),"P,",0),12)
 D 1
 W ?45,$G(ACR(133))
 W !?3,"A. Financial Assistance:"
 W ?28,$J($FN($G(ACR(104)),"P,",0),12)
 D 1
 W ?45,$G(ACR(134))
 W !,"11. Cumulative Awards (This Period)"
 D 1
 W !?3,"A. Financial Assistance:"
 W ?28,$J($FN($G(ACR(111)),"P,",0),12)
 D 1
 W !?3,"B. Direct Assistance...:"
 W ?28,$J($FN($G(ACR(112)),"P,",0),12)
 D 1
 W !?3,"C. Carry Forward.......:"
 W ?28,$J($FN($G(ACR(113)),"P,",0),12)
 D 1
 W !?3,"A. Financial Assistance:"
 W ?28,$J($FN($G(ACR(114)),"P,",0),12)
 D 1
 W !,"12. Unawarded Balance Current Year"
 D 1
 W !?28,$J($FN($G(ACR(114)),"P,",0),12)
 D PAUSE^ACRFWARN
 D 80
 W !,"14. Remarks (Other Documents Attached  |"
 W:$G(ACR(14))="Y" "XX"
 W ?45,"|  Yes  |"
 W:$G(ACR(14))="N" "XX"
 W ?58,"|  No )"
 D REMARKS
 D 80
 W !,"15. This Compact is subject to the Terms and Conditions incorporated directly"
 W !,"    or by reference in the following:"
 D TC
 D 80
 W !,"16. CRS-EIN: ",$G(ACR(16))
 W ?25,"|17. Object Class: ",$G(ACR(17))
 W ?60,"|18. List No.: ",$G(ACR(18))
 D PAUSE^ACRFWARN
 D 80
 W !?6,"FY CAN"
 W ?20,"DOCUMENT NO."
 W ?40,"AMOUNT FIN. ASST."
 W ?60,"AMOUNT DIR. ASST."
 W !,"19a. ",$G(ACR(191)),?20,"b. ",$G(ACR(192)),?40,"c. ",$J($FN($G(ACR(193)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(194)),"P,",0),12)
 W !,"20a. ",$G(ACR(201)),?20,"b. ",$G(ACR(202)),?40,"c. ",$J($FN($G(ACR(203)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(204)),"P,",0),12)
 W !,"21a. ",$G(ACR(211)),?20,"b. ",$G(ACR(212)),?40,"c. ",$J($FN($G(ACR(213)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(214)),"P,",0),12)
 W !,"22a. ",$G(ACR(221)),?20,"b. ",$G(ACR(222)),?40,"c. ",$J($FN($G(ACR(223)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(224)),"P,",0),12)
 W !,"23a. ",$G(ACR(231)),?20,"b. ",$G(ACR(232)),?40,"c. ",$J($FN($G(ACR(233)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(234)),"P,",0),12)
 W !,"24a. ",$G(ACR(241)),?20,"b. ",$G(ACR(242)),?40,"c. ",$J($FN($G(ACR(243)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(244)),"P,",0),12)
 W !,"25a. ",$G(ACR(251)),?20,"b. ",$G(ACR(252)),?40,"c. ",$J($FN($G(ACR(253)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(254)),"P,",0),12)
 W !,"26a. ",$G(ACR(261)),?20,"b. ",$G(ACR(262)),?40,"c. ",$J($FN($G(ACR(263)),"P,",0),12),?60,"d. ",$J($FN($G(ACR(264)),"P,",0),12)
 Q
GATHER ;GATHER ALL DATA FOR REPORT
 Q
1 W ?40,"|"
 Q
40 W $$DASH^ACRFMENU(40)
 Q
41 W $$DASH1^ACRFMENU(39)
 Q
80 W !
81 W $$DASH^ACRFMENU
 Q
REMARKS ;PRINT REMARKS
 Q
TC ;PRINT TERMS AND CONDITIONS
 Q
