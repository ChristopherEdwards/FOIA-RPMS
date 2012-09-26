BGP2VY17 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"804,58864-0846-20 ",.01)
 ;;58864-0846-20
 ;;9002226.02101,"804,58864-0846-20 ",.02)
 ;;58864-0846-20
 ;;9002226.02101,"804,58864-0846-40 ",.01)
 ;;58864-0846-40
 ;;9002226.02101,"804,58864-0846-40 ",.02)
 ;;58864-0846-40
 ;;9002226.02101,"804,59746-0177-06 ",.01)
 ;;59746-0177-06
 ;;9002226.02101,"804,59746-0177-06 ",.02)
 ;;59746-0177-06
 ;;9002226.02101,"804,59746-0177-10 ",.01)
 ;;59746-0177-10
 ;;9002226.02101,"804,59746-0177-10 ",.02)
 ;;59746-0177-10
 ;;9002226.02101,"804,59746-0211-06 ",.01)
 ;;59746-0211-06
 ;;9002226.02101,"804,59746-0211-06 ",.02)
 ;;59746-0211-06
 ;;9002226.02101,"804,59746-0211-10 ",.01)
 ;;59746-0211-10
 ;;9002226.02101,"804,59746-0211-10 ",.02)
 ;;59746-0211-10
 ;;9002226.02101,"804,60760-0110-30 ",.01)
 ;;60760-0110-30
 ;;9002226.02101,"804,60760-0110-30 ",.02)
 ;;60760-0110-30
 ;;9002226.02101,"804,60760-0110-40 ",.01)
 ;;60760-0110-40
 ;;9002226.02101,"804,60760-0110-40 ",.02)
 ;;60760-0110-40
 ;;9002226.02101,"804,60760-0110-60 ",.01)
 ;;60760-0110-60
 ;;9002226.02101,"804,60760-0110-60 ",.02)
 ;;60760-0110-60
 ;;9002226.02101,"804,60760-0110-90 ",.01)
 ;;60760-0110-90
 ;;9002226.02101,"804,60760-0110-90 ",.02)
 ;;60760-0110-90
 ;;9002226.02101,"804,60760-0136-06 ",.01)
 ;;60760-0136-06
 ;;9002226.02101,"804,60760-0136-06 ",.02)
 ;;60760-0136-06
 ;;9002226.02101,"804,60760-0136-30 ",.01)
 ;;60760-0136-30
 ;;9002226.02101,"804,60760-0136-30 ",.02)
 ;;60760-0136-30
 ;;9002226.02101,"804,60760-0290-30 ",.01)
 ;;60760-0290-30
 ;;9002226.02101,"804,60760-0290-30 ",.02)
 ;;60760-0290-30
 ;;9002226.02101,"804,60760-0347-40 ",.01)
 ;;60760-0347-40
 ;;9002226.02101,"804,60760-0347-40 ",.02)
 ;;60760-0347-40
 ;;9002226.02101,"804,60760-0418-09 ",.01)
 ;;60760-0418-09
 ;;9002226.02101,"804,60760-0418-09 ",.02)
 ;;60760-0418-09
 ;;9002226.02101,"804,60760-0418-20 ",.01)
 ;;60760-0418-20
 ;;9002226.02101,"804,60760-0418-20 ",.02)
 ;;60760-0418-20
 ;;9002226.02101,"804,60760-0418-30 ",.01)
 ;;60760-0418-30
 ;;9002226.02101,"804,60760-0418-30 ",.02)
 ;;60760-0418-30
 ;;9002226.02101,"804,60760-0418-60 ",.01)
 ;;60760-0418-60
 ;;9002226.02101,"804,60760-0418-60 ",.02)
 ;;60760-0418-60
 ;;9002226.02101,"804,60760-0810-30 ",.01)
 ;;60760-0810-30
 ;;9002226.02101,"804,60760-0810-30 ",.02)
 ;;60760-0810-30
 ;;9002226.02101,"804,60793-0136-01 ",.01)
 ;;60793-0136-01
 ;;9002226.02101,"804,60793-0136-01 ",.02)
 ;;60793-0136-01
 ;;9002226.02101,"804,60793-0136-05 ",.01)
 ;;60793-0136-05
 ;;9002226.02101,"804,60793-0136-05 ",.02)
 ;;60793-0136-05
 ;;9002226.02101,"804,61392-0711-45 ",.01)
 ;;61392-0711-45
 ;;9002226.02101,"804,61392-0711-45 ",.02)
 ;;61392-0711-45
 ;;9002226.02101,"804,61392-0711-54 ",.01)
 ;;61392-0711-54
 ;;9002226.02101,"804,61392-0711-54 ",.02)
 ;;61392-0711-54
 ;;9002226.02101,"804,61392-0711-91 ",.01)
 ;;61392-0711-91
 ;;9002226.02101,"804,61392-0711-91 ",.02)
 ;;61392-0711-91
 ;;9002226.02101,"804,61392-0716-45 ",.01)
 ;;61392-0716-45
 ;;9002226.02101,"804,61392-0716-45 ",.02)
 ;;61392-0716-45
 ;;9002226.02101,"804,61392-0716-54 ",.01)
 ;;61392-0716-54
 ;;9002226.02101,"804,61392-0716-54 ",.02)
 ;;61392-0716-54
 ;;9002226.02101,"804,61392-0716-91 ",.01)
 ;;61392-0716-91
 ;;9002226.02101,"804,61392-0716-91 ",.02)
 ;;61392-0716-91
 ;;9002226.02101,"804,61392-0739-30 ",.01)
 ;;61392-0739-30
 ;;9002226.02101,"804,61392-0739-30 ",.02)
 ;;61392-0739-30
 ;;9002226.02101,"804,61392-0739-31 ",.01)
 ;;61392-0739-31
 ;;9002226.02101,"804,61392-0739-31 ",.02)
 ;;61392-0739-31
 ;;9002226.02101,"804,61392-0739-32 ",.01)
 ;;61392-0739-32
 ;;9002226.02101,"804,61392-0739-32 ",.02)
 ;;61392-0739-32
 ;;9002226.02101,"804,61392-0739-39 ",.01)
 ;;61392-0739-39
 ;;9002226.02101,"804,61392-0739-39 ",.02)
 ;;61392-0739-39
 ;;9002226.02101,"804,61392-0739-45 ",.01)
 ;;61392-0739-45
 ;;9002226.02101,"804,61392-0739-45 ",.02)
 ;;61392-0739-45
 ;;9002226.02101,"804,61392-0739-51 ",.01)
 ;;61392-0739-51
 ;;9002226.02101,"804,61392-0739-51 ",.02)
 ;;61392-0739-51
 ;;9002226.02101,"804,61392-0739-54 ",.01)
 ;;61392-0739-54
 ;;9002226.02101,"804,61392-0739-54 ",.02)
 ;;61392-0739-54
 ;;9002226.02101,"804,61392-0739-60 ",.01)
 ;;61392-0739-60
 ;;9002226.02101,"804,61392-0739-60 ",.02)
 ;;61392-0739-60
 ;;9002226.02101,"804,61392-0739-90 ",.01)
 ;;61392-0739-90
 ;;9002226.02101,"804,61392-0739-90 ",.02)
 ;;61392-0739-90
 ;;9002226.02101,"804,61392-0739-91 ",.01)
 ;;61392-0739-91
 ;;9002226.02101,"804,61392-0739-91 ",.02)
 ;;61392-0739-91
 ;;9002226.02101,"804,61392-0740-30 ",.01)
 ;;61392-0740-30
 ;;9002226.02101,"804,61392-0740-30 ",.02)
 ;;61392-0740-30
 ;;9002226.02101,"804,61392-0740-31 ",.01)
 ;;61392-0740-31
 ;;9002226.02101,"804,61392-0740-31 ",.02)
 ;;61392-0740-31
 ;;9002226.02101,"804,61392-0740-32 ",.01)
 ;;61392-0740-32
 ;;9002226.02101,"804,61392-0740-32 ",.02)
 ;;61392-0740-32
 ;;9002226.02101,"804,61392-0740-39 ",.01)
 ;;61392-0740-39
 ;;9002226.02101,"804,61392-0740-39 ",.02)
 ;;61392-0740-39
 ;;9002226.02101,"804,61392-0740-45 ",.01)
 ;;61392-0740-45
 ;;9002226.02101,"804,61392-0740-45 ",.02)
 ;;61392-0740-45
 ;;9002226.02101,"804,61392-0740-51 ",.01)
 ;;61392-0740-51
 ;;9002226.02101,"804,61392-0740-51 ",.02)
 ;;61392-0740-51
 ;;9002226.02101,"804,61392-0740-54 ",.01)
 ;;61392-0740-54
 ;;9002226.02101,"804,61392-0740-54 ",.02)
 ;;61392-0740-54
 ;;9002226.02101,"804,61392-0740-60 ",.01)
 ;;61392-0740-60
 ;;9002226.02101,"804,61392-0740-60 ",.02)
 ;;61392-0740-60
 ;;9002226.02101,"804,61392-0740-90 ",.01)
 ;;61392-0740-90
 ;;9002226.02101,"804,61392-0740-90 ",.02)
 ;;61392-0740-90
 ;;9002226.02101,"804,61392-0740-91 ",.01)
 ;;61392-0740-91
 ;;9002226.02101,"804,61392-0740-91 ",.02)
 ;;61392-0740-91
 ;;9002226.02101,"804,62269-0266-29 ",.01)
 ;;62269-0266-29
 ;;9002226.02101,"804,62269-0266-29 ",.02)
 ;;62269-0266-29
 ;;9002226.02101,"804,62584-0354-01 ",.01)
 ;;62584-0354-01
 ;;9002226.02101,"804,62584-0354-01 ",.02)
 ;;62584-0354-01
 ;;9002226.02101,"804,62584-0354-11 ",.01)
 ;;62584-0354-11
 ;;9002226.02101,"804,62584-0354-11 ",.02)
 ;;62584-0354-11
 ;;9002226.02101,"804,62584-0780-01 ",.01)
 ;;62584-0780-01
 ;;9002226.02101,"804,62584-0780-01 ",.02)
 ;;62584-0780-01
 ;;9002226.02101,"804,62584-0780-11 ",.01)
 ;;62584-0780-11
 ;;9002226.02101,"804,62584-0780-11 ",.02)
 ;;62584-0780-11
 ;;9002226.02101,"804,62584-0781-01 ",.01)
 ;;62584-0781-01
 ;;9002226.02101,"804,62584-0781-01 ",.02)
 ;;62584-0781-01
 ;;9002226.02101,"804,62584-0781-11 ",.01)
 ;;62584-0781-11
 ;;9002226.02101,"804,62584-0781-11 ",.02)
 ;;62584-0781-11
 ;;9002226.02101,"804,62756-0446-02 ",.01)
 ;;62756-0446-02
 ;;9002226.02101,"804,62756-0446-02 ",.02)
 ;;62756-0446-02
 ;;9002226.02101,"804,62756-0446-04 ",.01)
 ;;62756-0446-04
 ;;9002226.02101,"804,62756-0446-04 ",.02)
 ;;62756-0446-04
 ;;9002226.02101,"804,62756-0446-05 ",.01)
 ;;62756-0446-05
 ;;9002226.02101,"804,62756-0446-05 ",.02)
 ;;62756-0446-05
 ;;9002226.02101,"804,63459-0700-60 ",.01)
 ;;63459-0700-60
 ;;9002226.02101,"804,63459-0700-60 ",.02)
 ;;63459-0700-60
 ;;9002226.02101,"804,63459-0701-60 ",.01)
 ;;63459-0701-60
 ;;9002226.02101,"804,63459-0701-60 ",.02)
 ;;63459-0701-60
 ;;9002226.02101,"804,63629-1308-00 ",.01)
 ;;63629-1308-00
 ;;9002226.02101,"804,63629-1308-00 ",.02)
 ;;63629-1308-00
 ;;9002226.02101,"804,63629-1339-01 ",.01)
 ;;63629-1339-01
 ;;9002226.02101,"804,63629-1339-01 ",.02)
 ;;63629-1339-01
 ;;9002226.02101,"804,63629-1339-02 ",.01)
 ;;63629-1339-02
 ;;9002226.02101,"804,63629-1339-02 ",.02)
 ;;63629-1339-02
 ;;9002226.02101,"804,63629-1339-03 ",.01)
 ;;63629-1339-03
 ;;9002226.02101,"804,63629-1339-03 ",.02)
 ;;63629-1339-03
 ;;9002226.02101,"804,63629-1339-04 ",.01)
 ;;63629-1339-04
 ;;9002226.02101,"804,63629-1339-04 ",.02)
 ;;63629-1339-04
 ;;9002226.02101,"804,63629-1339-05 ",.01)
 ;;63629-1339-05
 ;;9002226.02101,"804,63629-1339-05 ",.02)
 ;;63629-1339-05
 ;;9002226.02101,"804,63629-1339-06 ",.01)
 ;;63629-1339-06
 ;;9002226.02101,"804,63629-1339-06 ",.02)
 ;;63629-1339-06
 ;;9002226.02101,"804,63629-1339-07 ",.01)
 ;;63629-1339-07
 ;;9002226.02101,"804,63629-1339-07 ",.02)
 ;;63629-1339-07
 ;;9002226.02101,"804,63629-1564-01 ",.01)
 ;;63629-1564-01
 ;;9002226.02101,"804,63629-1564-01 ",.02)
 ;;63629-1564-01
 ;;9002226.02101,"804,63629-1564-02 ",.01)
 ;;63629-1564-02
 ;;9002226.02101,"804,63629-1564-02 ",.02)
 ;;63629-1564-02
 ;;9002226.02101,"804,63629-1586-01 ",.01)
 ;;63629-1586-01
 ;;9002226.02101,"804,63629-1586-01 ",.02)
 ;;63629-1586-01
 ;;9002226.02101,"804,63629-1622-01 ",.01)
 ;;63629-1622-01
 ;;9002226.02101,"804,63629-1622-01 ",.02)
 ;;63629-1622-01
 ;;9002226.02101,"804,63629-1622-02 ",.01)
 ;;63629-1622-02
 ;;9002226.02101,"804,63629-1622-02 ",.02)
 ;;63629-1622-02
 ;;9002226.02101,"804,63629-1622-03 ",.01)
 ;;63629-1622-03
 ;;9002226.02101,"804,63629-1622-03 ",.02)
 ;;63629-1622-03
 ;;9002226.02101,"804,63629-1622-04 ",.01)
 ;;63629-1622-04
 ;;9002226.02101,"804,63629-1622-04 ",.02)
 ;;63629-1622-04
 ;;9002226.02101,"804,63629-1623-01 ",.01)
 ;;63629-1623-01
 ;;9002226.02101,"804,63629-1623-01 ",.02)
 ;;63629-1623-01
 ;;9002226.02101,"804,63629-1623-02 ",.01)
 ;;63629-1623-02
 ;;9002226.02101,"804,63629-1623-02 ",.02)
 ;;63629-1623-02
 ;;9002226.02101,"804,63629-1623-03 ",.01)
 ;;63629-1623-03
 ;;9002226.02101,"804,63629-1623-03 ",.02)
 ;;63629-1623-03
 ;;9002226.02101,"804,63629-1623-04 ",.01)
 ;;63629-1623-04
 ;;9002226.02101,"804,63629-1623-04 ",.02)
 ;;63629-1623-04
 ;;9002226.02101,"804,63629-1623-05 ",.01)
 ;;63629-1623-05
 ;;9002226.02101,"804,63629-1623-05 ",.02)
 ;;63629-1623-05
 ;;9002226.02101,"804,63629-1623-06 ",.01)
 ;;63629-1623-06
 ;;9002226.02101,"804,63629-1623-06 ",.02)
 ;;63629-1623-06
 ;;9002226.02101,"804,63629-1623-07 ",.01)
 ;;63629-1623-07
 ;;9002226.02101,"804,63629-1623-07 ",.02)
 ;;63629-1623-07
 ;;9002226.02101,"804,63629-2768-01 ",.01)
 ;;63629-2768-01
 ;;9002226.02101,"804,63629-2768-01 ",.02)
 ;;63629-2768-01
 ;;9002226.02101,"804,63629-2768-02 ",.01)
 ;;63629-2768-02
 ;;9002226.02101,"804,63629-2768-02 ",.02)
 ;;63629-2768-02
 ;;9002226.02101,"804,63629-2768-03 ",.01)
 ;;63629-2768-03
 ;;9002226.02101,"804,63629-2768-03 ",.02)
 ;;63629-2768-03
 ;;9002226.02101,"804,63629-2768-04 ",.01)
 ;;63629-2768-04
 ;;9002226.02101,"804,63629-2768-04 ",.02)
 ;;63629-2768-04
 ;;9002226.02101,"804,63739-0049-10 ",.01)
 ;;63739-0049-10
 ;;9002226.02101,"804,63739-0049-10 ",.02)
 ;;63739-0049-10
 ;;9002226.02101,"804,63739-0049-15 ",.01)
 ;;63739-0049-15
 ;;9002226.02101,"804,63739-0049-15 ",.02)
 ;;63739-0049-15
 ;;9002226.02101,"804,63739-0066-10 ",.01)
 ;;63739-0066-10
 ;;9002226.02101,"804,63739-0066-10 ",.02)
 ;;63739-0066-10
 ;;9002226.02101,"804,63739-0066-15 ",.01)
 ;;63739-0066-15
 ;;9002226.02101,"804,63739-0066-15 ",.02)
 ;;63739-0066-15
 ;;9002226.02101,"804,63739-0166-10 ",.01)
 ;;63739-0166-10
 ;;9002226.02101,"804,63739-0166-10 ",.02)
 ;;63739-0166-10
 ;;9002226.02101,"804,63739-0166-15 ",.01)
 ;;63739-0166-15
 ;;9002226.02101,"804,63739-0166-15 ",.02)
 ;;63739-0166-15
 ;;9002226.02101,"804,63739-0167-10 ",.01)
 ;;63739-0167-10
 ;;9002226.02101,"804,63739-0167-10 ",.02)
 ;;63739-0167-10
 ;;9002226.02101,"804,63739-0167-15 ",.01)
 ;;63739-0167-15
 ;;9002226.02101,"804,63739-0167-15 ",.02)
 ;;63739-0167-15
 ;;9002226.02101,"804,63874-0315-01 ",.01)
 ;;63874-0315-01
 ;;9002226.02101,"804,63874-0315-01 ",.02)
 ;;63874-0315-01
 ;;9002226.02101,"804,63874-0315-02 ",.01)
 ;;63874-0315-02
 ;;9002226.02101,"804,63874-0315-02 ",.02)
 ;;63874-0315-02
 ;;9002226.02101,"804,63874-0315-04 ",.01)
 ;;63874-0315-04
 ;;9002226.02101,"804,63874-0315-04 ",.02)
 ;;63874-0315-04
 ;;9002226.02101,"804,63874-0315-05 ",.01)
 ;;63874-0315-05
 ;;9002226.02101,"804,63874-0315-05 ",.02)
 ;;63874-0315-05
 ;;9002226.02101,"804,63874-0315-07 ",.01)
 ;;63874-0315-07
 ;;9002226.02101,"804,63874-0315-07 ",.02)
 ;;63874-0315-07
 ;;9002226.02101,"804,63874-0315-10 ",.01)
 ;;63874-0315-10
 ;;9002226.02101,"804,63874-0315-10 ",.02)
 ;;63874-0315-10
 ;;9002226.02101,"804,63874-0315-12 ",.01)
 ;;63874-0315-12
 ;;9002226.02101,"804,63874-0315-12 ",.02)
 ;;63874-0315-12
 ;;9002226.02101,"804,63874-0315-14 ",.01)
 ;;63874-0315-14
 ;;9002226.02101,"804,63874-0315-14 ",.02)
 ;;63874-0315-14
 ;;9002226.02101,"804,63874-0315-15 ",.01)
 ;;63874-0315-15
 ;;9002226.02101,"804,63874-0315-15 ",.02)
 ;;63874-0315-15
 ;;9002226.02101,"804,63874-0315-18 ",.01)
 ;;63874-0315-18
 ;;9002226.02101,"804,63874-0315-18 ",.02)
 ;;63874-0315-18
 ;;9002226.02101,"804,63874-0315-20 ",.01)
 ;;63874-0315-20
 ;;9002226.02101,"804,63874-0315-20 ",.02)
 ;;63874-0315-20
 ;;9002226.02101,"804,63874-0315-21 ",.01)
 ;;63874-0315-21
 ;;9002226.02101,"804,63874-0315-21 ",.02)
 ;;63874-0315-21
 ;;9002226.02101,"804,63874-0315-24 ",.01)
 ;;63874-0315-24
 ;;9002226.02101,"804,63874-0315-24 ",.02)
 ;;63874-0315-24
 ;;9002226.02101,"804,63874-0315-25 ",.01)
 ;;63874-0315-25
 ;;9002226.02101,"804,63874-0315-25 ",.02)
 ;;63874-0315-25
 ;;9002226.02101,"804,63874-0315-28 ",.01)
 ;;63874-0315-28
 ;;9002226.02101,"804,63874-0315-28 ",.02)
 ;;63874-0315-28
 ;;9002226.02101,"804,63874-0315-30 ",.01)
 ;;63874-0315-30
 ;;9002226.02101,"804,63874-0315-30 ",.02)
 ;;63874-0315-30
 ;;9002226.02101,"804,63874-0315-35 ",.01)
 ;;63874-0315-35
 ;;9002226.02101,"804,63874-0315-35 ",.02)
 ;;63874-0315-35
 ;;9002226.02101,"804,63874-0315-40 ",.01)
 ;;63874-0315-40
 ;;9002226.02101,"804,63874-0315-40 ",.02)
 ;;63874-0315-40
