VENKI01D ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQR(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,19707.12,3060,0)
 ;;=9^Have you ever wondered if he/she is deaf?^^^732^1098^^^^^^^24^36
 ;;^UTILITY(U,$J,19707.12,3061,0)
 ;;=9^Sometimes stares at nothing or wanders with no purpose?^^^732^1098^^^^^^^24^36
 ;;^UTILITY(U,$J,19707.12,3063,0)
 ;;=27^TPR^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3064,0)
 ;;=27^Skin - mottling, erythema toxicum, pallor, jaundice, cyanosis^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3065,0)
 ;;=27^Birthmarks (hemangioma, nevi, Mongolian spots)^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3066,0)
 ;;=27^Head - shape, size, trauma^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3067,0)
 ;;=27^Eyes - red reflex, puffy, subconj hemorrhage, strabismus, dacryostenosis^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3068,0)
 ;;=27^ENT - Ear shape, patent nares, intact palate^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3069,0)
 ;;=27^Resp - tachypnea, retraction, air movement^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3070,0)
 ;;=27^Heart - murmur, femoral pulses^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3071,0)
 ;;=27^Abd - mass, distention, genitalia, rectum, cord^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3072,0)
 ;;=27^MS - spine, clavicles, hips, foot abnormalities^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3073,0)
 ;;=27^Neuro - Moro, tone, symmetry, suck/swallow, response to voice, follow face^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3074,0)
 ;;=28^NB screen^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3075,0)
 ;;=28^Hearing screen^^^0^7^^^^^^^0^.25
 ;;^UTILITY(U,$J,19707.12,3077,0)
 ;;=27^Skin- jaundice, pallor, dehydration, ^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3078,0)
 ;;=27^Neuro - irritability, lethargy, tone^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3079,0)
 ;;=27^Tachycardia, tachypnea, femoral pulses^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3080,0)
 ;;=27^Murmurs^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3081,0)
 ;;=27^Abd distension, cord, testes^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3082,0)
 ;;=27^Hips^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3083,0)
 ;;=27^Eyes - red relex, strabismus, dacryostenosis^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3084,0)
 ;;=28^Followup NB Screen^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3085,0)
 ;;=28^Hearing if not done earlier^^^7^30^^^^^^^.25^1
 ;;^UTILITY(U,$J,19707.12,3087,0)
 ;;=27^Torticollis^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3088,0)
 ;;=27^Metatarsus adductus^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3089,0)
 ;;=27^Hips^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3090,0)
 ;;=27^Murmurs, femoral pulses^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3091,0)
 ;;=27^Neuro probs, tone^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3092,0)
 ;;=27^Abdominal mass/distension, circumcision^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3093,0)
 ;;=27^Signs of neglect or abuse^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3094,0)
 ;;=27^Eyes-red reflex, strabismus, dacryostenosis^^^30^91^^^^^^^1^3
 ;;^UTILITY(U,$J,19707.12,3096,0)
 ;;=27^Murmurs, femoral pulses^^^91^152^^^^^^^3^5
 ;;^UTILITY(U,$J,19707.12,3097,0)
 ;;=27^Hips, testes^^^91^152^^^^^^^3^5
 ;;^UTILITY(U,$J,19707.12,3098,0)
 ;;=27^Neuro Problems, muscle tone^^^91^152^^^^^^^3^5
 ;;^UTILITY(U,$J,19707.12,3099,0)
 ;;=27^Possible neglect/abuse^^^91^152^^^^^^^3^5
 ;;^UTILITY(U,$J,19707.12,3100,0)
 ;;=27^Eyes, red reflex^^^91^152^^^^^^^3^5
 ;;^UTILITY(U,$J,19707.12,3102,0)
 ;;=27^Tooth eruption^^^152^244^^^^^^^5^8
 ;;^UTILITY(U,$J,19707.12,3103,0)
 ;;=27^Hips, testes^^^152^244^^^^^^^5^8
 ;;^UTILITY(U,$J,19707.12,3104,0)
 ;;=27^DTR problems, muscle tone, use of extremities^^^152^244^^^^^^^5^8
 ;;^UTILITY(U,$J,19707.12,3105,0)
 ;;=27^Signs of possible abuse/neglect^^^152^244^^^^^^^5^8
 ;;^UTILITY(U,$J,19707.12,3106,0)
 ;;=27^Eyes (fix/follow, alternate occlusion, corneal light reflex, red reflex, strabis^^^152^244^^^^^^^5^8
 ;;^UTILITY(U,$J,19707.12,3108,0)
 ;;=27^Tooth eruption^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3109,0)
 ;;=27^Parachute response for hemiparesis, neuro problems^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3110,0)
 ;;=27^Murmurs^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3111,0)
 ;;=27^Hips, testes^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3112,0)
 ;;=27^Signs of possible abuse/neglect^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3113,0)
 ;;=27^Eyes (fix/follow, alternate occlusion, corneal light reflex, red reflex, strabis^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3114,0)
 ;;=28^Lead^^^244^335^^^^^^^8^11
 ;;^UTILITY(U,$J,19707.12,3116,0)
 ;;=27^Feet, gait, walking^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3117,0)
 ;;=27^Tooth eruption, early caries^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3118,0)
 ;;=27^Murmurs^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3119,0)
 ;;=27^Hips^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3120,0)
 ;;=27^Red reflex^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3121,0)
 ;;=27^Possible neglect/abuse^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3122,0)
 ;;=28^Anemia^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3123,0)
 ;;=28^Lead^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3124,0)
 ;;=28^Autism^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3125,0)
 ;;=29^At risk for TB: PPD^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3126,0)
 ;;=29^Hearing (screen if indicated)^^^335^396^^^^^^^11^13
 ;;^UTILITY(U,$J,19707.12,3128,0)
 ;;=27^Feet, gait, walking^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3129,0)
 ;;=27^Skin for nevi, cafe au lait, birthmarks^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3130,0)
 ;;=27^Tooth eruption, caries, dental injuries^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3131,0)
 ;;=27^Signs of possible abuse/neglect, excessive injuries or bruising^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3132,0)
 ;;=28^Anemia (if not done)^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3133,0)
 ;;=28^Lead (if not done)^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3134,0)
 ;;=28^Autism^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3135,0)
 ;;=29^At risk for TB: PPD^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3136,0)
 ;;=29^Hearing (screen if indicated)^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3137,0)
 ;;=29^Vision (screen if indicated)^^^396^488^^^^^^^13^16
 ;;^UTILITY(U,$J,19707.12,3139,0)
 ;;=27^Feet, gait, walking^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3140,0)
 ;;=27^Early childhood caries or dental injuries^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3141,0)
 ;;=27^Signs of possible abuse/neglect, excessive bruising or injuries^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3142,0)
 ;;=28^Anemia (if not done)^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3143,0)
 ;;=28^Lead (if not done)^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3144,0)
 ;;=28^Autism^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3145,0)
 ;;=29^At risk for TB: PPD^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3146,0)
 ;;=29^Hearing (screen if indicated)^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3147,0)
 ;;=29^Vision (screen if indicated)^^^488^671^^^^^^^16^22
 ;;^UTILITY(U,$J,19707.12,3149,0)
 ;;=27^Early childhood caries or dental injuries^^^671^915^^^^^^^22^30
 ;;^UTILITY(U,$J,19707.12,3150,0)
 ;;=27^Signs of possible abuse/neglect, excessive bruising or injuries^^^671^915^^^^^^^22^30
 ;;^UTILITY(U,$J,19707.12,3151,0)
 ;;=27^Eyes - strabismus^^^671^915^^^^^^^22^30
 ;;^UTILITY(U,$J,19707.12,3152,0)
 ;;=28^Lead^^^671^915^^^^^^^22^30
 ;;^UTILITY(U,$J,19707.12,3153,0)
 ;;=28^Autism^^^671^915^^^^^^^22^30
 ;;^UTILITY(U,$J,19707.12,3154,0)
 ;;=29^At risk for TB: PPD^^^671^915^^^^^^^22^30
