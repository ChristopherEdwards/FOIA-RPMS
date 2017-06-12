BGP61F23 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1733,00781-5951-64 ",.02)
 ;;00781-5951-64
 ;;9002226.02101,"1733,00781-5951-92 ",.01)
 ;;00781-5951-92
 ;;9002226.02101,"1733,00781-5951-92 ",.02)
 ;;00781-5951-92
 ;;9002226.02101,"1733,00781-5952-10 ",.01)
 ;;00781-5952-10
 ;;9002226.02101,"1733,00781-5952-10 ",.02)
 ;;00781-5952-10
 ;;9002226.02101,"1733,00781-5952-64 ",.01)
 ;;00781-5952-64
 ;;9002226.02101,"1733,00781-5952-64 ",.02)
 ;;00781-5952-64
 ;;9002226.02101,"1733,00781-5952-92 ",.01)
 ;;00781-5952-92
 ;;9002226.02101,"1733,00781-5952-92 ",.02)
 ;;00781-5952-92
 ;;9002226.02101,"1733,00832-0483-11 ",.01)
 ;;00832-0483-11
 ;;9002226.02101,"1733,00832-0483-11 ",.02)
 ;;00832-0483-11
 ;;9002226.02101,"1733,00832-0484-11 ",.01)
 ;;00832-0484-11
 ;;9002226.02101,"1733,00832-0484-11 ",.02)
 ;;00832-0484-11
 ;;9002226.02101,"1733,00832-0485-11 ",.01)
 ;;00832-0485-11
 ;;9002226.02101,"1733,00832-0485-11 ",.02)
 ;;00832-0485-11
 ;;9002226.02101,"1733,00904-5045-61 ",.01)
 ;;00904-5045-61
 ;;9002226.02101,"1733,00904-5045-61 ",.02)
 ;;00904-5045-61
 ;;9002226.02101,"1733,00904-5046-61 ",.01)
 ;;00904-5046-61
 ;;9002226.02101,"1733,00904-5046-61 ",.02)
 ;;00904-5046-61
 ;;9002226.02101,"1733,00904-5501-60 ",.01)
 ;;00904-5501-60
 ;;9002226.02101,"1733,00904-5501-60 ",.02)
 ;;00904-5501-60
 ;;9002226.02101,"1733,00904-5502-61 ",.01)
 ;;00904-5502-61
 ;;9002226.02101,"1733,00904-5502-61 ",.02)
 ;;00904-5502-61
 ;;9002226.02101,"1733,00904-5609-61 ",.01)
 ;;00904-5609-61
 ;;9002226.02101,"1733,00904-5609-61 ",.02)
 ;;00904-5609-61
 ;;9002226.02101,"1733,00904-5610-61 ",.01)
 ;;00904-5610-61
 ;;9002226.02101,"1733,00904-5610-61 ",.02)
 ;;00904-5610-61
 ;;9002226.02101,"1733,00904-5611-61 ",.01)
 ;;00904-5611-61
 ;;9002226.02101,"1733,00904-5611-61 ",.02)
 ;;00904-5611-61
 ;;9002226.02101,"1733,00904-5638-89 ",.01)
 ;;00904-5638-89
 ;;9002226.02101,"1733,00904-5638-89 ",.02)
 ;;00904-5638-89
 ;;9002226.02101,"1733,00904-5639-43 ",.01)
 ;;00904-5639-43
 ;;9002226.02101,"1733,00904-5639-43 ",.02)
 ;;00904-5639-43
 ;;9002226.02101,"1733,00904-5639-46 ",.01)
 ;;00904-5639-46
 ;;9002226.02101,"1733,00904-5639-46 ",.02)
 ;;00904-5639-46
 ;;9002226.02101,"1733,00904-5639-48 ",.01)
 ;;00904-5639-48
 ;;9002226.02101,"1733,00904-5639-48 ",.02)
 ;;00904-5639-48
 ;;9002226.02101,"1733,00904-5639-89 ",.01)
 ;;00904-5639-89
 ;;9002226.02101,"1733,00904-5639-89 ",.02)
 ;;00904-5639-89
 ;;9002226.02101,"1733,00904-5640-46 ",.01)
 ;;00904-5640-46
 ;;9002226.02101,"1733,00904-5640-46 ",.02)
 ;;00904-5640-46
 ;;9002226.02101,"1733,00904-5640-48 ",.01)
 ;;00904-5640-48
 ;;9002226.02101,"1733,00904-5640-48 ",.02)
 ;;00904-5640-48
 ;;9002226.02101,"1733,00904-5640-89 ",.01)
 ;;00904-5640-89
 ;;9002226.02101,"1733,00904-5640-89 ",.02)
 ;;00904-5640-89
 ;;9002226.02101,"1733,00904-5642-89 ",.01)
 ;;00904-5642-89
 ;;9002226.02101,"1733,00904-5642-89 ",.02)
 ;;00904-5642-89
 ;;9002226.02101,"1733,00904-5701-61 ",.01)
 ;;00904-5701-61
 ;;9002226.02101,"1733,00904-5701-61 ",.02)
 ;;00904-5701-61
 ;;9002226.02101,"1733,00904-5808-43 ",.01)
 ;;00904-5808-43
 ;;9002226.02101,"1733,00904-5808-43 ",.02)
 ;;00904-5808-43
 ;;9002226.02101,"1733,00904-5808-46 ",.01)
 ;;00904-5808-46
 ;;9002226.02101,"1733,00904-5808-46 ",.02)
 ;;00904-5808-46
 ;;9002226.02101,"1733,00904-5808-48 ",.01)
 ;;00904-5808-48
 ;;9002226.02101,"1733,00904-5808-48 ",.02)
 ;;00904-5808-48
 ;;9002226.02101,"1733,00904-5808-61 ",.01)
 ;;00904-5808-61
 ;;9002226.02101,"1733,00904-5808-61 ",.02)
 ;;00904-5808-61
 ;;9002226.02101,"1733,00904-5808-80 ",.01)
 ;;00904-5808-80
 ;;9002226.02101,"1733,00904-5808-80 ",.02)
 ;;00904-5808-80
 ;;9002226.02101,"1733,00904-5808-89 ",.01)
 ;;00904-5808-89
 ;;9002226.02101,"1733,00904-5808-89 ",.02)
 ;;00904-5808-89
 ;;9002226.02101,"1733,00904-5808-93 ",.01)
 ;;00904-5808-93
 ;;9002226.02101,"1733,00904-5808-93 ",.02)
 ;;00904-5808-93
 ;;9002226.02101,"1733,00904-5809-43 ",.01)
 ;;00904-5809-43
 ;;9002226.02101,"1733,00904-5809-43 ",.02)
 ;;00904-5809-43
 ;;9002226.02101,"1733,00904-5809-46 ",.01)
 ;;00904-5809-46
 ;;9002226.02101,"1733,00904-5809-46 ",.02)
 ;;00904-5809-46
 ;;9002226.02101,"1733,00904-5809-48 ",.01)
 ;;00904-5809-48
 ;;9002226.02101,"1733,00904-5809-48 ",.02)
 ;;00904-5809-48
 ;;9002226.02101,"1733,00904-5809-61 ",.01)
 ;;00904-5809-61
 ;;9002226.02101,"1733,00904-5809-61 ",.02)
 ;;00904-5809-61
 ;;9002226.02101,"1733,00904-5809-80 ",.01)
 ;;00904-5809-80
 ;;9002226.02101,"1733,00904-5809-80 ",.02)
 ;;00904-5809-80
 ;;9002226.02101,"1733,00904-5809-89 ",.01)
 ;;00904-5809-89
 ;;9002226.02101,"1733,00904-5809-89 ",.02)
 ;;00904-5809-89
 ;;9002226.02101,"1733,00904-5809-93 ",.01)
 ;;00904-5809-93
 ;;9002226.02101,"1733,00904-5809-93 ",.02)
 ;;00904-5809-93
 ;;9002226.02101,"1733,00904-5810-43 ",.01)
 ;;00904-5810-43
 ;;9002226.02101,"1733,00904-5810-43 ",.02)
 ;;00904-5810-43
 ;;9002226.02101,"1733,00904-5810-46 ",.01)
 ;;00904-5810-46
 ;;9002226.02101,"1733,00904-5810-46 ",.02)
 ;;00904-5810-46
 ;;9002226.02101,"1733,00904-5810-48 ",.01)
 ;;00904-5810-48
 ;;9002226.02101,"1733,00904-5810-48 ",.02)
 ;;00904-5810-48
 ;;9002226.02101,"1733,00904-5810-52 ",.01)
 ;;00904-5810-52
 ;;9002226.02101,"1733,00904-5810-52 ",.02)
 ;;00904-5810-52
 ;;9002226.02101,"1733,00904-5810-61 ",.01)
 ;;00904-5810-61
 ;;9002226.02101,"1733,00904-5810-61 ",.02)
 ;;00904-5810-61
 ;;9002226.02101,"1733,00904-5810-80 ",.01)
 ;;00904-5810-80
 ;;9002226.02101,"1733,00904-5810-80 ",.02)
 ;;00904-5810-80
 ;;9002226.02101,"1733,00904-5810-89 ",.01)
 ;;00904-5810-89
 ;;9002226.02101,"1733,00904-5810-89 ",.02)
 ;;00904-5810-89
 ;;9002226.02101,"1733,00904-5810-93 ",.01)
 ;;00904-5810-93
 ;;9002226.02101,"1733,00904-5810-93 ",.02)
 ;;00904-5810-93
 ;;9002226.02101,"1733,00904-5811-43 ",.01)
 ;;00904-5811-43
 ;;9002226.02101,"1733,00904-5811-43 ",.02)
 ;;00904-5811-43
 ;;9002226.02101,"1733,00904-5811-46 ",.01)
 ;;00904-5811-46
 ;;9002226.02101,"1733,00904-5811-46 ",.02)
 ;;00904-5811-46
 ;;9002226.02101,"1733,00904-5811-61 ",.01)
 ;;00904-5811-61
 ;;9002226.02101,"1733,00904-5811-61 ",.02)
 ;;00904-5811-61
 ;;9002226.02101,"1733,00904-5811-80 ",.01)
 ;;00904-5811-80
 ;;9002226.02101,"1733,00904-5811-80 ",.02)
 ;;00904-5811-80
 ;;9002226.02101,"1733,00904-5811-89 ",.01)
 ;;00904-5811-89
 ;;9002226.02101,"1733,00904-5811-89 ",.02)
 ;;00904-5811-89
 ;;9002226.02101,"1733,00904-5812-40 ",.01)
 ;;00904-5812-40
 ;;9002226.02101,"1733,00904-5812-40 ",.02)
 ;;00904-5812-40
 ;;9002226.02101,"1733,00904-6189-40 ",.01)
 ;;00904-6189-40
 ;;9002226.02101,"1733,00904-6189-40 ",.02)
 ;;00904-6189-40
 ;;9002226.02101,"1733,00904-6190-40 ",.01)
 ;;00904-6190-40
 ;;9002226.02101,"1733,00904-6190-40 ",.02)
 ;;00904-6190-40
 ;;9002226.02101,"1733,00904-6191-40 ",.01)
 ;;00904-6191-40
 ;;9002226.02101,"1733,00904-6191-40 ",.02)
 ;;00904-6191-40
 ;;9002226.02101,"1733,00904-6192-40 ",.01)
 ;;00904-6192-40
 ;;9002226.02101,"1733,00904-6192-40 ",.02)
 ;;00904-6192-40
 ;;9002226.02101,"1733,00904-6389-61 ",.01)
 ;;00904-6389-61
 ;;9002226.02101,"1733,00904-6389-61 ",.02)
 ;;00904-6389-61
 ;;9002226.02101,"1733,00904-6390-61 ",.01)
 ;;00904-6390-61
 ;;9002226.02101,"1733,00904-6390-61 ",.02)
 ;;00904-6390-61
 ;;9002226.02101,"1733,00904-6391-61 ",.01)
 ;;00904-6391-61
 ;;9002226.02101,"1733,00904-6391-61 ",.02)
 ;;00904-6391-61
 ;;9002226.02101,"1733,00955-1040-30 ",.01)
 ;;00955-1040-30
 ;;9002226.02101,"1733,00955-1040-30 ",.02)
 ;;00955-1040-30
 ;;9002226.02101,"1733,00955-1040-90 ",.01)
 ;;00955-1040-90
 ;;9002226.02101,"1733,00955-1040-90 ",.02)
 ;;00955-1040-90
 ;;9002226.02101,"1733,00955-1041-30 ",.01)
 ;;00955-1041-30
 ;;9002226.02101,"1733,00955-1041-30 ",.02)
 ;;00955-1041-30
 ;;9002226.02101,"1733,00955-1041-90 ",.01)
 ;;00955-1041-90
 ;;9002226.02101,"1733,00955-1041-90 ",.02)
 ;;00955-1041-90
 ;;9002226.02101,"1733,00955-1042-30 ",.01)
 ;;00955-1042-30
 ;;9002226.02101,"1733,00955-1042-30 ",.02)
 ;;00955-1042-30
 ;;9002226.02101,"1733,00955-1042-90 ",.01)
 ;;00955-1042-90
 ;;9002226.02101,"1733,00955-1042-90 ",.02)
 ;;00955-1042-90
 ;;9002226.02101,"1733,00955-1045-30 ",.01)
 ;;00955-1045-30
 ;;9002226.02101,"1733,00955-1045-30 ",.02)
 ;;00955-1045-30
 ;;9002226.02101,"1733,00955-1045-90 ",.01)
 ;;00955-1045-90
 ;;9002226.02101,"1733,00955-1045-90 ",.02)
 ;;00955-1045-90
 ;;9002226.02101,"1733,00955-1046-30 ",.01)
 ;;00955-1046-30
 ;;9002226.02101,"1733,00955-1046-30 ",.02)
 ;;00955-1046-30
 ;;9002226.02101,"1733,00955-1046-90 ",.01)
 ;;00955-1046-90
 ;;9002226.02101,"1733,00955-1046-90 ",.02)
 ;;00955-1046-90
 ;;9002226.02101,"1733,10544-0170-30 ",.01)
 ;;10544-0170-30
 ;;9002226.02101,"1733,10544-0170-30 ",.02)
 ;;10544-0170-30
 ;;9002226.02101,"1733,10544-0195-90 ",.01)
 ;;10544-0195-90
 ;;9002226.02101,"1733,10544-0195-90 ",.02)
 ;;10544-0195-90
 ;;9002226.02101,"1733,10544-0237-30 ",.01)
 ;;10544-0237-30
 ;;9002226.02101,"1733,10544-0237-30 ",.02)
 ;;10544-0237-30
 ;;9002226.02101,"1733,10544-0238-60 ",.01)
 ;;10544-0238-60
 ;;9002226.02101,"1733,10544-0238-60 ",.02)
 ;;10544-0238-60
 ;;9002226.02101,"1733,10544-0239-60 ",.01)
 ;;10544-0239-60
 ;;9002226.02101,"1733,10544-0239-60 ",.02)
 ;;10544-0239-60
 ;;9002226.02101,"1733,10544-0240-30 ",.01)
 ;;10544-0240-30
 ;;9002226.02101,"1733,10544-0240-30 ",.02)
 ;;10544-0240-30
 ;;9002226.02101,"1733,10544-0293-30 ",.01)
 ;;10544-0293-30
 ;;9002226.02101,"1733,10544-0293-30 ",.02)
 ;;10544-0293-30
 ;;9002226.02101,"1733,10544-0293-90 ",.01)
 ;;10544-0293-90
 ;;9002226.02101,"1733,10544-0293-90 ",.02)
 ;;10544-0293-90
 ;;9002226.02101,"1733,10544-0554-30 ",.01)
 ;;10544-0554-30
 ;;9002226.02101,"1733,10544-0554-30 ",.02)
 ;;10544-0554-30
 ;;9002226.02101,"1733,10544-0554-90 ",.01)
 ;;10544-0554-90
 ;;9002226.02101,"1733,10544-0554-90 ",.02)
 ;;10544-0554-90
 ;;9002226.02101,"1733,10544-0564-30 ",.01)
 ;;10544-0564-30
 ;;9002226.02101,"1733,10544-0564-30 ",.02)
 ;;10544-0564-30
 ;;9002226.02101,"1733,10544-0566-30 ",.01)
 ;;10544-0566-30
 ;;9002226.02101,"1733,10544-0566-30 ",.02)
 ;;10544-0566-30
 ;;9002226.02101,"1733,10544-0566-90 ",.01)
 ;;10544-0566-90
 ;;9002226.02101,"1733,10544-0566-90 ",.02)
 ;;10544-0566-90
 ;;9002226.02101,"1733,10544-0585-30 ",.01)
 ;;10544-0585-30
 ;;9002226.02101,"1733,10544-0585-30 ",.02)
 ;;10544-0585-30
 ;;9002226.02101,"1733,10544-0588-30 ",.01)
 ;;10544-0588-30
 ;;9002226.02101,"1733,10544-0588-30 ",.02)
 ;;10544-0588-30
 ;;9002226.02101,"1733,10544-0623-30 ",.01)
 ;;10544-0623-30
 ;;9002226.02101,"1733,10544-0623-30 ",.02)
 ;;10544-0623-30
 ;;9002226.02101,"1733,10544-0632-30 ",.01)
 ;;10544-0632-30
 ;;9002226.02101,"1733,10544-0632-30 ",.02)
 ;;10544-0632-30
 ;;9002226.02101,"1733,10544-0633-30 ",.01)
 ;;10544-0633-30
 ;;9002226.02101,"1733,10544-0633-30 ",.02)
 ;;10544-0633-30
 ;;9002226.02101,"1733,13668-0067-30 ",.01)
 ;;13668-0067-30
 ;;9002226.02101,"1733,13668-0067-30 ",.02)
 ;;13668-0067-30
 ;;9002226.02101,"1733,13668-0068-90 ",.01)
 ;;13668-0068-90
 ;;9002226.02101,"1733,13668-0068-90 ",.02)
 ;;13668-0068-90
 ;;9002226.02101,"1733,13668-0069-90 ",.01)
 ;;13668-0069-90
 ;;9002226.02101,"1733,13668-0069-90 ",.02)
 ;;13668-0069-90
 ;;9002226.02101,"1733,13668-0070-90 ",.01)
 ;;13668-0070-90
 ;;9002226.02101,"1733,13668-0070-90 ",.02)
 ;;13668-0070-90
 ;;9002226.02101,"1733,13668-0113-10 ",.01)
 ;;13668-0113-10
 ;;9002226.02101,"1733,13668-0113-10 ",.02)
 ;;13668-0113-10
 ;;9002226.02101,"1733,13668-0113-90 ",.01)
 ;;13668-0113-90
 ;;9002226.02101,"1733,13668-0113-90 ",.02)
 ;;13668-0113-90
 ;;9002226.02101,"1733,13668-0114-10 ",.01)
 ;;13668-0114-10
 ;;9002226.02101,"1733,13668-0114-10 ",.02)
 ;;13668-0114-10
 ;;9002226.02101,"1733,13668-0114-30 ",.01)
 ;;13668-0114-30
 ;;9002226.02101,"1733,13668-0114-30 ",.02)
 ;;13668-0114-30
 ;;9002226.02101,"1733,13668-0114-90 ",.01)
 ;;13668-0114-90
 ;;9002226.02101,"1733,13668-0114-90 ",.02)
 ;;13668-0114-90
 ;;9002226.02101,"1733,13668-0115-10 ",.01)
 ;;13668-0115-10
 ;;9002226.02101,"1733,13668-0115-10 ",.02)
 ;;13668-0115-10
 ;;9002226.02101,"1733,13668-0115-30 ",.01)
 ;;13668-0115-30
 ;;9002226.02101,"1733,13668-0115-30 ",.02)
 ;;13668-0115-30
 ;;9002226.02101,"1733,13668-0115-90 ",.01)
 ;;13668-0115-90
 ;;9002226.02101,"1733,13668-0115-90 ",.02)
 ;;13668-0115-90
 ;;9002226.02101,"1733,13668-0116-10 ",.01)
 ;;13668-0116-10
 ;;9002226.02101,"1733,13668-0116-10 ",.02)
 ;;13668-0116-10
 ;;9002226.02101,"1733,13668-0116-30 ",.01)
 ;;13668-0116-30
 ;;9002226.02101,"1733,13668-0116-30 ",.02)
 ;;13668-0116-30
 ;;9002226.02101,"1733,13668-0116-90 ",.01)
 ;;13668-0116-90