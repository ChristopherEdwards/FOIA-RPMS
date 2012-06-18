VENKI01B ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,2939,0)
 ;;=23^Alcohol consequences when driving, biking, swimming, operating machinery^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2940,0)
 ;;=23^Plan to rise with designated driver or call for ride if drinking^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2941,0)
 ;;=23^Limit sun, use sun screen, avoid tanning salons^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2942,0)
 ;;=23^Know fire and other emergency procedures^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2943,0)
 ;;=23^Use helmet on bikes or motorcycles^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2944,0)
 ;;=23^Use protective sports gear^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2945,0)
 ;;=23^Use protective gear at work, follow job safety rules^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2946,0)
 ;;=23^Avoid high noise levels, especially with earphones^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2947,0)
 ;;=23^Don't carry or use weapons^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2948,0)
 ;;=23^Learn to protect self from abuse^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2949,0)
 ;;=23^Deal with anger, resolve conflicts without violence^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2950,0)
 ;;=23^Personal safety - strangers, chat rooms^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2951,0)
 ;;=23^Driver's Ed^^^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2952,0)
 ;;=22^Take on new challenges to build confidence.^^CHA-BH^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2952,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2953,0)
 ;;=22^Continue to develop sense of identity and clarify values, beliefs^^CHA-BH^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2953,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2954,0)
 ;;=22^Trust own feelings, listen to good friends and valued adults^^CHA-BH^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2954,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2955,0)
 ;;=22^Seek help if often feel angry, depressed or hopeless^^CHA-BH^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2955,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2956,0)
 ;;=22^Set reasonable and challenging goals^^CHA-BH^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2956,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2957,0)
 ;;=22^Recognize and deal with stress^^CHA-BH^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2957,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2958,0)
 ;;=22^Understand and meet spiritual needs^^CHA-BH^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2958,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2959,0)
 ;;=22^Self-destructive behaviors^^CHA-BH^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2959,2)
 ;;=^^CH-BH
 ;;^UTILITY(U,$J,19707.12,2960,0)
 ;;=14^Eat 3 nutritious meals a day at regular times^^CHA-N^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2960,2)
 ;;=^^CH-N
 ;;^UTILITY(U,$J,19707.12,2961,0)
 ;;=14^Limit high-fat and high-sugar foods^^CHA-N^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2961,2)
 ;;=^^CH-N
 ;;^UTILITY(U,$J,19707.12,2962,0)
 ;;=14^Healthy diet - 1: Fruits, vegetables; less breads, cereals, grains^^CHA-N^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2962,2)
 ;;=^^CH-N
 ;;^UTILITY(U,$J,19707.12,2963,0)
 ;;=14^Healthy diet - 2:, Chicken, fish, only lean meat and low-fat dairy products^^CHA-N^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2963,2)
 ;;=^^CH-N
 ;;^UTILITY(U,$J,19707.12,2964,0)
 ;;=14^Maintain healthy weight with good nutrition and activity^^CHA-N^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2964,2)
 ;;=^^CH-N
 ;;^UTILITY(U,$J,19707.12,2965,0)
 ;;=14^Eat in pleasant surroundings with companions^^CHA-N^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2965,2)
 ;;=^^CH-N
 ;;^UTILITY(U,$J,19707.12,2966,0)
 ;;=15^Brush and floss daily^^CHA-DC^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2966,2)
 ;;=^^CH-DC
 ;;^UTILITY(U,$J,19707.12,2967,0)
 ;;=15^Learn emergency dental care^^CHA-DC^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2967,2)
 ;;=^^CH-DC
 ;;^UTILITY(U,$J,19707.12,2968,0)
 ;;=15^Schedule dental appointment^^CHA-DC^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2968,2)
 ;;=^^CH-DC
 ;;^UTILITY(U,$J,19707.12,2969,0)
 ;;=15^Ask dentist to check wisdom teeth^^CHA-DC^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2969,2)
 ;;=^^CH-DC
 ;;^UTILITY(U,$J,19707.12,2970,0)
 ;;=15^Don't smoke or chew tobacco^^CHA-DC^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2970,2)
 ;;=^^CH-DC
 ;;^UTILITY(U,$J,19707.12,2971,0)
 ;;=17^Contraception^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2971,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2972,0)
 ;;=17^STD prevention^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2972,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2973,0)
 ;;=17^Gay, lesbian, bisexual issues^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2973,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2974,0)
 ;;=17^Discuss other questions and concerns^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2974,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2975,0)
 ;;=17^Delay having sex until older^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2975,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2976,0)
 ;;=17^Celibacy^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2976,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2977,0)
 ;;=17^Having sex should be a well-thought-out decision^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2977,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2978,0)
 ;;=17^Learn how to resist sexual pressures^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2978,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2979,0)
 ;;=17^Abstinence is still the safest way to prevent both pregnancy and STD^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2979,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2980,0)
 ;;=17^If sexually active, discuss contraception, safer sex, STD prevention^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2980,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2981,0)
 ;;=17^Limit sexual partners^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2981,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2982,0)
 ;;=17^Use latex condoms and other barriers correctly^^CHA-SX^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2982,2)
 ;;=^^CH-SX
 ;;^UTILITY(U,$J,19707.12,2983,0)
 ;;=26^Don't use tobacco, alcohol, drugs, diet pills, inhalants^^CHA-AOD^6100^7686^^^^^0^^200^252
 ;;^UTILITY(U,$J,19707.12,2983,2)
 ;;=^^CH-AOD
 ;;^UTILITY(U,$J,19707.12,2984,0)
 ;;=26^Don't sell drugs^^CHA-AOD^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2984,2)
 ;;=^^CH-AOD
 ;;^UTILITY(U,$J,19707.12,2985,0)
 ;;=26^If using tobacco, drugs or alcohol, discuss available help, seek assistance^^CHA-AOD^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2985,2)
 ;;=^^CH-AOD
 ;;^UTILITY(U,$J,19707.12,2986,0)
 ;;=26^Support friends who choose not to smoke, drink, use drugs^^CHA-AOD^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2986,2)
 ;;=^^CH-AOD
 ;;^UTILITY(U,$J,19707.12,2987,0)
 ;;=18^Continue to maintain strong family relationships. ^^CHA-PA^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2987,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2988,0)
 ;;=18^Develop good peer relationships and social support systems^^CHA-PA^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2988,2)
 ;;=^^CH-PA
 ;;^UTILITY(U,$J,19707.12,2989,0)
 ;;=18^Use peer refusal skills to handle negative peer pressure^^CHA-PA^6100^7686^^^^^1^^200^252
 ;;^UTILITY(U,$J,19707.12,2989,2)
 ;;=^^CH-PA
