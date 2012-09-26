BGP2TG13 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1199,58864-0952-30 ",.02)
 ;;58864-0952-30
 ;;9002226.02101,"1199,58864-0953-30 ",.01)
 ;;58864-0953-30
 ;;9002226.02101,"1199,58864-0953-30 ",.02)
 ;;58864-0953-30
 ;;9002226.02101,"1199,58864-0956-30 ",.01)
 ;;58864-0956-30
 ;;9002226.02101,"1199,58864-0956-30 ",.02)
 ;;58864-0956-30
 ;;9002226.02101,"1199,58864-0957-30 ",.01)
 ;;58864-0957-30
 ;;9002226.02101,"1199,58864-0957-30 ",.02)
 ;;58864-0957-30
 ;;9002226.02101,"1199,59762-2330-07 ",.01)
 ;;59762-2330-07
 ;;9002226.02101,"1199,59762-2330-07 ",.02)
 ;;59762-2330-07
 ;;9002226.02101,"1199,59762-2331-06 ",.01)
 ;;59762-2331-06
 ;;9002226.02101,"1199,59762-2331-06 ",.02)
 ;;59762-2331-06
 ;;9002226.02101,"1199,59762-2331-08 ",.01)
 ;;59762-2331-08
 ;;9002226.02101,"1199,59762-2331-08 ",.02)
 ;;59762-2331-08
 ;;9002226.02101,"1199,59762-2332-06 ",.01)
 ;;59762-2332-06
 ;;9002226.02101,"1199,59762-2332-06 ",.02)
 ;;59762-2332-06
 ;;9002226.02101,"1199,59762-2332-08 ",.01)
 ;;59762-2332-08
 ;;9002226.02101,"1199,59762-2332-08 ",.02)
 ;;59762-2332-08
 ;;9002226.02101,"1199,59762-3725-01 ",.01)
 ;;59762-3725-01
 ;;9002226.02101,"1199,59762-3725-01 ",.02)
 ;;59762-3725-01
 ;;9002226.02101,"1199,59762-3726-03 ",.01)
 ;;59762-3726-03
 ;;9002226.02101,"1199,59762-3726-03 ",.02)
 ;;59762-3726-03
 ;;9002226.02101,"1199,59762-3727-04 ",.01)
 ;;59762-3727-04
 ;;9002226.02101,"1199,59762-3727-04 ",.02)
 ;;59762-3727-04
 ;;9002226.02101,"1199,59762-3727-06 ",.01)
 ;;59762-3727-06
 ;;9002226.02101,"1199,59762-3727-06 ",.02)
 ;;59762-3727-06
 ;;9002226.02101,"1199,59762-3727-07 ",.01)
 ;;59762-3727-07
 ;;9002226.02101,"1199,59762-3727-07 ",.02)
 ;;59762-3727-07
 ;;9002226.02101,"1199,59762-3781-01 ",.01)
 ;;59762-3781-01
 ;;9002226.02101,"1199,59762-3781-01 ",.02)
 ;;59762-3781-01
 ;;9002226.02101,"1199,59762-3782-01 ",.01)
 ;;59762-3782-01
 ;;9002226.02101,"1199,59762-3782-01 ",.02)
 ;;59762-3782-01
 ;;9002226.02101,"1199,59762-3782-03 ",.01)
 ;;59762-3782-03
 ;;9002226.02101,"1199,59762-3782-03 ",.02)
 ;;59762-3782-03
 ;;9002226.02101,"1199,59762-3783-01 ",.01)
 ;;59762-3783-01
 ;;9002226.02101,"1199,59762-3783-01 ",.02)
 ;;59762-3783-01
 ;;9002226.02101,"1199,59762-3783-02 ",.01)
 ;;59762-3783-02
 ;;9002226.02101,"1199,59762-3783-02 ",.02)
 ;;59762-3783-02
 ;;9002226.02101,"1199,59762-3783-03 ",.01)
 ;;59762-3783-03
 ;;9002226.02101,"1199,59762-3783-03 ",.02)
 ;;59762-3783-03
 ;;9002226.02101,"1199,59762-5031-01 ",.01)
 ;;59762-5031-01
 ;;9002226.02101,"1199,59762-5031-01 ",.02)
 ;;59762-5031-01
 ;;9002226.02101,"1199,59762-5032-01 ",.01)
 ;;59762-5032-01
 ;;9002226.02101,"1199,59762-5032-01 ",.02)
 ;;59762-5032-01
 ;;9002226.02101,"1199,59762-5032-02 ",.01)
 ;;59762-5032-02
 ;;9002226.02101,"1199,59762-5032-02 ",.02)
 ;;59762-5032-02
 ;;9002226.02101,"1199,59762-5033-01 ",.01)
 ;;59762-5033-01
 ;;9002226.02101,"1199,59762-5033-01 ",.02)
 ;;59762-5033-01
 ;;9002226.02101,"1199,59762-5033-02 ",.01)
 ;;59762-5033-02
 ;;9002226.02101,"1199,59762-5033-02 ",.02)
 ;;59762-5033-02
 ;;9002226.02101,"1199,59762-7020-09 ",.01)
 ;;59762-7020-09
 ;;9002226.02101,"1199,59762-7020-09 ",.02)
 ;;59762-7020-09
 ;;9002226.02101,"1199,59762-7021-05 ",.01)
 ;;59762-7021-05
 ;;9002226.02101,"1199,59762-7021-05 ",.02)
 ;;59762-7021-05
 ;;9002226.02101,"1199,59762-7021-09 ",.01)
 ;;59762-7021-09
 ;;9002226.02101,"1199,59762-7021-09 ",.02)
 ;;59762-7021-09
 ;;9002226.02101,"1199,59762-7022-05 ",.01)
 ;;59762-7022-05
 ;;9002226.02101,"1199,59762-7022-05 ",.02)
 ;;59762-7022-05
 ;;9002226.02101,"1199,59762-7022-09 ",.01)
 ;;59762-7022-09
 ;;9002226.02101,"1199,59762-7022-09 ",.02)
 ;;59762-7022-09
 ;;9002226.02101,"1199,60346-0457-30 ",.01)
 ;;60346-0457-30
 ;;9002226.02101,"1199,60346-0457-30 ",.02)
 ;;60346-0457-30
 ;;9002226.02101,"1199,60346-0513-60 ",.01)
 ;;60346-0513-60
 ;;9002226.02101,"1199,60346-0513-60 ",.02)
 ;;60346-0513-60
 ;;9002226.02101,"1199,60346-0613-30 ",.01)
 ;;60346-0613-30
 ;;9002226.02101,"1199,60346-0613-30 ",.02)
 ;;60346-0613-30
 ;;9002226.02101,"1199,60346-0633-30 ",.01)
 ;;60346-0633-30
 ;;9002226.02101,"1199,60346-0633-30 ",.02)
 ;;60346-0633-30
 ;;9002226.02101,"1199,60346-0633-60 ",.01)
 ;;60346-0633-60
 ;;9002226.02101,"1199,60346-0633-60 ",.02)
 ;;60346-0633-60
 ;;9002226.02101,"1199,60346-0633-90 ",.01)
 ;;60346-0633-90
 ;;9002226.02101,"1199,60346-0633-90 ",.02)
 ;;60346-0633-90
 ;;9002226.02101,"1199,60346-0662-30 ",.01)
 ;;60346-0662-30
 ;;9002226.02101,"1199,60346-0662-30 ",.02)
 ;;60346-0662-30
 ;;9002226.02101,"1199,60346-0662-60 ",.01)
 ;;60346-0662-60
 ;;9002226.02101,"1199,60346-0662-60 ",.02)
 ;;60346-0662-60
 ;;9002226.02101,"1199,60346-0730-30 ",.01)
 ;;60346-0730-30
 ;;9002226.02101,"1199,60346-0730-30 ",.02)
 ;;60346-0730-30
 ;;9002226.02101,"1199,60346-0730-60 ",.01)
 ;;60346-0730-60
 ;;9002226.02101,"1199,60346-0730-60 ",.02)
 ;;60346-0730-60
 ;;9002226.02101,"1199,60346-0784-30 ",.01)
 ;;60346-0784-30
 ;;9002226.02101,"1199,60346-0784-30 ",.02)
 ;;60346-0784-30
 ;;9002226.02101,"1199,60346-0890-30 ",.01)
 ;;60346-0890-30
 ;;9002226.02101,"1199,60346-0890-30 ",.02)
 ;;60346-0890-30
 ;;9002226.02101,"1199,60346-0938-07 ",.01)
 ;;60346-0938-07
 ;;9002226.02101,"1199,60346-0938-07 ",.02)
 ;;60346-0938-07
 ;;9002226.02101,"1199,60346-0938-30 ",.01)
 ;;60346-0938-30
 ;;9002226.02101,"1199,60346-0938-30 ",.02)
 ;;60346-0938-30
 ;;9002226.02101,"1199,60429-0082-30 ",.01)
 ;;60429-0082-30
 ;;9002226.02101,"1199,60429-0082-30 ",.02)
 ;;60429-0082-30
 ;;9002226.02101,"1199,60429-0082-60 ",.01)
 ;;60429-0082-60
 ;;9002226.02101,"1199,60429-0082-60 ",.02)
 ;;60429-0082-60
 ;;9002226.02101,"1199,60429-0083-12 ",.01)
 ;;60429-0083-12
 ;;9002226.02101,"1199,60429-0083-12 ",.02)
 ;;60429-0083-12
 ;;9002226.02101,"1199,60429-0083-30 ",.01)
 ;;60429-0083-30
 ;;9002226.02101,"1199,60429-0083-30 ",.02)
 ;;60429-0083-30
 ;;9002226.02101,"1199,60429-0083-60 ",.01)
 ;;60429-0083-60
 ;;9002226.02101,"1199,60429-0083-60 ",.02)
 ;;60429-0083-60
 ;;9002226.02101,"1199,60429-0085-12 ",.01)
 ;;60429-0085-12
 ;;9002226.02101,"1199,60429-0085-12 ",.02)
 ;;60429-0085-12
 ;;9002226.02101,"1199,60429-0085-18 ",.01)
 ;;60429-0085-18
 ;;9002226.02101,"1199,60429-0085-18 ",.02)
 ;;60429-0085-18
 ;;9002226.02101,"1199,60429-0085-27 ",.01)
 ;;60429-0085-27
 ;;9002226.02101,"1199,60429-0085-27 ",.02)
 ;;60429-0085-27
 ;;9002226.02101,"1199,60429-0085-30 ",.01)
 ;;60429-0085-30
 ;;9002226.02101,"1199,60429-0085-30 ",.02)
 ;;60429-0085-30
 ;;9002226.02101,"1199,60429-0085-36 ",.01)
 ;;60429-0085-36
 ;;9002226.02101,"1199,60429-0085-36 ",.02)
 ;;60429-0085-36
 ;;9002226.02101,"1199,60429-0085-60 ",.01)
 ;;60429-0085-60
 ;;9002226.02101,"1199,60429-0085-60 ",.02)
 ;;60429-0085-60
 ;;9002226.02101,"1199,60429-0085-90 ",.01)
 ;;60429-0085-90
 ;;9002226.02101,"1199,60429-0085-90 ",.02)
 ;;60429-0085-90
 ;;9002226.02101,"1199,60505-0141-00 ",.01)
 ;;60505-0141-00
 ;;9002226.02101,"1199,60505-0141-00 ",.02)
 ;;60505-0141-00
 ;;9002226.02101,"1199,60505-0141-01 ",.01)
 ;;60505-0141-01
 ;;9002226.02101,"1199,60505-0141-01 ",.02)
 ;;60505-0141-01
 ;;9002226.02101,"1199,60505-0141-02 ",.01)
 ;;60505-0141-02
 ;;9002226.02101,"1199,60505-0141-02 ",.02)
 ;;60505-0141-02
 ;;9002226.02101,"1199,60505-0141-08 ",.01)
 ;;60505-0141-08
 ;;9002226.02101,"1199,60505-0141-08 ",.02)
 ;;60505-0141-08
 ;;9002226.02101,"1199,60505-0142-00 ",.01)
 ;;60505-0142-00
 ;;9002226.02101,"1199,60505-0142-00 ",.02)
 ;;60505-0142-00
 ;;9002226.02101,"1199,60505-0142-01 ",.01)
 ;;60505-0142-01
 ;;9002226.02101,"1199,60505-0142-01 ",.02)
 ;;60505-0142-01
 ;;9002226.02101,"1199,60505-0142-02 ",.01)
 ;;60505-0142-02
 ;;9002226.02101,"1199,60505-0142-02 ",.02)
 ;;60505-0142-02
 ;;9002226.02101,"1199,60505-0142-04 ",.01)
 ;;60505-0142-04
 ;;9002226.02101,"1199,60505-0142-04 ",.02)
 ;;60505-0142-04
 ;;9002226.02101,"1199,60951-0714-70 ",.01)
 ;;60951-0714-70
 ;;9002226.02101,"1199,60951-0714-70 ",.02)
 ;;60951-0714-70
 ;;9002226.02101,"1199,60951-0714-85 ",.01)
 ;;60951-0714-85
 ;;9002226.02101,"1199,60951-0714-85 ",.02)
 ;;60951-0714-85
 ;;9002226.02101,"1199,61442-0115-01 ",.01)
 ;;61442-0115-01
 ;;9002226.02101,"1199,61442-0115-01 ",.02)
 ;;61442-0115-01
 ;;9002226.02101,"1199,61442-0116-01 ",.01)
 ;;61442-0116-01
 ;;9002226.02101,"1199,61442-0116-01 ",.02)
 ;;61442-0116-01
 ;;9002226.02101,"1199,61442-0117-01 ",.01)
 ;;61442-0117-01
 ;;9002226.02101,"1199,61442-0117-01 ",.02)
 ;;61442-0117-01
 ;;9002226.02101,"1199,62037-0871-30 ",.01)
 ;;62037-0871-30
 ;;9002226.02101,"1199,62037-0871-30 ",.02)
 ;;62037-0871-30
 ;;9002226.02101,"1199,62037-0872-01 ",.01)
 ;;62037-0872-01
 ;;9002226.02101,"1199,62037-0872-01 ",.02)
 ;;62037-0872-01
 ;;9002226.02101,"1199,62037-0872-05 ",.01)
 ;;62037-0872-05
 ;;9002226.02101,"1199,62037-0872-05 ",.02)
 ;;62037-0872-05
 ;;9002226.02101,"1199,62037-0873-01 ",.01)
 ;;62037-0873-01
 ;;9002226.02101,"1199,62037-0873-01 ",.02)
 ;;62037-0873-01
 ;;9002226.02101,"1199,62037-0873-05 ",.01)
 ;;62037-0873-05
 ;;9002226.02101,"1199,62037-0873-05 ",.02)
 ;;62037-0873-05
 ;;9002226.02101,"1199,62682-5002-01 ",.01)
 ;;62682-5002-01
 ;;9002226.02101,"1199,62682-5002-01 ",.02)
 ;;62682-5002-01
 ;;9002226.02101,"1199,62682-5004-03 ",.01)
 ;;62682-5004-03
 ;;9002226.02101,"1199,62682-5004-03 ",.02)
 ;;62682-5004-03
 ;;9002226.02101,"1199,62682-5006-03 ",.01)
 ;;62682-5006-03
 ;;9002226.02101,"1199,62682-5006-03 ",.02)
 ;;62682-5006-03
 ;;9002226.02101,"1199,63304-0425-01 ",.01)
 ;;63304-0425-01
 ;;9002226.02101,"1199,63304-0425-01 ",.02)
 ;;63304-0425-01
 ;;9002226.02101,"1199,63304-0426-01 ",.01)
 ;;63304-0426-01
 ;;9002226.02101,"1199,63304-0426-01 ",.02)
 ;;63304-0426-01
 ;;9002226.02101,"1199,63304-0427-01 ",.01)
 ;;63304-0427-01
 ;;9002226.02101,"1199,63304-0427-01 ",.02)
 ;;63304-0427-01
 ;;9002226.02101,"1199,63629-1255-01 ",.01)
 ;;63629-1255-01
 ;;9002226.02101,"1199,63629-1255-01 ",.02)
 ;;63629-1255-01
 ;;9002226.02101,"1199,63629-1255-02 ",.01)
 ;;63629-1255-02
 ;;9002226.02101,"1199,63629-1255-02 ",.02)
 ;;63629-1255-02
 ;;9002226.02101,"1199,63629-1392-01 ",.01)
 ;;63629-1392-01
 ;;9002226.02101,"1199,63629-1392-01 ",.02)
 ;;63629-1392-01
 ;;9002226.02101,"1199,63629-1392-02 ",.01)
 ;;63629-1392-02
 ;;9002226.02101,"1199,63629-1392-02 ",.02)
 ;;63629-1392-02
 ;;9002226.02101,"1199,63629-1392-03 ",.01)
 ;;63629-1392-03
 ;;9002226.02101,"1199,63629-1392-03 ",.02)
 ;;63629-1392-03
 ;;9002226.02101,"1199,63629-1393-01 ",.01)
 ;;63629-1393-01
 ;;9002226.02101,"1199,63629-1393-01 ",.02)
 ;;63629-1393-01
 ;;9002226.02101,"1199,63629-1393-02 ",.01)
 ;;63629-1393-02
 ;;9002226.02101,"1199,63629-1393-02 ",.02)
 ;;63629-1393-02
 ;;9002226.02101,"1199,63629-1393-03 ",.01)
 ;;63629-1393-03
 ;;9002226.02101,"1199,63629-1393-03 ",.02)
 ;;63629-1393-03
 ;;9002226.02101,"1199,63629-1393-04 ",.01)
 ;;63629-1393-04
 ;;9002226.02101,"1199,63629-1393-04 ",.02)
 ;;63629-1393-04
 ;;9002226.02101,"1199,63629-1394-01 ",.01)
 ;;63629-1394-01
 ;;9002226.02101,"1199,63629-1394-01 ",.02)
 ;;63629-1394-01
 ;;9002226.02101,"1199,63629-1394-02 ",.01)
 ;;63629-1394-02
 ;;9002226.02101,"1199,63629-1394-02 ",.02)
 ;;63629-1394-02
 ;;9002226.02101,"1199,63629-1394-03 ",.01)
 ;;63629-1394-03
 ;;9002226.02101,"1199,63629-1394-03 ",.02)
 ;;63629-1394-03
 ;;9002226.02101,"1199,63629-1398-01 ",.01)
 ;;63629-1398-01
 ;;9002226.02101,"1199,63629-1398-01 ",.02)
 ;;63629-1398-01
 ;;9002226.02101,"1199,63629-1398-02 ",.01)
 ;;63629-1398-02
 ;;9002226.02101,"1199,63629-1398-02 ",.02)
 ;;63629-1398-02
 ;;9002226.02101,"1199,63629-1398-03 ",.01)
 ;;63629-1398-03
 ;;9002226.02101,"1199,63629-1398-03 ",.02)
 ;;63629-1398-03
 ;;9002226.02101,"1199,63629-2793-01 ",.01)
 ;;63629-2793-01
 ;;9002226.02101,"1199,63629-2793-01 ",.02)
 ;;63629-2793-01
 ;;9002226.02101,"1199,63629-2793-03 ",.01)
 ;;63629-2793-03
 ;;9002226.02101,"1199,63629-2793-03 ",.02)
 ;;63629-2793-03
 ;;9002226.02101,"1199,63629-2793-04 ",.01)
 ;;63629-2793-04
 ;;9002226.02101,"1199,63629-2793-04 ",.02)
 ;;63629-2793-04
 ;;9002226.02101,"1199,63629-2793-05 ",.01)
 ;;63629-2793-05
 ;;9002226.02101,"1199,63629-2793-05 ",.02)
 ;;63629-2793-05
 ;;9002226.02101,"1199,63629-2907-01 ",.01)
 ;;63629-2907-01
 ;;9002226.02101,"1199,63629-2907-01 ",.02)
 ;;63629-2907-01
 ;;9002226.02101,"1199,63629-2907-02 ",.01)
 ;;63629-2907-02
 ;;9002226.02101,"1199,63629-2907-02 ",.02)
 ;;63629-2907-02
 ;;9002226.02101,"1199,63629-3043-01 ",.01)
 ;;63629-3043-01
 ;;9002226.02101,"1199,63629-3043-01 ",.02)
 ;;63629-3043-01
 ;;9002226.02101,"1199,63629-3043-02 ",.01)
 ;;63629-3043-02
 ;;9002226.02101,"1199,63629-3043-02 ",.02)
 ;;63629-3043-02
 ;;9002226.02101,"1199,63629-3158-01 ",.01)
 ;;63629-3158-01
 ;;9002226.02101,"1199,63629-3158-01 ",.02)
 ;;63629-3158-01
 ;;9002226.02101,"1199,63629-3158-02 ",.01)
 ;;63629-3158-02
 ;;9002226.02101,"1199,63629-3158-02 ",.02)
 ;;63629-3158-02
 ;;9002226.02101,"1199,63629-3158-03 ",.01)
 ;;63629-3158-03
 ;;9002226.02101,"1199,63629-3158-03 ",.02)
 ;;63629-3158-03
 ;;9002226.02101,"1199,63629-3397-03 ",.01)
 ;;63629-3397-03
 ;;9002226.02101,"1199,63629-3397-03 ",.02)
 ;;63629-3397-03
 ;;9002226.02101,"1199,63629-3998-01 ",.01)
 ;;63629-3998-01
 ;;9002226.02101,"1199,63629-3998-01 ",.02)
 ;;63629-3998-01
 ;;9002226.02101,"1199,63629-4071-01 ",.01)
 ;;63629-4071-01
 ;;9002226.02101,"1199,63629-4071-01 ",.02)
 ;;63629-4071-01
 ;;9002226.02101,"1199,63739-0116-01 ",.01)
 ;;63739-0116-01
 ;;9002226.02101,"1199,63739-0116-01 ",.02)
 ;;63739-0116-01
