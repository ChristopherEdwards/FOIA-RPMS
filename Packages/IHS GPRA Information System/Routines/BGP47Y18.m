BGP47Y18 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1729,00093-5457-98 ",.01)
 ;;00093-5457-98
 ;;9002226.02101,"1729,00093-5457-98 ",.02)
 ;;00093-5457-98
 ;;9002226.02101,"1729,00093-5458-98 ",.01)
 ;;00093-5458-98
 ;;9002226.02101,"1729,00093-5458-98 ",.02)
 ;;00093-5458-98
 ;;9002226.02101,"1729,00093-5459-98 ",.01)
 ;;00093-5459-98
 ;;9002226.02101,"1729,00093-5459-98 ",.02)
 ;;00093-5459-98
 ;;9002226.02101,"1729,00093-7222-10 ",.01)
 ;;00093-7222-10
 ;;9002226.02101,"1729,00093-7222-10 ",.02)
 ;;00093-7222-10
 ;;9002226.02101,"1729,00093-7222-98 ",.01)
 ;;00093-7222-98
 ;;9002226.02101,"1729,00093-7222-98 ",.02)
 ;;00093-7222-98
 ;;9002226.02101,"1729,00093-7223-10 ",.01)
 ;;00093-7223-10
 ;;9002226.02101,"1729,00093-7223-10 ",.02)
 ;;00093-7223-10
 ;;9002226.02101,"1729,00093-7223-98 ",.01)
 ;;00093-7223-98
 ;;9002226.02101,"1729,00093-7223-98 ",.02)
 ;;00093-7223-98
 ;;9002226.02101,"1729,00093-7224-10 ",.01)
 ;;00093-7224-10
 ;;9002226.02101,"1729,00093-7224-10 ",.02)
 ;;00093-7224-10
 ;;9002226.02101,"1729,00093-7224-98 ",.01)
 ;;00093-7224-98
 ;;9002226.02101,"1729,00093-7224-98 ",.02)
 ;;00093-7224-98
 ;;9002226.02101,"1729,00093-7238-56 ",.01)
 ;;00093-7238-56
 ;;9002226.02101,"1729,00093-7238-56 ",.02)
 ;;00093-7238-56
 ;;9002226.02101,"1729,00093-7238-98 ",.01)
 ;;00093-7238-98
 ;;9002226.02101,"1729,00093-7238-98 ",.02)
 ;;00093-7238-98
 ;;9002226.02101,"1729,00093-7239-56 ",.01)
 ;;00093-7239-56
 ;;9002226.02101,"1729,00093-7239-56 ",.02)
 ;;00093-7239-56
 ;;9002226.02101,"1729,00093-7239-98 ",.01)
 ;;00093-7239-98
 ;;9002226.02101,"1729,00093-7239-98 ",.02)
 ;;00093-7239-98
 ;;9002226.02101,"1729,00093-7325-01 ",.01)
 ;;00093-7325-01
 ;;9002226.02101,"1729,00093-7325-01 ",.02)
 ;;00093-7325-01
 ;;9002226.02101,"1729,00093-7326-01 ",.01)
 ;;00093-7326-01
 ;;9002226.02101,"1729,00093-7326-01 ",.02)
 ;;00093-7326-01
 ;;9002226.02101,"1729,00093-7327-01 ",.01)
 ;;00093-7327-01
 ;;9002226.02101,"1729,00093-7327-01 ",.02)
 ;;00093-7327-01
 ;;9002226.02101,"1729,00093-7364-10 ",.01)
 ;;00093-7364-10
 ;;9002226.02101,"1729,00093-7364-10 ",.02)
 ;;00093-7364-10
 ;;9002226.02101,"1729,00093-7364-98 ",.01)
 ;;00093-7364-98
 ;;9002226.02101,"1729,00093-7364-98 ",.02)
 ;;00093-7364-98
 ;;9002226.02101,"1729,00093-7365-10 ",.01)
 ;;00093-7365-10
 ;;9002226.02101,"1729,00093-7365-10 ",.02)
 ;;00093-7365-10
 ;;9002226.02101,"1729,00093-7365-56 ",.01)
 ;;00093-7365-56
 ;;9002226.02101,"1729,00093-7365-56 ",.02)
 ;;00093-7365-56
 ;;9002226.02101,"1729,00093-7365-98 ",.01)
 ;;00093-7365-98
 ;;9002226.02101,"1729,00093-7365-98 ",.02)
 ;;00093-7365-98
 ;;9002226.02101,"1729,00093-7366-10 ",.01)
 ;;00093-7366-10
 ;;9002226.02101,"1729,00093-7366-10 ",.02)
 ;;00093-7366-10
 ;;9002226.02101,"1729,00093-7366-56 ",.01)
 ;;00093-7366-56
 ;;9002226.02101,"1729,00093-7366-56 ",.02)
 ;;00093-7366-56
 ;;9002226.02101,"1729,00093-7366-98 ",.01)
 ;;00093-7366-98
 ;;9002226.02101,"1729,00093-7366-98 ",.02)
 ;;00093-7366-98
 ;;9002226.02101,"1729,00093-7367-10 ",.01)
 ;;00093-7367-10
 ;;9002226.02101,"1729,00093-7367-10 ",.02)
 ;;00093-7367-10
 ;;9002226.02101,"1729,00093-7367-56 ",.01)
 ;;00093-7367-56
 ;;9002226.02101,"1729,00093-7367-56 ",.02)
 ;;00093-7367-56
 ;;9002226.02101,"1729,00093-7367-98 ",.01)
 ;;00093-7367-98
 ;;9002226.02101,"1729,00093-7367-98 ",.02)
 ;;00093-7367-98
 ;;9002226.02101,"1729,00093-7368-10 ",.01)
 ;;00093-7368-10
 ;;9002226.02101,"1729,00093-7368-10 ",.02)
 ;;00093-7368-10
 ;;9002226.02101,"1729,00093-7368-56 ",.01)
 ;;00093-7368-56
 ;;9002226.02101,"1729,00093-7368-56 ",.02)
 ;;00093-7368-56
 ;;9002226.02101,"1729,00093-7368-98 ",.01)
 ;;00093-7368-98
 ;;9002226.02101,"1729,00093-7368-98 ",.02)
 ;;00093-7368-98
 ;;9002226.02101,"1729,00093-7369-10 ",.01)
 ;;00093-7369-10
 ;;9002226.02101,"1729,00093-7369-10 ",.02)
 ;;00093-7369-10
 ;;9002226.02101,"1729,00093-7369-56 ",.01)
 ;;00093-7369-56
 ;;9002226.02101,"1729,00093-7369-56 ",.02)
 ;;00093-7369-56
 ;;9002226.02101,"1729,00093-7369-98 ",.01)
 ;;00093-7369-98
 ;;9002226.02101,"1729,00093-7369-98 ",.02)
 ;;00093-7369-98
 ;;9002226.02101,"1729,00093-7370-01 ",.01)
 ;;00093-7370-01
 ;;9002226.02101,"1729,00093-7370-01 ",.02)
 ;;00093-7370-01
 ;;9002226.02101,"1729,00093-7371-01 ",.01)
 ;;00093-7371-01
 ;;9002226.02101,"1729,00093-7371-01 ",.02)
 ;;00093-7371-01
 ;;9002226.02101,"1729,00093-7371-10 ",.01)
 ;;00093-7371-10
 ;;9002226.02101,"1729,00093-7371-10 ",.02)
 ;;00093-7371-10
 ;;9002226.02101,"1729,00093-7372-01 ",.01)
 ;;00093-7372-01
 ;;9002226.02101,"1729,00093-7372-01 ",.02)
 ;;00093-7372-01
 ;;9002226.02101,"1729,00093-7372-10 ",.01)
 ;;00093-7372-10
 ;;9002226.02101,"1729,00093-7372-10 ",.02)
 ;;00093-7372-10
 ;;9002226.02101,"1729,00093-7373-01 ",.01)
 ;;00093-7373-01
 ;;9002226.02101,"1729,00093-7373-01 ",.02)
 ;;00093-7373-01
 ;;9002226.02101,"1729,00093-7373-10 ",.01)
 ;;00093-7373-10
 ;;9002226.02101,"1729,00093-7373-10 ",.02)
 ;;00093-7373-10
 ;;9002226.02101,"1729,00093-7436-01 ",.01)
 ;;00093-7436-01
 ;;9002226.02101,"1729,00093-7436-01 ",.02)
 ;;00093-7436-01
 ;;9002226.02101,"1729,00093-7437-01 ",.01)
 ;;00093-7437-01
 ;;9002226.02101,"1729,00093-7437-01 ",.02)
 ;;00093-7437-01
 ;;9002226.02101,"1729,00093-7438-01 ",.01)
 ;;00093-7438-01
 ;;9002226.02101,"1729,00093-7438-01 ",.02)
 ;;00093-7438-01
 ;;9002226.02101,"1729,00093-7464-56 ",.01)
 ;;00093-7464-56
 ;;9002226.02101,"1729,00093-7464-56 ",.02)
 ;;00093-7464-56
 ;;9002226.02101,"1729,00093-7464-98 ",.01)
 ;;00093-7464-98
 ;;9002226.02101,"1729,00093-7464-98 ",.02)
 ;;00093-7464-98
 ;;9002226.02101,"1729,00093-7465-05 ",.01)
 ;;00093-7465-05
 ;;9002226.02101,"1729,00093-7465-05 ",.02)
 ;;00093-7465-05
 ;;9002226.02101,"1729,00093-7465-56 ",.01)
 ;;00093-7465-56
 ;;9002226.02101,"1729,00093-7465-56 ",.02)
 ;;00093-7465-56
 ;;9002226.02101,"1729,00093-7465-98 ",.01)
 ;;00093-7465-98
 ;;9002226.02101,"1729,00093-7465-98 ",.02)
 ;;00093-7465-98
 ;;9002226.02101,"1729,00093-7466-05 ",.01)
 ;;00093-7466-05
 ;;9002226.02101,"1729,00093-7466-05 ",.02)
 ;;00093-7466-05
 ;;9002226.02101,"1729,00093-7466-56 ",.01)
 ;;00093-7466-56
 ;;9002226.02101,"1729,00093-7466-56 ",.02)
 ;;00093-7466-56
 ;;9002226.02101,"1729,00093-7466-98 ",.01)
 ;;00093-7466-98
 ;;9002226.02101,"1729,00093-7466-98 ",.02)
 ;;00093-7466-98
 ;;9002226.02101,"1729,00093-7514-05 ",.01)
 ;;00093-7514-05
 ;;9002226.02101,"1729,00093-7514-05 ",.02)
 ;;00093-7514-05
 ;;9002226.02101,"1729,00093-7514-56 ",.01)
 ;;00093-7514-56
 ;;9002226.02101,"1729,00093-7514-56 ",.02)
 ;;00093-7514-56
 ;;9002226.02101,"1729,00093-7514-98 ",.01)
 ;;00093-7514-98
 ;;9002226.02101,"1729,00093-7514-98 ",.02)
 ;;00093-7514-98
 ;;9002226.02101,"1729,00093-7670-01 ",.01)
 ;;00093-7670-01
 ;;9002226.02101,"1729,00093-7670-01 ",.02)
 ;;00093-7670-01
 ;;9002226.02101,"1729,00093-7671-01 ",.01)
 ;;00093-7671-01
 ;;9002226.02101,"1729,00093-7671-01 ",.02)
 ;;00093-7671-01
 ;;9002226.02101,"1729,00093-8132-10 ",.01)
 ;;00093-8132-10
 ;;9002226.02101,"1729,00093-8132-10 ",.02)
 ;;00093-8132-10
 ;;9002226.02101,"1729,00093-8133-01 ",.01)
 ;;00093-8133-01
 ;;9002226.02101,"1729,00093-8133-01 ",.02)
 ;;00093-8133-01
 ;;9002226.02101,"1729,00093-8133-10 ",.01)
 ;;00093-8133-10
 ;;9002226.02101,"1729,00093-8133-10 ",.02)
 ;;00093-8133-10
 ;;9002226.02101,"1729,00093-8134-10 ",.01)
 ;;00093-8134-10
 ;;9002226.02101,"1729,00093-8134-10 ",.02)
 ;;00093-8134-10
 ;;9002226.02101,"1729,00093-8135-01 ",.01)
 ;;00093-8135-01
 ;;9002226.02101,"1729,00093-8135-01 ",.02)
 ;;00093-8135-01
 ;;9002226.02101,"1729,00093-8232-56 ",.01)
 ;;00093-8232-56
 ;;9002226.02101,"1729,00093-8232-56 ",.02)
 ;;00093-8232-56
 ;;9002226.02101,"1729,00093-8232-98 ",.01)
 ;;00093-8232-98
 ;;9002226.02101,"1729,00093-8232-98 ",.02)
 ;;00093-8232-98
 ;;9002226.02101,"1729,00093-8238-56 ",.01)
 ;;00093-8238-56
 ;;9002226.02101,"1729,00093-8238-56 ",.02)
 ;;00093-8238-56
 ;;9002226.02101,"1729,00093-8238-98 ",.01)
 ;;00093-8238-98
 ;;9002226.02101,"1729,00093-8238-98 ",.02)
 ;;00093-8238-98
 ;;9002226.02101,"1729,00143-1171-01 ",.01)
 ;;00143-1171-01
 ;;9002226.02101,"1729,00143-1171-01 ",.02)
 ;;00143-1171-01
 ;;9002226.02101,"1729,00143-1171-10 ",.01)
 ;;00143-1171-10
 ;;9002226.02101,"1729,00143-1171-10 ",.02)
 ;;00143-1171-10
 ;;9002226.02101,"1729,00143-1171-25 ",.01)
 ;;00143-1171-25
 ;;9002226.02101,"1729,00143-1171-25 ",.02)
 ;;00143-1171-25
 ;;9002226.02101,"1729,00143-1172-01 ",.01)
 ;;00143-1172-01
 ;;9002226.02101,"1729,00143-1172-01 ",.02)
 ;;00143-1172-01
 ;;9002226.02101,"1729,00143-1172-10 ",.01)
 ;;00143-1172-10
 ;;9002226.02101,"1729,00143-1172-10 ",.02)
 ;;00143-1172-10
 ;;9002226.02101,"1729,00143-1172-25 ",.01)
 ;;00143-1172-25
 ;;9002226.02101,"1729,00143-1172-25 ",.02)
 ;;00143-1172-25
 ;;9002226.02101,"1729,00143-1173-01 ",.01)
 ;;00143-1173-01
 ;;9002226.02101,"1729,00143-1173-01 ",.02)
 ;;00143-1173-01
 ;;9002226.02101,"1729,00143-1173-10 ",.01)
 ;;00143-1173-10
 ;;9002226.02101,"1729,00143-1173-10 ",.02)
 ;;00143-1173-10
 ;;9002226.02101,"1729,00143-1173-25 ",.01)
 ;;00143-1173-25
 ;;9002226.02101,"1729,00143-1173-25 ",.02)
 ;;00143-1173-25
 ;;9002226.02101,"1729,00143-1174-01 ",.01)
 ;;00143-1174-01
 ;;9002226.02101,"1729,00143-1174-01 ",.02)
 ;;00143-1174-01
 ;;9002226.02101,"1729,00143-1174-25 ",.01)
 ;;00143-1174-25
 ;;9002226.02101,"1729,00143-1174-25 ",.02)
 ;;00143-1174-25
 ;;9002226.02101,"1729,00143-1262-01 ",.01)
 ;;00143-1262-01
 ;;9002226.02101,"1729,00143-1262-01 ",.02)
 ;;00143-1262-01
 ;;9002226.02101,"1729,00143-1262-10 ",.01)
 ;;00143-1262-10
 ;;9002226.02101,"1729,00143-1262-10 ",.02)
 ;;00143-1262-10
 ;;9002226.02101,"1729,00143-1263-01 ",.01)
 ;;00143-1263-01
 ;;9002226.02101,"1729,00143-1263-01 ",.02)
 ;;00143-1263-01
 ;;9002226.02101,"1729,00143-1263-10 ",.01)
 ;;00143-1263-10
 ;;9002226.02101,"1729,00143-1263-10 ",.02)
 ;;00143-1263-10
 ;;9002226.02101,"1729,00143-1264-01 ",.01)
 ;;00143-1264-01
 ;;9002226.02101,"1729,00143-1264-01 ",.02)
 ;;00143-1264-01
 ;;9002226.02101,"1729,00143-1264-10 ",.01)
 ;;00143-1264-10
 ;;9002226.02101,"1729,00143-1264-10 ",.02)
 ;;00143-1264-10
 ;;9002226.02101,"1729,00143-1265-01 ",.01)
 ;;00143-1265-01
 ;;9002226.02101,"1729,00143-1265-01 ",.02)
 ;;00143-1265-01
 ;;9002226.02101,"1729,00143-1265-09 ",.01)
 ;;00143-1265-09
 ;;9002226.02101,"1729,00143-1265-09 ",.02)
 ;;00143-1265-09
 ;;9002226.02101,"1729,00143-1265-10 ",.01)
 ;;00143-1265-10
 ;;9002226.02101,"1729,00143-1265-10 ",.02)
 ;;00143-1265-10
 ;;9002226.02101,"1729,00143-1266-01 ",.01)
 ;;00143-1266-01
 ;;9002226.02101,"1729,00143-1266-01 ",.02)
 ;;00143-1266-01
 ;;9002226.02101,"1729,00143-1266-09 ",.01)
 ;;00143-1266-09
 ;;9002226.02101,"1729,00143-1266-09 ",.02)
 ;;00143-1266-09
 ;;9002226.02101,"1729,00143-1266-10 ",.01)
 ;;00143-1266-10
 ;;9002226.02101,"1729,00143-1266-10 ",.02)
 ;;00143-1266-10
 ;;9002226.02101,"1729,00143-1266-30 ",.01)
 ;;00143-1266-30
 ;;9002226.02101,"1729,00143-1266-30 ",.02)
 ;;00143-1266-30
 ;;9002226.02101,"1729,00143-1266-45 ",.01)
 ;;00143-1266-45
 ;;9002226.02101,"1729,00143-1266-45 ",.02)
 ;;00143-1266-45
 ;;9002226.02101,"1729,00143-1267-01 ",.01)
 ;;00143-1267-01
 ;;9002226.02101,"1729,00143-1267-01 ",.02)
 ;;00143-1267-01
 ;;9002226.02101,"1729,00143-1267-09 ",.01)
 ;;00143-1267-09
 ;;9002226.02101,"1729,00143-1267-09 ",.02)
 ;;00143-1267-09
 ;;9002226.02101,"1729,00143-1267-10 ",.01)
 ;;00143-1267-10
 ;;9002226.02101,"1729,00143-1267-10 ",.02)
 ;;00143-1267-10
 ;;9002226.02101,"1729,00143-1267-18 ",.01)
 ;;00143-1267-18
 ;;9002226.02101,"1729,00143-1267-18 ",.02)
 ;;00143-1267-18
 ;;9002226.02101,"1729,00143-1267-30 ",.01)
 ;;00143-1267-30
 ;;9002226.02101,"1729,00143-1267-30 ",.02)
 ;;00143-1267-30
 ;;9002226.02101,"1729,00143-1267-45 ",.01)
 ;;00143-1267-45
 ;;9002226.02101,"1729,00143-1267-45 ",.02)
 ;;00143-1267-45
 ;;9002226.02101,"1729,00143-1268-01 ",.01)
 ;;00143-1268-01
 ;;9002226.02101,"1729,00143-1268-01 ",.02)
 ;;00143-1268-01
 ;;9002226.02101,"1729,00143-1268-09 ",.01)
 ;;00143-1268-09
 ;;9002226.02101,"1729,00143-1268-09 ",.02)
 ;;00143-1268-09
 ;;9002226.02101,"1729,00143-1268-10 ",.01)
 ;;00143-1268-10
 ;;9002226.02101,"1729,00143-1268-10 ",.02)
 ;;00143-1268-10
 ;;9002226.02101,"1729,00143-1268-18 ",.01)
 ;;00143-1268-18
 ;;9002226.02101,"1729,00143-1268-18 ",.02)
 ;;00143-1268-18
 ;;9002226.02101,"1729,00143-1268-30 ",.01)
 ;;00143-1268-30
 ;;9002226.02101,"1729,00143-1268-30 ",.02)
 ;;00143-1268-30
 ;;9002226.02101,"1729,00143-1268-45 ",.01)
 ;;00143-1268-45
 ;;9002226.02101,"1729,00143-1268-45 ",.02)
 ;;00143-1268-45
 ;;9002226.02101,"1729,00143-1270-01 ",.01)
 ;;00143-1270-01
 ;;9002226.02101,"1729,00143-1270-01 ",.02)
 ;;00143-1270-01
 ;;9002226.02101,"1729,00143-1270-09 ",.01)
 ;;00143-1270-09
 ;;9002226.02101,"1729,00143-1270-09 ",.02)
 ;;00143-1270-09
 ;;9002226.02101,"1729,00143-1270-10 ",.01)
 ;;00143-1270-10
 ;;9002226.02101,"1729,00143-1270-10 ",.02)
 ;;00143-1270-10
 ;;9002226.02101,"1729,00143-1270-18 ",.01)
 ;;00143-1270-18
 ;;9002226.02101,"1729,00143-1270-18 ",.02)
 ;;00143-1270-18
 ;;9002226.02101,"1729,00143-1270-30 ",.01)
 ;;00143-1270-30
 ;;9002226.02101,"1729,00143-1270-30 ",.02)
 ;;00143-1270-30
 ;;9002226.02101,"1729,00143-1270-45 ",.01)
 ;;00143-1270-45
 ;;9002226.02101,"1729,00143-1270-45 ",.02)
 ;;00143-1270-45
 ;;9002226.02101,"1729,00143-1280-01 ",.01)
 ;;00143-1280-01
 ;;9002226.02101,"1729,00143-1280-01 ",.02)
 ;;00143-1280-01
 ;;9002226.02101,"1729,00143-1280-10 ",.01)
 ;;00143-1280-10