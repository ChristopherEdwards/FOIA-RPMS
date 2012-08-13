VENKI00W ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,2194,0)
 ;;=10^Choose responsible caregivers, babysitters^^CHI-PA^152^244^^^^^0^^5^8
 ;;^UTILITY(U,$J,19707.12,2194,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2195,0)
 ;;=10^Keep in contact with family and friends^^CHI-PA^152^244^^^^^1^^5^8
 ;;^UTILITY(U,$J,19707.12,2195,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2196,0)
 ;;=10^Meet siblings' needs^^CHI-PA^152^244^^^^^1^^5^8
 ;;^UTILITY(U,$J,19707.12,2196,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2197,0)
 ;;=10^Discuss folic acid if considering future pregnancy^^CHI-PA^152^244^^^^^1^^5^8
 ;;^UTILITY(U,$J,19707.12,2197,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2198,0)
 ;;=13^Car seat in rear seat, NEVER in front seat with air bag^^CHI-S^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2198,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2199,0)
 ;;=13^SIDS --Back to Sleep, No soft bedding or toys, Not too warm^^CHI-S^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2199,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2200,0)
 ;;=13^Lower crib mattress^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2200,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2201,0)
 ;;=13^Water heater <120^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2201,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2202,0)
 ;;=13^Never shake baby^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2202,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2203,0)
 ;;=13^Keep home and car smoke-free^^CHI-S^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2203,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2204,0)
 ;;=13^Empty tub or water buckets, pools^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2204,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2205,0)
 ;;=13^Tub/pool safety^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2205,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2206,0)
 ;;=13^Don't leave baby alone in tub or high places; always keep a hand on baby^^CHI-S^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2206,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2207,0)
 ;;=13^Don't leave heavy objects or hot liquids on tablecloths^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2207,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2208,0)
 ;;=13^Care with hot liquids^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2208,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2209,0)
 ;;=13^Childproof home-1: poisons, medicines, outlets, dangling cords ^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2209,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2210,0)
 ;;=13^Childproof home-2: small/sharp objects, plastic bags, balloons, guns^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2210,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2211,0)
 ;;=13^Keep poison control center number handy^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2211,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2212,0)
 ;;=13^Use safety locks, stair gates^^CHI-S^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2212,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2213,0)
 ;;=13^Choking hazards^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2213,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2214,0)
 ;;=13^Crawling hazards^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2214,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2215,0)
 ;;=13^Don't use baby walkers^^CHI-S^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2215,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2216,0)
 ;;=13^Don't smoke or use drugs; moderate alcohol^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2216,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2217,0)
 ;;=13^Limit sun; use sunscreen, hats^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2217,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2218,0)
 ;;=13^Signs of illness-1: fever >100.4, seizure, rash, irritability, lethargy, cough^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2218,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2219,0)
 ;;=13^Signs of illness-2: failure to eat, vomiting, diarrhea, dehydration^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2219,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2220,0)
 ;;=13^Review emergency procedures for home, child care^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2220,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2221,0)
 ;;=13^Learn first aid, CPR^^CHI-S^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2221,2)
 ;;=^^CHI-S
 ;;^UTILITY(U,$J,19707.12,2222,0)
 ;;=14^Breastfeed or use iron-fortified formula (Iron/Vit D if indicated)^^CHI-N^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2222,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2223,0)
 ;;=14^No bottle propping^^CHI-N^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2223,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2224,0)
 ;;=14^Increase soft, moist table foods gradually^^CHI-N^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2224,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2225,0)
 ;;=14^Encourage self-feeding, cup use, use toast or biscuits^^CHI-N^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2225,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2226,0)
 ;;=14^Avoid "choke foods"-1: nuts, popcorn, carrot sticks, raisons^^CHI-N^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2226,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2227,0)
 ;;=14^Avoid "choke foods"-2: hard candy, large pieces of fruit/vegetables^^CHI-N^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2227,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2228,0)
 ;;=14^Supervise eating^^CHI-N^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2228,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2229,0)
 ;;=14^No honey until age 1^^CHI-N^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2229,2)
 ;;=^^CHI-N
 ;;^UTILITY(U,$J,19707.12,2230,0)
 ;;=15^Don't put baby to bed with bottle^^CHI-DC^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2230,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2231,0)
 ;;=15^Fluoride^^CHI-DC^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2231,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2232,0)
 ;;=15^Brush baby teeth with soft toothbrush, water only^^CHI-DC^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2232,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2233,0)
 ;;=15^Practice good family oral health habits (brush, floss)^^CHI-DC^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2233,2)
 ;;=^^CHI-DC
 ;;^UTILITY(U,$J,19707.12,2234,0)
 ;;=16^Talk, sing and read to baby; play music; play games; share books^^CHI-PA^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2234,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2235,0)
 ;;=16^Encourage safe exploration^^CHI-PA^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2235,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2236,0)
 ;;=16^Set simple rules and limits^^CHI-PA^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2236,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2237,0)
 ;;=16^Have bedtime routines; put baby to bed awake^^CHI-PA^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2237,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2238,0)
 ;;=16^Use same comfort object (toy, blanket, stuffed animal)^^CHI-PA^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2238,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2239,0)
 ;;=10^Take time for self and partner^^CHI-PA^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2239,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2240,0)
 ;;=10^Choose responsible caregivers, babysitters^^CHI-PA^244^335^^^^^0^^8^11
 ;;^UTILITY(U,$J,19707.12,2240,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2241,0)
 ;;=10^Keep in contact with family and friends^^CHI-PA^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2241,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2242,0)
 ;;=10^Discuss sibs reactions to baby's exploration^^CHI-PA^244^335^^^^^1^^8^11
 ;;^UTILITY(U,$J,19707.12,2242,2)
 ;;=^^CHI-PA
 ;;^UTILITY(U,$J,19707.12,2243,0)
 ;;=11^Avoid or limit TV viewing^^CHT-PA^335^396^^^^^1^^11^13
