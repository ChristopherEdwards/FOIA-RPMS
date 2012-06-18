VENKI00S ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,1985,0)
 ;;=12^Cord care, circumcision, skin and nails^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1985,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1986,0)
 ;;=12^Burping, hiccoughs, spitting up, colic^^CHN-I^0^7^^^^^0^^0^.25
 ;;^UTILITY(U,$J,19707.12,1986,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1987,0)
 ;;=12^Thumbsucking, pacifiers ^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1987,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1988,0)
 ;;=12^Crying^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1988,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1989,0)
 ;;=12^Sleeping^^CHN-I^0^7^^^^^0^^0^.25
 ;;^UTILITY(U,$J,19707.12,1989,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1990,0)
 ;;=12^Stools^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1990,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1991,0)
 ;;=12^Thermometer use^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1991,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1992,0)
 ;;=12^Clothing^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1992,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1993,0)
 ;;=12^Vaginal discharge/bleeding^^CHN-I^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1993,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,1994,0)
 ;;=16^Learn baby temperament^^CHN-PA^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1994,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,1995,0)
 ;;=16^Consoling baby -- cuddle, rock^^CHN-PA^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1995,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,1996,0)
 ;;=10^Encourage partner help^^CHN-PA^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1996,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,1997,0)
 ;;=10^Rest when baby sleeps^^CHN-PA^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1997,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,1998,0)
 ;;=10^Recognize fatigue, depression^^CHN-PA^0^7^^^^^0^^0^.25
 ;;^UTILITY(U,$J,19707.12,1998,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,1999,0)
 ;;=10^Accepting support from others (family, friends, professionals)^^CHN-PA^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,1999,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2000,0)
 ;;=10^Prepare for sibling reactions^^CHN-PA^0^7^^^^^1^^0^.25
 ;;^UTILITY(U,$J,19707.12,2000,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2001,0)
 ;;=10^Resources - financial, medical, WIC^^CHN-PA^0^7^^^^^0^^0^.25
 ;;^UTILITY(U,$J,19707.12,2001,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2002,0)
 ;;=13^Car seat, rear facing, in rear seat, NEVER in front seat with air bag^^CHN-S^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2002,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2003,0)
 ;;=13^Crib safety (slats less than 2 3/8" apart)^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2003,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2004,0)
 ;;=13^SIDS --Back to Sleep, No soft bedding or toys, Not too warm^^CHN-S^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2004,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2005,0)
 ;;=13^Water heater <120^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2005,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2006,0)
 ;;=13^Never shake baby^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2006,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2007,0)
 ;;=13^Keep home and car smoke-free^^CHN-S^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2007,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2008,0)
 ;;=13^Install and check smoke alarms^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2008,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2009,0)
 ;;=13^Keep hot liquids away from baby^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2009,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2010,0)
 ;;=13^Don't leave baby alone in tub or high places; always keep a hand on baby^^CHN-S^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2010,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2011,0)
 ;;=13^Don't smoke or use drugs; moderate alcohol^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2011,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2012,0)
 ;;=13^Avoid direct sun^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2012,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2013,0)
 ;;=13^Wash hands often^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2013,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2014,0)
 ;;=13^Signs of illness-1: fever >100.4, seizure, rash, irritability, lethargy^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2014,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2015,0)
 ;;=13^Signs of illness-2: failure to eat, vomiting, diarrhea, jaundice, dehydration^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2015,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2016,0)
 ;;=13^Signs of illness-3: apnea, cyanosis^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2016,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2017,0)
 ;;=13^Review emergency procedures^^CHN-S^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2017,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2018,0)
 ;;=13^When to call clinic^^CHN-S^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2018,2)
 ;;=^^CHN-S
 ;;^UTILITY(U,$J,19707.12,2019,0)
 ;;=14^Breastfeed on demand or bottle feed with iron-fortified formula^^CHN-N^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2019,2)
 ;;=^^CHN-N
 ;;^UTILITY(U,$J,19707.12,2020,0)
 ;;=14^Don't warm bottles in microwave^^CHN-N^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2020,2)
 ;;=^^CHN-N
 ;;^UTILITY(U,$J,19707.12,2021,0)
 ;;=14^No bottle propping^^CHN-N^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2021,2)
 ;;=^^CHN-N
 ;;^UTILITY(U,$J,19707.12,2022,0)
 ;;=14^Feed in semi-sitting position^^CHN-N^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2022,2)
 ;;=^^CHN-N
 ;;^UTILITY(U,$J,19707.12,2023,0)
 ;;=15^Don't put baby to bed with bottle^^CHN-DC^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2023,2)
 ;;=^^CHN-DC
 ;;^UTILITY(U,$J,19707.12,2024,0)
 ;;=15^Practice good family oral health habits^^CHN-DC^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2024,2)
 ;;=^^CHN-DC
 ;;^UTILITY(U,$J,19707.12,2025,0)
 ;;=12^Cord care, circumcision, skin and nails^^CHN-I^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2025,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2026,0)
 ;;=12^Burping, hiccoughs, spitting up, colic^^CHN-I^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2026,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2027,0)
 ;;=12^Thumbsucking, pacifiers ^^CHN-I^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2027,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2028,0)
 ;;=12^Crying^^CHN-I^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2028,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2029,0)
 ;;=12^Sleeping^^CHN-I^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2029,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2030,0)
 ;;=12^Stools^^CHN-I^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2030,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2031,0)
 ;;=12^Thermometer use^^CHN-I^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2031,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2032,0)
 ;;=12^Clothing^^CHN-I^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2032,2)
 ;;=^^CHN-I
 ;;^UTILITY(U,$J,19707.12,2033,0)
 ;;=16^Learn baby's temperament^^CHN-PA^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2033,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2034,0)
 ;;=16^Try to console baby - crying peaks at 6 weeks^^CHN-PA^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2034,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2035,0)
 ;;=16^Hold, cuddle, play, talk, sing to baby^^CHN-PA^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2035,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2036,0)
 ;;=10^Take time to rest^^CHN-PA^7^30^^^^^1^^.25^1
 ;;^UTILITY(U,$J,19707.12,2036,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2037,0)
 ;;=10^Take time for self and partner^^CHN-PA^7^30^^^^^0^^.25^1
 ;;^UTILITY(U,$J,19707.12,2037,2)
 ;;=^^CHN-PA
 ;;^UTILITY(U,$J,19707.12,2038,0)
 ;;=10^Encourage partner help^^CHN-PA^7^30^^^^^1^^.25^1
