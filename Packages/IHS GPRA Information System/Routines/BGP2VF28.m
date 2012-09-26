BGP2VF28 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"798,21695-0137-30 ",.01)
 ;;21695-0137-30
 ;;9002226.02101,"798,21695-0137-30 ",.02)
 ;;21695-0137-30
 ;;9002226.02101,"798,21695-0137-45 ",.01)
 ;;21695-0137-45
 ;;9002226.02101,"798,21695-0137-45 ",.02)
 ;;21695-0137-45
 ;;9002226.02101,"798,21695-0138-15 ",.01)
 ;;21695-0138-15
 ;;9002226.02101,"798,21695-0138-15 ",.02)
 ;;21695-0138-15
 ;;9002226.02101,"798,21695-0138-30 ",.01)
 ;;21695-0138-30
 ;;9002226.02101,"798,21695-0138-30 ",.02)
 ;;21695-0138-30
 ;;9002226.02101,"798,21695-0145-15 ",.01)
 ;;21695-0145-15
 ;;9002226.02101,"798,21695-0145-15 ",.02)
 ;;21695-0145-15
 ;;9002226.02101,"798,21695-0145-30 ",.01)
 ;;21695-0145-30
 ;;9002226.02101,"798,21695-0145-30 ",.02)
 ;;21695-0145-30
 ;;9002226.02101,"798,21695-0146-15 ",.01)
 ;;21695-0146-15
 ;;9002226.02101,"798,21695-0146-15 ",.02)
 ;;21695-0146-15
 ;;9002226.02101,"798,21695-0159-15 ",.01)
 ;;21695-0159-15
 ;;9002226.02101,"798,21695-0159-15 ",.02)
 ;;21695-0159-15
 ;;9002226.02101,"798,21695-0159-30 ",.01)
 ;;21695-0159-30
 ;;9002226.02101,"798,21695-0159-30 ",.02)
 ;;21695-0159-30
 ;;9002226.02101,"798,21695-0160-30 ",.01)
 ;;21695-0160-30
 ;;9002226.02101,"798,21695-0160-30 ",.02)
 ;;21695-0160-30
 ;;9002226.02101,"798,21695-0164-30 ",.01)
 ;;21695-0164-30
 ;;9002226.02101,"798,21695-0164-30 ",.02)
 ;;21695-0164-30
 ;;9002226.02101,"798,21695-0165-30 ",.01)
 ;;21695-0165-30
 ;;9002226.02101,"798,21695-0165-30 ",.02)
 ;;21695-0165-30
 ;;9002226.02101,"798,21695-0166-30 ",.01)
 ;;21695-0166-30
 ;;9002226.02101,"798,21695-0166-30 ",.02)
 ;;21695-0166-30
 ;;9002226.02101,"798,21695-0174-60 ",.01)
 ;;21695-0174-60
 ;;9002226.02101,"798,21695-0174-60 ",.02)
 ;;21695-0174-60
 ;;9002226.02101,"798,21695-0175-60 ",.01)
 ;;21695-0175-60
 ;;9002226.02101,"798,21695-0175-60 ",.02)
 ;;21695-0175-60
 ;;9002226.02101,"798,21695-0176-30 ",.01)
 ;;21695-0176-30
 ;;9002226.02101,"798,21695-0176-30 ",.02)
 ;;21695-0176-30
 ;;9002226.02101,"798,21695-0176-60 ",.01)
 ;;21695-0176-60
 ;;9002226.02101,"798,21695-0176-60 ",.02)
 ;;21695-0176-60
 ;;9002226.02101,"798,21695-0177-30 ",.01)
 ;;21695-0177-30
 ;;9002226.02101,"798,21695-0177-30 ",.02)
 ;;21695-0177-30
 ;;9002226.02101,"798,21695-0177-60 ",.01)
 ;;21695-0177-60
 ;;9002226.02101,"798,21695-0177-60 ",.02)
 ;;21695-0177-60
 ;;9002226.02101,"798,21695-0251-30 ",.01)
 ;;21695-0251-30
 ;;9002226.02101,"798,21695-0251-30 ",.02)
 ;;21695-0251-30
 ;;9002226.02101,"798,21695-0251-60 ",.01)
 ;;21695-0251-60
 ;;9002226.02101,"798,21695-0251-60 ",.02)
 ;;21695-0251-60
 ;;9002226.02101,"798,21695-0251-90 ",.01)
 ;;21695-0251-90
 ;;9002226.02101,"798,21695-0251-90 ",.02)
 ;;21695-0251-90
 ;;9002226.02101,"798,21695-0253-30 ",.01)
 ;;21695-0253-30
 ;;9002226.02101,"798,21695-0253-30 ",.02)
 ;;21695-0253-30
 ;;9002226.02101,"798,21695-0279-30 ",.01)
 ;;21695-0279-30
 ;;9002226.02101,"798,21695-0279-30 ",.02)
 ;;21695-0279-30
 ;;9002226.02101,"798,21695-0295-60 ",.01)
 ;;21695-0295-60
 ;;9002226.02101,"798,21695-0295-60 ",.02)
 ;;21695-0295-60
 ;;9002226.02101,"798,21695-0296-15 ",.01)
 ;;21695-0296-15
 ;;9002226.02101,"798,21695-0296-15 ",.02)
 ;;21695-0296-15
 ;;9002226.02101,"798,21695-0320-00 ",.01)
 ;;21695-0320-00
 ;;9002226.02101,"798,21695-0320-00 ",.02)
 ;;21695-0320-00
 ;;9002226.02101,"798,21695-0320-90 ",.01)
 ;;21695-0320-90
 ;;9002226.02101,"798,21695-0320-90 ",.02)
 ;;21695-0320-90
 ;;9002226.02101,"798,21695-0321-00 ",.01)
 ;;21695-0321-00
 ;;9002226.02101,"798,21695-0321-00 ",.02)
 ;;21695-0321-00
 ;;9002226.02101,"798,21695-0321-30 ",.01)
 ;;21695-0321-30
 ;;9002226.02101,"798,21695-0321-30 ",.02)
 ;;21695-0321-30
 ;;9002226.02101,"798,21695-0321-60 ",.01)
 ;;21695-0321-60
 ;;9002226.02101,"798,21695-0321-60 ",.02)
 ;;21695-0321-60
 ;;9002226.02101,"798,21695-0321-90 ",.01)
 ;;21695-0321-90
 ;;9002226.02101,"798,21695-0321-90 ",.02)
 ;;21695-0321-90
 ;;9002226.02101,"798,21695-0428-00 ",.01)
 ;;21695-0428-00
 ;;9002226.02101,"798,21695-0428-00 ",.02)
 ;;21695-0428-00
 ;;9002226.02101,"798,21695-0428-28 ",.01)
 ;;21695-0428-28
 ;;9002226.02101,"798,21695-0428-28 ",.02)
 ;;21695-0428-28
 ;;9002226.02101,"798,21695-0428-30 ",.01)
 ;;21695-0428-30
 ;;9002226.02101,"798,21695-0428-30 ",.02)
 ;;21695-0428-30
 ;;9002226.02101,"798,21695-0441-30 ",.01)
 ;;21695-0441-30
 ;;9002226.02101,"798,21695-0441-30 ",.02)
 ;;21695-0441-30
 ;;9002226.02101,"798,21695-0446-30 ",.01)
 ;;21695-0446-30
 ;;9002226.02101,"798,21695-0446-30 ",.02)
 ;;21695-0446-30
 ;;9002226.02101,"798,21695-0465-90 ",.01)
 ;;21695-0465-90
 ;;9002226.02101,"798,21695-0465-90 ",.02)
 ;;21695-0465-90
 ;;9002226.02101,"798,21695-0577-30 ",.01)
 ;;21695-0577-30
 ;;9002226.02101,"798,21695-0577-30 ",.02)
 ;;21695-0577-30
 ;;9002226.02101,"798,21695-0578-30 ",.01)
 ;;21695-0578-30
 ;;9002226.02101,"798,21695-0578-30 ",.02)
 ;;21695-0578-30
 ;;9002226.02101,"798,21695-0596-30 ",.01)
 ;;21695-0596-30
 ;;9002226.02101,"798,21695-0596-30 ",.02)
 ;;21695-0596-30
 ;;9002226.02101,"798,21695-0641-30 ",.01)
 ;;21695-0641-30
 ;;9002226.02101,"798,21695-0641-30 ",.02)
 ;;21695-0641-30
 ;;9002226.02101,"798,21695-0655-30 ",.01)
 ;;21695-0655-30
 ;;9002226.02101,"798,21695-0655-30 ",.02)
 ;;21695-0655-30
 ;;9002226.02101,"798,21695-0657-60 ",.01)
 ;;21695-0657-60
 ;;9002226.02101,"798,21695-0657-60 ",.02)
 ;;21695-0657-60
 ;;9002226.02101,"798,21695-0715-60 ",.01)
 ;;21695-0715-60
 ;;9002226.02101,"798,21695-0715-60 ",.02)
 ;;21695-0715-60
 ;;9002226.02101,"798,21695-0716-30 ",.01)
 ;;21695-0716-30
 ;;9002226.02101,"798,21695-0716-30 ",.02)
 ;;21695-0716-30
 ;;9002226.02101,"798,21695-0720-60 ",.01)
 ;;21695-0720-60
 ;;9002226.02101,"798,21695-0720-60 ",.02)
 ;;21695-0720-60
 ;;9002226.02101,"798,23490-5047-00 ",.01)
 ;;23490-5047-00
 ;;9002226.02101,"798,23490-5047-00 ",.02)
 ;;23490-5047-00
 ;;9002226.02101,"798,23490-5047-01 ",.01)
 ;;23490-5047-01
 ;;9002226.02101,"798,23490-5047-01 ",.02)
 ;;23490-5047-01
 ;;9002226.02101,"798,23490-5047-02 ",.01)
 ;;23490-5047-02
 ;;9002226.02101,"798,23490-5047-02 ",.02)
 ;;23490-5047-02
 ;;9002226.02101,"798,23490-5047-03 ",.01)
 ;;23490-5047-03
 ;;9002226.02101,"798,23490-5047-03 ",.02)
 ;;23490-5047-03
 ;;9002226.02101,"798,23490-5047-04 ",.01)
 ;;23490-5047-04
 ;;9002226.02101,"798,23490-5047-04 ",.02)
 ;;23490-5047-04
 ;;9002226.02101,"798,23490-5050-00 ",.01)
 ;;23490-5050-00
 ;;9002226.02101,"798,23490-5050-00 ",.02)
 ;;23490-5050-00
 ;;9002226.02101,"798,23490-5050-01 ",.01)
 ;;23490-5050-01
 ;;9002226.02101,"798,23490-5050-01 ",.02)
 ;;23490-5050-01
 ;;9002226.02101,"798,23490-5050-04 ",.01)
 ;;23490-5050-04
 ;;9002226.02101,"798,23490-5050-04 ",.02)
 ;;23490-5050-04
 ;;9002226.02101,"798,23490-5050-05 ",.01)
 ;;23490-5050-05
 ;;9002226.02101,"798,23490-5050-05 ",.02)
 ;;23490-5050-05
 ;;9002226.02101,"798,23490-5050-06 ",.01)
 ;;23490-5050-06
 ;;9002226.02101,"798,23490-5050-06 ",.02)
 ;;23490-5050-06
 ;;9002226.02101,"798,23490-5050-08 ",.01)
 ;;23490-5050-08
 ;;9002226.02101,"798,23490-5050-08 ",.02)
 ;;23490-5050-08
 ;;9002226.02101,"798,23490-5050-09 ",.01)
 ;;23490-5050-09
 ;;9002226.02101,"798,23490-5050-09 ",.02)
 ;;23490-5050-09
 ;;9002226.02101,"798,23490-5051-01 ",.01)
 ;;23490-5051-01
 ;;9002226.02101,"798,23490-5051-01 ",.02)
 ;;23490-5051-01
 ;;9002226.02101,"798,23490-5051-02 ",.01)
 ;;23490-5051-02
 ;;9002226.02101,"798,23490-5051-02 ",.02)
 ;;23490-5051-02
 ;;9002226.02101,"798,23490-5051-03 ",.01)
 ;;23490-5051-03
 ;;9002226.02101,"798,23490-5051-03 ",.02)
 ;;23490-5051-03
 ;;9002226.02101,"798,23490-5052-03 ",.01)
 ;;23490-5052-03
 ;;9002226.02101,"798,23490-5052-03 ",.02)
 ;;23490-5052-03
 ;;9002226.02101,"798,23490-5172-03 ",.01)
 ;;23490-5172-03
 ;;9002226.02101,"798,23490-5172-03 ",.02)
 ;;23490-5172-03
 ;;9002226.02101,"798,23490-5172-06 ",.01)
 ;;23490-5172-06
 ;;9002226.02101,"798,23490-5172-06 ",.02)
 ;;23490-5172-06
 ;;9002226.02101,"798,23490-5173-03 ",.01)
 ;;23490-5173-03
 ;;9002226.02101,"798,23490-5173-03 ",.02)
 ;;23490-5173-03
 ;;9002226.02101,"798,23490-5391-01 ",.01)
 ;;23490-5391-01
 ;;9002226.02101,"798,23490-5391-01 ",.02)
 ;;23490-5391-01
 ;;9002226.02101,"798,23490-5392-01 ",.01)
 ;;23490-5392-01
 ;;9002226.02101,"798,23490-5392-01 ",.02)
 ;;23490-5392-01
 ;;9002226.02101,"798,23490-5393-01 ",.01)
 ;;23490-5393-01
 ;;9002226.02101,"798,23490-5393-01 ",.02)
 ;;23490-5393-01
 ;;9002226.02101,"798,23490-5393-02 ",.01)
 ;;23490-5393-02
 ;;9002226.02101,"798,23490-5393-02 ",.02)
 ;;23490-5393-02
 ;;9002226.02101,"798,23490-5394-01 ",.01)
 ;;23490-5394-01
 ;;9002226.02101,"798,23490-5394-01 ",.02)
 ;;23490-5394-01
 ;;9002226.02101,"798,23490-5394-02 ",.01)
 ;;23490-5394-02
 ;;9002226.02101,"798,23490-5394-02 ",.02)
 ;;23490-5394-02
 ;;9002226.02101,"798,23490-5394-03 ",.01)
 ;;23490-5394-03
 ;;9002226.02101,"798,23490-5394-03 ",.02)
 ;;23490-5394-03
 ;;9002226.02101,"798,23490-5480-03 ",.01)
 ;;23490-5480-03
 ;;9002226.02101,"798,23490-5480-03 ",.02)
 ;;23490-5480-03
 ;;9002226.02101,"798,23490-5601-03 ",.01)
 ;;23490-5601-03
 ;;9002226.02101,"798,23490-5601-03 ",.02)
 ;;23490-5601-03
 ;;9002226.02101,"798,23490-5602-01 ",.01)
 ;;23490-5602-01
 ;;9002226.02101,"798,23490-5602-01 ",.02)
 ;;23490-5602-01
 ;;9002226.02101,"798,23490-5602-02 ",.01)
 ;;23490-5602-02
 ;;9002226.02101,"798,23490-5602-02 ",.02)
 ;;23490-5602-02
 ;;9002226.02101,"798,23490-5602-03 ",.01)
 ;;23490-5602-03
 ;;9002226.02101,"798,23490-5602-03 ",.02)
 ;;23490-5602-03
 ;;9002226.02101,"798,23490-6019-01 ",.01)
 ;;23490-6019-01
 ;;9002226.02101,"798,23490-6019-01 ",.02)
 ;;23490-6019-01
 ;;9002226.02101,"798,23490-6019-02 ",.01)
 ;;23490-6019-02
 ;;9002226.02101,"798,23490-6019-02 ",.02)
 ;;23490-6019-02
 ;;9002226.02101,"798,23490-6019-03 ",.01)
 ;;23490-6019-03
 ;;9002226.02101,"798,23490-6019-03 ",.02)
 ;;23490-6019-03
 ;;9002226.02101,"798,23490-6019-04 ",.01)
 ;;23490-6019-04
 ;;9002226.02101,"798,23490-6019-04 ",.02)
 ;;23490-6019-04
 ;;9002226.02101,"798,23490-6020-01 ",.01)
 ;;23490-6020-01
 ;;9002226.02101,"798,23490-6020-01 ",.02)
 ;;23490-6020-01
 ;;9002226.02101,"798,23490-6020-02 ",.01)
 ;;23490-6020-02
 ;;9002226.02101,"798,23490-6020-02 ",.02)
 ;;23490-6020-02
 ;;9002226.02101,"798,23490-6020-03 ",.01)
 ;;23490-6020-03
 ;;9002226.02101,"798,23490-6020-03 ",.02)
 ;;23490-6020-03
 ;;9002226.02101,"798,23490-6021-06 ",.01)
 ;;23490-6021-06
 ;;9002226.02101,"798,23490-6021-06 ",.02)
 ;;23490-6021-06
 ;;9002226.02101,"798,23490-6059-01 ",.01)
 ;;23490-6059-01
 ;;9002226.02101,"798,23490-6059-01 ",.02)
 ;;23490-6059-01
 ;;9002226.02101,"798,23490-6059-02 ",.01)
 ;;23490-6059-02
 ;;9002226.02101,"798,23490-6059-02 ",.02)
 ;;23490-6059-02
 ;;9002226.02101,"798,23490-6059-03 ",.01)
 ;;23490-6059-03
 ;;9002226.02101,"798,23490-6059-03 ",.02)
 ;;23490-6059-03
 ;;9002226.02101,"798,23490-6060-01 ",.01)
 ;;23490-6060-01
 ;;9002226.02101,"798,23490-6060-01 ",.02)
 ;;23490-6060-01
 ;;9002226.02101,"798,23490-6060-02 ",.01)
 ;;23490-6060-02
 ;;9002226.02101,"798,23490-6060-02 ",.02)
 ;;23490-6060-02
 ;;9002226.02101,"798,23490-6263-01 ",.01)
 ;;23490-6263-01
 ;;9002226.02101,"798,23490-6263-01 ",.02)
 ;;23490-6263-01
 ;;9002226.02101,"798,23490-6263-02 ",.01)
 ;;23490-6263-02
 ;;9002226.02101,"798,23490-6263-02 ",.02)
 ;;23490-6263-02
 ;;9002226.02101,"798,23490-6263-03 ",.01)
 ;;23490-6263-03
 ;;9002226.02101,"798,23490-6263-03 ",.02)
 ;;23490-6263-03
 ;;9002226.02101,"798,23490-6264-01 ",.01)
 ;;23490-6264-01
 ;;9002226.02101,"798,23490-6264-01 ",.02)
 ;;23490-6264-01
 ;;9002226.02101,"798,23490-6264-02 ",.01)
 ;;23490-6264-02
 ;;9002226.02101,"798,23490-6264-02 ",.02)
 ;;23490-6264-02
 ;;9002226.02101,"798,23490-6264-03 ",.01)
 ;;23490-6264-03
 ;;9002226.02101,"798,23490-6264-03 ",.02)
 ;;23490-6264-03
 ;;9002226.02101,"798,23490-6264-04 ",.01)
 ;;23490-6264-04
 ;;9002226.02101,"798,23490-6264-04 ",.02)
 ;;23490-6264-04
 ;;9002226.02101,"798,23490-6405-01 ",.01)
 ;;23490-6405-01
 ;;9002226.02101,"798,23490-6405-01 ",.02)
 ;;23490-6405-01
 ;;9002226.02101,"798,23490-6405-02 ",.01)
 ;;23490-6405-02
 ;;9002226.02101,"798,23490-6405-02 ",.02)
 ;;23490-6405-02
 ;;9002226.02101,"798,23490-6405-09 ",.01)
 ;;23490-6405-09
 ;;9002226.02101,"798,23490-6405-09 ",.02)
 ;;23490-6405-09
 ;;9002226.02101,"798,23490-6406-01 ",.01)
 ;;23490-6406-01
 ;;9002226.02101,"798,23490-6406-01 ",.02)
 ;;23490-6406-01
 ;;9002226.02101,"798,23490-6406-02 ",.01)
 ;;23490-6406-02
 ;;9002226.02101,"798,23490-6406-02 ",.02)
 ;;23490-6406-02
 ;;9002226.02101,"798,23490-6406-06 ",.01)
 ;;23490-6406-06
 ;;9002226.02101,"798,23490-6406-06 ",.02)
 ;;23490-6406-06
 ;;9002226.02101,"798,23490-6406-09 ",.01)
 ;;23490-6406-09
 ;;9002226.02101,"798,23490-6406-09 ",.02)
 ;;23490-6406-09
 ;;9002226.02101,"798,23490-6407-01 ",.01)
 ;;23490-6407-01
 ;;9002226.02101,"798,23490-6407-01 ",.02)
 ;;23490-6407-01
 ;;9002226.02101,"798,23490-6407-02 ",.01)
 ;;23490-6407-02
 ;;9002226.02101,"798,23490-6407-02 ",.02)
 ;;23490-6407-02
 ;;9002226.02101,"798,23490-6407-03 ",.01)
 ;;23490-6407-03
 ;;9002226.02101,"798,23490-6407-03 ",.02)
 ;;23490-6407-03
 ;;9002226.02101,"798,23490-6407-04 ",.01)
 ;;23490-6407-04
 ;;9002226.02101,"798,23490-6407-04 ",.02)
 ;;23490-6407-04
 ;;9002226.02101,"798,23490-6530-06 ",.01)
 ;;23490-6530-06
 ;;9002226.02101,"798,23490-6530-06 ",.02)
 ;;23490-6530-06
 ;;9002226.02101,"798,23490-6577-01 ",.01)
 ;;23490-6577-01
 ;;9002226.02101,"798,23490-6577-01 ",.02)
 ;;23490-6577-01
