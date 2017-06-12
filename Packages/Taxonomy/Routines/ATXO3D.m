ATXO3D ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BTPW BRST RECON UNS PROC
 ;
 ; This routine loads Taxonomy BTPW BRST RECON UNS PROC
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 D OTHER
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"0H0T0ZZ ")
 ;;4
 ;;21,"0H0T3ZZ ")
 ;;5
 ;;21,"0H0TXZZ ")
 ;;6
 ;;21,"0H0U0ZZ ")
 ;;7
 ;;21,"0H0U3ZZ ")
 ;;8
 ;;21,"0H0UXZZ ")
 ;;9
 ;;21,"0H0V0ZZ ")
 ;;10
 ;;21,"0H0V3ZZ ")
 ;;11
 ;;21,"0H0VXZZ ")
 ;;12
 ;;21,"0HHT0NZ ")
 ;;13
 ;;21,"0HHT3NZ ")
 ;;14
 ;;21,"0HHT7NZ ")
 ;;15
 ;;21,"0HHT8NZ ")
 ;;16
 ;;21,"0HHU0NZ ")
 ;;17
 ;;21,"0HHU3NZ ")
 ;;18
 ;;21,"0HHU7NZ ")
 ;;19
 ;;21,"0HHU8NZ ")
 ;;20
 ;;21,"0HHV0NZ ")
 ;;21
 ;;21,"0HHV3NZ ")
 ;;22
 ;;21,"0HHV7NZ ")
 ;;23
 ;;21,"0HHV8NZ ")
 ;;24
 ;;21,"0HMTXZZ ")
 ;;25
 ;;21,"0HMUXZZ ")
 ;;26
 ;;21,"0HMVXZZ ")
 ;;27
 ;;21,"0HMWXZZ ")
 ;;28
 ;;21,"0HMXXZZ ")
 ;;29
 ;;21,"0HNT0ZZ ")
 ;;30
 ;;21,"0HNT3ZZ ")
 ;;31
 ;;21,"0HNT7ZZ ")
 ;;32
 ;;21,"0HNT8ZZ ")
 ;;33
 ;;21,"0HNTXZZ ")
 ;;34
 ;;21,"0HNU0ZZ ")
 ;;35
 ;;21,"0HNU3ZZ ")
 ;;36
 ;;21,"0HNU7ZZ ")
 ;;37
 ;;21,"0HNU8ZZ ")
 ;;38
 ;;21,"0HNUXZZ ")
 ;;39
 ;;21,"0HNV0ZZ ")
 ;;40
 ;;21,"0HNV3ZZ ")
 ;;41
 ;;21,"0HNV7ZZ ")
 ;;42
 ;;21,"0HNV8ZZ ")
 ;;43
 ;;21,"0HNVXZZ ")
 ;;44
 ;;21,"0HNW0ZZ ")
 ;;45
 ;;21,"0HNW3ZZ ")
 ;;46
 ;;21,"0HNW7ZZ ")
 ;;47
 ;;21,"0HNW8ZZ ")
 ;;48
 ;;21,"0HNWXZZ ")
 ;;49
 ;;21,"0HNX0ZZ ")
 ;;50
 ;;21,"0HNX3ZZ ")
 ;;51
 ;;21,"0HNX7ZZ ")
 ;;52
 ;;21,"0HNX8ZZ ")
 ;;53
 ;;21,"0HNXXZZ ")
 ;;54
 ;;21,"0HPT0JZ ")
 ;;55
 ;;21,"0HPT0NZ ")
 ;;56
 ;;21,"0HPT3JZ ")
 ;;57
 ;;21,"0HPT3NZ ")
 ;;58
 ;;21,"0HPU0JZ ")
 ;;59
 ;;21,"0HPU0NZ ")
 ;;60
 ;;21,"0HPU3JZ ")
 ;;61
 ;;21,"0HPU3NZ ")
 ;;62
 ;;21,"0HQT0ZZ ")
 ;;63
 ;;21,"0HQT3ZZ ")
 ;;64
 ;;21,"0HQT7ZZ ")
 ;;65
 ;;21,"0HQT8ZZ ")
 ;;66
 ;;21,"0HQTXZZ ")
 ;;67
 ;;21,"0HQU0ZZ ")
 ;;68
 ;;21,"0HQU3ZZ ")
 ;;69
 ;;21,"0HQU7ZZ ")
 ;;70
 ;;21,"0HQU8ZZ ")
 ;;71
 ;;21,"0HQUXZZ ")
 ;;72
 ;;21,"0HQV0ZZ ")
 ;;73
 ;;21,"0HQV3ZZ ")
 ;;74
 ;;21,"0HQV7ZZ ")
 ;;75
 ;;21,"0HQV8ZZ ")
 ;;76
 ;;21,"0HQVXZZ ")
 ;;77
 ;;21,"0HRT07Z ")
 ;;78
 ;;21,"0HRT0JZ ")
 ;;79
 ;;21,"0HRT0KZ ")
 ;;80
 ;;21,"0HRT37Z ")
 ;;81
 ;;21,"0HRT3KZ ")
 ;;82
 ;;21,"0HRTX7Z ")
 ;;83
 ;;21,"0HRTXJZ ")
 ;;84
 ;;21,"0HRTXKZ ")
 ;;85
 ;;21,"0HRU07Z ")
 ;;86
 ;;21,"0HRU0JZ ")
 ;;87
 ;;21,"0HRU0KZ ")
 ;;88
 ;;21,"0HRU37Z ")
 ;;89
 ;;21,"0HRU3KZ ")
 ;;90
 ;;21,"0HRUX7Z ")
 ;;91
 ;;21,"0HRUXJZ ")
 ;;92
 ;;21,"0HRUXKZ ")
 ;;93
 ;;21,"0HRV07Z ")
 ;;94
 ;;21,"0HRV0KZ ")
 ;;95
 ;;21,"0HRV37Z ")
 ;;96
 ;;21,"0HRV3KZ ")
 ;;97
 ;;21,"0HRVX7Z ")
 ;;98
 ;;21,"0HRVXJZ ")
 ;;99
 ;;21,"0HRVXKZ ")
 ;;100
 ;;21,"0HRW07Z ")
 ;;101
 ;;21,"0HRW0JZ ")
 ;;102
 ;;21,"0HRW0KZ ")
 ;;103
 ;;21,"0HRW37Z ")
 ;;104
 ;;21,"0HRW3JZ ")
 ;;105
 ;;21,"0HRW3KZ ")
 ;;106
 ;;21,"0HRWX7Z ")
 ;;107
 ;;21,"0HRWXJZ ")
 ;;108
 ;;21,"0HRWXKZ ")
 ;;109
 ;;21,"0HRX07Z ")
 ;;110
 ;;21,"0HRX0JZ ")
 ;;111
 ;;21,"0HRX0KZ ")
 ;;112
 ;;21,"0HRX37Z ")
 ;;113
 ;;21,"0HRX3JZ ")
 ;;114
 ;;21,"0HRX3KZ ")
 ;;115
 ;;21,"0HRXX7Z ")
 ;;116
 ;;21,"0HRXXJZ ")
 ;;117
 ;;21,"0HRXXKZ ")
 ;;118
 ;;21,"0HSWXZZ ")
 ;;119
 ;;21,"0HSXXZZ ")
 ;;120
 ;;21,"0HUT07Z ")
 ;;121
 ;;21,"0HUT0JZ ")
 ;;122
 ;;21,"0HUT0KZ ")
 ;;123
 ;;21,"0HUT37Z ")
 ;;124
 ;;21,"0HUT3JZ ")
 ;;125
 ;;21,"0HUT3KZ ")
 ;;126
 ;;21,"0HUT77Z ")
 ;;127
 ;;21,"0HUT7JZ ")
 ;;128
 ;;21,"0HUT7KZ ")
 ;;129
 ;;21,"0HUT87Z ")
 ;;130
 ;;21,"0HUT8JZ ")
 ;;131
 ;;21,"0HUT8KZ ")
 ;;132
 ;;21,"0HUTX7Z ")
 ;;133
 ;;21,"0HUTXJZ ")
 ;;134
 ;;21,"0HUTXKZ ")
 ;;135
 ;;21,"0HUU07Z ")
 ;;136
 ;;21,"0HUU0JZ ")
 ;;137
 ;;21,"0HUU0KZ ")
 ;;138
 ;;21,"0HUU37Z ")
 ;;139
 ;;21,"0HUU3JZ ")
 ;;140
 ;;21,"0HUU3KZ ")
 ;;141
 ;;21,"0HUU77Z ")
 ;;142
 ;;21,"0HUU7JZ ")
 ;;143
 ;;21,"0HUU7KZ ")
 ;;144
 ;;21,"0HUU87Z ")
 ;;145
 ;;21,"0HUU8JZ ")
 ;;146
 ;;21,"0HUU8KZ ")
 ;;147
 ;;21,"0HUUX7Z ")
 ;;148
 ;;21,"0HUUXJZ ")
 ;;149
 ;;21,"0HUUXKZ ")
 ;;150
 ;;21,"0HUV07Z ")
 ;;151
 ;;21,"0HUV0JZ ")
 ;;152
 ;;21,"0HUV0KZ ")
 ;;153
 ;;21,"0HUV37Z ")
 ;;154
 ;;21,"0HUV3JZ ")
 ;;155
 ;;21,"0HUV3KZ ")
 ;;156
 ;;21,"0HUV77Z ")
 ;;157
 ;;21,"0HUV7JZ ")
 ;;158
 ;;21,"0HUV7KZ ")
 ;;159
 ;;21,"0HUV87Z ")
 ;;160
 ;;21,"0HUV8JZ ")
 ;;161
 ;;21,"0HUV8KZ ")
 ;;162
 ;;21,"0HUVX7Z ")
 ;;163
 ;;21,"0HUVXJZ ")
 ;;164
 ;;21,"0HUVXKZ ")
 ;;165
 ;;21,"0HUW07Z ")
 ;;166
 ;;21,"0HUW0JZ ")
 ;;167
 ;;21,"0HUW0KZ ")
 ;;168
 ;;21,"0HUW37Z ")
 ;;169
 ;;21,"0HUW3JZ ")
 ;;170
 ;;21,"0HUW3KZ ")
 ;;171
 ;;21,"0HUW77Z ")
 ;;172
 ;;21,"0HUW7JZ ")
 ;;173
 ;;21,"0HUW7KZ ")
 ;;174
 ;;21,"0HUW87Z ")
 ;;175
 ;;21,"0HUW8JZ ")
 ;;176
 ;;21,"0HUW8KZ ")
 ;;177
 ;;21,"0HUWX7Z ")
 ;;178
 ;;21,"0HUWXJZ ")
 ;;179
 ;;21,"0HUWXKZ ")
 ;;180
 ;;21,"0HUX07Z ")
 ;;181
 ;;21,"0HUX0JZ ")
 ;;182
 ;;21,"0HUX0KZ ")
 ;;183
 ;;21,"0HUX37Z ")
 ;;184
 ;;21,"0HUX3JZ ")
 ;;185
 ;;21,"0HUX3KZ ")
 ;;186
 ;;21,"0HUX77Z ")
 ;;187
 ;;21,"0HUX7JZ ")
 ;;188
 ;;21,"0HUX7KZ ")
 ;;189
 ;;21,"0HUX87Z ")
 ;;190
 ;;21,"0HUX8JZ ")
 ;;191
 ;;21,"0HUX8KZ ")
 ;;192
 ;;21,"0HUXX7Z ")
 ;;193
 ;;21,"0HUXXJZ ")
 ;;194
 ;;21,"0HUXXKZ ")
 ;;195
 ;;21,"0HWT0JZ ")
 ;;196
 ;;21,"0HWT3JZ ")
 ;;197
 ;;21,"0HWU0JZ ")
 ;;198
 ;;21,"0HWU3JZ ")
 ;;199
 ;;21,"85.70 ")
 ;;1
 ;;21,"85.82 ")
 ;;2
 ;;21,"85.92 ")
 ;;3
 ;;9002226,1381,.01)
 ;;BTPW BRST RECON UNS PROC
 ;;9002226,1381,.02)
 ;;@
 ;;9002226,1381,.04)
 ;;n
 ;;9002226,1381,.06)
 ;;@
 ;;9002226,1381,.08)
 ;;0
 ;;9002226,1381,.09)
 ;;3131112
 ;;9002226,1381,.11)
 ;;@
 ;;9002226,1381,.12)
 ;;255
 ;;9002226,1381,.13)
 ;;1
 ;;9002226,1381,.14)
 ;;@
 ;;9002226,1381,.15)
 ;;80.1
 ;;9002226,1381,.16)
 ;;@
 ;;9002226,1381,.17)
 ;;@
 ;;9002226,1381,3101)
 ;;@
 ;;9002226.02101,"1381,0H0T0ZZ ",.01)
 ;;0H0T0ZZ 
 ;;9002226.02101,"1381,0H0T0ZZ ",.02)
 ;;0H0T0ZZ 
 ;;9002226.02101,"1381,0H0T0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0T3ZZ ",.01)
 ;;0H0T3ZZ 
 ;;9002226.02101,"1381,0H0T3ZZ ",.02)
 ;;0H0T3ZZ 
 ;;9002226.02101,"1381,0H0T3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0TXZZ ",.01)
 ;;0H0TXZZ 
 ;;9002226.02101,"1381,0H0TXZZ ",.02)
 ;;0H0TXZZ 
 ;;9002226.02101,"1381,0H0TXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0U0ZZ ",.01)
 ;;0H0U0ZZ 
 ;;9002226.02101,"1381,0H0U0ZZ ",.02)
 ;;0H0U0ZZ 
 ;;9002226.02101,"1381,0H0U0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0U3ZZ ",.01)
 ;;0H0U3ZZ 
 ;;9002226.02101,"1381,0H0U3ZZ ",.02)
 ;;0H0U3ZZ 
 ;;9002226.02101,"1381,0H0U3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0UXZZ ",.01)
 ;;0H0UXZZ 
 ;;9002226.02101,"1381,0H0UXZZ ",.02)
 ;;0H0UXZZ 
 ;;9002226.02101,"1381,0H0UXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0V0ZZ ",.01)
 ;;0H0V0ZZ 
 ;;9002226.02101,"1381,0H0V0ZZ ",.02)
 ;;0H0V0ZZ 
 ;;9002226.02101,"1381,0H0V0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0V3ZZ ",.01)
 ;;0H0V3ZZ 
 ;;9002226.02101,"1381,0H0V3ZZ ",.02)
 ;;0H0V3ZZ 
 ;;9002226.02101,"1381,0H0V3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0H0VXZZ ",.01)
 ;;0H0VXZZ 
 ;;9002226.02101,"1381,0H0VXZZ ",.02)
 ;;0H0VXZZ 
 ;;9002226.02101,"1381,0H0VXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHT0NZ ",.01)
 ;;0HHT0NZ 
 ;;9002226.02101,"1381,0HHT0NZ ",.02)
 ;;0HHT0NZ 
 ;;9002226.02101,"1381,0HHT0NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHT3NZ ",.01)
 ;;0HHT3NZ 
 ;;9002226.02101,"1381,0HHT3NZ ",.02)
 ;;0HHT3NZ 
 ;;9002226.02101,"1381,0HHT3NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHT7NZ ",.01)
 ;;0HHT7NZ 
 ;;9002226.02101,"1381,0HHT7NZ ",.02)
 ;;0HHT7NZ 
 ;;9002226.02101,"1381,0HHT7NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHT8NZ ",.01)
 ;;0HHT8NZ 
 ;;9002226.02101,"1381,0HHT8NZ ",.02)
 ;;0HHT8NZ 
 ;;9002226.02101,"1381,0HHT8NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHU0NZ ",.01)
 ;;0HHU0NZ 
 ;;9002226.02101,"1381,0HHU0NZ ",.02)
 ;;0HHU0NZ 
 ;;9002226.02101,"1381,0HHU0NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHU3NZ ",.01)
 ;;0HHU3NZ 
 ;;9002226.02101,"1381,0HHU3NZ ",.02)
 ;;0HHU3NZ 
 ;;9002226.02101,"1381,0HHU3NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHU7NZ ",.01)
 ;;0HHU7NZ 
 ;;9002226.02101,"1381,0HHU7NZ ",.02)
 ;;0HHU7NZ 
 ;;9002226.02101,"1381,0HHU7NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHU8NZ ",.01)
 ;;0HHU8NZ 
 ;;9002226.02101,"1381,0HHU8NZ ",.02)
 ;;0HHU8NZ 
 ;;9002226.02101,"1381,0HHU8NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHV0NZ ",.01)
 ;;0HHV0NZ 
 ;;9002226.02101,"1381,0HHV0NZ ",.02)
 ;;0HHV0NZ 
 ;;9002226.02101,"1381,0HHV0NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHV3NZ ",.01)
 ;;0HHV3NZ 
 ;;9002226.02101,"1381,0HHV3NZ ",.02)
 ;;0HHV3NZ 
 ;;9002226.02101,"1381,0HHV3NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHV7NZ ",.01)
 ;;0HHV7NZ 
 ;;9002226.02101,"1381,0HHV7NZ ",.02)
 ;;0HHV7NZ 
 ;;9002226.02101,"1381,0HHV7NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HHV8NZ ",.01)
 ;;0HHV8NZ 
 ;;9002226.02101,"1381,0HHV8NZ ",.02)
 ;;0HHV8NZ 
 ;;9002226.02101,"1381,0HHV8NZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HMTXZZ ",.01)
 ;;0HMTXZZ 
 ;;9002226.02101,"1381,0HMTXZZ ",.02)
 ;;0HMTXZZ 
 ;;9002226.02101,"1381,0HMTXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HMUXZZ ",.01)
 ;;0HMUXZZ 
 ;;9002226.02101,"1381,0HMUXZZ ",.02)
 ;;0HMUXZZ 
 ;;9002226.02101,"1381,0HMUXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HMVXZZ ",.01)
 ;;0HMVXZZ 
 ;;9002226.02101,"1381,0HMVXZZ ",.02)
 ;;0HMVXZZ 
 ;;9002226.02101,"1381,0HMVXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HMWXZZ ",.01)
 ;;0HMWXZZ 
 ;;9002226.02101,"1381,0HMWXZZ ",.02)
 ;;0HMWXZZ 
 ;;9002226.02101,"1381,0HMWXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HMXXZZ ",.01)
 ;;0HMXXZZ 
 ;;9002226.02101,"1381,0HMXXZZ ",.02)
 ;;0HMXXZZ 
 ;;9002226.02101,"1381,0HMXXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNT0ZZ ",.01)
 ;;0HNT0ZZ 
 ;;9002226.02101,"1381,0HNT0ZZ ",.02)
 ;;0HNT0ZZ 
 ;;9002226.02101,"1381,0HNT0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNT3ZZ ",.01)
 ;;0HNT3ZZ 
 ;;9002226.02101,"1381,0HNT3ZZ ",.02)
 ;;0HNT3ZZ 
 ;;9002226.02101,"1381,0HNT3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNT7ZZ ",.01)
 ;;0HNT7ZZ 
 ;;9002226.02101,"1381,0HNT7ZZ ",.02)
 ;;0HNT7ZZ 
 ;;9002226.02101,"1381,0HNT7ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNT8ZZ ",.01)
 ;;0HNT8ZZ 
 ;;9002226.02101,"1381,0HNT8ZZ ",.02)
 ;;0HNT8ZZ 
 ;;9002226.02101,"1381,0HNT8ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNTXZZ ",.01)
 ;;0HNTXZZ 
 ;;9002226.02101,"1381,0HNTXZZ ",.02)
 ;;0HNTXZZ 
 ;;9002226.02101,"1381,0HNTXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNU0ZZ ",.01)
 ;;0HNU0ZZ 
 ;;9002226.02101,"1381,0HNU0ZZ ",.02)
 ;;0HNU0ZZ 
 ;;9002226.02101,"1381,0HNU0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNU3ZZ ",.01)
 ;;0HNU3ZZ 
 ;;9002226.02101,"1381,0HNU3ZZ ",.02)
 ;;0HNU3ZZ 
 ;;9002226.02101,"1381,0HNU3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNU7ZZ ",.01)
 ;;0HNU7ZZ 
 ;;9002226.02101,"1381,0HNU7ZZ ",.02)
 ;;0HNU7ZZ 
 ;;9002226.02101,"1381,0HNU7ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNU8ZZ ",.01)
 ;;0HNU8ZZ 
 ;;9002226.02101,"1381,0HNU8ZZ ",.02)
 ;;0HNU8ZZ 
 ;;9002226.02101,"1381,0HNU8ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNUXZZ ",.01)
 ;;0HNUXZZ 
 ;;9002226.02101,"1381,0HNUXZZ ",.02)
 ;;0HNUXZZ 
 ;;9002226.02101,"1381,0HNUXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNV0ZZ ",.01)
 ;;0HNV0ZZ 
 ;;9002226.02101,"1381,0HNV0ZZ ",.02)
 ;;0HNV0ZZ 
 ;;9002226.02101,"1381,0HNV0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNV3ZZ ",.01)
 ;;0HNV3ZZ 
 ;;9002226.02101,"1381,0HNV3ZZ ",.02)
 ;;0HNV3ZZ 
 ;;9002226.02101,"1381,0HNV3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNV7ZZ ",.01)
 ;;0HNV7ZZ 
 ;;9002226.02101,"1381,0HNV7ZZ ",.02)
 ;;0HNV7ZZ 
 ;;9002226.02101,"1381,0HNV7ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNV8ZZ ",.01)
 ;;0HNV8ZZ 
 ;;9002226.02101,"1381,0HNV8ZZ ",.02)
 ;;0HNV8ZZ 
 ;;9002226.02101,"1381,0HNV8ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNVXZZ ",.01)
 ;;0HNVXZZ 
 ;;9002226.02101,"1381,0HNVXZZ ",.02)
 ;;0HNVXZZ 
 ;;9002226.02101,"1381,0HNVXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNW0ZZ ",.01)
 ;;0HNW0ZZ 
 ;;9002226.02101,"1381,0HNW0ZZ ",.02)
 ;;0HNW0ZZ 
 ;;9002226.02101,"1381,0HNW0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNW3ZZ ",.01)
 ;;0HNW3ZZ 
 ;;9002226.02101,"1381,0HNW3ZZ ",.02)
 ;;0HNW3ZZ 
 ;;9002226.02101,"1381,0HNW3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNW7ZZ ",.01)
 ;;0HNW7ZZ 
 ;;9002226.02101,"1381,0HNW7ZZ ",.02)
 ;;0HNW7ZZ 
 ;;9002226.02101,"1381,0HNW7ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNW8ZZ ",.01)
 ;;0HNW8ZZ 
 ;;9002226.02101,"1381,0HNW8ZZ ",.02)
 ;;0HNW8ZZ 
 ;;9002226.02101,"1381,0HNW8ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNWXZZ ",.01)
 ;;0HNWXZZ 
 ;;9002226.02101,"1381,0HNWXZZ ",.02)
 ;;0HNWXZZ 
 ;;9002226.02101,"1381,0HNWXZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNX0ZZ ",.01)
 ;;0HNX0ZZ 
 ;;9002226.02101,"1381,0HNX0ZZ ",.02)
 ;;0HNX0ZZ 
 ;;9002226.02101,"1381,0HNX0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNX3ZZ ",.01)
 ;;0HNX3ZZ 
 ;;9002226.02101,"1381,0HNX3ZZ ",.02)
 ;;0HNX3ZZ 
 ;;9002226.02101,"1381,0HNX3ZZ ",.03)
 ;;31
 ;;9002226.02101,"1381,0HNX7ZZ ",.01)
 ;;0HNX7ZZ 
 ;;9002226.02101,"1381,0HNX7ZZ ",.02)
 ;;0HNX7ZZ 
 ;;9002226.02101,"1381,0HNX7ZZ ",.03)
 ;;31
 ;
OTHER ; OTHER ROUTINES
 D ^ATXO3D2
 D ^ATXO3D3
 Q