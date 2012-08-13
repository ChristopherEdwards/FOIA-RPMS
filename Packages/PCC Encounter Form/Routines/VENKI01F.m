VENKI01F ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,3249,0)
 ;;=29^Menstruating girls: anemia screen^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3250,0)
 ;;=29^Girls with amenorrhea or menstrual complaints: pelvic exam^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3251,0)
 ;;=29^Boys: assess risk of testicular cancer (hx of cryptorchidism, single testicle)^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3252,0)
 ;;=29^Family history acanthosis, obesity: Lipid screen^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3253,0)
 ;;=29^At risk for TB: PPD^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3254,0)
 ;;=29^Sexually-active: needs annual STD screening (urine for GC and Chlamydia)^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3255,0)
 ;;=29^Athletes: significant injuries^^^3843^4880^^^^^^^126^160
 ;;^UTILITY(U,$J,19707.12,3257,0)
 ;;=27^Tanner Stage^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3258,0)
 ;;=27^Scoliosis or kyphosis (Females at Tanner 2, Males Tanner 3-4)^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3259,0)
 ;;=27^Evidence of neglect/abuse^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3260,0)
 ;;=27^Eating disorders/obesity^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3261,0)
 ;;=27^Orthopedic problems, sports injuries^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3262,0)
 ;;=27^Teeth (eg orthodontia needs, caries)^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3263,0)
 ;;=27^Acne^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3264,0)
 ;;=27^Tattoos, piercing^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3265,0)
 ;;=27^Excessive body hair^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3266,0)
 ;;=27^Girls:  Examine genitalia, condyloma, vaginitis, teach breast self-exam^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3267,0)
 ;;=27^Boys:  Testicular self exam, varicocele, hernia, condyloma, gynecomastia^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3268,0)
 ;;=28^Vision and hearing (age 15)^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3269,0)
 ;;=28^BP annually^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3270,0)
 ;;=28^UA, once in adolescence^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3271,0)
 ;;=28^Immunization review/update per current AAP guidelines^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3272,0)
 ;;=30^Stressors^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3273,0)
 ;;=30^Substance use (including tobacco)^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3274,0)
 ;;=30^Sexual behavior^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3275,0)
 ;;=30^Cruelty, history of abuse^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3276,0)
 ;;=30^Depression, suicide risk^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3277,0)
 ;;=30^School/learning problems^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3278,0)
 ;;=29^Menstruating girls: anemia screen^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3279,0)
 ;;=29^Girls with amenorrhea or menstrual complaints: pelvic exam^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3280,0)
 ;;=29^Boys: assess risk of testicular cancer (hx of cryptorchidism, single testicle)^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3281,0)
 ;;=29^Family history acanthosis, obesity: Lipid screen^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3282,0)
 ;;=29^At risk for TB: PPD^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3283,0)
 ;;=29^Sexually-active: needs annual STD screening (urine for GC and Chlamydia)^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3284,0)
 ;;=29^Athletes: significant injuries^^^4880^6100^^^^^^^160^200
 ;;^UTILITY(U,$J,19707.12,3286,0)
 ;;=27^Tanner Stage^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3287,0)
 ;;=27^Scoliosis or kyphosis (Females at Tanner 2, Males Tanner 3-4)^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3288,0)
 ;;=27^Evidence of neglect/abuse^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3289,0)
 ;;=27^Eating disorders/obesity^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3290,0)
 ;;=27^Orthopedic problems, sports injuries^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3291,0)
 ;;=27^Teeth (eg orthodontia needs, caries)^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3292,0)
 ;;=27^Acne^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3293,0)
 ;;=27^Tattoos, piercing^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3294,0)
 ;;=27^Excessive body hair^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3295,0)
 ;;=27^Girls:  Examine genitalia, condyloma, vaginitis, teach breast self-exam^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3296,0)
 ;;=27^Boys:  Testicular self exam, varicocele, hernia, condyloma, gynecomastia^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3297,0)
 ;;=28^Vision and hearing (age 18)^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3298,0)
 ;;=28^BP annually^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3299,0)
 ;;=28^UA once in adolescence^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3300,0)
 ;;=28^Immunization review/update per current AAP guidelines^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3301,0)
 ;;=30^Stressors^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3302,0)
 ;;=30^Substance use (including tobacco)^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3303,0)
 ;;=30^Sexual behavior^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3304,0)
 ;;=30^Cruelty, history of abuse^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3305,0)
 ;;=30^Depression, suicide risk^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3306,0)
 ;;=30^School/learning problems^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3307,0)
 ;;=29^Menstruating girls: annual anemia screen^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3308,0)
 ;;=29^Girls with amenorrhea or menstrual complaints: pelvic exam^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3309,0)
 ;;=29^Girls over age 20: Pap q3years starting age 21^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3310,0)
 ;;=29^Boys: assess risk of testicular cancer (hx of cryptorchidism, single testicle)^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3311,0)
 ;;=29^Family history acanthosis, obesity: Lipid screen^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3312,0)
 ;;=29^At risk for TB: PPD^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3313,0)
 ;;=29^Sexually-active: needs annual STD screening (urine for GC and Chlamydia)^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3314,0)
 ;;=29^Athletes: significant injuries^^^6100^7686^^^^^^^200^252
 ;;^UTILITY(U,$J,19707.12,3315,0)
 ;;=34^Bang 2 Cubes^wcdfm110^^213^228^^^^^0^30^7.0^7.5^^1
 ;;^UTILITY(U,$J,19707.12,3316,0)
 ;;=34^Bang 2 Cubes^wcdfm111^^228^244^^^^^0^50^7.5^8^^1
 ;;^UTILITY(U,$J,19707.12,3317,0)
 ;;=34^Bang 2 Cubes^wcdfm112^^244^259^^^^^0^55^8.0^8.5^^1
 ;;^UTILITY(U,$J,19707.12,3318,0)
 ;;=34^Bang 2 Cubes^wcdfm113^^259^274^^^^^0^60^8.5^9^^1
 ;;^UTILITY(U,$J,19707.12,3319,0)
 ;;=34^Bang 2 Cubes^wcdfm114^^274^289^^^^^0^65^9.0^9.5^^1
 ;;^UTILITY(U,$J,19707.12,3320,0)
 ;;=34^Bang 2 Cubes^wcdfm115^^289^305^^^^^0^70^9.5^10^^1
 ;;^UTILITY(U,$J,19707.12,3321,0)
 ;;=34^Bang 2 Cubes^wcdfm116^^305^320^^^^^0^75^10.0^10.5^^1
 ;;^UTILITY(U,$J,19707.12,3322,0)
 ;;=34^Bang 2 Cubes^wcdfm117^^320^335^^^^^0^80^10.5^11^^1
 ;;^UTILITY(U,$J,19707.12,3323,0)
 ;;=34^Bang 2 Cubes^wcdfm118^^335^350^^^^^0^90^11.0^11.5^^1
 ;;^UTILITY(U,$J,19707.12,3324,0)
 ;;=34^Bang 2 Cubes^wcdfm119^^350^366^^^^^0^100^11.5^12^^1
 ;;^UTILITY(U,$J,19707.12,3325,0)
 ;;=34^Bang 2 Cubes^wcdfm120^^366^381^^^^^0^100^12.0^12.5^^1
