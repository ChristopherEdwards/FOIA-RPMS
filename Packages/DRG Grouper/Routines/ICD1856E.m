ICD1856E ;ALB/MJB - YEARLY DRG UPDATE;8/9/2010
 ;;18.0;DRG Grouper;**56**;Oct 13, 2000;Build 7
 ;
 Q
 ;
PRO ; update existing operation/procedure codes 
 D BMES^XPDUTL(">>>Modify existing procedure codes - file 80.1")
 N LINE,X,ICDPROC,ENTRY,SUBLINE,DATA,FDA
 F LINE=1:1 S X=$T(REV+LINE) S ICDPROC=$P(X,";;",2) Q:ICDPROC="EXIT"  D
 .Q:ICDPROC["+"
 .S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",0))
 .I ENTRY D
 ..;check for possible inactive dupe
 ..I $P($G(^ICD0(ENTRY,0)),U,9)=1 S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",ENTRY)) I 'ENTRY Q
 ..; check if already created in case patch being re-installed
 ..Q:$D(^ICD0(ENTRY,2,"B",3111001))
 ..;add 80.171, 80.1711 and 80.17111 records
 ..F SUBLINE=1:1 S X=$T(REV+LINE+SUBLINE) S DATA=$P(X,";;",2) Q:DATA'["+"  D
 ...I SUBLINE=1 D
 ....S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ....S FDA(1820,80.171,"+2,?1,",.01)=3111001
 ....D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S DATA=$E(DATA,2,99)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3111001
 ...S FDA(1820,80.1711,"+3,?2,?1,",.01)=$P(DATA,U)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3111001
 ...S FDA(1820,80.1711,"?3,?2,?1,",.01)=$P(DATA,U)
 ...S FDA(1820,80.17111,"+4,?3,?2,?1,",.01)=$P(DATA,U,2)
 ...I $P(DATA,U,3) S FDA(1820,80.17111,"+5,?3,?2,?1,",.01)=$P(DATA,U,3)
 ...I $P(DATA,U,4) S FDA(1820,80.17111,"+6,?3,?2,?1,",.01)=$P(DATA,U,4)
 ...I $P(DATA,U,5) S FDA(1820,80.17111,"+7,?3,?2,?1,",.01)=$P(DATA,U,5)
 ...I $P(DATA,U,6) S FDA(1820,80.17111,"+8,?3,?2,?1,",.01)=$P(DATA,U,6)
 ...I $P(DATA,U,7) S FDA(1820,80.17111,"+9,?3,?2,?1,",.01)=$P(DATA,U,7)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
ID ;
 ; Modify Identifier field (#2) in file 80.1 - 
 N LINE,X,ICDPROC,ENTRY,DA,DIE,DR,IDENT,DIC
 F LINE=1:1 S X=$T(REVID+LINE) S ICDPROC=$P(X,";;",2) Q:ICDPROC="EXIT"  D
 .S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",0)) I ENTRY D
 ..S DA=ENTRY,DIE="^ICD0("
 ..S IDENT=$P(ICDPROC,U,2)
 ..S DR="2///^S X=IDENT"
 ..D ^DIE
 Q
 ; 
REV ;
 ;;02.93^OQ^
 ;;+1^23^24^25^26^27^31^32^33
 ;;+17^820^821^822
 ;;+24^957^958^959
 ;;38.45^O7^
 ;;+4^163^164^165
 ;;+5^216^217^218^219^220^221
 ;;+6^326^327^328
 ;;+21^907^908^909
 ;;39.73^O^
 ;;+5^216^217^218^219^220^221
 ;;+11^673^674^675
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;41.00^OB^
 ;;+98^16^17
 ;;41.01^OB^
 ;;+98^16^17
 ;;41.04^OB^
 ;;+98^16^17
 ;;41.07^OB^
 ;;+98^16^17
 ;;41.09^OB^
 ;;+98^16^17
 ;;43.89^O^
 ;;+5^264
 ;;+6^326^327^328
 ;;+10^619^620^621
 ;;+17^820^821^822^826^827^828
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;86.22^O^
 ;;+1^40^41^42
 ;;+2^115
 ;;+3^133^134
 ;;+4^166^167^168
 ;;+5^264
 ;;+6^356^357^358
 ;;+7^423^424^425
 ;;+8^463^464^465
 ;;+9^570^571^572
 ;;+10^622^623^624
 ;;+11^673^674^675
 ;;+12^715^716^717^718
 ;;+13^749^750
 ;;+16^802^803^804
 ;;+21^901^902^903
 ;;+24^957^958^959
 ;;86.98^O^
 ;;+1^23^24^40^41^42
 ;;EXIT
 ;
REVID ; update identifier for procedure codes
 ;;37.52^Oq
 ;;EXIT
