BGP2WV ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 28, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP HIV TEST LOINC CODES
 ;
 ; This routine loads Taxonomy BGP HIV TEST LOINC CODES
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
 ;;21,"10351-5 ")
 ;;1
 ;;21,"10682-3 ")
 ;;2
 ;;21,"10901-7 ")
 ;;3
 ;;21,"10902-5 ")
 ;;4
 ;;21,"11078-3 ")
 ;;5
 ;;21,"11079-1 ")
 ;;6
 ;;21,"11080-9 ")
 ;;7
 ;;21,"11081-7 ")
 ;;8
 ;;21,"11082-5 ")
 ;;9
 ;;21,"12855-3 ")
 ;;10
 ;;21,"12856-1 ")
 ;;11
 ;;21,"12857-9 ")
 ;;12
 ;;21,"12858-7 ")
 ;;13
 ;;21,"12859-5 ")
 ;;14
 ;;21,"12870-2 ")
 ;;15
 ;;21,"12871-0 ")
 ;;16
 ;;21,"12872-8 ")
 ;;17
 ;;21,"12875-1 ")
 ;;18
 ;;21,"12876-9 ")
 ;;19
 ;;21,"12893-4 ")
 ;;20
 ;;21,"12894-2 ")
 ;;21
 ;;21,"12895-9 ")
 ;;22
 ;;21,"13499-9 ")
 ;;23
 ;;21,"13920-4 ")
 ;;24
 ;;21,"14092-1 ")
 ;;25
 ;;21,"14126-7 ")
 ;;26
 ;;21,"16132-3 ")
 ;;27
 ;;21,"16974-8 ")
 ;;28
 ;;21,"16975-5 ")
 ;;29
 ;;21,"16976-3 ")
 ;;30
 ;;21,"16977-1 ")
 ;;31
 ;;21,"16978-9 ")
 ;;32
 ;;21,"16979-7 ")
 ;;33
 ;;21,"18396-2 ")
 ;;34
 ;;21,"19110-6 ")
 ;;35
 ;;21,"20447-9 ")
 ;;36
 ;;21,"21007-0 ")
 ;;37
 ;;21,"21008-8 ")
 ;;38
 ;;21,"21009-6 ")
 ;;39
 ;;21,"21331-4 ")
 ;;40
 ;;21,"21332-2 ")
 ;;41
 ;;21,"21333-0 ")
 ;;42
 ;;21,"21334-8 ")
 ;;43
 ;;21,"21335-5 ")
 ;;44
 ;;21,"21336-3 ")
 ;;45
 ;;21,"21337-1 ")
 ;;46
 ;;21,"21338-9 ")
 ;;47
 ;;21,"21339-7 ")
 ;;48
 ;;21,"21340-5 ")
 ;;49
 ;;21,"22356-0 ")
 ;;50
 ;;21,"22357-8 ")
 ;;51
 ;;21,"22358-6 ")
 ;;52
 ;;21,"23876-6 ")
 ;;53
 ;;21,"24012-7 ")
 ;;54
 ;;21,"24013-5 ")
 ;;55
 ;;21,"25835-0 ")
 ;;56
 ;;21,"25836-8 ")
 ;;57
 ;;21,"25841-8 ")
 ;;58
 ;;21,"25842-6 ")
 ;;59
 ;;21,"28004-0 ")
 ;;60
 ;;21,"28052-9 ")
 ;;61
 ;;21,"29327-4 ")
 ;;62
 ;;21,"29539-4 ")
 ;;63
 ;;21,"29541-0 ")
 ;;64
 ;;21,"29893-5 ")
 ;;65
 ;;21,"30245-5 ")
 ;;66
 ;;21,"30361-0 ")
 ;;67
 ;;21,"30554-0 ")
 ;;68
 ;;21,"31072-2 ")
 ;;69
 ;;21,"31073-0 ")
 ;;70
 ;;21,"31201-7 ")
 ;;71
 ;;21,"31430-2 ")
 ;;72
 ;;21,"32571-2 ")
 ;;73
 ;;21,"32602-5 ")
 ;;74
 ;;21,"32827-8 ")
 ;;75
 ;;21,"32842-7 ")
 ;;76
 ;;21,"33508-3 ")
 ;;77
 ;;21,"33630-5 ")
 ;;78
 ;;21,"33660-2 ")
 ;;79
 ;;21,"33806-1 ")
 ;;80
 ;;21,"33807-9 ")
 ;;81
 ;;21,"33866-5 ")
 ;;82
 ;;21,"34591-8 ")
 ;;83
 ;;21,"34592-6 ")
 ;;84
 ;;21,"34699-9 ")
 ;;85
 ;;21,"34700-5 ")
 ;;86
 ;;21,"35437-3 ")
 ;;87
 ;;21,"35438-1 ")
 ;;88
 ;;21,"35439-9 ")
 ;;89
 ;;21,"35440-7 ")
 ;;90
 ;;21,"35441-5 ")
 ;;91
 ;;21,"35442-3 ")
 ;;92
 ;;21,"35443-1 ")
 ;;93
 ;;21,"35444-9 ")
 ;;94
 ;;21,"35445-6 ")
 ;;95
 ;;21,"35446-4 ")
 ;;96
 ;;21,"35447-2 ")
 ;;97
 ;;21,"35448-0 ")
 ;;98
 ;;21,"35449-8 ")
 ;;99
 ;;21,"35450-6 ")
 ;;100
 ;;21,"35452-2 ")
 ;;101
 ;;21,"35564-4 ")
 ;;102
 ;;21,"35565-1 ")
 ;;103
 ;;21,"38998-1 ")
 ;;104
 ;;21,"40437-6 ")
 ;;105
 ;;21,"40438-4 ")
 ;;106
 ;;21,"40439-2 ")
 ;;107
 ;;21,"40732-0 ")
 ;;108
 ;;21,"40733-8 ")
 ;;109
 ;;21,"41143-9 ")
 ;;110
 ;;21,"41144-7 ")
 ;;111
 ;;21,"41145-4 ")
 ;;112
 ;;21,"41290-8 ")
 ;;113
 ;;21,"41497-9 ")
 ;;114
 ;;21,"41498-7 ")
 ;;115
 ;;21,"41513-3 ")
 ;;116
 ;;21,"41514-1 ")
 ;;117
 ;;21,"41515-8 ")
 ;;118
 ;;21,"41516-6 ")
 ;;119
 ;;21,"42339-2 ")
 ;;120
 ;;21,"42600-7 ")
 ;;121
 ;;21,"42627-0 ")
 ;;122
 ;;21,"42768-2 ")
 ;;123
 ;;21,"42917-5 ")
 ;;124
 ;;21,"43008-2 ")
 ;;125
 ;;21,"43009-0 ")
 ;;126
 ;;21,"43010-8 ")
 ;;127
 ;;21,"43011-6 ")
 ;;128
 ;;21,"43012-4 ")
 ;;129
 ;;21,"43013-2 ")
 ;;130
 ;;21,"43185-8 ")
 ;;131
 ;;21,"43599-0 ")
 ;;132
 ;;21,"44531-2 ")
 ;;133
 ;;21,"44532-0 ")
 ;;134
 ;;21,"44533-8 ")
 ;;135
 ;;21,"44607-0 ")
 ;;136
 ;;21,"44871-2 ")
 ;;137
 ;;21,"44872-0 ")
 ;;138
 ;;21,"44873-8 ")
 ;;139
 ;;21,"45175-7 ")
 ;;140
 ;;21,"45176-5 ")
 ;;141
 ;;21,"45182-3 ")
 ;;142
 ;;21,"45212-8 ")
 ;;143
 ;;21,"47029-4 ")
 ;;144
 ;;21,"47359-5 ")
 ;;145
 ;;21,"48023-6 ")
 ;;146
 ;;21,"48345-3 ")
 ;;147
 ;;21,"48346-1 ")
 ;;148
 ;;21,"48510-2 ")
 ;;149
 ;;21,"48511-0 ")
 ;;150
 ;;21,"48551-6 ")
 ;;151
 ;;21,"48552-4 ")
 ;;152
 ;;21,"48558-1 ")
 ;;153
 ;;21,"48559-9 ")
 ;;154
 ;;21,"49483-1 ")
 ;;182
 ;;21,"49580-4 ")
 ;;192
 ;;21,"49718-0 ")
 ;;193
 ;;21,"49890-7 ")
 ;;194
 ;;21,"49905-3 ")
 ;;195
 ;;21,"49965-7 ")
 ;;183
 ;;21,"5017-9 ")
 ;;155
 ;;21,"5018-7 ")
 ;;156
 ;;21,"50624-6 ")
 ;;196
 ;;21,"50790-5 ")
 ;;197
 ;;21,"51780-5 ")
 ;;184
 ;;21,"51786-2 ")
 ;;185
 ;;21,"51866-2 ")
 ;;186
 ;;21,"5220-9 ")
 ;;157
 ;;21,"5221-7 ")
 ;;158
 ;;21,"5222-5 ")
 ;;159
 ;;21,"5223-3 ")
 ;;160
 ;;21,"5224-1 ")
 ;;161
 ;;21,"5225-8 ")
 ;;162
 ;;21,"53379-4 ")
 ;;198
 ;;21,"53601-1 ")
 ;;187
 ;;21,"53825-6 ")
 ;;199
 ;;21,"53923-9 ")
 ;;200
 ;;21,"54086-4 ")
 ;;201
 ;;21,"56888-1 ")
 ;;188
 ;;21,"57182-8 ")
 ;;202
 ;;21,"57974-8 ")
 ;;203
 ;;21,"57975-5 ")
 ;;204
 ;;21,"57976-3 ")
 ;;189
 ;;21,"57977-1 ")
 ;;190
 ;;21,"57978-9 ")
 ;;191
 ;;21,"58900-2 ")
 ;;205
 ;;21,"59052-1 ")
 ;;206
 ;;21,"59419-2 ")
 ;;207
 ;;21,"62456-9 ")
 ;;208
 ;;21,"62469-2 ")
 ;;209
 ;;21,"6429-5 ")
 ;;163
 ;;21,"6430-3 ")
 ;;164
 ;;21,"6431-1 ")
 ;;165
 ;;21,"68961-2 ")
 ;;210
 ;;21,"69353-1 ")
 ;;211
 ;;21,"69354-9 ")
 ;;212
 ;;21,"7917-8 ")
 ;;166
 ;;21,"7918-6 ")
 ;;167
 ;;21,"7919-4 ")
 ;;168
 ;;21,"9660-2 ")
 ;;169
 ;;21,"9661-0 ")
 ;;170
 ;;21,"9662-8 ")
 ;;171
 ;;21,"9663-6 ")
 ;;172
 ;;21,"9664-4 ")
 ;;173
 ;;21,"9665-1 ")
 ;;174
 ;;21,"9666-9 ")
 ;;175
 ;;21,"9667-7 ")
 ;;176
 ;;21,"9668-5 ")
 ;;177
 ;;21,"9669-3 ")
 ;;178
 ;;21,"9821-0 ")
 ;;179
 ;;21,"9836-8 ")
 ;;180
 ;;21,"9837-6 ")
 ;;181
 ;;9002226,314,.01)
 ;;BGP HIV TEST LOINC CODES
 ;;9002226,314,.02)
 ;;@
 ;;9002226,314,.04)
 ;;n
 ;;9002226,314,.06)
 ;;@
 ;;9002226,314,.08)
 ;;@
 ;;9002226,314,.09)
 ;;@
 ;;9002226,314,.11)
 ;;@
 ;;9002226,314,.12)
 ;;@
 ;;9002226,314,.13)
 ;;1
 ;;9002226,314,.14)
 ;;FIHS
 ;;9002226,314,.15)
 ;;95.3
 ;;9002226,314,.16)
 ;;0
 ;;9002226,314,.17)
 ;;@
 ;;9002226,314,3101)
 ;;@
 ;;9002226.02101,"314,10351-5 ",.01)
 ;;10351-5
 ;;9002226.02101,"314,10351-5 ",.02)
 ;;10351-5
 ;;9002226.02101,"314,10682-3 ",.01)
 ;;10682-3
 ;;9002226.02101,"314,10682-3 ",.02)
 ;;10682-3
 ;;9002226.02101,"314,10901-7 ",.01)
 ;;10901-7
 ;;9002226.02101,"314,10901-7 ",.02)
 ;;10901-7
 ;;9002226.02101,"314,10902-5 ",.01)
 ;;10902-5
 ;;9002226.02101,"314,10902-5 ",.02)
 ;;10902-5
 ;;9002226.02101,"314,11078-3 ",.01)
 ;;11078-3
 ;;9002226.02101,"314,11078-3 ",.02)
 ;;11078-3
 ;;9002226.02101,"314,11079-1 ",.01)
 ;;11079-1
 ;;9002226.02101,"314,11079-1 ",.02)
 ;;11079-1
 ;;9002226.02101,"314,11080-9 ",.01)
 ;;11080-9
 ;;9002226.02101,"314,11080-9 ",.02)
 ;;11080-9
 ;;9002226.02101,"314,11081-7 ",.01)
 ;;11081-7
 ;;9002226.02101,"314,11081-7 ",.02)
 ;;11081-7
 ;;9002226.02101,"314,11082-5 ",.01)
 ;;11082-5
 ;;9002226.02101,"314,11082-5 ",.02)
 ;;11082-5
 ;;9002226.02101,"314,12855-3 ",.01)
 ;;12855-3
 ;;9002226.02101,"314,12855-3 ",.02)
 ;;12855-3
 ;;9002226.02101,"314,12856-1 ",.01)
 ;;12856-1
 ;;9002226.02101,"314,12856-1 ",.02)
 ;;12856-1
 ;;9002226.02101,"314,12857-9 ",.01)
 ;;12857-9
 ;;9002226.02101,"314,12857-9 ",.02)
 ;;12857-9
 ;;9002226.02101,"314,12858-7 ",.01)
 ;;12858-7
 ;;9002226.02101,"314,12858-7 ",.02)
 ;;12858-7
 ;;9002226.02101,"314,12859-5 ",.01)
 ;;12859-5
 ;;9002226.02101,"314,12859-5 ",.02)
 ;;12859-5
 ;;9002226.02101,"314,12870-2 ",.01)
 ;;12870-2
 ;;9002226.02101,"314,12870-2 ",.02)
 ;;12870-2
 ;;9002226.02101,"314,12871-0 ",.01)
 ;;12871-0
 ;;9002226.02101,"314,12871-0 ",.02)
 ;;12871-0
 ;;9002226.02101,"314,12872-8 ",.01)
 ;;12872-8
 ;;9002226.02101,"314,12872-8 ",.02)
 ;;12872-8
 ;;9002226.02101,"314,12875-1 ",.01)
 ;;12875-1
 ;;9002226.02101,"314,12875-1 ",.02)
 ;;12875-1
 ;;9002226.02101,"314,12876-9 ",.01)
 ;;12876-9
 ;;9002226.02101,"314,12876-9 ",.02)
 ;;12876-9
 ;;9002226.02101,"314,12893-4 ",.01)
 ;;12893-4
 ;;9002226.02101,"314,12893-4 ",.02)
 ;;12893-4
 ;;9002226.02101,"314,12894-2 ",.01)
 ;;12894-2
 ;;9002226.02101,"314,12894-2 ",.02)
 ;;12894-2
 ;;9002226.02101,"314,12895-9 ",.01)
 ;;12895-9
 ;;9002226.02101,"314,12895-9 ",.02)
 ;;12895-9
 ;;9002226.02101,"314,13499-9 ",.01)
 ;;13499-9
 ;;9002226.02101,"314,13499-9 ",.02)
 ;;13499-9
 ;;9002226.02101,"314,13920-4 ",.01)
 ;;13920-4
 ;;9002226.02101,"314,13920-4 ",.02)
 ;;13920-4
 ;;9002226.02101,"314,14092-1 ",.01)
 ;;14092-1
 ;;9002226.02101,"314,14092-1 ",.02)
 ;;14092-1
 ;;9002226.02101,"314,14126-7 ",.01)
 ;;14126-7
 ;;9002226.02101,"314,14126-7 ",.02)
 ;;14126-7
 ;;9002226.02101,"314,16132-3 ",.01)
 ;;16132-3
 ;;9002226.02101,"314,16132-3 ",.02)
 ;;16132-3
 ;;9002226.02101,"314,16974-8 ",.01)
 ;;16974-8
 ;;9002226.02101,"314,16974-8 ",.02)
 ;;16974-8
 ;;9002226.02101,"314,16975-5 ",.01)
 ;;16975-5
 ;;9002226.02101,"314,16975-5 ",.02)
 ;;16975-5
 ;;9002226.02101,"314,16976-3 ",.01)
 ;;16976-3
 ;;9002226.02101,"314,16976-3 ",.02)
 ;;16976-3
 ;;9002226.02101,"314,16977-1 ",.01)
 ;;16977-1
 ;;9002226.02101,"314,16977-1 ",.02)
 ;;16977-1
 ;;9002226.02101,"314,16978-9 ",.01)
 ;;16978-9
 ;;9002226.02101,"314,16978-9 ",.02)
 ;;16978-9
 ;;9002226.02101,"314,16979-7 ",.01)
 ;;16979-7
 ;;9002226.02101,"314,16979-7 ",.02)
 ;;16979-7
 ;;9002226.02101,"314,18396-2 ",.01)
 ;;18396-2
 ;;9002226.02101,"314,18396-2 ",.02)
 ;;18396-2
 ;;9002226.02101,"314,19110-6 ",.01)
 ;;19110-6
 ;;9002226.02101,"314,19110-6 ",.02)
 ;;19110-6
 ;;9002226.02101,"314,20447-9 ",.01)
 ;;20447-9
 ;;9002226.02101,"314,20447-9 ",.02)
 ;;20447-9
 ;;9002226.02101,"314,21007-0 ",.01)
 ;;21007-0
 ;;9002226.02101,"314,21007-0 ",.02)
 ;;21007-0
 ;;9002226.02101,"314,21008-8 ",.01)
 ;;21008-8
 ;;9002226.02101,"314,21008-8 ",.02)
 ;;21008-8
 ;;9002226.02101,"314,21009-6 ",.01)
 ;;21009-6
 ;;9002226.02101,"314,21009-6 ",.02)
 ;;21009-6
 ;;9002226.02101,"314,21331-4 ",.01)
 ;;21331-4
 ;;9002226.02101,"314,21331-4 ",.02)
 ;;21331-4
 ;;9002226.02101,"314,21332-2 ",.01)
 ;;21332-2
 ;;9002226.02101,"314,21332-2 ",.02)
 ;;21332-2
 ;;9002226.02101,"314,21333-0 ",.01)
 ;;21333-0
 ;;9002226.02101,"314,21333-0 ",.02)
 ;;21333-0
 ;;9002226.02101,"314,21334-8 ",.01)
 ;;21334-8
 ;;9002226.02101,"314,21334-8 ",.02)
 ;;21334-8
 ;;9002226.02101,"314,21335-5 ",.01)
 ;;21335-5
 ;;9002226.02101,"314,21335-5 ",.02)
 ;;21335-5
 ;;9002226.02101,"314,21336-3 ",.01)
 ;;21336-3
 ;;9002226.02101,"314,21336-3 ",.02)
 ;;21336-3
 ;;9002226.02101,"314,21337-1 ",.01)
 ;;21337-1
 ;;9002226.02101,"314,21337-1 ",.02)
 ;;21337-1
 ;;9002226.02101,"314,21338-9 ",.01)
 ;;21338-9
 ;;9002226.02101,"314,21338-9 ",.02)
 ;;21338-9
 ;;9002226.02101,"314,21339-7 ",.01)
 ;;21339-7
 ;;9002226.02101,"314,21339-7 ",.02)
 ;;21339-7
 ;;9002226.02101,"314,21340-5 ",.01)
 ;;21340-5
 ;;9002226.02101,"314,21340-5 ",.02)
 ;;21340-5
 ;;9002226.02101,"314,22356-0 ",.01)
 ;;22356-0
 ;;9002226.02101,"314,22356-0 ",.02)
 ;;22356-0
 ;;9002226.02101,"314,22357-8 ",.01)
 ;;22357-8
 ;;9002226.02101,"314,22357-8 ",.02)
 ;;22357-8
 ;;9002226.02101,"314,22358-6 ",.01)
 ;;22358-6
 ;;9002226.02101,"314,22358-6 ",.02)
 ;;22358-6
 ;;9002226.02101,"314,23876-6 ",.01)
 ;;23876-6
 ;;9002226.02101,"314,23876-6 ",.02)
 ;;23876-6
 ;;9002226.02101,"314,24012-7 ",.01)
 ;;24012-7
 ;;9002226.02101,"314,24012-7 ",.02)
 ;;24012-7
 ;;9002226.02101,"314,24013-5 ",.01)
 ;;24013-5
 ;;9002226.02101,"314,24013-5 ",.02)
 ;;24013-5
 ;;9002226.02101,"314,25835-0 ",.01)
 ;;25835-0
 ;;9002226.02101,"314,25835-0 ",.02)
 ;;25835-0
 ;;9002226.02101,"314,25836-8 ",.01)
 ;;25836-8
 ;;9002226.02101,"314,25836-8 ",.02)
 ;;25836-8
 ;;9002226.02101,"314,25841-8 ",.01)
 ;;25841-8
 ;;9002226.02101,"314,25841-8 ",.02)
 ;;25841-8
 ;;9002226.02101,"314,25842-6 ",.01)
 ;;25842-6
 ;;9002226.02101,"314,25842-6 ",.02)
 ;;25842-6
 ;;9002226.02101,"314,28004-0 ",.01)
 ;;28004-0
 ;;9002226.02101,"314,28004-0 ",.02)
 ;;28004-0
 ;;9002226.02101,"314,28052-9 ",.01)
 ;;28052-9
 ;;9002226.02101,"314,28052-9 ",.02)
 ;;28052-9
 ;;9002226.02101,"314,29327-4 ",.01)
 ;;29327-4
 ;;9002226.02101,"314,29327-4 ",.02)
 ;;29327-4
 ;;9002226.02101,"314,29539-4 ",.01)
 ;;29539-4
 ;;9002226.02101,"314,29539-4 ",.02)
 ;;29539-4
 ;;9002226.02101,"314,29541-0 ",.01)
 ;;29541-0
 ;;9002226.02101,"314,29541-0 ",.02)
 ;;29541-0
 ;;9002226.02101,"314,29893-5 ",.01)
 ;;29893-5
 ;;9002226.02101,"314,29893-5 ",.02)
 ;;29893-5
 ;;9002226.02101,"314,30245-5 ",.01)
 ;;30245-5
 ;;9002226.02101,"314,30245-5 ",.02)
 ;;30245-5
 ;;9002226.02101,"314,30361-0 ",.01)
 ;;30361-0
 ;;9002226.02101,"314,30361-0 ",.02)
 ;;30361-0
 ;;9002226.02101,"314,30554-0 ",.01)
 ;;30554-0
 ;;9002226.02101,"314,30554-0 ",.02)
 ;;30554-0
 ;;9002226.02101,"314,31072-2 ",.01)
 ;;31072-2
 ;;9002226.02101,"314,31072-2 ",.02)
 ;;31072-2
 ;;9002226.02101,"314,31073-0 ",.01)
 ;;31073-0
 ;;9002226.02101,"314,31073-0 ",.02)
 ;;31073-0
 ;
OTHER ; OTHER ROUTINES
 D ^BGP2WV2
 D ^BGP2WV3
 Q
