ACRF1441 ;IHS/OIRM/DSD/THL,AEF - SOLICITATION FOR COMMERCIAL ITEMS - COM'T; [ 11/01/2001  11:14 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
PSC I $E($G(IOST),1,2)="C-" W @IOF,!,"ARMS REF: ",$P(ACRDOC0,U,6),"/",ACRDOCDA
 D L
 W !,"SOLICITATION/CONTRACT/ORDER FOR COMMERCIAL ITEMS|1. Requisition #  |PAGE 1 OF"
 W !,"Offeror to complete blocks 12,17,23,24, & 30"
 D 48
 W $G(ACR1)
 D 67
 W $G(ACRPOPG)
 D L
 W !,"2. Contract NO. |3. Award Date |4. Order Number |5. Solicitation # |6.Solic Date"
 W !?3,$G(ACR2)
 D 16
 W $G(ACR3)
 D 31
 W $G(ACR4)
 D 48
 W $G(ACR5)
 D 67
 W $G(ACR6)
 D L
 W !,"7.For Solicitatn|a. Name"
 D 48
 W "b. Phome NO."
 D 67
 W "8. Offer Due"
 W !,"Information call|"
 W ?$X+1,$G(ACR7A)
 D 48
 W " ",$G(ACR7B)
 D 67
 W " ",$G(ACR8)
 W $G(ACR8)
 D L
 W !,"9. Issued by"
 D 35
 W "10. ACQUISI-"
 D 48
 W "11. Deliver to"
 D 64
 W "12. Discount"
 W !?3,"USPHS INDIAN HEATLH SERVICE"
 D 35
 W "    tion is"
 D 48
 W "FOB Dest Unless"
 D 64
 W "    Terms"
 W !?3
 I $G(ACR9(3))]"" W $G(ACR9(1))
 D 35
 W " ",$G(ACR10)
 D 48
 W "marked |",$G(ACR11)
 D 64
 W $G(ACR12)
 W !?3
 I $G(ACR9(3))]"" W $G(ACR9(2))
 E  W $G(ACR9(1))
 D 35
 D 48
 D L31
 W !?3
 I $G(ACR9(3))]"" W $G(ACR9(3))
 E  W $G(ACR9(2))
 D 35,48
 W $G(ACR13A)
 W ?52,"|13a Rated order under DPAS"
 W !?3,$G(ACR9(4))
 I $G(ACR9(4))]"" W ", ",$G(ACR9(5)),"  ",$G(ACR9(6))
 D 35
 D 48
 D L31
 W !?3,"PHONE: ",$G(ACR9(7))
 D 35,48
 W "13b. Rating: "
 W !?3
 D 35,48
 W "  ",$G(ACR13B)
 D PAUSE^ACRFWARN
 W !?3
 D 35
 D 48
 D L31
 W !?3
 D 35,48
 W "14. Method of Solicitation"
 W !
 D 35
 D 48
 W "  ",$G(ACR14)
 D L
 W !,"15. Deliver to"
 D 40
 W "16. Administered by"
 W !?3
 I $G(ACR15(3))]"" W $G(ACR15(1))
 D 40
 W !?3
 I $G(ACR15(3))]"" W $G(ACR15(3))
 E  W $G(ACR15(2))
 D 40
 W !?3,$G(ACR15(4))
 I $G(ACR15(4))]"" W ", ",$G(ACR15(5)),"  ",$G(ACR15(6))
 D 40
 W !?3,"PHONE: ",$G(ACR15(7))
 D 40
 D L
 W !,"17a. Contractor/Offeror"
 D 40
 W "18a. Payment will be made by"
 W !?3
 I $G(ACR17(3))]"" W $G(ACR17(1))
 D 40
 I $G(ACR18(3))]"" W $G(ACR18(1))
 W !?3
 I $G(ACR17(3))]"" W $G(ACR17(2))
 E  W $G(ACR17(1))
 D 40
 I $G(ACR18(3))]"" W $G(ACR18(2))
 E  W $G(ACR18(1))
 W !?3
 I $G(ACR17(3))]"" W $G(ACR17(3))
 E  W $G(ACR17(2))
 D 40
 I $G(ACR18(3))]"" W $G(ACR18(3))
 E  W $G(ACR18(2))
 W !?3,$G(ACR17(4))
 I $G(ACR17(4))]"" W ", ",$G(ACR17(5)),"  ",$G(ACR17(6))
 D 40
 W $G(ACR18(4))
 I $G(ACR18(4))]"" W ", ",$G(ACR18(5)),"  ",$G(ACR18(6))
 W !?3,"PHONE: ",$G(ACR17(7))
 D 40
 W "PHONE: ",$G(ACR18(7))
 D L
 W !?3,$G(ACR17B)
 W ?3,"|Check if remit address different"
 D 40
 W $G(ACR18B)
 W ?44,"|Invoice to ADD above unless checked"
 D L
 W !?17,"See addendum for SCHEDULE OF SUPPLIES/SERVICES"
 D:$G(ACRDOCDA) ^ACRFPSS
 D L
 W !?3,$G(ACR27A)
 W ?3,"|27a Solicitation Incorp by Ref FAR 52.212-1,52.212-4, Addenda ",$G(ACR27A1)
 W !?3,$G(ACR27B)
 W ?3,"|27b Contract/PO Incorp by Ref FAR 52.212-4,52.212-5, Addenda ",$G(ACR27B1)
 D L
 W !,"28. Contractor required to sign & return"
 D 40
 W "29.Your offer on solicitation (Block 5)"
 W !,"1 copy to Issuing Office. Contractor"
 D 40
 W "including any additions/changes set"
 W !,"agrees to deliver items itentified on"
 D 40
 W "forth herein is accepted as to Items"
 W !,"the SCHEDULE OF SUPPLIES/SERVICES"
 D 40
 W "on SCHEDULE OF SUPPLIES/SERVICES"
 W !,"30a. Signature of Contractor"
 D L
 W !,"30b. Name & Title of Signer"
 D 48
 W "30c. Date signed"
 D PAUSE^ACRFWARN
 D:$G(ACRDOCDA) ^ACRFPAPV
 D DISPLAY^ACRFSS12
 Q
L W $$DASH^ACRFMENU
 Q
16 W ?16,"|"
 Q
31 W ?31,"|"
 Q
35 W ?35,"|"
 Q
40 W ?40,"|"
 Q
48 W ?48,"|"
 Q
64 W ?64,"|"
 Q
67 W ?67,"|"
 Q
L31 W $$DASH1^ACRFMENU(31)
 Q
