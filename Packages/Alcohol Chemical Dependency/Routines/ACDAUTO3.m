ACDAUTO3 ;IHS/ADC/EDE/KML - Broke up ACDAUTO1;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
MODV ; EP - MODIFY DEMOGRAPHIC PORTION OF VISIT JUST GENERATED
 ;RE DO THIS TO GET DEMOGRAPHICS FROM THE ACD CLIENT CATEGORY FILE.
 ;
 K ACDFIELD
 ;
 ;Update visit with new DFN and new TRIBE and SEX M F U & AGE RANGE
 ;Set up program pointer node
 ;Set up duplication flag i.e., field 100 upward pointer
 ;
 ;Get tribe name and tribe code
 S ACDTRBNM=$P(^ACDPAT(ACDCATP,1,ACDDFNP,0),U,7),ACDTRBCD=$P(^(0),U,2)
 ;
 ;
 ;Get state name and state code
 S ACDSTANM=$P(^ACDPAT(ACDCATP,1,ACDDFNP,0),U,6),ACDSTACD=$P(^(0),U,5)
 ;Get gender
 S ACDSEX=$P(^ACDPAT(ACDCATP,1,ACDDFNP,0),U,3)
 ;
 ;Get age range/age
 S ACDAGER=$P(^ACDPAT(ACDCATP,1,ACDDFNP,0),U,4),ACDAGE=$P(^(0),U,9)
 ;
 ;
 ;Get veteran status
 S ACDVET=$P(^ACDPAT(ACDCATP,1,ACDDFNP,0),U,8)
 ;
 ;
 S DIE=9002172.1
 S DA=ACDPT1(ACDDFNP)
 S ACDPG=$G(^ACDVIS(ACDVISP,"BWP"))
 S DR="4////"_ACDDFNP_";9////"_ACDAGER_";99.99////"_ACDPG_";100////"_ACDVISP_";101////"_ACDTRBCD_";102////"_ACDSTACD_";103////"_ACDSEX_";104////"_ACDVET_";105////"_ACDTRBNM_";106////"_ACDSTANM_";107////"_ACDAGE
 D DIE^ACDFMC
 ;
 Q
