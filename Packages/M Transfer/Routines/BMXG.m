BMXG ; IHS/OIT/HMW - UTIL: GET DATA ; 
 ;;4.0;BMX;;JUN 28, 2010
 ;;Stolen from:* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;
 ;
 ;----------
GET(FILE,Y,PC) ;EP
 ;---> Return text of .01 Field of an entry in a file.
 ;---> Parameters:
 ;     1 - FILE (req) Number corresponding to desired file:
 ;                    1 = State File, #5
 ;                    2 = Community File, #9999999.5
 ;                    3 = Employer File, #9999999.75
 ;                    4 = Beneficiary File, #9999999.25
 ;                    5 = Tribe File, #9999999.03
 ;                    6 = Insurer File, #9999999.18
 ;                    7 = Suffix File, #9999999.32
 ;                    8 = Employer Group Insurance File, #9999999.77
 ;                    9 = Medicare Eligible File, #9000003
 ;                   10 = Medicaid Eligible File, #9000004
 ;                   11 = Private Insurance Eligible File, #9000006
 ;                   12 = Patient File, #9000001
 ;                   13 = VA Patient File, #2
 ;                   14 = Policy Holder File, #9000003.1
 ;                   15 = Relationship File, #9999999.36
 ;
 ;     2 - Y    (req) IEN in the File storing the desired entry.
 ;     3 - PC   (opt) Piece of 0-Node to return (default=1).
 ;                    If PC=0 return entire 0-node.
 ;
 Q:($G(Y)'?1N.N) ""
 Q:'$G(FILE) ""
 S:$G(PC)="" PC=1 S U="^"
 ;
 D
 .I FILE=1 S GLB="^DIC(5,"_Y_",0)" Q
 .I FILE=2 S GLB="^AUTTCOM("_Y_",0)" Q
 .I FILE=3 S GLB="^AUTNEMPL("_Y_",0)" Q
 .I FILE=4 S GLB="^AUTTBEN("_Y_",0)" Q
 .I FILE=5 S GLB="^AUTTTRI("_Y_",0)" Q
 .I FILE=6 S GLB="^AUTNINS("_Y_",0)" Q
 .I FILE=7 S GLB="^AUTTMCS("_Y_",0)" Q
 .I FILE=8 S GLB="^AUTNEGRP("_Y_",0)" Q
 .I FILE=9 S GLB="^AUPNMCR("_Y_",0)" Q
 .I FILE=10 S GLB="^AUPNMCD("_Y_",0)" Q
 .I FILE=11 S GLB="^AUPNPRVT("_Y_",0)" Q
 .I FILE=12 S GLB="^AUPNPAT("_Y_",0)" Q
 .I FILE=13 S GLB="^DPT("_Y_",0)" Q
 .I FILE=14 S GLB="^AUPN3PPH("_Y_",0)" Q
 .I FILE=15 S GLB="^AUTTRLSH("_Y_",0)" Q
 ;
 Q:'FILE ""
 Q:PC=0 $G(@GLB)
 Q $P($G(@GLB),U,PC)
