VENKI005 ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12)
 ;;=^VEN(7.12,
 ;;^UTILITY(U,$J,19707.12,0)
 ;;=VEN EHP KB ITEM^19707.12P^5169^5150
 ;;^UTILITY(U,$J,19707.12,1,0)
 ;;=6^Accidents are a major cause of death^wcpe1^CHI-S01^0^793^^^^^1^^0^26
 ;;^UTILITY(U,$J,19707.12,1,2)
 ;;=^^CHT-S
 ;;^UTILITY(U,$J,19707.12,2,0)
 ;;=6^Adolesence earlier in females^wcpe2^CHA-SX3^2897^3019^^^^^1^^95^99
 ;;^UTILITY(U,$J,19707.12,3,0)
 ;;=6^Age appropriate recreational activities^wcpe3^CHS-S3^1982^2745^^^^^1^^65^90
 ;;^UTILITY(U,$J,19707.12,4,0)
 ;;=6^Alternatives to TV^wcpe4^CHS-PA3^823^2928^^^^^1^^27^96
 ;;^UTILITY(U,$J,19707.12,5,0)
 ;;=6^Always supervised around water^wcpe5^CHP-S11^732^2379^^^^^1^^24^78
 ;;^UTILITY(U,$J,19707.12,6,0)
 ;;=6^Avoid high noise levels^wcpe6^CHA-S8^2897^3172^^^^^1^^95^104
 ;;^UTILITY(U,$J,19707.12,7,0)
 ;;=6^Back or side to sleep^wcpe7^CHI-S04^0^335^^^^^1^^0^11
 ;;^UTILITY(U,$J,19707.12,8,0)
 ;;=6^Benefits of abstinence^wcpe8^CHA-SX5^2958^3172^^^^^1^^97^104
 ;;^UTILITY(U,$J,19707.12,9,0)
 ;;=6^Bicycle safety, including helmet^wcpe9^CHS-S7^2409^2897^^^^^1^^79^95
 ;;^UTILITY(U,$J,19707.12,10,0)
 ;;=6^Burn prevention around house^wcpe10^CHP-S12^396^1647^^^^^1^^13^54
 ;;^UTILITY(U,$J,19707.12,11,0)
 ;;=6^Car Seat^wcpe11^CHT-SAFETY^0^2775^^^^^1^^0^91
 ;;^UTILITY(U,$J,19707.12,12,0)
 ;;=6^Care with ingestable substances/objects^wcpe12^CHI-S06^213^488^^^^^1^^7^16
 ;;^UTILITY(U,$J,19707.12,13,0)
 ;;=6^Child-proof home^wcpe13^CHI-S05^0^183^^^^^1^^0^6
 ;;^UTILITY(U,$J,19707.12,14,0)
 ;;=6^Dental hygeine^wcpe14^CHA-WELLNESS^213^3172^^^^^1^^7^104
 ;;^UTILITY(U,$J,19707.12,15,0)
 ;;=6^Do not carry or use any weapon^wcpe15^CHA-S6^2958^3172^^^^^1^^97^104
 ;;^UTILITY(U,$J,19707.12,16,0)
 ;;=6^Do not leave child unattended^wcpe16^CHI-S16^0^457^^^^^1^^0^15
 ;;^UTILITY(U,$J,19707.12,17,0)
 ;;=6^Do not use alcohol, tobacco or drugs^wcpe17^CHA-S7^2897^3172^^^^^1^^95^104
 ;;^UTILITY(U,$J,19707.12,18,0)
 ;;=6^Don't leave young siblings or pets with baby^wcpe18^CHI-S12^0^244^^^^^1^^0^8
 ;;^UTILITY(U,$J,19707.12,19,0)
 ;;=6^Driver's ed/drive responsibly^wcpe19^CHA-S2^3050^3172^^^^^1^^100^104
 ;;^UTILITY(U,$J,19707.12,20,0)
 ;;=6^Encourage identification programs^wcpe20^CHP-S06^823^2013^^^^^1^^27^66
 ;;^UTILITY(U,$J,19707.12,21,0)
 ;;=6^Helmet/protective gear for sports^wcpe21^CHA-S1^1677^3172^^^^^1^^55^104
 ;;^UTILITY(U,$J,19707.12,22,0)
 ;;=6^Importance of communicating and listening^wcpe22^CHA-PA2^2958^3172^^^^^1^^97^104
 ;;^UTILITY(U,$J,19707.12,23,0)
 ;;=6^Increased independence and decision making^wcpe23^CHA-PA4^2958^3172^^^^^1^^97^104
 ;;^UTILITY(U,$J,19707.12,24,0)
 ;;=6^Increased independence, risk for accidents^wcpe24^CHP-S01^823^1616^^^^^1^^27^53
 ;;^UTILITY(U,$J,19707.12,25,0)
 ;;=6^Ipecac at home^wcpe25^WL-S2^396^2348^^^^^^^13^77
 ;;^UTILITY(U,$J,19707.12,26,0)
 ;;=6^Learn First-Aid and CPR^wcpe26^CHI-S14^0^488^^^^^1^^0^16
 ;;^UTILITY(U,$J,19707.12,27,0)
 ;;=6^Locked doors/gates around stairs^wcpe27^CHP-S09^396^1952^^^^^1^^13^64
 ;;^UTILITY(U,$J,19707.12,28,0)
 ;;=6^Never jiggle or shake a baby^wcpe28^CHI-S15^0^122^^^^^1^^0^4
 ;;^UTILITY(U,$J,19707.12,29,0)
 ;;=6^Never leave unattended (car/home)^wcpe29^CHP-S13^1128^1647^^^^^1^^37^54
 ;;^UTILITY(U,$J,19707.12,30,0)
 ;;=6^No Walkers^wcpe30^CHI-S03^213^488^^^^^1^^7^16
 ;;^UTILITY(U,$J,19707.12,31,0)
 ;;=6^Outlet covers, electrical cord safety^wcpe31^CHP-S08^396^1952^^^^^1^^13^64
 ;;^UTILITY(U,$J,19707.12,32,0)
 ;;=6^Personal safety-strangers, chat rooms, etc^wcpe32^CHA-S4^2897^3172^^^^^1^^95^104
 ;;^UTILITY(U,$J,19707.12,33,0)
 ;;=6^Physical changes of adolescence^wcpe33^CHA-SX-1^2958^3141^^^^^1^^97^103
 ;;^UTILITY(U,$J,19707.12,34,0)
 ;;=6^Poison proof home^wcpe34^WL-S3^732^1647^^^^^^^24^54
 ;;^UTILITY(U,$J,19707.12,35,0)
 ;;=6^Safety devices on cabinets^wcpe35^CHT-S^579^1952^^^^^1^^19^64
 ;;^UTILITY(U,$J,19707.12,35,2)
 ;;=^^CHT-S
 ;;^UTILITY(U,$J,19707.12,36,0)
 ;;=6^Seat belt use^wcpe36^WL-S1^2806^3172^^^^^^^92^104
 ;;^UTILITY(U,$J,19707.12,37,0)
 ;;=6^Select safe child-care settings^wcpe37^CHI-S13^91^793^^^^^1^^3^26
 ;;^UTILITY(U,$J,19707.12,38,0)
 ;;=6^Self destructive behaviors^wcpe38^CHA-S5^2897^3172^^^^^1^^95^104
 ;;^UTILITY(U,$J,19707.12,39,0)
 ;;=6^Self-image and peer pressure^wcpe39^CHA-PA1^2958^3172^^^^^1^^97^104
 ;;^UTILITY(U,$J,19707.12,40,0)
 ;;=6^Sexuality, birth control, and STDs^wcpe40^CHA-SX4^2958^3172^^^^^1^^97^104
 ;;^UTILITY(U,$J,19707.12,41,0)
 ;;=6^Teach caution with strangers^wcpe41^CHS-S5^1677^2745^^^^^1^^55^90
 ;;^UTILITY(U,$J,19707.12,42,0)
 ;;=6^Teach full name, address, phone.^wcpe42^CHS-S6^1677^2745^^^^^1^^55^90
 ;;^UTILITY(U,$J,19707.12,43,0)
 ;;=6^Teach safety in driveway and street^wcpe43^CHT-SAFETY^1128^2379^^^^^1^^37^78
 ;;^UTILITY(U,$J,19707.12,44,0)
 ;;=7^2 snacks/day^wcn44^CHT-DT^2013^2806^^^^^1^^66^92
 ;;^UTILITY(U,$J,19707.12,44,2)
 ;;=^^CHT-DT
 ;;^UTILITY(U,$J,19707.12,45,0)
 ;;=7^2-3 snacks a day^wcn45^CHT-DT^762^1982^^^^^1^^25^65
 ;;^UTILITY(U,$J,19707.12,45,2)
 ;;=^^CHT-DT
 ;;^UTILITY(U,$J,19707.12,46,0)
 ;;=7^3 meals/day^wcn46^^2013^2989^^^^^^^66^98
 ;;^UTILITY(U,$J,19707.12,47,0)
 ;;=7^Achieve and maintain a healthy weight^wcn47^^2928^2989^^^^^^^96^98
 ;;^UTILITY(U,$J,19707.12,48,0)
 ;;=7^Add new food weekly^wcn48^^244^366^^^^^^^8^12
 ;;^UTILITY(U,$J,19707.12,49,0)
 ;;=7^Allow child to feed self^wcn49^^762^1250^^^^^^^25^41
 ;;^UTILITY(U,$J,19707.12,50,0)
 ;;=7^Anticipate imitation of peer's likes and dislikes^wcn50^^1982^2379^^^^^^^65^78
 ;;^UTILITY(U,$J,19707.12,51,0)
 ;;=7^Anticipate sporadic eating habits^wcn51^^762^915^^^^^^^25^30
 ;;^UTILITY(U,$J,19707.12,52,0)
 ;;=7^Avoid foods that can be aspirated^wcn52^^396^1281^^^^^^^13^42
 ;;^UTILITY(U,$J,19707.12,53,0)
 ;;=7^Avoid items high in sugar^wcn53^^762^915^^^^^^^25^30
 ;;^UTILITY(U,$J,19707.12,54,0)
 ;;=7^Avoid junk food and high carb snacks^wcn54^^2409^2867^^^^^^^79^94
 ;;^UTILITY(U,$J,19707.12,55,0)
 ;;=7^Begin weaning^wcn55^^762^884^^^^^^^25^29
 ;;^UTILITY(U,$J,19707.12,56,0)
 ;;=7^Bottle feeding:^wcn56^^244^518^^^^^^^8^17
 ;;^UTILITY(U,$J,19707.12,57,0)
 ;;=7^Breastfeeding: Adequate maternal diet?^wcn57^^0^122^^^^^0^^0^4
 ;;^UTILITY(U,$J,19707.12,58,0)
 ;;=7^Breastfeeding: Frequency, Satisfaction^wcn58^^0^122^^^^^0^^0^4
 ;;^UTILITY(U,$J,19707.12,59,0)
 ;;=7^Breastfeeding: Problems^wcn59^^0^122^^^^^0^^0^4
 ;;^UTILITY(U,$J,19707.12,60,0)
 ;;=7^Breastfeeding: Supplement?^wcn60^^0^122^^^^^0^^0^4
 ;;^UTILITY(U,$J,19707.12,61,0)
 ;;=7^Can start solid foods:^wcn61^^244^366^^^^^^^8^12
 ;;^UTILITY(U,$J,19707.12,62,0)
 ;;=7^Change to whole milk, 16-24oz/day^wcn62^^762^884^^^^^^^25^29
 ;;^UTILITY(U,$J,19707.12,63,0)
 ;;=7^Choose nutritious snacks^wcn63^^2836^2989^^^^^^^93^98
 ;;^UTILITY(U,$J,19707.12,64,0)
 ;;=7^Continue breast or bottle until 12 months^wcn64^^213^732^^^^^^^7^24
 ;;^UTILITY(U,$J,19707.12,65,0)
 ;;=7^Decreased appetite^wcn65^^762^1037^^^^^^^25^34
 ;;^UTILITY(U,$J,19707.12,66,0)
 ;;=7^Discourage use as a pacifier^wcn66^^396^518^^^^^^^13^17
 ;;^UTILITY(U,$J,19707.12,67,0)
 ;;=7^Do not put infant in crib with bottle^wcn67^^244^518^^^^^^^8^17
 ;;^UTILITY(U,$J,19707.12,68,0)
 ;;=7^Eat meals with family on a regular basis^wcn68^^2958^2989^^^^^^^97^98
 ;;^UTILITY(U,$J,19707.12,69,0)
 ;;=7^Encourage drinking from cup^wcn69^^396^732^^^^^^^13^24
 ;;^UTILITY(U,$J,19707.12,70,0)
 ;;=7^Ensure balanced diet^wcn70^CHT-DT^1525^1982^^^^^1^^50^65
 ;;^UTILITY(U,$J,19707.12,70,2)
 ;;=^^CHT-DT
 ;;^UTILITY(U,$J,19707.12,71,0)
 ;;=7^Explain nursing caries and otitis media^wcn71^^396^518^^^^^^^13^17
 ;;^UTILITY(U,$J,19707.12,72,0)
 ;;=7^Feed at family mealtimes, make enjoyable^wcn72^^762^2379^^^^^^^25^78
 ;;^UTILITY(U,$J,19707.12,73,0)
 ;;=7^Feeding intervals at 3-4 hours during day^wcn73^^152^274^^^^^^^5^9
