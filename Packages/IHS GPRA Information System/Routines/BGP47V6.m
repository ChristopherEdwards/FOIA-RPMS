BGP47V6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"67544-0491-45 ")
 ;;1953
 ;;21,"67544-0567-30 ")
 ;;1954
 ;;21,"67544-0567-60 ")
 ;;1955
 ;;21,"67544-0573-82 ")
 ;;1956
 ;;21,"67544-0627-80 ")
 ;;1957
 ;;21,"67544-0911-60 ")
 ;;1958
 ;;21,"67801-0304-30 ")
 ;;1959
 ;;21,"67801-0315-30 ")
 ;;1960
 ;;21,"67801-0316-03 ")
 ;;1961
 ;;21,"67857-0700-01 ")
 ;;1962
 ;;21,"67857-0701-01 ")
 ;;1963
 ;;21,"68084-0209-01 ")
 ;;1964
 ;;21,"68084-0209-11 ")
 ;;1965
 ;;21,"68084-0210-01 ")
 ;;1966
 ;;21,"68084-0210-11 ")
 ;;1967
 ;;21,"68084-0211-01 ")
 ;;1968
 ;;21,"68084-0211-11 ")
 ;;1969
 ;;21,"68084-0212-01 ")
 ;;1970
 ;;21,"68084-0212-11 ")
 ;;1971
 ;;21,"68084-0261-01 ")
 ;;1972
 ;;21,"68084-0261-11 ")
 ;;1973
 ;;21,"68084-0262-01 ")
 ;;1974
 ;;21,"68084-0262-11 ")
 ;;1975
 ;;21,"68084-0263-01 ")
 ;;1976
 ;;21,"68084-0263-11 ")
 ;;1977
 ;;21,"68084-0264-01 ")
 ;;1978
 ;;21,"68084-0264-11 ")
 ;;1979
 ;;21,"68084-0301-01 ")
 ;;1980
 ;;21,"68084-0301-11 ")
 ;;1981
 ;;21,"68084-0302-11 ")
 ;;1982
 ;;21,"68084-0302-21 ")
 ;;1983
 ;;21,"68084-0303-01 ")
 ;;1984
 ;;21,"68084-0303-11 ")
 ;;1985
 ;;21,"68084-0304-01 ")
 ;;1986
 ;;21,"68084-0304-11 ")
 ;;1987
 ;;21,"68084-0387-01 ")
 ;;1988
 ;;21,"68084-0456-01 ")
 ;;1989
 ;;21,"68084-0456-11 ")
 ;;1990
 ;;21,"68084-0457-01 ")
 ;;1991
 ;;21,"68084-0457-11 ")
 ;;1992
 ;;21,"68084-0487-11 ")
 ;;1993
 ;;21,"68084-0487-21 ")
 ;;1994
 ;;21,"68084-0497-01 ")
 ;;1995
 ;;21,"68084-0497-11 ")
 ;;1996
 ;;21,"68084-0503-01 ")
 ;;1997
 ;;21,"68084-0503-11 ")
 ;;1998
 ;;21,"68084-0504-01 ")
 ;;1999
 ;;21,"68084-0504-11 ")
 ;;2000
 ;;21,"68115-0040-15 ")
 ;;2001
 ;;21,"68115-0238-90 ")
 ;;2002
 ;;21,"68115-0239-90 ")
 ;;2003
 ;;21,"68115-0310-30 ")
 ;;2004
 ;;21,"68115-0727-30 ")
 ;;2005
 ;;21,"68382-0022-01 ")
 ;;2006
 ;;21,"68382-0022-10 ")
 ;;2007
 ;;21,"68382-0023-01 ")
 ;;2008
 ;;21,"68382-0023-10 ")
 ;;2009
 ;;21,"68382-0024-01 ")
 ;;2010
 ;;21,"68382-0024-10 ")
 ;;2011
 ;;21,"68382-0092-01 ")
 ;;2012
 ;;21,"68382-0092-05 ")
 ;;2013
 ;;21,"68382-0093-01 ")
 ;;2014
 ;;21,"68382-0093-05 ")
 ;;2015
 ;;21,"68382-0094-01 ")
 ;;2016
 ;;21,"68382-0094-05 ")
 ;;2017
 ;;21,"68382-0095-01 ")
 ;;2018
 ;;21,"68382-0095-05 ")
 ;;2019
 ;;21,"68387-0538-30 ")
 ;;2020
 ;;21,"68387-0539-30 ")
 ;;2021
 ;;21,"68462-0162-01 ")
 ;;2022
 ;;21,"68462-0162-05 ")
 ;;2023
 ;;21,"68462-0163-01 ")
 ;;2024
 ;;21,"68462-0163-05 ")
 ;;2025
 ;;21,"68462-0164-01 ")
 ;;2026
 ;;21,"68462-0164-05 ")
 ;;2027
 ;;21,"68462-0165-01 ")
 ;;2028
 ;;21,"68462-0165-05 ")
 ;;2029
 ;;21,"68645-0190-59 ")
 ;;2030
 ;;21,"68645-0191-59 ")
 ;;2031
 ;;9002226,805,.01)
 ;;BGP HEDIS BETA BLOCKER NDC
 ;;9002226,805,.02)
 ;;@
 ;;9002226,805,.04)
 ;;n
 ;;9002226,805,.06)
 ;;@
 ;;9002226,805,.08)
 ;;@
 ;;9002226,805,.09)
 ;;3140317
 ;;9002226,805,.11)
 ;;@
 ;;9002226,805,.12)
 ;;@
 ;;9002226,805,.13)
 ;;1
 ;;9002226,805,.14)
 ;;@
 ;;9002226,805,.15)
 ;;@
 ;;9002226,805,.16)
 ;;@
 ;;9002226,805,.17)
 ;;@
 ;;9002226,805,3101)
 ;;@
 ;;9002226.02101,"805,00007-3370-13 ",.01)
 ;;00007-3370-13
 ;;9002226.02101,"805,00007-3370-13 ",.02)
 ;;00007-3370-13
 ;;9002226.02101,"805,00007-3370-59 ",.01)
 ;;00007-3370-59
 ;;9002226.02101,"805,00007-3370-59 ",.02)
 ;;00007-3370-59
 ;;9002226.02101,"805,00007-3371-13 ",.01)
 ;;00007-3371-13
 ;;9002226.02101,"805,00007-3371-13 ",.02)
 ;;00007-3371-13
 ;;9002226.02101,"805,00007-3371-59 ",.01)
 ;;00007-3371-59
 ;;9002226.02101,"805,00007-3371-59 ",.02)
 ;;00007-3371-59
 ;;9002226.02101,"805,00007-3372-13 ",.01)
 ;;00007-3372-13
 ;;9002226.02101,"805,00007-3372-13 ",.02)
 ;;00007-3372-13
 ;;9002226.02101,"805,00007-3372-59 ",.01)
 ;;00007-3372-59
 ;;9002226.02101,"805,00007-3372-59 ",.02)
 ;;00007-3372-59
 ;;9002226.02101,"805,00007-3373-13 ",.01)
 ;;00007-3373-13
 ;;9002226.02101,"805,00007-3373-13 ",.02)
 ;;00007-3373-13
 ;;9002226.02101,"805,00007-3373-59 ",.01)
 ;;00007-3373-59
 ;;9002226.02101,"805,00007-3373-59 ",.02)
 ;;00007-3373-59
 ;;9002226.02101,"805,00007-4139-20 ",.01)
 ;;00007-4139-20
 ;;9002226.02101,"805,00007-4139-20 ",.02)
 ;;00007-4139-20
 ;;9002226.02101,"805,00007-4140-20 ",.01)
 ;;00007-4140-20
 ;;9002226.02101,"805,00007-4140-20 ",.02)
 ;;00007-4140-20
 ;;9002226.02101,"805,00007-4141-20 ",.01)
 ;;00007-4141-20
 ;;9002226.02101,"805,00007-4141-20 ",.02)
 ;;00007-4141-20
 ;;9002226.02101,"805,00007-4142-20 ",.01)
 ;;00007-4142-20
 ;;9002226.02101,"805,00007-4142-20 ",.02)
 ;;00007-4142-20
 ;;9002226.02101,"805,00024-2300-20 ",.01)
 ;;00024-2300-20
 ;;9002226.02101,"805,00024-2300-20 ",.02)
 ;;00024-2300-20
 ;;9002226.02101,"805,00024-2301-10 ",.01)
 ;;00024-2301-10
 ;;9002226.02101,"805,00024-2301-10 ",.02)
 ;;00024-2301-10
 ;;9002226.02101,"805,00028-0051-01 ",.01)
 ;;00028-0051-01
 ;;9002226.02101,"805,00028-0051-01 ",.02)
 ;;00028-0051-01
 ;;9002226.02101,"805,00028-0051-10 ",.01)
 ;;00028-0051-10
 ;;9002226.02101,"805,00028-0051-10 ",.02)
 ;;00028-0051-10
 ;;9002226.02101,"805,00028-0071-01 ",.01)
 ;;00028-0071-01
 ;;9002226.02101,"805,00028-0071-01 ",.02)
 ;;00028-0071-01
 ;;9002226.02101,"805,00028-0071-10 ",.01)
 ;;00028-0071-10
 ;;9002226.02101,"805,00028-0071-10 ",.02)
 ;;00028-0071-10
 ;;9002226.02101,"805,00054-3727-63 ",.01)
 ;;00054-3727-63
 ;;9002226.02101,"805,00054-3727-63 ",.02)
 ;;00054-3727-63
 ;;9002226.02101,"805,00054-3730-63 ",.01)
 ;;00054-3730-63
 ;;9002226.02101,"805,00054-3730-63 ",.02)
 ;;00054-3730-63
 ;;9002226.02101,"805,00078-0458-05 ",.01)
 ;;00078-0458-05
 ;;9002226.02101,"805,00078-0458-05 ",.02)
 ;;00078-0458-05
 ;;9002226.02101,"805,00078-0458-09 ",.01)
 ;;00078-0458-09
 ;;9002226.02101,"805,00078-0458-09 ",.02)
 ;;00078-0458-09
 ;;9002226.02101,"805,00078-0459-05 ",.01)
 ;;00078-0459-05
 ;;9002226.02101,"805,00078-0459-05 ",.02)
 ;;00078-0459-05
 ;;9002226.02101,"805,00078-0459-09 ",.01)
 ;;00078-0459-09
 ;;9002226.02101,"805,00078-0459-09 ",.02)
 ;;00078-0459-09
 ;;9002226.02101,"805,00078-0460-05 ",.01)
 ;;00078-0460-05
 ;;9002226.02101,"805,00078-0460-05 ",.02)
 ;;00078-0460-05
 ;;9002226.02101,"805,00078-0461-05 ",.01)
 ;;00078-0461-05
 ;;9002226.02101,"805,00078-0461-05 ",.02)
 ;;00078-0461-05
 ;;9002226.02101,"805,00085-0244-04 ",.01)
 ;;00085-0244-04
 ;;9002226.02101,"805,00085-0244-04 ",.02)
 ;;00085-0244-04
 ;;9002226.02101,"805,00085-0244-05 ",.01)
 ;;00085-0244-05
 ;;9002226.02101,"805,00085-0244-05 ",.02)
 ;;00085-0244-05
 ;;9002226.02101,"805,00085-0244-07 ",.01)
 ;;00085-0244-07
 ;;9002226.02101,"805,00085-0244-07 ",.02)
 ;;00085-0244-07
 ;;9002226.02101,"805,00085-0244-08 ",.01)
 ;;00085-0244-08
 ;;9002226.02101,"805,00085-0244-08 ",.02)
 ;;00085-0244-08
 ;;9002226.02101,"805,00085-0438-03 ",.01)
 ;;00085-0438-03
 ;;9002226.02101,"805,00085-0438-03 ",.02)
 ;;00085-0438-03
 ;;9002226.02101,"805,00085-0438-05 ",.01)
 ;;00085-0438-05
 ;;9002226.02101,"805,00085-0438-05 ",.02)
 ;;00085-0438-05
 ;;9002226.02101,"805,00085-0438-06 ",.01)
 ;;00085-0438-06
 ;;9002226.02101,"805,00085-0438-06 ",.02)
 ;;00085-0438-06
 ;;9002226.02101,"805,00085-0752-04 ",.01)
 ;;00085-0752-04
 ;;9002226.02101,"805,00085-0752-04 ",.02)
 ;;00085-0752-04
 ;;9002226.02101,"805,00085-0752-05 ",.01)
 ;;00085-0752-05
 ;;9002226.02101,"805,00085-0752-05 ",.02)
 ;;00085-0752-05
 ;;9002226.02101,"805,00085-0752-07 ",.01)
 ;;00085-0752-07
 ;;9002226.02101,"805,00085-0752-07 ",.02)
 ;;00085-0752-07
 ;;9002226.02101,"805,00085-0752-08 ",.01)
 ;;00085-0752-08
 ;;9002226.02101,"805,00085-0752-08 ",.02)
 ;;00085-0752-08
 ;;9002226.02101,"805,00091-4500-15 ",.01)
 ;;00091-4500-15
 ;;9002226.02101,"805,00091-4500-15 ",.02)
 ;;00091-4500-15
 ;;9002226.02101,"805,00093-0051-01 ",.01)
 ;;00093-0051-01
 ;;9002226.02101,"805,00093-0051-01 ",.02)
 ;;00093-0051-01
 ;;9002226.02101,"805,00093-0051-05 ",.01)
 ;;00093-0051-05
 ;;9002226.02101,"805,00093-0051-05 ",.02)
 ;;00093-0051-05
 ;;9002226.02101,"805,00093-0135-01 ",.01)
 ;;00093-0135-01
 ;;9002226.02101,"805,00093-0135-01 ",.02)
 ;;00093-0135-01
 ;;9002226.02101,"805,00093-0135-05 ",.01)
 ;;00093-0135-05
 ;;9002226.02101,"805,00093-0135-05 ",.02)
 ;;00093-0135-05
 ;;9002226.02101,"805,00093-0733-01 ",.01)
 ;;00093-0733-01
 ;;9002226.02101,"805,00093-0733-01 ",.02)
 ;;00093-0733-01
 ;;9002226.02101,"805,00093-0733-10 ",.01)
 ;;00093-0733-10
 ;;9002226.02101,"805,00093-0733-10 ",.02)
 ;;00093-0733-10
 ;;9002226.02101,"805,00093-0734-01 ",.01)
 ;;00093-0734-01
 ;;9002226.02101,"805,00093-0734-01 ",.02)
 ;;00093-0734-01
 ;;9002226.02101,"805,00093-0734-10 ",.01)
 ;;00093-0734-10
 ;;9002226.02101,"805,00093-0734-10 ",.02)
 ;;00093-0734-10
 ;;9002226.02101,"805,00093-0752-01 ",.01)
 ;;00093-0752-01
 ;;9002226.02101,"805,00093-0752-01 ",.02)
 ;;00093-0752-01
 ;;9002226.02101,"805,00093-0752-10 ",.01)
 ;;00093-0752-10
 ;;9002226.02101,"805,00093-0752-10 ",.02)
 ;;00093-0752-10
 ;;9002226.02101,"805,00093-0753-01 ",.01)
 ;;00093-0753-01
 ;;9002226.02101,"805,00093-0753-01 ",.02)
 ;;00093-0753-01
 ;;9002226.02101,"805,00093-0753-05 ",.01)
 ;;00093-0753-05
 ;;9002226.02101,"805,00093-0753-05 ",.02)
 ;;00093-0753-05
 ;;9002226.02101,"805,00093-0787-01 ",.01)
 ;;00093-0787-01
 ;;9002226.02101,"805,00093-0787-01 ",.02)
 ;;00093-0787-01
 ;;9002226.02101,"805,00093-0787-10 ",.01)
 ;;00093-0787-10
 ;;9002226.02101,"805,00093-0787-10 ",.02)
 ;;00093-0787-10
 ;;9002226.02101,"805,00093-1060-01 ",.01)
 ;;00093-1060-01
 ;;9002226.02101,"805,00093-1060-01 ",.02)
 ;;00093-1060-01
 ;;9002226.02101,"805,00093-1061-01 ",.01)
 ;;00093-1061-01
 ;;9002226.02101,"805,00093-1061-01 ",.02)
 ;;00093-1061-01
 ;;9002226.02101,"805,00093-1062-01 ",.01)
 ;;00093-1062-01
 ;;9002226.02101,"805,00093-1062-01 ",.02)
 ;;00093-1062-01
 ;;9002226.02101,"805,00093-1063-01 ",.01)
 ;;00093-1063-01
 ;;9002226.02101,"805,00093-1063-01 ",.02)
 ;;00093-1063-01
 ;;9002226.02101,"805,00093-4235-01 ",.01)
 ;;00093-4235-01
 ;;9002226.02101,"805,00093-4235-01 ",.02)
 ;;00093-4235-01
 ;;9002226.02101,"805,00093-4236-01 ",.01)
 ;;00093-4236-01
 ;;9002226.02101,"805,00093-4236-01 ",.02)
 ;;00093-4236-01
 ;;9002226.02101,"805,00093-4237-01 ",.01)
 ;;00093-4237-01
 ;;9002226.02101,"805,00093-4237-01 ",.02)
 ;;00093-4237-01
 ;;9002226.02101,"805,00093-5270-56 ",.01)
 ;;00093-5270-56
 ;;9002226.02101,"805,00093-5270-56 ",.02)
 ;;00093-5270-56
 ;;9002226.02101,"805,00093-5271-56 ",.01)
 ;;00093-5271-56
 ;;9002226.02101,"805,00093-5271-56 ",.02)
 ;;00093-5271-56
 ;;9002226.02101,"805,00093-7295-01 ",.01)
 ;;00093-7295-01
 ;;9002226.02101,"805,00093-7295-01 ",.02)
 ;;00093-7295-01
 ;;9002226.02101,"805,00093-7295-05 ",.01)
 ;;00093-7295-05
 ;;9002226.02101,"805,00093-7295-05 ",.02)
 ;;00093-7295-05
 ;;9002226.02101,"805,00093-7296-01 ",.01)
 ;;00093-7296-01
 ;;9002226.02101,"805,00093-7296-01 ",.02)
 ;;00093-7296-01
 ;;9002226.02101,"805,00093-7296-05 ",.01)
 ;;00093-7296-05
 ;;9002226.02101,"805,00093-7296-05 ",.02)
 ;;00093-7296-05
 ;;9002226.02101,"805,00115-2711-01 ",.01)
 ;;00115-2711-01
 ;;9002226.02101,"805,00115-2711-01 ",.02)
 ;;00115-2711-01
 ;;9002226.02101,"805,00115-5311-01 ",.01)
 ;;00115-5311-01
 ;;9002226.02101,"805,00115-5311-01 ",.02)
 ;;00115-5311-01
 ;;9002226.02101,"805,00115-5322-01 ",.01)
 ;;00115-5322-01
 ;;9002226.02101,"805,00115-5322-01 ",.02)
 ;;00115-5322-01
 ;;9002226.02101,"805,00172-4364-10 ",.01)
 ;;00172-4364-10
 ;;9002226.02101,"805,00172-4364-10 ",.02)
 ;;00172-4364-10
 ;;9002226.02101,"805,00172-4364-60 ",.01)
 ;;00172-4364-60
 ;;9002226.02101,"805,00172-4364-60 ",.02)
 ;;00172-4364-60
 ;;9002226.02101,"805,00172-4364-70 ",.01)
 ;;00172-4364-70
 ;;9002226.02101,"805,00172-4364-70 ",.02)
 ;;00172-4364-70
 ;;9002226.02101,"805,00172-4365-00 ",.01)
 ;;00172-4365-00
 ;;9002226.02101,"805,00172-4365-00 ",.02)
 ;;00172-4365-00
 ;;9002226.02101,"805,00172-4365-10 ",.01)
 ;;00172-4365-10
 ;;9002226.02101,"805,00172-4365-10 ",.02)
 ;;00172-4365-10
 ;;9002226.02101,"805,00172-4365-60 ",.01)
 ;;00172-4365-60
 ;;9002226.02101,"805,00172-4365-60 ",.02)
 ;;00172-4365-60
 ;;9002226.02101,"805,00172-4365-70 ",.01)
 ;;00172-4365-70
 ;;9002226.02101,"805,00172-4365-70 ",.02)
 ;;00172-4365-70
 ;;9002226.02101,"805,00172-4366-60 ",.01)
 ;;00172-4366-60
 ;;9002226.02101,"805,00172-4366-60 ",.02)
 ;;00172-4366-60
 ;;9002226.02101,"805,00173-0790-01 ",.01)
 ;;00173-0790-01
 ;;9002226.02101,"805,00173-0790-01 ",.02)
 ;;00173-0790-01
 ;;9002226.02101,"805,00173-0790-02 ",.01)
 ;;00173-0790-02
 ;;9002226.02101,"805,00173-0790-02 ",.02)
 ;;00173-0790-02
 ;;9002226.02101,"805,00173-0791-01 ",.01)
 ;;00173-0791-01
 ;;9002226.02101,"805,00173-0791-01 ",.02)
 ;;00173-0791-01
 ;;9002226.02101,"805,00173-0791-02 ",.01)
 ;;00173-0791-02
 ;;9002226.02101,"805,00173-0791-02 ",.02)
 ;;00173-0791-02
 ;;9002226.02101,"805,00182-8202-00 ",.01)
 ;;00182-8202-00
 ;;9002226.02101,"805,00182-8202-00 ",.02)
 ;;00182-8202-00
 ;;9002226.02101,"805,00182-8202-89 ",.01)
 ;;00182-8202-89
 ;;9002226.02101,"805,00182-8202-89 ",.02)
 ;;00182-8202-89
 ;;9002226.02101,"805,00182-8203-00 ",.01)
 ;;00182-8203-00
 ;;9002226.02101,"805,00182-8203-00 ",.02)
 ;;00182-8203-00
 ;;9002226.02101,"805,00182-8203-89 ",.01)
 ;;00182-8203-89
 ;;9002226.02101,"805,00182-8203-89 ",.02)
 ;;00182-8203-89
 ;;9002226.02101,"805,00182-8236-00 ",.01)
 ;;00182-8236-00
 ;;9002226.02101,"805,00182-8236-00 ",.02)
 ;;00182-8236-00