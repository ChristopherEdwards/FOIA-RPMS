BGP53W4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 16, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"614,2345-7 ",.01)
 ;;2345-7
 ;;9002226.02101,"614,2345-7 ",.02)
 ;;2345-7
 ;;9002226.02101,"614,25663-6 ",.01)
 ;;25663-6
 ;;9002226.02101,"614,25663-6 ",.02)
 ;;25663-6
 ;;9002226.02101,"614,25665-1 ",.01)
 ;;25665-1
 ;;9002226.02101,"614,25665-1 ",.02)
 ;;25665-1
 ;;9002226.02101,"614,25666-9 ",.01)
 ;;25666-9
 ;;9002226.02101,"614,25666-9 ",.02)
 ;;25666-9
 ;;9002226.02101,"614,25668-5 ",.01)
 ;;25668-5
 ;;9002226.02101,"614,25668-5 ",.02)
 ;;25668-5
 ;;9002226.02101,"614,25669-3 ",.01)
 ;;25669-3
 ;;9002226.02101,"614,25669-3 ",.02)
 ;;25669-3
 ;;9002226.02101,"614,25671-9 ",.01)
 ;;25671-9
 ;;9002226.02101,"614,25671-9 ",.02)
 ;;25671-9
 ;;9002226.02101,"614,25672-7 ",.01)
 ;;25672-7
 ;;9002226.02101,"614,25672-7 ",.02)
 ;;25672-7
 ;;9002226.02101,"614,25673-5 ",.01)
 ;;25673-5
 ;;9002226.02101,"614,25673-5 ",.02)
 ;;25673-5
 ;;9002226.02101,"614,25674-3 ",.01)
 ;;25674-3
 ;;9002226.02101,"614,25674-3 ",.02)
 ;;25674-3
 ;;9002226.02101,"614,25676-8 ",.01)
 ;;25676-8
 ;;9002226.02101,"614,25676-8 ",.02)
 ;;25676-8
 ;;9002226.02101,"614,25677-6 ",.01)
 ;;25677-6
 ;;9002226.02101,"614,25677-6 ",.02)
 ;;25677-6
 ;;9002226.02101,"614,25679-2 ",.01)
 ;;25679-2
 ;;9002226.02101,"614,25679-2 ",.02)
 ;;25679-2
 ;;9002226.02101,"614,25680-0 ",.01)
 ;;25680-0
 ;;9002226.02101,"614,25680-0 ",.02)
 ;;25680-0
 ;;9002226.02101,"614,26538-9 ",.01)
 ;;26538-9
 ;;9002226.02101,"614,26538-9 ",.02)
 ;;26538-9
 ;;9002226.02101,"614,26539-7 ",.01)
 ;;26539-7
 ;;9002226.02101,"614,26539-7 ",.02)
 ;;26539-7
 ;;9002226.02101,"614,26540-5 ",.01)
 ;;26540-5
 ;;9002226.02101,"614,26540-5 ",.02)
 ;;26540-5
 ;;9002226.02101,"614,26541-3 ",.01)
 ;;26541-3
 ;;9002226.02101,"614,26541-3 ",.02)
 ;;26541-3
 ;;9002226.02101,"614,26543-9 ",.01)
 ;;26543-9
 ;;9002226.02101,"614,26543-9 ",.02)
 ;;26543-9
 ;;9002226.02101,"614,26544-7 ",.01)
 ;;26544-7
 ;;9002226.02101,"614,26544-7 ",.02)
 ;;26544-7
 ;;9002226.02101,"614,26548-8 ",.01)
 ;;26548-8
 ;;9002226.02101,"614,26548-8 ",.02)
 ;;26548-8
 ;;9002226.02101,"614,26549-6 ",.01)
 ;;26549-6
 ;;9002226.02101,"614,26549-6 ",.02)
 ;;26549-6
 ;;9002226.02101,"614,26552-0 ",.01)
 ;;26552-0
 ;;9002226.02101,"614,26552-0 ",.02)
 ;;26552-0
 ;;9002226.02101,"614,26554-6 ",.01)
 ;;26554-6
 ;;9002226.02101,"614,26554-6 ",.02)
 ;;26554-6
 ;;9002226.02101,"614,26555-3 ",.01)
 ;;26555-3
 ;;9002226.02101,"614,26555-3 ",.02)
 ;;26555-3
 ;;9002226.02101,"614,26695-7 ",.01)
 ;;26695-7
 ;;9002226.02101,"614,26695-7 ",.02)
 ;;26695-7
 ;;9002226.02101,"614,26777-3 ",.01)
 ;;26777-3
 ;;9002226.02101,"614,26777-3 ",.02)
 ;;26777-3
 ;;9002226.02101,"614,26778-1 ",.01)
 ;;26778-1
 ;;9002226.02101,"614,26778-1 ",.02)
 ;;26778-1
 ;;9002226.02101,"614,26779-9 ",.01)
 ;;26779-9
 ;;9002226.02101,"614,26779-9 ",.02)
 ;;26779-9
 ;;9002226.02101,"614,26780-7 ",.01)
 ;;26780-7
 ;;9002226.02101,"614,26780-7 ",.02)
 ;;26780-7
 ;;9002226.02101,"614,26781-5 ",.01)
 ;;26781-5
 ;;9002226.02101,"614,26781-5 ",.02)
 ;;26781-5
 ;;9002226.02101,"614,26782-3 ",.01)
 ;;26782-3
 ;;9002226.02101,"614,26782-3 ",.02)
 ;;26782-3
 ;;9002226.02101,"614,26783-1 ",.01)
 ;;26783-1
 ;;9002226.02101,"614,26783-1 ",.02)
 ;;26783-1
 ;;9002226.02101,"614,26817-7 ",.01)
 ;;26817-7
 ;;9002226.02101,"614,26817-7 ",.02)
 ;;26817-7
 ;;9002226.02101,"614,26853-2 ",.01)
 ;;26853-2
 ;;9002226.02101,"614,26853-2 ",.02)
 ;;26853-2
 ;;9002226.02101,"614,26854-0 ",.01)
 ;;26854-0
 ;;9002226.02101,"614,26854-0 ",.02)
 ;;26854-0
 ;;9002226.02101,"614,27353-2 ",.01)
 ;;27353-2
 ;;9002226.02101,"614,27353-2 ",.02)
 ;;27353-2
 ;;9002226.02101,"614,27432-4 ",.01)
 ;;27432-4
 ;;9002226.02101,"614,27432-4 ",.02)
 ;;27432-4
 ;;9002226.02101,"614,29329-0 ",.01)
 ;;29329-0
 ;;9002226.02101,"614,29329-0 ",.02)
 ;;29329-0
 ;;9002226.02101,"614,29330-8 ",.01)
 ;;29330-8
 ;;9002226.02101,"614,29330-8 ",.02)
 ;;29330-8
 ;;9002226.02101,"614,29331-6 ",.01)
 ;;29331-6
 ;;9002226.02101,"614,29331-6 ",.02)
 ;;29331-6
 ;;9002226.02101,"614,29332-4 ",.01)
 ;;29332-4
 ;;9002226.02101,"614,29332-4 ",.02)
 ;;29332-4
 ;;9002226.02101,"614,29412-4 ",.01)
 ;;29412-4
 ;;9002226.02101,"614,29412-4 ",.02)
 ;;29412-4
 ;;9002226.02101,"614,30251-3 ",.01)
 ;;30251-3
 ;;9002226.02101,"614,30251-3 ",.02)
 ;;30251-3
 ;;9002226.02101,"614,30252-1 ",.01)
 ;;30252-1
 ;;9002226.02101,"614,30252-1 ",.02)
 ;;30252-1
 ;;9002226.02101,"614,30253-9 ",.01)
 ;;30253-9
 ;;9002226.02101,"614,30253-9 ",.02)
 ;;30253-9
 ;;9002226.02101,"614,30263-8 ",.01)
 ;;30263-8
 ;;9002226.02101,"614,30263-8 ",.02)
 ;;30263-8
 ;;9002226.02101,"614,30264-6 ",.01)
 ;;30264-6
 ;;9002226.02101,"614,30264-6 ",.02)
 ;;30264-6
 ;;9002226.02101,"614,30265-3 ",.01)
 ;;30265-3
 ;;9002226.02101,"614,30265-3 ",.02)
 ;;30265-3
 ;;9002226.02101,"614,30266-1 ",.01)
 ;;30266-1
 ;;9002226.02101,"614,30266-1 ",.02)
 ;;30266-1
 ;;9002226.02101,"614,30267-9 ",.01)
 ;;30267-9
 ;;9002226.02101,"614,30267-9 ",.02)
 ;;30267-9
 ;;9002226.02101,"614,30344-6 ",.01)
 ;;30344-6
 ;;9002226.02101,"614,30344-6 ",.02)
 ;;30344-6
 ;;9002226.02101,"614,30345-3 ",.01)
 ;;30345-3
 ;;9002226.02101,"614,30345-3 ",.02)
 ;;30345-3
 ;;9002226.02101,"614,30346-1 ",.01)
 ;;30346-1
 ;;9002226.02101,"614,30346-1 ",.02)
 ;;30346-1
 ;;9002226.02101,"614,32016-8 ",.01)
 ;;32016-8
 ;;9002226.02101,"614,32016-8 ",.02)
 ;;32016-8
 ;;9002226.02101,"614,32319-6 ",.01)
 ;;32319-6
 ;;9002226.02101,"614,32319-6 ",.02)
 ;;32319-6
 ;;9002226.02101,"614,32320-4 ",.01)
 ;;32320-4
 ;;9002226.02101,"614,32320-4 ",.02)
 ;;32320-4
 ;;9002226.02101,"614,32321-2 ",.01)
 ;;32321-2
 ;;9002226.02101,"614,32321-2 ",.02)
 ;;32321-2
 ;;9002226.02101,"614,32322-0 ",.01)
 ;;32322-0
 ;;9002226.02101,"614,32322-0 ",.02)
 ;;32322-0
 ;;9002226.02101,"614,32359-2 ",.01)
 ;;32359-2
 ;;9002226.02101,"614,32359-2 ",.02)
 ;;32359-2
 ;;9002226.02101,"614,32820-3 ",.01)
 ;;32820-3
 ;;9002226.02101,"614,32820-3 ",.02)
 ;;32820-3
 ;;9002226.02101,"614,33024-1 ",.01)
 ;;33024-1
 ;;9002226.02101,"614,33024-1 ",.02)
 ;;33024-1
 ;;9002226.02101,"614,34056-2 ",.01)
 ;;34056-2
 ;;9002226.02101,"614,34056-2 ",.02)
 ;;34056-2
 ;;9002226.02101,"614,34057-0 ",.01)
 ;;34057-0
 ;;9002226.02101,"614,34057-0 ",.02)
 ;;34057-0
 ;;9002226.02101,"614,34058-8 ",.01)
 ;;34058-8
 ;;9002226.02101,"614,34058-8 ",.02)
 ;;34058-8
 ;;9002226.02101,"614,34059-6 ",.01)
 ;;34059-6
 ;;9002226.02101,"614,34059-6 ",.02)
 ;;34059-6
 ;;9002226.02101,"614,34060-4 ",.01)
 ;;34060-4
 ;;9002226.02101,"614,34060-4 ",.02)
 ;;34060-4
 ;;9002226.02101,"614,35184-1 ",.01)
 ;;35184-1
 ;;9002226.02101,"614,35184-1 ",.02)
 ;;35184-1
 ;;9002226.02101,"614,35211-2 ",.01)
 ;;35211-2
 ;;9002226.02101,"614,35211-2 ",.02)
 ;;35211-2
 ;;9002226.02101,"614,39480-9 ",.01)
 ;;39480-9
 ;;9002226.02101,"614,39480-9 ",.02)
 ;;39480-9
 ;;9002226.02101,"614,39481-7 ",.01)
 ;;39481-7
 ;;9002226.02101,"614,39481-7 ",.02)
 ;;39481-7
 ;;9002226.02101,"614,39561-6 ",.01)
 ;;39561-6
 ;;9002226.02101,"614,39561-6 ",.02)
 ;;39561-6
 ;;9002226.02101,"614,39562-4 ",.01)
 ;;39562-4
 ;;9002226.02101,"614,39562-4 ",.02)
 ;;39562-4
 ;;9002226.02101,"614,39563-2 ",.01)
 ;;39563-2
 ;;9002226.02101,"614,39563-2 ",.02)
 ;;39563-2
 ;;9002226.02101,"614,39997-2 ",.01)
 ;;39997-2
 ;;9002226.02101,"614,39997-2 ",.02)
 ;;39997-2
 ;;9002226.02101,"614,39998-0 ",.01)
 ;;39998-0
 ;;9002226.02101,"614,39998-0 ",.02)
 ;;39998-0
 ;;9002226.02101,"614,39999-8 ",.01)
 ;;39999-8
 ;;9002226.02101,"614,39999-8 ",.02)
 ;;39999-8
 ;;9002226.02101,"614,40000-2 ",.01)
 ;;40000-2
 ;;9002226.02101,"614,40000-2 ",.02)
 ;;40000-2
 ;;9002226.02101,"614,40001-0 ",.01)
 ;;40001-0
 ;;9002226.02101,"614,40001-0 ",.02)
 ;;40001-0
 ;;9002226.02101,"614,40002-8 ",.01)
 ;;40002-8
 ;;9002226.02101,"614,40002-8 ",.02)
 ;;40002-8
 ;;9002226.02101,"614,40003-6 ",.01)
 ;;40003-6
 ;;9002226.02101,"614,40003-6 ",.02)
 ;;40003-6
 ;;9002226.02101,"614,40004-4 ",.01)
 ;;40004-4
 ;;9002226.02101,"614,40004-4 ",.02)
 ;;40004-4
 ;;9002226.02101,"614,40005-1 ",.01)
 ;;40005-1
 ;;9002226.02101,"614,40005-1 ",.02)
 ;;40005-1
 ;;9002226.02101,"614,40006-9 ",.01)
 ;;40006-9
 ;;9002226.02101,"614,40006-9 ",.02)
 ;;40006-9
 ;;9002226.02101,"614,40007-7 ",.01)
 ;;40007-7
 ;;9002226.02101,"614,40007-7 ",.02)
 ;;40007-7
 ;;9002226.02101,"614,40008-5 ",.01)
 ;;40008-5
 ;;9002226.02101,"614,40008-5 ",.02)
 ;;40008-5
 ;;9002226.02101,"614,40009-3 ",.01)
 ;;40009-3
 ;;9002226.02101,"614,40009-3 ",.02)
 ;;40009-3
 ;;9002226.02101,"614,40010-1 ",.01)
 ;;40010-1
 ;;9002226.02101,"614,40010-1 ",.02)
 ;;40010-1
 ;;9002226.02101,"614,40011-9 ",.01)
 ;;40011-9
 ;;9002226.02101,"614,40011-9 ",.02)
 ;;40011-9
 ;;9002226.02101,"614,40012-7 ",.01)
 ;;40012-7
 ;;9002226.02101,"614,40012-7 ",.02)
 ;;40012-7
 ;;9002226.02101,"614,40013-5 ",.01)
 ;;40013-5
 ;;9002226.02101,"614,40013-5 ",.02)
 ;;40013-5
 ;;9002226.02101,"614,40014-3 ",.01)
 ;;40014-3
 ;;9002226.02101,"614,40014-3 ",.02)
 ;;40014-3
 ;;9002226.02101,"614,40015-0 ",.01)
 ;;40015-0
 ;;9002226.02101,"614,40015-0 ",.02)
 ;;40015-0
 ;;9002226.02101,"614,40016-8 ",.01)
 ;;40016-8
 ;;9002226.02101,"614,40016-8 ",.02)
 ;;40016-8
 ;;9002226.02101,"614,40017-6 ",.01)
 ;;40017-6
 ;;9002226.02101,"614,40017-6 ",.02)
 ;;40017-6
 ;;9002226.02101,"614,40018-4 ",.01)
 ;;40018-4
 ;;9002226.02101,"614,40018-4 ",.02)
 ;;40018-4
 ;;9002226.02101,"614,40019-2 ",.01)
 ;;40019-2
 ;;9002226.02101,"614,40019-2 ",.02)
 ;;40019-2
 ;;9002226.02101,"614,40020-0 ",.01)
 ;;40020-0
 ;;9002226.02101,"614,40020-0 ",.02)
 ;;40020-0
 ;;9002226.02101,"614,40021-8 ",.01)
 ;;40021-8
 ;;9002226.02101,"614,40021-8 ",.02)
 ;;40021-8
 ;;9002226.02101,"614,40022-6 ",.01)
 ;;40022-6
 ;;9002226.02101,"614,40022-6 ",.02)
 ;;40022-6
 ;;9002226.02101,"614,40023-4 ",.01)
 ;;40023-4
 ;;9002226.02101,"614,40023-4 ",.02)
 ;;40023-4
 ;;9002226.02101,"614,40024-2 ",.01)
 ;;40024-2
 ;;9002226.02101,"614,40024-2 ",.02)
 ;;40024-2
 ;;9002226.02101,"614,40025-9 ",.01)
 ;;40025-9
 ;;9002226.02101,"614,40025-9 ",.02)
 ;;40025-9
 ;;9002226.02101,"614,40026-7 ",.01)
 ;;40026-7
 ;;9002226.02101,"614,40026-7 ",.02)
 ;;40026-7
 ;;9002226.02101,"614,40027-5 ",.01)
 ;;40027-5
 ;;9002226.02101,"614,40027-5 ",.02)
 ;;40027-5
 ;;9002226.02101,"614,40028-3 ",.01)
 ;;40028-3
 ;;9002226.02101,"614,40028-3 ",.02)
 ;;40028-3
 ;;9002226.02101,"614,40029-1 ",.01)
 ;;40029-1
 ;;9002226.02101,"614,40029-1 ",.02)
 ;;40029-1
 ;;9002226.02101,"614,40030-9 ",.01)
 ;;40030-9
 ;;9002226.02101,"614,40030-9 ",.02)
 ;;40030-9
 ;;9002226.02101,"614,40031-7 ",.01)
 ;;40031-7
 ;;9002226.02101,"614,40031-7 ",.02)
 ;;40031-7
 ;;9002226.02101,"614,40032-5 ",.01)
 ;;40032-5
 ;;9002226.02101,"614,40032-5 ",.02)
 ;;40032-5
 ;;9002226.02101,"614,40033-3 ",.01)
 ;;40033-3
 ;;9002226.02101,"614,40033-3 ",.02)
 ;;40033-3
 ;;9002226.02101,"614,40034-1 ",.01)
 ;;40034-1
 ;;9002226.02101,"614,40034-1 ",.02)
 ;;40034-1
 ;;9002226.02101,"614,40035-8 ",.01)
 ;;40035-8
 ;;9002226.02101,"614,40035-8 ",.02)
 ;;40035-8
 ;;9002226.02101,"614,40036-6 ",.01)
 ;;40036-6
 ;;9002226.02101,"614,40036-6 ",.02)
 ;;40036-6
 ;;9002226.02101,"614,40037-4 ",.01)
 ;;40037-4
 ;;9002226.02101,"614,40037-4 ",.02)
 ;;40037-4
 ;;9002226.02101,"614,40038-2 ",.01)
 ;;40038-2
 ;;9002226.02101,"614,40038-2 ",.02)
 ;;40038-2
 ;;9002226.02101,"614,40039-0 ",.01)
 ;;40039-0
 ;;9002226.02101,"614,40039-0 ",.02)
 ;;40039-0
 ;;9002226.02101,"614,40040-8 ",.01)
 ;;40040-8