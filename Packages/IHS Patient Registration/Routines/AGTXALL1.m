AGTXALL1 ;IHS/ASDS/EFG - EXPORT ALL REG DATA CONT. ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
CHK() ;EP - Check if today is before the schedule export date. If so, confirm.
 I DT>$$WHEN($E($P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10),1,2)) Q 1
 D ALL,HELP^XBHELP("H","AGTXALL1")
 Q $$DIR^XBDIR("YO","Proceed","N","","YOU'RE EARLY.  Do you still want to proceed with the extract  (Y/N)")
 ;
SCHED ;;^AREA^EXPORT DATE^EXPORT DATE FM
 ;;^Alaska^ 9-Oct-01^3011009
 ;;^Billings^10-Oct-01^3011010
 ;;^Tucson^11-Oct-01^3011011
 ;;^California^12-Oct-01^3011012
 ;;^Navajo^15-Oct-01^3011015
 ;;^Albuquerque^16-Oct-01^3011016
 ;;^Phoenix^17-Oct-01^3011017
 ;;^Nashville^18-Oct-01^3011018
 ;;^Portland^22-Oct-01^3011022
 ;;^Aberdeen^23-Oct-01^3011023
 ;;^Bemidji^24-Oct-01^3011024
 ;;^Oklahoma^25-Oct-01^3011025
 ;
ALL ;EP - Display the whole schedule.
 F %=1:1:12 W !?5,$P($T(SCHED+%),U,2),?20,$P($T(SCHED+%),U,3)
 Q
H ;
 ;;According to the RPMS SITE file, your facility, 
 ;;@;$P(^DIC(4,$P(^AUTTSITE(1,0),U,1),0),U,1)_", "
 ;;is in the 
 ;;@;$P(^AUTTAREA($P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,4),0),U,1)_" area."
 ;;According to the export schedule, you should perform your comprehensive
 ;;extract on:  
 ;;@;$$FMTE^XLFDT($$WHEN^AGTXALL1($E($P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10),1,2)))_"."
 ;;If local circumstances dictate an early extract, just answer "Y" to the
 ;;prompt, below.  We prefer that you wait until 
 ;;@;$$FMTE^XLFDT($$WHEN^AGTXALL1($E($P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10),1,2)))_".  If you proceed,"
 ;;notify help desk.
 ;;###
WHEN(A) ;EP - Lookup when an Area should export, given area code A.
 Q $S('$L($T(@A)):"<not found>",1:$P($T(SCHED+$P($T(@A),U,2)),U,4))
 ;
 ;;area name ^ offset from "SCHED"
10 ;;ABERDEEN^10
15 ;;ABERDEEN TRIBE/638^10
17 ;;ABERDEEN URBAN^10
30 ;;ALASKA^1
39 ;;ALASKA NON-IHS^1
35 ;;ALASKA TRIBE/638^1
20 ;;ALBUQUERQUE^6
25 ;;ALBUQUERQUE TRIBE/638^6
11 ;;BEMIDJI^11
18 ;;BEMIDJI NON-IHS^11
16 ;;BEMIDJI TRIBE/638^11
14 ;;BEMIDJI URBAN^11
40 ;;BILLINGS^2
45 ;;BILLINGS TRIBE/638^2
47 ;;BILLINGS URBAN^2
61 ;;CALIFORNIA^4
68 ;;CALIFORNIA NON-IHS^4
66 ;;CALIFORNIA TRIBE/638^4
64 ;;CALIFORNIA URBAN^4
99 ;;HEADQUARTERS EAST
23 ;;HEADQUARTERS WEST
51 ;;NASHVILLE^8
58 ;;NASHVILLE NON-IHS^8
56 ;;NASHVILLE TRIBE/638^8
54 ;;NASHVILLE URBAN^8
80 ;;NAVAJO^5
89 ;;NAVAJO NON-IHS^5
85 ;;NAVAJO TRIBE/638^5
50 ;;OKLAHOMA^12
59 ;;OKLAHOMA NON-IHS^12
55 ;;OKLAHOMA TRIBE/638^12
57 ;;OKLAHOMA URBAN^12
60 ;;PHOENIX^7
69 ;;PHOENIX NON-IHS^7
65 ;;PHOENIX TRIBE/638^7
67 ;;PHOENIX URBAN^7
70 ;;PORTLAND^9
79 ;;PORTLAND NON-IHS^9
75 ;;PORTLAND TRIBE/638^9
77 ;;PORTLAND URBAN^9
00 ;;TUCSON^3
09 ;;TUCSON NON-IHS^3
05 ;;TUCSON TRIBE/638^3
07 ;;TUCSON URBAN^3
 ;
 ;For possible future use.
RG9(DFN) ;- Given the DFN, create RG9 record(s) of unique Visit IDs.
 Q:'$G(DFN)
 NEW AG,AGV
 S (AG,AGV)=0
 F  S AGV=$O(^AUPNVSIT("AC",DFN,AGV)) Q:'AGV  S T(9)=$G(T(9))_U_AGV S AG=AG+1 I AG=28 S T(9)="RG9"_U_T(9) D SET^AGTXALL(9) S T(9)=""
 Q
 ;For possible future use.
VID(V) ;EP - Given Visit IEN, return unique Visit record id.
 ;If not there, stuff the ASUFAC into RPMS SITE for durability.
 I '$P($G(^AUTTSITE(1,1)),U,3) S $P(^AUTTSITE(1,1),U,3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U,1),0),U,10)
 Q $P(^AUTTSITE(1,1),U,3)_$E("0000000000",1,10-$L(V))_V
