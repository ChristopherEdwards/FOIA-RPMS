VENKI00T ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,2038,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2039,0)
 ;;=10^Recognize fatigue, depression^^CHN-PA^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2039,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2040,0)
 ;;=10^Accepting support from others (family, friends, professionals)^^CHN-PA^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2040,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2041,0)
 ;;=10^Give siblings attention^^CHN-PA^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2041,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2042,0)
 ;;=10^Schedule postpartum checkup^^CHN-PA^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2042,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2043,0)
 ;;=10^Resources - financial, medical, WIC^^CHN-PA^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2043,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2044,0)
 ;;=13^Car seat, rear facing, in rear seat, NEVER in front seat with air bag^^CHI-S^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2044,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2045,0)
 ;;=13^Accidents are a major cause of death^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2045,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2046,0)
 ;;=13^SIDS --Back to Sleep, No soft bedding or toys, Not too warm^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2046,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2047,0)
 ;;=13^Water heater <120^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2047,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2048,0)
 ;;=13^Test water before bath^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2048,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2049,0)
 ;;=13^Never shake baby^^CHI-S^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2049,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2050,0)
 ;;=13^Keep home and car smoke-free^^CHI-S^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2050,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2051,0)
 ;;=13^Install and check smoke alarms^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2051,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2052,0)
 ;;=13^Keep hot liquids away from baby^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2052,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2053,0)
 ;;=13^Don't leave baby alone in tub or high places; always keep a hand on baby^^CHI-S^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2053,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2054,0)
 ;;=13^Never leave baby alone with young siblings or pets^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2054,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2055,0)
 ;;=13^Childproof home: Keep small/sharp objects and plastic bags out of reach^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2055,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2056,0)
 ;;=13^Don't smoke or use drugs; moderate alcohol^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2056,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2057,0)
 ;;=13^Avoid direct sun^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2057,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2058,0)
 ;;=13^Signs of illness-1: fever >100.4, seizure, rash, irritability, lethargy^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2058,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2059,0)
 ;;=13^Signs of illness-2: failure to eat, vomiting, diarrhea, dehydration^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2059,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2060,0)
 ;;=13^Review emergency procedures for home and child  care^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2060,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2061,0)
 ;;=13^Wash hands and toys often^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2061,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2062,0)
 ;;=13^Learn first aid and CPR^^CHI-S^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2062,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2063,0)
 ;;=14^Be sure baby is gaining weight^^CHI-N^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2063,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2064,0)
 ;;=14^Breastfeed on demand or bottle feed with iron-fortified formula^^CHI-N^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2064,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2065,0)
 ;;=14^Don't put cereal in bottle^^CHI-N^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2065,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2066,0)
 ;;=14^Delay solids until 4-6 months^^CHI-N^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2066,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2067,0)
 ;;=14^No bottle propping^^CHI-N^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2067,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2068,0)
 ;;=14^Avoid honey ^^CHI-N^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2068,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2069,0)
 ;;=14^Feed in semi-sitting position^^CHI-N^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2069,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2070,0)
 ;;=14^Feed every 3-4 hours in day^^CHI-N^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2070,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2071,0)
 ;;=15^Don't put baby to bed with bottle^^CHI-DC^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2071,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2072,0)
 ;;=15^Practice good family oral health habits^^CHI-DC^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2072,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2073,0)
 ;;=12^Skin care and nails^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2073,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2074,0)
 ;;=12^Colic^^CHI-I^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2074,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2075,0)
 ;;=12^Bathing^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2075,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2076,0)
 ;;=12^Thumbsucking, pacifiers^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2076,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2077,0)
 ;;=12^Crying^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2077,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2078,0)
 ;;=12^Sleeping^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2078,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2079,0)
 ;;=12^Stools^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2079,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2080,0)
 ;;=12^Thermometer use^^CHI-I^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2080,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2081,0)
 ;;=16^Learn baby's temperament^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2081,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2082,0)
 ;;=16^Hold, cuddle, play, talk, sing to baby^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2082,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2083,0)
 ;;=16^Read to baby^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2083,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2084,0)
 ;;=16^Establish bedtime routines^^CHI-PA^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2084,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2085,0)
 ;;=16^Provide age-appropriate toys^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2085,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2086,0)
 ;;=10^Take time for self and partner^^CHI-PA^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2086,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2087,0)
 ;;=10^Encourage partner help^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2087,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2088,0)
 ;;=10^Choose responsible babysitters^^CHI-PA^30^91^^^^^0^^1^3
 ;;^UTILITY(U,$J,19707.12,2088,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2089,0)
 ;;=10^Keep in contact with family and friends^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2089,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2090,0)
 ;;=10^Meet needs of other children^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2090,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2091,0)
 ;;=10^Discuss family planning^^CHI-PA^30^91^^^^^1^^1^3
