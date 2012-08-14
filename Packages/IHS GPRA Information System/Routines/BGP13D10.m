BGP13D10 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON APR 14, 2011 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"994,00501-6000-32 ",.01)
 ;;00501-6000-32
 ;;9002226.02101,"994,00501-6000-32 ",.02)
 ;;00501-6000-32
 ;;9002226.02101,"994,00536-0632-47 ",.01)
 ;;00536-0632-47
 ;;9002226.02101,"994,00536-0632-47 ",.02)
 ;;00536-0632-47
 ;;9002226.02101,"994,00536-0632-97 ",.01)
 ;;00536-0632-97
 ;;9002226.02101,"994,00536-0632-97 ",.02)
 ;;00536-0632-97
 ;;9002226.02101,"994,00536-0770-58 ",.01)
 ;;00536-0770-58
 ;;9002226.02101,"994,00536-0770-58 ",.02)
 ;;00536-0770-58
 ;;9002226.02101,"994,00536-0770-85 ",.01)
 ;;00536-0770-85
 ;;9002226.02101,"994,00536-0770-85 ",.02)
 ;;00536-0770-85
 ;;9002226.02101,"994,00536-0770-97 ",.01)
 ;;00536-0770-97
 ;;9002226.02101,"994,00536-0770-97 ",.02)
 ;;00536-0770-97
 ;;9002226.02101,"994,00536-1002-85 ",.01)
 ;;00536-1002-85
 ;;9002226.02101,"994,00536-1002-85 ",.02)
 ;;00536-1002-85
 ;;9002226.02101,"994,00536-1745-90 ",.01)
 ;;00536-1745-90
 ;;9002226.02101,"994,00536-1745-90 ",.02)
 ;;00536-1745-90
 ;;9002226.02101,"994,00536-1930-85 ",.01)
 ;;00536-1930-85
 ;;9002226.02101,"994,00536-1930-85 ",.02)
 ;;00536-1930-85
 ;;9002226.02101,"994,00536-3283-35 ",.01)
 ;;00536-3283-35
 ;;9002226.02101,"994,00536-3283-35 ",.02)
 ;;00536-3283-35
 ;;9002226.02101,"994,00536-3594-01 ",.01)
 ;;00536-3594-01
 ;;9002226.02101,"994,00536-3594-01 ",.02)
 ;;00536-3594-01
 ;;9002226.02101,"994,00536-3594-10 ",.01)
 ;;00536-3594-10
 ;;9002226.02101,"994,00536-3594-10 ",.02)
 ;;00536-3594-10
 ;;9002226.02101,"994,00536-3594-35 ",.01)
 ;;00536-3594-35
 ;;9002226.02101,"994,00536-3594-35 ",.02)
 ;;00536-3594-35
 ;;9002226.02101,"994,00536-3597-01 ",.01)
 ;;00536-3597-01
 ;;9002226.02101,"994,00536-3597-01 ",.02)
 ;;00536-3597-01
 ;;9002226.02101,"994,00536-3772-06 ",.01)
 ;;00536-3772-06
 ;;9002226.02101,"994,00536-3772-06 ",.02)
 ;;00536-3772-06
 ;;9002226.02101,"994,00555-0059-02 ",.01)
 ;;00555-0059-02
 ;;9002226.02101,"994,00555-0059-02 ",.02)
 ;;00555-0059-02
 ;;9002226.02101,"994,00555-0059-05 ",.01)
 ;;00555-0059-05
 ;;9002226.02101,"994,00555-0059-05 ",.02)
 ;;00555-0059-05
 ;;9002226.02101,"994,00555-0302-02 ",.01)
 ;;00555-0302-02
 ;;9002226.02101,"994,00555-0302-02 ",.02)
 ;;00555-0302-02
 ;;9002226.02101,"994,00555-0302-04 ",.01)
 ;;00555-0302-04
 ;;9002226.02101,"994,00555-0302-04 ",.02)
 ;;00555-0302-04
 ;;9002226.02101,"994,00555-0323-02 ",.01)
 ;;00555-0323-02
 ;;9002226.02101,"994,00555-0323-02 ",.02)
 ;;00555-0323-02
 ;;9002226.02101,"994,00555-0323-04 ",.01)
 ;;00555-0323-04
 ;;9002226.02101,"994,00555-0323-04 ",.02)
 ;;00555-0323-04
 ;;9002226.02101,"994,00555-0324-02 ",.01)
 ;;00555-0324-02
 ;;9002226.02101,"994,00555-0324-02 ",.02)
 ;;00555-0324-02
 ;;9002226.02101,"994,00573-0315-10 ",.01)
 ;;00573-0315-10
 ;;9002226.02101,"994,00573-0315-10 ",.02)
 ;;00573-0315-10
 ;;9002226.02101,"994,00573-3412-10 ",.01)
 ;;00573-3412-10
 ;;9002226.02101,"994,00573-3412-10 ",.02)
 ;;00573-3412-10
 ;;9002226.02101,"994,00573-3412-15 ",.01)
 ;;00573-3412-15
 ;;9002226.02101,"994,00573-3412-15 ",.02)
 ;;00573-3412-15
 ;;9002226.02101,"994,00591-0800-01 ",.01)
 ;;00591-0800-01
 ;;9002226.02101,"994,00591-0800-01 ",.02)
 ;;00591-0800-01
 ;;9002226.02101,"994,00591-0800-05 ",.01)
 ;;00591-0800-05
 ;;9002226.02101,"994,00591-0800-05 ",.02)
 ;;00591-0800-05
 ;;9002226.02101,"994,00591-0801-01 ",.01)
 ;;00591-0801-01
 ;;9002226.02101,"994,00591-0801-01 ",.02)
 ;;00591-0801-01
 ;;9002226.02101,"994,00591-0801-05 ",.01)
 ;;00591-0801-05
 ;;9002226.02101,"994,00591-0801-05 ",.02)
 ;;00591-0801-05
 ;;9002226.02101,"994,00591-3423-01 ",.01)
 ;;00591-3423-01
 ;;9002226.02101,"994,00591-3423-01 ",.02)
 ;;00591-3423-01
 ;;9002226.02101,"994,00591-3423-05 ",.01)
 ;;00591-3423-05
 ;;9002226.02101,"994,00591-3423-05 ",.02)
 ;;00591-3423-05
 ;;9002226.02101,"994,00591-3423-10 ",.01)
 ;;00591-3423-10
 ;;9002226.02101,"994,00591-3423-10 ",.02)
 ;;00591-3423-10
 ;;9002226.02101,"994,00591-5307-01 ",.01)
 ;;00591-5307-01
 ;;9002226.02101,"994,00591-5307-01 ",.02)
 ;;00591-5307-01
 ;;9002226.02101,"994,00591-5307-10 ",.01)
 ;;00591-5307-10
 ;;9002226.02101,"994,00591-5307-10 ",.02)
 ;;00591-5307-10
 ;;9002226.02101,"994,00591-5319-01 ",.01)
 ;;00591-5319-01
 ;;9002226.02101,"994,00591-5319-01 ",.02)
 ;;00591-5319-01
 ;;9002226.02101,"994,00591-5522-01 ",.01)
 ;;00591-5522-01
 ;;9002226.02101,"994,00591-5522-01 ",.02)
 ;;00591-5522-01
 ;;9002226.02101,"994,00591-5522-05 ",.01)
 ;;00591-5522-05
 ;;9002226.02101,"994,00591-5522-05 ",.02)
 ;;00591-5522-05
 ;;9002226.02101,"994,00591-5523-01 ",.01)
 ;;00591-5523-01
 ;;9002226.02101,"994,00591-5523-01 ",.02)
 ;;00591-5523-01
 ;;9002226.02101,"994,00591-5523-05 ",.01)
 ;;00591-5523-05
 ;;9002226.02101,"994,00591-5523-05 ",.02)
 ;;00591-5523-05
 ;;9002226.02101,"994,00591-5523-10 ",.01)
 ;;00591-5523-10
 ;;9002226.02101,"994,00591-5523-10 ",.02)
 ;;00591-5523-10
 ;;9002226.02101,"994,00603-0239-18 ",.01)
 ;;00603-0239-18
 ;;9002226.02101,"994,00603-0239-18 ",.02)
 ;;00603-0239-18
 ;;9002226.02101,"994,00603-0240-18 ",.01)
 ;;00603-0240-18
 ;;9002226.02101,"994,00603-0240-18 ",.02)
 ;;00603-0240-18
 ;;9002226.02101,"994,00603-0241-18 ",.01)
 ;;00603-0241-18
 ;;9002226.02101,"994,00603-0241-18 ",.02)
 ;;00603-0241-18
 ;;9002226.02101,"994,00603-0822-54 ",.01)
 ;;00603-0822-54
 ;;9002226.02101,"994,00603-0822-54 ",.02)
 ;;00603-0822-54
 ;;9002226.02101,"994,00603-0823-54 ",.01)
 ;;00603-0823-54
 ;;9002226.02101,"994,00603-0823-54 ",.02)
 ;;00603-0823-54
 ;;9002226.02101,"994,00603-0823-58 ",.01)
 ;;00603-0823-58
 ;;9002226.02101,"994,00603-0823-58 ",.02)
 ;;00603-0823-58
 ;;9002226.02101,"994,00603-0823-81 ",.01)
 ;;00603-0823-81
 ;;9002226.02101,"994,00603-0823-81 ",.02)
 ;;00603-0823-81
 ;;9002226.02101,"994,00603-0823-94 ",.01)
 ;;00603-0823-94
 ;;9002226.02101,"994,00603-0823-94 ",.02)
 ;;00603-0823-94
 ;;9002226.02101,"994,00603-0860-54 ",.01)
 ;;00603-0860-54
 ;;9002226.02101,"994,00603-0860-54 ",.02)
 ;;00603-0860-54
 ;;9002226.02101,"994,00603-1117-58 ",.01)
 ;;00603-1117-58
 ;;9002226.02101,"994,00603-1117-58 ",.02)
 ;;00603-1117-58
 ;;9002226.02101,"994,00603-1175-58 ",.01)
 ;;00603-1175-58
 ;;9002226.02101,"994,00603-1175-58 ",.02)
 ;;00603-1175-58
 ;;9002226.02101,"994,00603-1310-58 ",.01)
 ;;00603-1310-58
 ;;9002226.02101,"994,00603-1310-58 ",.02)
 ;;00603-1310-58
 ;;9002226.02101,"994,00603-1584-54 ",.01)
 ;;00603-1584-54
 ;;9002226.02101,"994,00603-1584-54 ",.02)
 ;;00603-1584-54
 ;;9002226.02101,"994,00603-1584-58 ",.01)
 ;;00603-1584-58
 ;;9002226.02101,"994,00603-1584-58 ",.02)
 ;;00603-1584-58
 ;;9002226.02101,"994,00603-1585-54 ",.01)
 ;;00603-1585-54
 ;;9002226.02101,"994,00603-1585-54 ",.02)
 ;;00603-1585-54
 ;;9002226.02101,"994,00603-1585-58 ",.01)
 ;;00603-1585-58
 ;;9002226.02101,"994,00603-1585-58 ",.02)
 ;;00603-1585-58
 ;;9002226.02101,"994,00603-1586-54 ",.01)
 ;;00603-1586-54
 ;;9002226.02101,"994,00603-1586-54 ",.02)
 ;;00603-1586-54
 ;;9002226.02101,"994,00603-1586-58 ",.01)
 ;;00603-1586-58
 ;;9002226.02101,"994,00603-1586-58 ",.02)
 ;;00603-1586-58
 ;;9002226.02101,"994,00603-1587-54 ",.01)
 ;;00603-1587-54
 ;;9002226.02101,"994,00603-1587-54 ",.02)
 ;;00603-1587-54
 ;;9002226.02101,"994,00603-1587-58 ",.01)
 ;;00603-1587-58
 ;;9002226.02101,"994,00603-1587-58 ",.02)
 ;;00603-1587-58
 ;;9002226.02101,"994,00603-1588-54 ",.01)
 ;;00603-1588-54
 ;;9002226.02101,"994,00603-1588-54 ",.02)
 ;;00603-1588-54
 ;;9002226.02101,"994,00603-1588-58 ",.01)
 ;;00603-1588-58
 ;;9002226.02101,"994,00603-1588-58 ",.02)
 ;;00603-1588-58
 ;;9002226.02101,"994,00603-3198-21 ",.01)
 ;;00603-3198-21
 ;;9002226.02101,"994,00603-3198-21 ",.02)
 ;;00603-3198-21
 ;;9002226.02101,"994,00603-3199-21 ",.01)
 ;;00603-3199-21
 ;;9002226.02101,"994,00603-3199-21 ",.02)
 ;;00603-3199-21
 ;;9002226.02101,"994,00603-3337-21 ",.01)
 ;;00603-3337-21
 ;;9002226.02101,"994,00603-3337-21 ",.02)
 ;;00603-3337-21
 ;;9002226.02101,"994,00603-3337-32 ",.01)
 ;;00603-3337-32
 ;;9002226.02101,"994,00603-3337-32 ",.02)
 ;;00603-3337-32
 ;;9002226.02101,"994,00603-3338-21 ",.01)
 ;;00603-3338-21
 ;;9002226.02101,"994,00603-3338-21 ",.02)
 ;;00603-3338-21
 ;;9002226.02101,"994,00603-3338-32 ",.01)
 ;;00603-3338-32
 ;;9002226.02101,"994,00603-3338-32 ",.02)
 ;;00603-3338-32
 ;;9002226.02101,"994,00603-3339-21 ",.01)
 ;;00603-3339-21
 ;;9002226.02101,"994,00603-3339-21 ",.02)
 ;;00603-3339-21
 ;;9002226.02101,"994,00603-3339-32 ",.01)
 ;;00603-3339-32
 ;;9002226.02101,"994,00603-3339-32 ",.02)
 ;;00603-3339-32
 ;;9002226.02101,"994,00603-3340-21 ",.01)
 ;;00603-3340-21
 ;;9002226.02101,"994,00603-3340-21 ",.02)
 ;;00603-3340-21
 ;;9002226.02101,"994,00603-3340-32 ",.01)
 ;;00603-3340-32
 ;;9002226.02101,"994,00603-3340-32 ",.02)
 ;;00603-3340-32
 ;;9002226.02101,"994,00603-3967-21 ",.01)
 ;;00603-3967-21
 ;;9002226.02101,"994,00603-3967-21 ",.02)
 ;;00603-3967-21
 ;;9002226.02101,"994,00603-3967-28 ",.01)
 ;;00603-3967-28
 ;;9002226.02101,"994,00603-3967-28 ",.02)
 ;;00603-3967-28
 ;;9002226.02101,"994,00603-3967-32 ",.01)
 ;;00603-3967-32
 ;;9002226.02101,"994,00603-3967-32 ",.02)
 ;;00603-3967-32
 ;;9002226.02101,"994,00603-3968-21 ",.01)
 ;;00603-3968-21
 ;;9002226.02101,"994,00603-3968-21 ",.02)
 ;;00603-3968-21
 ;;9002226.02101,"994,00603-3968-28 ",.01)
 ;;00603-3968-28
 ;;9002226.02101,"994,00603-3968-28 ",.02)
 ;;00603-3968-28
 ;;9002226.02101,"994,00603-3968-32 ",.01)
 ;;00603-3968-32
 ;;9002226.02101,"994,00603-3968-32 ",.02)
 ;;00603-3968-32
 ;;9002226.02101,"994,00603-3969-21 ",.01)
 ;;00603-3969-21
 ;;9002226.02101,"994,00603-3969-21 ",.02)
 ;;00603-3969-21
 ;;9002226.02101,"994,00603-3969-28 ",.01)
 ;;00603-3969-28
 ;;9002226.02101,"994,00603-3969-28 ",.02)
 ;;00603-3969-28
 ;;9002226.02101,"994,00603-3994-21 ",.01)
 ;;00603-3994-21
 ;;9002226.02101,"994,00603-3994-21 ",.02)
 ;;00603-3994-21
 ;;9002226.02101,"994,00603-3994-28 ",.01)
 ;;00603-3994-28
 ;;9002226.02101,"994,00603-3994-28 ",.02)
 ;;00603-3994-28
 ;;9002226.02101,"994,00603-3995-21 ",.01)
 ;;00603-3995-21
 ;;9002226.02101,"994,00603-3995-21 ",.02)
 ;;00603-3995-21
 ;;9002226.02101,"994,00603-5437-21 ",.01)
 ;;00603-5437-21
 ;;9002226.02101,"994,00603-5437-21 ",.02)
 ;;00603-5437-21
 ;;9002226.02101,"994,00603-5438-21 ",.01)
 ;;00603-5438-21
 ;;9002226.02101,"994,00603-5438-21 ",.02)
 ;;00603-5438-21
 ;;9002226.02101,"994,00603-5438-32 ",.01)
 ;;00603-5438-32
 ;;9002226.02101,"994,00603-5438-32 ",.02)
 ;;00603-5438-32
 ;;9002226.02101,"994,00603-5439-21 ",.01)
 ;;00603-5439-21
 ;;9002226.02101,"994,00603-5439-21 ",.02)
 ;;00603-5439-21
 ;;9002226.02101,"994,00615-0331-53 ",.01)
 ;;00615-0331-53
 ;;9002226.02101,"994,00615-0331-53 ",.02)
 ;;00615-0331-53
 ;;9002226.02101,"994,00615-0331-63 ",.01)
 ;;00615-0331-63
 ;;9002226.02101,"994,00615-0331-63 ",.02)
 ;;00615-0331-63
 ;;9002226.02101,"994,00615-0332-13 ",.01)
 ;;00615-0332-13
 ;;9002226.02101,"994,00615-0332-13 ",.02)
 ;;00615-0332-13
 ;;9002226.02101,"994,00615-0332-63 ",.01)
 ;;00615-0332-63
 ;;9002226.02101,"994,00615-0332-63 ",.02)
 ;;00615-0332-63
 ;;9002226.02101,"994,00615-0368-01 ",.01)
 ;;00615-0368-01
 ;;9002226.02101,"994,00615-0368-01 ",.02)
 ;;00615-0368-01
 ;;9002226.02101,"994,00615-0368-10 ",.01)
 ;;00615-0368-10
 ;;9002226.02101,"994,00615-0368-10 ",.02)
 ;;00615-0368-10
 ;;9002226.02101,"994,00615-0368-32 ",.01)
 ;;00615-0368-32
 ;;9002226.02101,"994,00615-0368-32 ",.02)
 ;;00615-0368-32
 ;;9002226.02101,"994,00615-0369-01 ",.01)
 ;;00615-0369-01
 ;;9002226.02101,"994,00615-0369-01 ",.02)
 ;;00615-0369-01
 ;;9002226.02101,"994,00615-0369-10 ",.01)
 ;;00615-0369-10
 ;;9002226.02101,"994,00615-0369-10 ",.02)
 ;;00615-0369-10
 ;;9002226.02101,"994,00615-0369-32 ",.01)
 ;;00615-0369-32
 ;;9002226.02101,"994,00615-0369-32 ",.02)
 ;;00615-0369-32
 ;;9002226.02101,"994,00615-0369-53 ",.01)
 ;;00615-0369-53
 ;;9002226.02101,"994,00615-0369-53 ",.02)
 ;;00615-0369-53
 ;;9002226.02101,"994,00615-0369-63 ",.01)
 ;;00615-0369-63
 ;;9002226.02101,"994,00615-0369-63 ",.02)
 ;;00615-0369-63
 ;;9002226.02101,"994,00615-1525-13 ",.01)
 ;;00615-1525-13
 ;;9002226.02101,"994,00615-1525-13 ",.02)
 ;;00615-1525-13
 ;;9002226.02101,"994,00615-1526-43 ",.01)
 ;;00615-1526-43
 ;;9002226.02101,"994,00615-1526-43 ",.02)
 ;;00615-1526-43
 ;;9002226.02101,"994,00615-1526-53 ",.01)
 ;;00615-1526-53
 ;;9002226.02101,"994,00615-1526-53 ",.02)
 ;;00615-1526-53
 ;;9002226.02101,"994,00615-1526-63 ",.01)
 ;;00615-1526-63
 ;;9002226.02101,"994,00615-1526-63 ",.02)
 ;;00615-1526-63
 ;;9002226.02101,"994,00615-1536-13 ",.01)
 ;;00615-1536-13