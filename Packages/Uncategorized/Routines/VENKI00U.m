VENKI00U ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,2091,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2092,0)
 ;;=10^If return to work, discuss breastfeeding, child care^^CHI-PA^30^91^^^^^1^^1^3
 ;;^UTILITY(U,$J,19707.12,2092,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2093,0)
 ;;=13^Car seat in rear seat, NEVER in front seat with air bag^^CHI-S^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2093,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2094,0)
 ;;=13^SIDS --Back to Sleep, No soft bedding or toys, Not too warm^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2094,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2095,0)
 ;;=13^Water heater <120^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2095,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2096,0)
 ;;=13^Never shake baby^^CHI-S^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2096,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2097,0)
 ;;=13^Keep home and car smoke-free^^CHI-S^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2097,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2098,0)
 ;;=13^Install and check smoke alarms^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2098,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2099,0)
 ;;=13^Keep hot liquids away from baby^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2099,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2100,0)
 ;;=13^Don't leave baby alone in tub or high places; always keep a hand on baby^^CHI-S^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2100,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2101,0)
 ;;=13^Never leave baby alone with young siblings or pets^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2101,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2102,0)
 ;;=13^Childproof home-1 - hot liquids, cigarettes, alcohol, poisons, medicines^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2102,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2103,0)
 ;;=13^Childproof home-2 outlets, cords, small/sharp objects, plastic bags^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2103,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2104,0)
 ;;=13^Use safety locks on cabinets^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2104,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2105,0)
 ;;=13^Don't use baby walkers^^CHI-S^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2105,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2106,0)
 ;;=13^Don't smoke or use drugs; moderate alcohol^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2106,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2107,0)
 ;;=13^Avoid direct sun^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2107,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2108,0)
 ;;=13^Signs of illness-1: fever >100.4, seizure, rash, irritability, lethargy^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2108,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2109,0)
 ;;=13^Signs of illness-2: failure to eat, vomiting, diarrhea, dehydration^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2109,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2110,0)
 ;;=13^Wash hands and toys often^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2110,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2111,0)
 ;;=13^Choking hazards^^CHI-S^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2111,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2112,0)
 ;;=13^Avoid sharp toys^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2112,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2113,0)
 ;;=13^Learn first aid and CPR^^CHI-S^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2113,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2114,0)
 ;;=14^Be sure baby is gaining weight^^CHI-N^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2114,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2115,0)
 ;;=14^Breastfeed or bottle feed with iron-fortified formula^^CHI-N^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2115,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2116,0)
 ;;=14^No bottle propping^^CHI-N^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2116,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2117,0)
 ;;=14^If exclusive breastfeeding, give iron supplement^^CHI-N^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2117,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2118,0)
 ;;=14^Start solids 4-6 months (iron fortified cereal, fruits, vegetables, meats)^^CHI-N^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2118,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2119,0)
 ;;=14^Wait 1+ week before adding a new food^^CHI-N^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2119,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2120,0)
 ;;=14^Avoid honey^^CHI-N^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2120,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2121,0)
 ;;=14^Don't feed directly from jars or warm jars/bottles in microwave^^CHI-N^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2121,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2122,0)
 ;;=15^Don't put baby to bed with bottle^^CHI-DC^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2122,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2123,0)
 ;;=15^Discuss teething^^CHI-DC^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2123,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2124,0)
 ;;=15^Dental hygiene: Practice good family oral health habits^^CHI-DC^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2124,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2125,0)
 ;;=12^Skin care and nails^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2125,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2126,0)
 ;;=12^Colic^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2126,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2127,0)
 ;;=12^Bathing^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2127,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2128,0)
 ;;=12^Thumbsucking, pacifiers^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2128,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2129,0)
 ;;=12^Crying^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2129,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2130,0)
 ;;=12^Sleeping^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2130,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2131,0)
 ;;=12^Stools^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2131,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2132,0)
 ;;=12^Thermometer use^^CHI-I^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2132,2)
 ;;=^^CHI-I
 ;;^UTILITY(U,$J,19707.12,2133,0)
 ;;=16^Hold, cuddle, play with baby^^CHI-PA^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2133,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2134,0)
 ;;=16^Talk, sing and read to baby; play music^^CHI-PA^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2134,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2135,0)
 ;;=16^Play games (pat-a-cake, peek-a-boo)^^CHI-PA^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2135,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2136,0)
 ;;=16^Establish bedtime routines; put baby to bed awake^^CHI-PA^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2136,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2137,0)
 ;;=16^Use same comfort object (toy, blanket, stuffed animal)^^CHI-PA^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2137,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2138,0)
 ;;=16^Self-consoling of baby^^CHI-PA^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2138,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2139,0)
 ;;=16^Provide age-appropriate toys^^CHI-PA^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2139,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2140,0)
 ;;=10^Take time for self and partner^^CHI-PA^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2140,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2141,0)
 ;;=10^Encourage partner help^^CHI-PA^91^152^^^^^1^^3^5
 ;;^UTILITY(U,$J,19707.12,2141,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2142,0)
 ;;=10^Choose responsible babysitters^^CHI-PA^91^152^^^^^0^^3^5
 ;;^UTILITY(U,$J,19707.12,2142,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2143,0)
 ;;=10^Keep in contact with family and friends^^CHI-PA^91^152^^^^^1^^3^5
