AQALKILL ; IHS/ORDC/LJF - QI RPMS LINKS UTILITY RTN ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;PUBLISHED ENTRY POINT
 ;to be used by calling RPMS packages to kill AQAL variables when they
 ;no longer need them
 ;
NM ; >> kill namespaced variables
 D ^AQALVKL0
 ;S X="AQAL"
 ;F  S X=$O(@X) Q:X'?1"AQAL".E  D
 ;.K Y F I=1:1:4 I $P($T(SYS+I),";;",2)=X S Y=""
 ;.Q:$D(Y)
 ;.K @X
 ;K AQAL
 ;
 Q
 ;
SYS ;;SYSTEM-WIDE VARIABLES
