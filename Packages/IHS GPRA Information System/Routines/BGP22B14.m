BGP22B14 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1196,00087-0609-45 ",.02)
 ;;00087-0609-45
 ;;9002226.02101,"1196,00087-0609-85 ",.01)
 ;;00087-0609-85
 ;;9002226.02101,"1196,00087-0609-85 ",.02)
 ;;00087-0609-85
 ;;9002226.02101,"1196,00087-1202-13 ",.01)
 ;;00087-1202-13
 ;;9002226.02101,"1196,00087-1202-13 ",.02)
 ;;00087-1202-13
 ;;9002226.02101,"1196,00087-1492-01 ",.01)
 ;;00087-1492-01
 ;;9002226.02101,"1196,00087-1492-01 ",.02)
 ;;00087-1492-01
 ;;9002226.02101,"1196,00087-1493-01 ",.01)
 ;;00087-1493-01
 ;;9002226.02101,"1196,00087-1493-01 ",.02)
 ;;00087-1493-01
 ;;9002226.02101,"1196,00087-2771-31 ",.01)
 ;;00087-2771-31
 ;;9002226.02101,"1196,00087-2771-31 ",.02)
 ;;00087-2771-31
 ;;9002226.02101,"1196,00087-2771-32 ",.01)
 ;;00087-2771-32
 ;;9002226.02101,"1196,00087-2771-32 ",.02)
 ;;00087-2771-32
 ;;9002226.02101,"1196,00087-2772-15 ",.01)
 ;;00087-2772-15
 ;;9002226.02101,"1196,00087-2772-15 ",.02)
 ;;00087-2772-15
 ;;9002226.02101,"1196,00087-2772-31 ",.01)
 ;;00087-2772-31
 ;;9002226.02101,"1196,00087-2772-31 ",.02)
 ;;00087-2772-31
 ;;9002226.02101,"1196,00087-2772-32 ",.01)
 ;;00087-2772-32
 ;;9002226.02101,"1196,00087-2772-32 ",.02)
 ;;00087-2772-32
 ;;9002226.02101,"1196,00087-2772-35 ",.01)
 ;;00087-2772-35
 ;;9002226.02101,"1196,00087-2772-35 ",.02)
 ;;00087-2772-35
 ;;9002226.02101,"1196,00087-2773-15 ",.01)
 ;;00087-2773-15
 ;;9002226.02101,"1196,00087-2773-15 ",.02)
 ;;00087-2773-15
 ;;9002226.02101,"1196,00087-2773-31 ",.01)
 ;;00087-2773-31
 ;;9002226.02101,"1196,00087-2773-31 ",.02)
 ;;00087-2773-31
 ;;9002226.02101,"1196,00087-2773-32 ",.01)
 ;;00087-2773-32
 ;;9002226.02101,"1196,00087-2773-32 ",.02)
 ;;00087-2773-32
 ;;9002226.02101,"1196,00087-2775-31 ",.01)
 ;;00087-2775-31
 ;;9002226.02101,"1196,00087-2775-31 ",.02)
 ;;00087-2775-31
 ;;9002226.02101,"1196,00087-2775-32 ",.01)
 ;;00087-2775-32
 ;;9002226.02101,"1196,00087-2775-32 ",.02)
 ;;00087-2775-32
 ;;9002226.02101,"1196,00087-2776-31 ",.01)
 ;;00087-2776-31
 ;;9002226.02101,"1196,00087-2776-31 ",.02)
 ;;00087-2776-31
 ;;9002226.02101,"1196,00087-2776-32 ",.01)
 ;;00087-2776-32
 ;;9002226.02101,"1196,00087-2776-32 ",.02)
 ;;00087-2776-32
 ;;9002226.02101,"1196,00087-2788-31 ",.01)
 ;;00087-2788-31
 ;;9002226.02101,"1196,00087-2788-31 ",.02)
 ;;00087-2788-31
 ;;9002226.02101,"1196,00087-2788-32 ",.01)
 ;;00087-2788-32
 ;;9002226.02101,"1196,00087-2788-32 ",.02)
 ;;00087-2788-32
 ;;9002226.02101,"1196,00087-2875-31 ",.01)
 ;;00087-2875-31
 ;;9002226.02101,"1196,00087-2875-31 ",.02)
 ;;00087-2875-31
 ;;9002226.02101,"1196,00087-2875-32 ",.01)
 ;;00087-2875-32
 ;;9002226.02101,"1196,00087-2875-32 ",.02)
 ;;00087-2875-32
 ;;9002226.02101,"1196,00087-2876-31 ",.01)
 ;;00087-2876-31
 ;;9002226.02101,"1196,00087-2876-31 ",.02)
 ;;00087-2876-31
 ;;9002226.02101,"1196,00087-2876-32 ",.01)
 ;;00087-2876-32
 ;;9002226.02101,"1196,00087-2876-32 ",.02)
 ;;00087-2876-32
 ;;9002226.02101,"1196,00091-3707-01 ",.01)
 ;;00091-3707-01
 ;;9002226.02101,"1196,00091-3707-01 ",.02)
 ;;00091-3707-01
 ;;9002226.02101,"1196,00091-3707-09 ",.01)
 ;;00091-3707-09
 ;;9002226.02101,"1196,00091-3707-09 ",.02)
 ;;00091-3707-09
 ;;9002226.02101,"1196,00091-3712-01 ",.01)
 ;;00091-3712-01
 ;;9002226.02101,"1196,00091-3712-01 ",.02)
 ;;00091-3712-01
 ;;9002226.02101,"1196,00091-3715-01 ",.01)
 ;;00091-3715-01
 ;;9002226.02101,"1196,00091-3715-01 ",.02)
 ;;00091-3715-01
 ;;9002226.02101,"1196,00091-3715-09 ",.01)
 ;;00091-3715-09
 ;;9002226.02101,"1196,00091-3715-09 ",.02)
 ;;00091-3715-09
 ;;9002226.02101,"1196,00091-3720-01 ",.01)
 ;;00091-3720-01
 ;;9002226.02101,"1196,00091-3720-01 ",.02)
 ;;00091-3720-01
 ;;9002226.02101,"1196,00091-3725-01 ",.01)
 ;;00091-3725-01
 ;;9002226.02101,"1196,00091-3725-01 ",.02)
 ;;00091-3725-01
 ;;9002226.02101,"1196,00093-0017-01 ",.01)
 ;;00093-0017-01
 ;;9002226.02101,"1196,00093-0017-01 ",.02)
 ;;00093-0017-01
 ;;9002226.02101,"1196,00093-0026-01 ",.01)
 ;;00093-0026-01
 ;;9002226.02101,"1196,00093-0026-01 ",.02)
 ;;00093-0026-01
 ;;9002226.02101,"1196,00093-0026-10 ",.01)
 ;;00093-0026-10
 ;;9002226.02101,"1196,00093-0026-10 ",.02)
 ;;00093-0026-10
 ;;9002226.02101,"1196,00093-0027-01 ",.01)
 ;;00093-0027-01
 ;;9002226.02101,"1196,00093-0027-01 ",.02)
 ;;00093-0027-01
 ;;9002226.02101,"1196,00093-0027-10 ",.01)
 ;;00093-0027-10
 ;;9002226.02101,"1196,00093-0027-10 ",.02)
 ;;00093-0027-10
 ;;9002226.02101,"1196,00093-0027-50 ",.01)
 ;;00093-0027-50
 ;;9002226.02101,"1196,00093-0027-50 ",.02)
 ;;00093-0027-50
 ;;9002226.02101,"1196,00093-0028-01 ",.01)
 ;;00093-0028-01
 ;;9002226.02101,"1196,00093-0028-01 ",.02)
 ;;00093-0028-01
 ;;9002226.02101,"1196,00093-0028-10 ",.01)
 ;;00093-0028-10
 ;;9002226.02101,"1196,00093-0028-10 ",.02)
 ;;00093-0028-10
 ;;9002226.02101,"1196,00093-0028-50 ",.01)
 ;;00093-0028-50
 ;;9002226.02101,"1196,00093-0028-50 ",.02)
 ;;00093-0028-50
 ;;9002226.02101,"1196,00093-0029-01 ",.01)
 ;;00093-0029-01
 ;;9002226.02101,"1196,00093-0029-01 ",.02)
 ;;00093-0029-01
 ;;9002226.02101,"1196,00093-0029-10 ",.01)
 ;;00093-0029-10
 ;;9002226.02101,"1196,00093-0029-10 ",.02)
 ;;00093-0029-10
 ;;9002226.02101,"1196,00093-0029-50 ",.01)
 ;;00093-0029-50
 ;;9002226.02101,"1196,00093-0029-50 ",.02)
 ;;00093-0029-50
 ;;9002226.02101,"1196,00093-0091-01 ",.01)
 ;;00093-0091-01
 ;;9002226.02101,"1196,00093-0091-01 ",.02)
 ;;00093-0091-01
 ;;9002226.02101,"1196,00093-0091-10 ",.01)
 ;;00093-0091-10
 ;;9002226.02101,"1196,00093-0091-10 ",.02)
 ;;00093-0091-10
 ;;9002226.02101,"1196,00093-0092-01 ",.01)
 ;;00093-0092-01
 ;;9002226.02101,"1196,00093-0092-01 ",.02)
 ;;00093-0092-01
 ;;9002226.02101,"1196,00093-0092-10 ",.01)
 ;;00093-0092-10
 ;;9002226.02101,"1196,00093-0092-10 ",.02)
 ;;00093-0092-10
 ;;9002226.02101,"1196,00093-0097-01 ",.01)
 ;;00093-0097-01
 ;;9002226.02101,"1196,00093-0097-01 ",.02)
 ;;00093-0097-01
 ;;9002226.02101,"1196,00093-0097-10 ",.01)
 ;;00093-0097-10
 ;;9002226.02101,"1196,00093-0097-10 ",.02)
 ;;00093-0097-10
 ;;9002226.02101,"1196,00093-0098-01 ",.01)
 ;;00093-0098-01
 ;;9002226.02101,"1196,00093-0098-01 ",.02)
 ;;00093-0098-01
 ;;9002226.02101,"1196,00093-0176-01 ",.01)
 ;;00093-0176-01
 ;;9002226.02101,"1196,00093-0176-01 ",.02)
 ;;00093-0176-01
 ;;9002226.02101,"1196,00093-0177-01 ",.01)
 ;;00093-0177-01
 ;;9002226.02101,"1196,00093-0177-01 ",.02)
 ;;00093-0177-01
 ;;9002226.02101,"1196,00093-0181-01 ",.01)
 ;;00093-0181-01
 ;;9002226.02101,"1196,00093-0181-01 ",.02)
 ;;00093-0181-01
 ;;9002226.02101,"1196,00093-0182-01 ",.01)
 ;;00093-0182-01
 ;;9002226.02101,"1196,00093-0182-01 ",.02)
 ;;00093-0182-01
 ;;9002226.02101,"1196,00093-1035-01 ",.01)
 ;;00093-1035-01
 ;;9002226.02101,"1196,00093-1035-01 ",.02)
 ;;00093-1035-01
 ;;9002226.02101,"1196,00093-1036-01 ",.01)
 ;;00093-1036-01
 ;;9002226.02101,"1196,00093-1036-01 ",.02)
 ;;00093-1036-01
 ;;9002226.02101,"1196,00093-1036-05 ",.01)
 ;;00093-1036-05
 ;;9002226.02101,"1196,00093-1036-05 ",.02)
 ;;00093-1036-05
 ;;9002226.02101,"1196,00093-1037-01 ",.01)
 ;;00093-1037-01
 ;;9002226.02101,"1196,00093-1037-01 ",.02)
 ;;00093-1037-01
 ;;9002226.02101,"1196,00093-1037-05 ",.01)
 ;;00093-1037-05
 ;;9002226.02101,"1196,00093-1037-05 ",.02)
 ;;00093-1037-05
 ;;9002226.02101,"1196,00093-1044-01 ",.01)
 ;;00093-1044-01
 ;;9002226.02101,"1196,00093-1044-01 ",.02)
 ;;00093-1044-01
 ;;9002226.02101,"1196,00093-1045-05 ",.01)
 ;;00093-1045-05
 ;;9002226.02101,"1196,00093-1045-05 ",.02)
 ;;00093-1045-05
 ;;9002226.02101,"1196,00093-1045-98 ",.01)
 ;;00093-1045-98
 ;;9002226.02101,"1196,00093-1045-98 ",.02)
 ;;00093-1045-98
 ;;9002226.02101,"1196,00093-1050-05 ",.01)
 ;;00093-1050-05
 ;;9002226.02101,"1196,00093-1050-05 ",.02)
 ;;00093-1050-05
 ;;9002226.02101,"1196,00093-1050-98 ",.01)
 ;;00093-1050-98
 ;;9002226.02101,"1196,00093-1050-98 ",.02)
 ;;00093-1050-98
 ;;9002226.02101,"1196,00093-1051-05 ",.01)
 ;;00093-1051-05
 ;;9002226.02101,"1196,00093-1051-05 ",.02)
 ;;00093-1051-05
 ;;9002226.02101,"1196,00093-1051-98 ",.01)
 ;;00093-1051-98
 ;;9002226.02101,"1196,00093-1051-98 ",.02)
 ;;00093-1051-98
 ;;9002226.02101,"1196,00093-1052-01 ",.01)
 ;;00093-1052-01
 ;;9002226.02101,"1196,00093-1052-01 ",.02)
 ;;00093-1052-01
 ;;9002226.02101,"1196,00093-1052-10 ",.01)
 ;;00093-1052-10
 ;;9002226.02101,"1196,00093-1052-10 ",.02)
 ;;00093-1052-10
 ;;9002226.02101,"1196,00093-1053-05 ",.01)
 ;;00093-1053-05
 ;;9002226.02101,"1196,00093-1053-05 ",.02)
 ;;00093-1053-05
 ;;9002226.02101,"1196,00093-1053-98 ",.01)
 ;;00093-1053-98
 ;;9002226.02101,"1196,00093-1053-98 ",.02)
 ;;00093-1053-98
 ;;9002226.02101,"1196,00093-1111-01 ",.01)
 ;;00093-1111-01
 ;;9002226.02101,"1196,00093-1111-01 ",.02)
 ;;00093-1111-01
 ;;9002226.02101,"1196,00093-1112-01 ",.01)
 ;;00093-1112-01
 ;;9002226.02101,"1196,00093-1112-01 ",.02)
 ;;00093-1112-01
 ;;9002226.02101,"1196,00093-1112-10 ",.01)
 ;;00093-1112-10
 ;;9002226.02101,"1196,00093-1112-10 ",.02)
 ;;00093-1112-10
 ;;9002226.02101,"1196,00093-1113-01 ",.01)
 ;;00093-1113-01
 ;;9002226.02101,"1196,00093-1113-01 ",.02)
 ;;00093-1113-01
 ;;9002226.02101,"1196,00093-1113-10 ",.01)
 ;;00093-1113-10
 ;;9002226.02101,"1196,00093-1113-10 ",.02)
 ;;00093-1113-10
 ;;9002226.02101,"1196,00093-1114-01 ",.01)
 ;;00093-1114-01
 ;;9002226.02101,"1196,00093-1114-01 ",.02)
 ;;00093-1114-01
 ;;9002226.02101,"1196,00093-1114-10 ",.01)
 ;;00093-1114-10
 ;;9002226.02101,"1196,00093-1114-10 ",.02)
 ;;00093-1114-10
 ;;9002226.02101,"1196,00093-1115-01 ",.01)
 ;;00093-1115-01
 ;;9002226.02101,"1196,00093-1115-01 ",.02)
 ;;00093-1115-01
 ;;9002226.02101,"1196,00093-1115-05 ",.01)
 ;;00093-1115-05
 ;;9002226.02101,"1196,00093-1115-05 ",.02)
 ;;00093-1115-05
 ;;9002226.02101,"1196,00093-5124-01 ",.01)
 ;;00093-5124-01
 ;;9002226.02101,"1196,00093-5124-01 ",.02)
 ;;00093-5124-01
 ;;9002226.02101,"1196,00093-5125-01 ",.01)
 ;;00093-5125-01
 ;;9002226.02101,"1196,00093-5125-01 ",.02)
 ;;00093-5125-01
 ;;9002226.02101,"1196,00093-5125-05 ",.01)
 ;;00093-5125-05
 ;;9002226.02101,"1196,00093-5125-05 ",.02)
 ;;00093-5125-05
 ;;9002226.02101,"1196,00093-5126-01 ",.01)
 ;;00093-5126-01
 ;;9002226.02101,"1196,00093-5126-01 ",.02)
 ;;00093-5126-01
 ;;9002226.02101,"1196,00093-5126-05 ",.01)
 ;;00093-5126-05
 ;;9002226.02101,"1196,00093-5126-05 ",.02)
 ;;00093-5126-05
 ;;9002226.02101,"1196,00093-5127-01 ",.01)
 ;;00093-5127-01
 ;;9002226.02101,"1196,00093-5127-01 ",.02)
 ;;00093-5127-01
 ;;9002226.02101,"1196,00093-5150-01 ",.01)
 ;;00093-5150-01
 ;;9002226.02101,"1196,00093-5150-01 ",.02)
 ;;00093-5150-01
 ;;9002226.02101,"1196,00093-5157-01 ",.01)
 ;;00093-5157-01
 ;;9002226.02101,"1196,00093-5157-01 ",.02)
 ;;00093-5157-01
 ;;9002226.02101,"1196,00093-5213-01 ",.01)
 ;;00093-5213-01
 ;;9002226.02101,"1196,00093-5213-01 ",.02)
 ;;00093-5213-01
 ;;9002226.02101,"1196,00093-5214-01 ",.01)
 ;;00093-5214-01
 ;;9002226.02101,"1196,00093-5214-01 ",.02)
 ;;00093-5214-01
 ;;9002226.02101,"1196,00093-5215-01 ",.01)
 ;;00093-5215-01
 ;;9002226.02101,"1196,00093-5215-01 ",.02)
 ;;00093-5215-01
 ;;9002226.02101,"1196,00093-5456-98 ",.01)
 ;;00093-5456-98
 ;;9002226.02101,"1196,00093-5456-98 ",.02)
 ;;00093-5456-98
 ;;9002226.02101,"1196,00093-5457-98 ",.01)
 ;;00093-5457-98
 ;;9002226.02101,"1196,00093-5457-98 ",.02)
 ;;00093-5457-98
 ;;9002226.02101,"1196,00093-5458-98 ",.01)
 ;;00093-5458-98
 ;;9002226.02101,"1196,00093-5458-98 ",.02)
 ;;00093-5458-98
 ;;9002226.02101,"1196,00093-5459-98 ",.01)
 ;;00093-5459-98
 ;;9002226.02101,"1196,00093-5459-98 ",.02)
 ;;00093-5459-98
 ;;9002226.02101,"1196,00093-7222-10 ",.01)
 ;;00093-7222-10
 ;;9002226.02101,"1196,00093-7222-10 ",.02)
 ;;00093-7222-10
 ;;9002226.02101,"1196,00093-7222-98 ",.01)
 ;;00093-7222-98
 ;;9002226.02101,"1196,00093-7222-98 ",.02)
 ;;00093-7222-98
 ;;9002226.02101,"1196,00093-7223-10 ",.01)
 ;;00093-7223-10
 ;;9002226.02101,"1196,00093-7223-10 ",.02)
 ;;00093-7223-10
 ;;9002226.02101,"1196,00093-7223-98 ",.01)
 ;;00093-7223-98
 ;;9002226.02101,"1196,00093-7223-98 ",.02)
 ;;00093-7223-98
 ;;9002226.02101,"1196,00093-7224-10 ",.01)
 ;;00093-7224-10
 ;;9002226.02101,"1196,00093-7224-10 ",.02)
 ;;00093-7224-10
 ;;9002226.02101,"1196,00093-7224-98 ",.01)
 ;;00093-7224-98
 ;;9002226.02101,"1196,00093-7224-98 ",.02)
 ;;00093-7224-98
 ;;9002226.02101,"1196,00093-7325-01 ",.01)
 ;;00093-7325-01
 ;;9002226.02101,"1196,00093-7325-01 ",.02)
 ;;00093-7325-01
 ;;9002226.02101,"1196,00093-7326-01 ",.01)
 ;;00093-7326-01
 ;;9002226.02101,"1196,00093-7326-01 ",.02)
 ;;00093-7326-01
 ;;9002226.02101,"1196,00093-7327-01 ",.01)
 ;;00093-7327-01
 ;;9002226.02101,"1196,00093-7327-01 ",.02)
 ;;00093-7327-01
 ;;9002226.02101,"1196,00093-7364-10 ",.01)
 ;;00093-7364-10
 ;;9002226.02101,"1196,00093-7364-10 ",.02)
 ;;00093-7364-10
 ;;9002226.02101,"1196,00093-7364-98 ",.01)
 ;;00093-7364-98
 ;;9002226.02101,"1196,00093-7364-98 ",.02)
 ;;00093-7364-98
 ;;9002226.02101,"1196,00093-7365-10 ",.01)
 ;;00093-7365-10
 ;;9002226.02101,"1196,00093-7365-10 ",.02)
 ;;00093-7365-10
 ;;9002226.02101,"1196,00093-7365-56 ",.01)
 ;;00093-7365-56
 ;;9002226.02101,"1196,00093-7365-56 ",.02)
 ;;00093-7365-56
 ;;9002226.02101,"1196,00093-7365-98 ",.01)
 ;;00093-7365-98
 ;;9002226.02101,"1196,00093-7365-98 ",.02)
 ;;00093-7365-98
 ;;9002226.02101,"1196,00093-7366-10 ",.01)
 ;;00093-7366-10
 ;;9002226.02101,"1196,00093-7366-10 ",.02)
 ;;00093-7366-10
 ;;9002226.02101,"1196,00093-7366-56 ",.01)
 ;;00093-7366-56
 ;;9002226.02101,"1196,00093-7366-56 ",.02)
 ;;00093-7366-56
