VENKI01A ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,2891,2)
 ;;=^^CHA-AOD
 ;;^UTILITY(U,$J,19707.12,2892,0)
 ;;=26^If using tobacco, drugs or alcohol, discuss available help, seek assistance^^CHA-AOD^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2892,2)
 ;;=^^CHA-AOD
 ;;^UTILITY(U,$J,19707.12,2893,0)
 ;;=26^Avoid situations where drugs or alcohol are present^^CHA-AOD^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2893,2)
 ;;=^^CHA-AOD
 ;;^UTILITY(U,$J,19707.12,2894,0)
 ;;=18^Enjoy family activities^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2894,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2895,0)
 ;;=18^Participate in social activities, community groups, team sports^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2895,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2896,0)
 ;;=18^Respect parental limits and consequences for behavior^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2896,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2897,0)
 ;;=18^Discuss handling negative peer pressure^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2897,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2898,0)
 ;;=18^Continue to build decision-making skills, understand consequences of behavior^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2898,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2899,0)
 ;;=18^Importance of listening and communicating^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2899,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2900,0)
 ;;=24^Respect rights and needs of others^^CHA-BH^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2900,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2901,0)
 ;;=24^Follow family rules (curfew, car)^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2901,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2902,0)
 ;;=24^Share in household chores^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2902,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2903,0)
 ;;=24^Take on new responsibilities^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2903,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2904,0)
 ;;=24^Learn new skills (lifesaving, mentoring)^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2904,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2905,0)
 ;;=24^Discuss taking responsibility for own health and using preventive services^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2905,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2906,0)
 ;;=24^Increased independence and decision making^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2906,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2907,0)
 ;;=25^Be responsible for attendance, homework, course selection^^CHA-BH^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2907,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2908,0)
 ;;=25^Discuss frustrations or thoughts of dropping out^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2908,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2909,0)
 ;;=25^Participate in school activities^^CHA-BH^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2909,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2910,0)
 ;;=25^Identify  and pursue talents and interests^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2910,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2911,0)
 ;;=25^Make plans for after high school^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2911,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2912,0)
 ;;=19^Ask for resources or referrals if needed^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2912,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2913,0)
 ;;=19^Discuss current events^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2913,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2914,0)
 ;;=19^Explore cultural heritage, diversity^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2914,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2915,0)
 ;;=19^Advocate for community programs^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2915,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2916,0)
 ;;=19^Ask about health programs and services in school^^CHA-BH^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2916,2)
 ;;=^^CHA-BH
 ;;^UTILITY(U,$J,19707.12,2917,0)
 ;;=21^Show affection and praise good behavior^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2917,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2918,0)
 ;;=21^Model respect, family values, safe driving practices, healthy behaviors^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2918,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2919,0)
 ;;=21^Respect teen's need for privacy^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2919,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2920,0)
 ;;=21^Establish realistic expectations, clear limits, consequences.^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2920,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2921,0)
 ;;=21^Anticipate challenges to parental authority^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2921,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2922,0)
 ;;=21^Minimize criticism.  Avoid nagging and negative messages^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2922,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2923,0)
 ;;=21^Emphasize importance of school, show interest in school activities^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2923,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2924,0)
 ;;=21^Ask for resources or referrals if needed^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2924,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2925,0)
 ;;=21^Keep guns unloaded and locked up, or remove from home.^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2925,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2926,0)
 ;;=21^Normal development^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2926,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2927,0)
 ;;=21^Signs of emotional/physical disease^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2927,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2928,0)
 ;;=21^Be a healthy  role model^^CHA-PA^4880^6100^^^^^1^^160^200
 ;;^UTILITY(U,$J,19707.12,2928,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2929,0)
 ;;=21^Help teens avoid harmful behaviors (drugs, alcohol, tobacco or sex)^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2929,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2930,0)
 ;;=21^Spend time with adolescent^^CHA-PA^4880^6100^^^^^0^^160^200
 ;;^UTILITY(U,$J,19707.12,2930,2)
 ;;=^^CHA-PA
 ;;^UTILITY(U,$J,19707.12,2931,0)
 ;;=11^Keep home and car smoke-free^^CHA-PA^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2931,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2932,0)
 ;;=11^Try to get 8 hours of sleep a night^^CHA-PA^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2932,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2933,0)
 ;;=11^Engage in physical activity 30-60 minutes 3+ times a week^^CHA-PA^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2933,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2934,0)
 ;;=11^Athletic conditioning, weights, fluids, weight gain/loss, supplements^^CHA-PA^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2934,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2935,0)
 ;;=11^Time management^^CHA-PA^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2935,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2936,0)
 ;;=23^Use lap and shoulder belt in car; be sure passengers wear them too^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2937,0)
 ;;=23^Follow speed limits, drive responsibly, avoid distractions^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2938,0)
 ;;=23^Don't drink alcohol^^^6100^7686^^^^^1^^200^252
