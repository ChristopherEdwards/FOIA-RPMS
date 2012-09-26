BGP2VV9 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"736,63874-0201-56 ",.02)
 ;;63874-0201-56
 ;;9002226.02101,"736,63874-0201-60 ",.01)
 ;;63874-0201-60
 ;;9002226.02101,"736,63874-0201-60 ",.02)
 ;;63874-0201-60
 ;;9002226.02101,"736,63874-0201-71 ",.01)
 ;;63874-0201-71
 ;;9002226.02101,"736,63874-0201-71 ",.02)
 ;;63874-0201-71
 ;;9002226.02101,"736,63874-0201-72 ",.01)
 ;;63874-0201-72
 ;;9002226.02101,"736,63874-0201-72 ",.02)
 ;;63874-0201-72
 ;;9002226.02101,"736,63874-0201-74 ",.01)
 ;;63874-0201-74
 ;;9002226.02101,"736,63874-0201-74 ",.02)
 ;;63874-0201-74
 ;;9002226.02101,"736,63874-0201-77 ",.01)
 ;;63874-0201-77
 ;;9002226.02101,"736,63874-0201-77 ",.02)
 ;;63874-0201-77
 ;;9002226.02101,"736,63874-0201-80 ",.01)
 ;;63874-0201-80
 ;;9002226.02101,"736,63874-0201-80 ",.02)
 ;;63874-0201-80
 ;;9002226.02101,"736,63874-0201-84 ",.01)
 ;;63874-0201-84
 ;;9002226.02101,"736,63874-0201-84 ",.02)
 ;;63874-0201-84
 ;;9002226.02101,"736,63874-0201-90 ",.01)
 ;;63874-0201-90
 ;;9002226.02101,"736,63874-0201-90 ",.02)
 ;;63874-0201-90
 ;;9002226.02101,"736,63874-0212-20 ",.01)
 ;;63874-0212-20
 ;;9002226.02101,"736,63874-0212-20 ",.02)
 ;;63874-0212-20
 ;;9002226.02101,"736,63874-0212-30 ",.01)
 ;;63874-0212-30
 ;;9002226.02101,"736,63874-0212-30 ",.02)
 ;;63874-0212-30
 ;;9002226.02101,"736,63874-0215-12 ",.01)
 ;;63874-0215-12
 ;;9002226.02101,"736,63874-0215-12 ",.02)
 ;;63874-0215-12
 ;;9002226.02101,"736,63874-0215-30 ",.01)
 ;;63874-0215-30
 ;;9002226.02101,"736,63874-0215-30 ",.02)
 ;;63874-0215-30
 ;;9002226.02101,"736,63874-0215-50 ",.01)
 ;;63874-0215-50
 ;;9002226.02101,"736,63874-0215-50 ",.02)
 ;;63874-0215-50
 ;;9002226.02101,"736,63874-0215-60 ",.01)
 ;;63874-0215-60
 ;;9002226.02101,"736,63874-0215-60 ",.02)
 ;;63874-0215-60
 ;;9002226.02101,"736,63874-0220-01 ",.01)
 ;;63874-0220-01
 ;;9002226.02101,"736,63874-0220-01 ",.02)
 ;;63874-0220-01
 ;;9002226.02101,"736,63874-0220-03 ",.01)
 ;;63874-0220-03
 ;;9002226.02101,"736,63874-0220-03 ",.02)
 ;;63874-0220-03
 ;;9002226.02101,"736,63874-0220-04 ",.01)
 ;;63874-0220-04
 ;;9002226.02101,"736,63874-0220-04 ",.02)
 ;;63874-0220-04
 ;;9002226.02101,"736,63874-0220-10 ",.01)
 ;;63874-0220-10
 ;;9002226.02101,"736,63874-0220-10 ",.02)
 ;;63874-0220-10
 ;;9002226.02101,"736,63874-0220-12 ",.01)
 ;;63874-0220-12
 ;;9002226.02101,"736,63874-0220-12 ",.02)
 ;;63874-0220-12
 ;;9002226.02101,"736,63874-0220-15 ",.01)
 ;;63874-0220-15
 ;;9002226.02101,"736,63874-0220-15 ",.02)
 ;;63874-0220-15
 ;;9002226.02101,"736,63874-0220-20 ",.01)
 ;;63874-0220-20
 ;;9002226.02101,"736,63874-0220-20 ",.02)
 ;;63874-0220-20
 ;;9002226.02101,"736,63874-0220-30 ",.01)
 ;;63874-0220-30
 ;;9002226.02101,"736,63874-0220-30 ",.02)
 ;;63874-0220-30
 ;;9002226.02101,"736,63874-0220-35 ",.01)
 ;;63874-0220-35
 ;;9002226.02101,"736,63874-0220-35 ",.02)
 ;;63874-0220-35
 ;;9002226.02101,"736,63874-0220-40 ",.01)
 ;;63874-0220-40
 ;;9002226.02101,"736,63874-0220-40 ",.02)
 ;;63874-0220-40
 ;;9002226.02101,"736,63874-0220-60 ",.01)
 ;;63874-0220-60
 ;;9002226.02101,"736,63874-0220-60 ",.02)
 ;;63874-0220-60
 ;;9002226.02101,"736,63874-0220-90 ",.01)
 ;;63874-0220-90
 ;;9002226.02101,"736,63874-0220-90 ",.02)
 ;;63874-0220-90
 ;;9002226.02101,"736,66267-0178-06 ",.01)
 ;;66267-0178-06
 ;;9002226.02101,"736,66267-0178-06 ",.02)
 ;;66267-0178-06
 ;;9002226.02101,"736,66267-0178-12 ",.01)
 ;;66267-0178-12
 ;;9002226.02101,"736,66267-0178-12 ",.02)
 ;;66267-0178-12
 ;;9002226.02101,"736,66267-0178-15 ",.01)
 ;;66267-0178-15
 ;;9002226.02101,"736,66267-0178-15 ",.02)
 ;;66267-0178-15
 ;;9002226.02101,"736,66267-0178-20 ",.01)
 ;;66267-0178-20
 ;;9002226.02101,"736,66267-0178-20 ",.02)
 ;;66267-0178-20
 ;;9002226.02101,"736,66267-0178-30 ",.01)
 ;;66267-0178-30
 ;;9002226.02101,"736,66267-0178-30 ",.02)
 ;;66267-0178-30
 ;;9002226.02101,"736,66267-0178-40 ",.01)
 ;;66267-0178-40
 ;;9002226.02101,"736,66267-0178-40 ",.02)
 ;;66267-0178-40
 ;;9002226.02101,"736,66267-0178-50 ",.01)
 ;;66267-0178-50
 ;;9002226.02101,"736,66267-0178-50 ",.02)
 ;;66267-0178-50
 ;;9002226.02101,"736,66267-0178-60 ",.01)
 ;;66267-0178-60
 ;;9002226.02101,"736,66267-0178-60 ",.02)
 ;;66267-0178-60
 ;;9002226.02101,"736,66267-0178-90 ",.01)
 ;;66267-0178-90
 ;;9002226.02101,"736,66267-0178-90 ",.02)
 ;;66267-0178-90
 ;;9002226.02101,"736,66267-0178-91 ",.01)
 ;;66267-0178-91
 ;;9002226.02101,"736,66267-0178-91 ",.02)
 ;;66267-0178-91
 ;;9002226.02101,"736,66267-0179-12 ",.01)
 ;;66267-0179-12
 ;;9002226.02101,"736,66267-0179-12 ",.02)
 ;;66267-0179-12
 ;;9002226.02101,"736,66267-0179-20 ",.01)
 ;;66267-0179-20
 ;;9002226.02101,"736,66267-0179-20 ",.02)
 ;;66267-0179-20
 ;;9002226.02101,"736,66267-0179-30 ",.01)
 ;;66267-0179-30
 ;;9002226.02101,"736,66267-0179-30 ",.02)
 ;;66267-0179-30
 ;;9002226.02101,"736,66267-0487-30 ",.01)
 ;;66267-0487-30
 ;;9002226.02101,"736,66267-0487-30 ",.02)
 ;;66267-0487-30
 ;;9002226.02101,"736,66267-0487-40 ",.01)
 ;;66267-0487-40
 ;;9002226.02101,"736,66267-0487-40 ",.02)
 ;;66267-0487-40
 ;;9002226.02101,"736,66336-0416-30 ",.01)
 ;;66336-0416-30
 ;;9002226.02101,"736,66336-0416-30 ",.02)
 ;;66336-0416-30
 ;;9002226.02101,"736,66336-0610-20 ",.01)
 ;;66336-0610-20
 ;;9002226.02101,"736,66336-0610-20 ",.02)
 ;;66336-0610-20
 ;;9002226.02101,"736,66336-0610-30 ",.01)
 ;;66336-0610-30
 ;;9002226.02101,"736,66336-0610-30 ",.02)
 ;;66336-0610-30
 ;;9002226.02101,"736,66336-0628-10 ",.01)
 ;;66336-0628-10
 ;;9002226.02101,"736,66336-0628-10 ",.02)
 ;;66336-0628-10
 ;;9002226.02101,"736,66336-0628-12 ",.01)
 ;;66336-0628-12
 ;;9002226.02101,"736,66336-0628-12 ",.02)
 ;;66336-0628-12
 ;;9002226.02101,"736,66336-0628-15 ",.01)
 ;;66336-0628-15
 ;;9002226.02101,"736,66336-0628-15 ",.02)
 ;;66336-0628-15
 ;;9002226.02101,"736,66336-0628-16 ",.01)
 ;;66336-0628-16
 ;;9002226.02101,"736,66336-0628-16 ",.02)
 ;;66336-0628-16
 ;;9002226.02101,"736,66336-0628-20 ",.01)
 ;;66336-0628-20
 ;;9002226.02101,"736,66336-0628-20 ",.02)
 ;;66336-0628-20
 ;;9002226.02101,"736,66336-0628-30 ",.01)
 ;;66336-0628-30
 ;;9002226.02101,"736,66336-0628-30 ",.02)
 ;;66336-0628-30
 ;;9002226.02101,"736,66336-0628-60 ",.01)
 ;;66336-0628-60
 ;;9002226.02101,"736,66336-0628-60 ",.02)
 ;;66336-0628-60
 ;;9002226.02101,"736,66479-0510-10 ",.01)
 ;;66479-0510-10
 ;;9002226.02101,"736,66479-0510-10 ",.02)
 ;;66479-0510-10
 ;;9002226.02101,"736,66479-0512-10 ",.01)
 ;;66479-0512-10
 ;;9002226.02101,"736,66479-0512-10 ",.02)
 ;;66479-0512-10
 ;;9002226.02101,"736,66479-0513-10 ",.01)
 ;;66479-0513-10
 ;;9002226.02101,"736,66479-0513-10 ",.02)
 ;;66479-0513-10
 ;;9002226.02101,"736,66479-0514-10 ",.01)
 ;;66479-0514-10
 ;;9002226.02101,"736,66479-0514-10 ",.02)
 ;;66479-0514-10
 ;;9002226.02101,"736,66479-0515-10 ",.01)
 ;;66479-0515-10
 ;;9002226.02101,"736,66479-0515-10 ",.02)
 ;;66479-0515-10
 ;;9002226.02101,"736,66479-0515-50 ",.01)
 ;;66479-0515-50
 ;;9002226.02101,"736,66479-0515-50 ",.02)
 ;;66479-0515-50
 ;;9002226.02101,"736,66591-0612-41 ",.01)
 ;;66591-0612-41
 ;;9002226.02101,"736,66591-0612-41 ",.02)
 ;;66591-0612-41
 ;;9002226.02101,"736,66591-0631-41 ",.01)
 ;;66591-0631-41
 ;;9002226.02101,"736,66591-0631-41 ",.02)
 ;;66591-0631-41
 ;;9002226.02101,"736,66591-0641-41 ",.01)
 ;;66591-0641-41
 ;;9002226.02101,"736,66591-0641-41 ",.02)
 ;;66591-0641-41
 ;;9002226.02101,"736,66591-0641-51 ",.01)
 ;;66591-0641-51
 ;;9002226.02101,"736,66591-0641-51 ",.02)
 ;;66591-0641-51
 ;;9002226.02101,"736,67544-0033-30 ",.01)
 ;;67544-0033-30
 ;;9002226.02101,"736,67544-0033-30 ",.02)
 ;;67544-0033-30
 ;;9002226.02101,"736,67544-0131-30 ",.01)
 ;;67544-0131-30
 ;;9002226.02101,"736,67544-0131-30 ",.02)
 ;;67544-0131-30
 ;;9002226.02101,"736,67544-0138-30 ",.01)
 ;;67544-0138-30
 ;;9002226.02101,"736,67544-0138-30 ",.02)
 ;;67544-0138-30
 ;;9002226.02101,"736,67544-0151-30 ",.01)
 ;;67544-0151-30
 ;;9002226.02101,"736,67544-0151-30 ",.02)
 ;;67544-0151-30
 ;;9002226.02101,"736,67544-0396-30 ",.01)
 ;;67544-0396-30
 ;;9002226.02101,"736,67544-0396-30 ",.02)
 ;;67544-0396-30
 ;;9002226.02101,"736,67544-0497-30 ",.01)
 ;;67544-0497-30
 ;;9002226.02101,"736,67544-0497-30 ",.02)
 ;;67544-0497-30
 ;;9002226.02101,"736,68071-0760-30 ",.01)
 ;;68071-0760-30
 ;;9002226.02101,"736,68071-0760-30 ",.02)
 ;;68071-0760-30
 ;;9002226.02101,"736,68084-0393-01 ",.01)
 ;;68084-0393-01
 ;;9002226.02101,"736,68084-0393-01 ",.02)
 ;;68084-0393-01
 ;;9002226.02101,"736,68115-0305-00 ",.01)
 ;;68115-0305-00
 ;;9002226.02101,"736,68115-0305-00 ",.02)
 ;;68115-0305-00
 ;;9002226.02101,"736,68115-0305-20 ",.01)
 ;;68115-0305-20
 ;;9002226.02101,"736,68115-0305-20 ",.02)
 ;;68115-0305-20
 ;;9002226.02101,"736,68115-0305-25 ",.01)
 ;;68115-0305-25
 ;;9002226.02101,"736,68115-0305-25 ",.02)
 ;;68115-0305-25
 ;;9002226.02101,"736,68115-0305-30 ",.01)
 ;;68115-0305-30
 ;;9002226.02101,"736,68115-0305-30 ",.02)
 ;;68115-0305-30
 ;;9002226.02101,"736,68115-0305-40 ",.01)
 ;;68115-0305-40
 ;;9002226.02101,"736,68115-0305-40 ",.02)
 ;;68115-0305-40
 ;;9002226.02101,"736,68115-0305-60 ",.01)
 ;;68115-0305-60
 ;;9002226.02101,"736,68115-0305-60 ",.02)
 ;;68115-0305-60
 ;;9002226.02101,"736,68115-0305-90 ",.01)
 ;;68115-0305-90
 ;;9002226.02101,"736,68115-0305-90 ",.02)
 ;;68115-0305-90
 ;;9002226.02101,"736,68115-0305-99 ",.01)
 ;;68115-0305-99
 ;;9002226.02101,"736,68115-0305-99 ",.02)
 ;;68115-0305-99
 ;;9002226.02101,"736,68115-0306-12 ",.01)
 ;;68115-0306-12
 ;;9002226.02101,"736,68115-0306-12 ",.02)
 ;;68115-0306-12
 ;;9002226.02101,"736,68115-0306-30 ",.01)
 ;;68115-0306-30
 ;;9002226.02101,"736,68115-0306-30 ",.02)
 ;;68115-0306-30
 ;;9002226.02101,"736,68115-0306-60 ",.01)
 ;;68115-0306-60
 ;;9002226.02101,"736,68115-0306-60 ",.02)
 ;;68115-0306-60
 ;;9002226.02101,"736,68115-0462-30 ",.01)
 ;;68115-0462-30
 ;;9002226.02101,"736,68115-0462-30 ",.02)
 ;;68115-0462-30
 ;;9002226.02101,"736,68115-0462-60 ",.01)
 ;;68115-0462-60
 ;;9002226.02101,"736,68115-0462-60 ",.02)
 ;;68115-0462-60
 ;;9002226.02101,"736,68115-0605-00 ",.01)
 ;;68115-0605-00
 ;;9002226.02101,"736,68115-0605-00 ",.02)
 ;;68115-0605-00
 ;;9002226.02101,"736,68115-0743-00 ",.01)
 ;;68115-0743-00
 ;;9002226.02101,"736,68115-0743-00 ",.02)
 ;;68115-0743-00
 ;;9002226.02101,"736,68115-0815-00 ",.01)
 ;;68115-0815-00
 ;;9002226.02101,"736,68115-0815-00 ",.02)
 ;;68115-0815-00
 ;;9002226.02101,"736,68387-0100-01 ",.01)
 ;;68387-0100-01
 ;;9002226.02101,"736,68387-0100-01 ",.02)
 ;;68387-0100-01
 ;;9002226.02101,"736,68387-0100-12 ",.01)
 ;;68387-0100-12
 ;;9002226.02101,"736,68387-0100-12 ",.02)
 ;;68387-0100-12
 ;;9002226.02101,"736,68387-0100-15 ",.01)
 ;;68387-0100-15
 ;;9002226.02101,"736,68387-0100-15 ",.02)
 ;;68387-0100-15
 ;;9002226.02101,"736,68387-0100-30 ",.01)
 ;;68387-0100-30
 ;;9002226.02101,"736,68387-0100-30 ",.02)
 ;;68387-0100-30
 ;;9002226.02101,"736,68387-0100-40 ",.01)
 ;;68387-0100-40
 ;;9002226.02101,"736,68387-0100-40 ",.02)
 ;;68387-0100-40
 ;;9002226.02101,"736,68387-0100-50 ",.01)
 ;;68387-0100-50
 ;;9002226.02101,"736,68387-0100-50 ",.02)
 ;;68387-0100-50
 ;;9002226.02101,"736,68387-0100-60 ",.01)
 ;;68387-0100-60
 ;;9002226.02101,"736,68387-0100-60 ",.02)
 ;;68387-0100-60
 ;;9002226.02101,"736,68387-0100-90 ",.01)
 ;;68387-0100-90
 ;;9002226.02101,"736,68387-0100-90 ",.02)
 ;;68387-0100-90
 ;;9002226.02101,"736,68387-0531-12 ",.01)
 ;;68387-0531-12
 ;;9002226.02101,"736,68387-0531-12 ",.02)
 ;;68387-0531-12
 ;;9002226.02101,"736,68387-0531-60 ",.01)
 ;;68387-0531-60
 ;;9002226.02101,"736,68387-0531-60 ",.02)
 ;;68387-0531-60
