BGP71T23 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1218,54868-5295-00 ",.01)
 ;;54868-5295-00
 ;;9002226.02101,"1218,54868-5295-00 ",.02)
 ;;54868-5295-00
 ;;9002226.02101,"1218,54868-5295-01 ",.01)
 ;;54868-5295-01
 ;;9002226.02101,"1218,54868-5295-01 ",.02)
 ;;54868-5295-01
 ;;9002226.02101,"1218,54868-5344-00 ",.01)
 ;;54868-5344-00
 ;;9002226.02101,"1218,54868-5344-00 ",.02)
 ;;54868-5344-00
 ;;9002226.02101,"1218,54868-5344-01 ",.01)
 ;;54868-5344-01
 ;;9002226.02101,"1218,54868-5344-01 ",.02)
 ;;54868-5344-01
 ;;9002226.02101,"1218,54868-5344-02 ",.01)
 ;;54868-5344-02
 ;;9002226.02101,"1218,54868-5344-02 ",.02)
 ;;54868-5344-02
 ;;9002226.02101,"1218,54868-5395-00 ",.01)
 ;;54868-5395-00
 ;;9002226.02101,"1218,54868-5395-00 ",.02)
 ;;54868-5395-00
 ;;9002226.02101,"1218,54868-5400-00 ",.01)
 ;;54868-5400-00
 ;;9002226.02101,"1218,54868-5400-00 ",.02)
 ;;54868-5400-00
 ;;9002226.02101,"1218,54868-5400-01 ",.01)
 ;;54868-5400-01
 ;;9002226.02101,"1218,54868-5400-01 ",.02)
 ;;54868-5400-01
 ;;9002226.02101,"1218,54868-5520-00 ",.01)
 ;;54868-5520-00
 ;;9002226.02101,"1218,54868-5520-00 ",.02)
 ;;54868-5520-00
 ;;9002226.02101,"1218,54868-5524-00 ",.01)
 ;;54868-5524-00
 ;;9002226.02101,"1218,54868-5524-00 ",.02)
 ;;54868-5524-00
 ;;9002226.02101,"1218,54868-5524-01 ",.01)
 ;;54868-5524-01
 ;;9002226.02101,"1218,54868-5524-01 ",.02)
 ;;54868-5524-01
 ;;9002226.02101,"1218,54868-5564-00 ",.01)
 ;;54868-5564-00
 ;;9002226.02101,"1218,54868-5564-00 ",.02)
 ;;54868-5564-00
 ;;9002226.02101,"1218,54868-5564-01 ",.01)
 ;;54868-5564-01
 ;;9002226.02101,"1218,54868-5564-01 ",.02)
 ;;54868-5564-01
 ;;9002226.02101,"1218,54868-5729-00 ",.01)
 ;;54868-5729-00
 ;;9002226.02101,"1218,54868-5729-00 ",.02)
 ;;54868-5729-00
 ;;9002226.02101,"1218,54868-5729-01 ",.01)
 ;;54868-5729-01
 ;;9002226.02101,"1218,54868-5729-01 ",.02)
 ;;54868-5729-01
 ;;9002226.02101,"1218,54868-5729-02 ",.01)
 ;;54868-5729-02
 ;;9002226.02101,"1218,54868-5729-02 ",.02)
 ;;54868-5729-02
 ;;9002226.02101,"1218,54868-5729-03 ",.01)
 ;;54868-5729-03
 ;;9002226.02101,"1218,54868-5729-03 ",.02)
 ;;54868-5729-03
 ;;9002226.02101,"1218,54868-5729-04 ",.01)
 ;;54868-5729-04
 ;;9002226.02101,"1218,54868-5729-04 ",.02)
 ;;54868-5729-04
 ;;9002226.02101,"1218,54868-5729-05 ",.01)
 ;;54868-5729-05
 ;;9002226.02101,"1218,54868-5729-05 ",.02)
 ;;54868-5729-05
 ;;9002226.02101,"1218,54868-5729-06 ",.01)
 ;;54868-5729-06
 ;;9002226.02101,"1218,54868-5729-06 ",.02)
 ;;54868-5729-06
 ;;9002226.02101,"1218,54868-5730-00 ",.01)
 ;;54868-5730-00
 ;;9002226.02101,"1218,54868-5730-00 ",.02)
 ;;54868-5730-00
 ;;9002226.02101,"1218,54868-5730-01 ",.01)
 ;;54868-5730-01
 ;;9002226.02101,"1218,54868-5730-01 ",.02)
 ;;54868-5730-01
 ;;9002226.02101,"1218,54868-5730-02 ",.01)
 ;;54868-5730-02
 ;;9002226.02101,"1218,54868-5730-02 ",.02)
 ;;54868-5730-02
 ;;9002226.02101,"1218,54868-5730-03 ",.01)
 ;;54868-5730-03
 ;;9002226.02101,"1218,54868-5730-03 ",.02)
 ;;54868-5730-03
 ;;9002226.02101,"1218,54868-5730-04 ",.01)
 ;;54868-5730-04
 ;;9002226.02101,"1218,54868-5730-04 ",.02)
 ;;54868-5730-04
 ;;9002226.02101,"1218,54868-5730-05 ",.01)
 ;;54868-5730-05
 ;;9002226.02101,"1218,54868-5730-05 ",.02)
 ;;54868-5730-05
 ;;9002226.02101,"1218,54868-5731-00 ",.01)
 ;;54868-5731-00
 ;;9002226.02101,"1218,54868-5731-00 ",.02)
 ;;54868-5731-00
 ;;9002226.02101,"1218,54868-5731-01 ",.01)
 ;;54868-5731-01
 ;;9002226.02101,"1218,54868-5731-01 ",.02)
 ;;54868-5731-01
 ;;9002226.02101,"1218,54868-5731-02 ",.01)
 ;;54868-5731-02
 ;;9002226.02101,"1218,54868-5731-02 ",.02)
 ;;54868-5731-02
 ;;9002226.02101,"1218,54868-5731-03 ",.01)
 ;;54868-5731-03
 ;;9002226.02101,"1218,54868-5731-03 ",.02)
 ;;54868-5731-03
 ;;9002226.02101,"1218,54868-5731-04 ",.01)
 ;;54868-5731-04
 ;;9002226.02101,"1218,54868-5731-04 ",.02)
 ;;54868-5731-04
 ;;9002226.02101,"1218,54868-5731-05 ",.01)
 ;;54868-5731-05
 ;;9002226.02101,"1218,54868-5731-05 ",.02)
 ;;54868-5731-05
 ;;9002226.02101,"1218,54868-5732-00 ",.01)
 ;;54868-5732-00
 ;;9002226.02101,"1218,54868-5732-00 ",.02)
 ;;54868-5732-00
 ;;9002226.02101,"1218,54868-5732-01 ",.01)
 ;;54868-5732-01
 ;;9002226.02101,"1218,54868-5732-01 ",.02)
 ;;54868-5732-01
 ;;9002226.02101,"1218,54868-5732-02 ",.01)
 ;;54868-5732-02
 ;;9002226.02101,"1218,54868-5732-02 ",.02)
 ;;54868-5732-02
 ;;9002226.02101,"1218,54868-5755-00 ",.01)
 ;;54868-5755-00
 ;;9002226.02101,"1218,54868-5755-00 ",.02)
 ;;54868-5755-00
 ;;9002226.02101,"1218,54868-5755-01 ",.01)
 ;;54868-5755-01
 ;;9002226.02101,"1218,54868-5755-01 ",.02)
 ;;54868-5755-01
 ;;9002226.02101,"1218,54868-5771-00 ",.01)
 ;;54868-5771-00
 ;;9002226.02101,"1218,54868-5771-00 ",.02)
 ;;54868-5771-00
 ;;9002226.02101,"1218,54868-5771-01 ",.01)
 ;;54868-5771-01
 ;;9002226.02101,"1218,54868-5771-01 ",.02)
 ;;54868-5771-01
 ;;9002226.02101,"1218,54868-5773-00 ",.01)
 ;;54868-5773-00
 ;;9002226.02101,"1218,54868-5773-00 ",.02)
 ;;54868-5773-00
 ;;9002226.02101,"1218,54868-5773-01 ",.01)
 ;;54868-5773-01
 ;;9002226.02101,"1218,54868-5773-01 ",.02)
 ;;54868-5773-01
 ;;9002226.02101,"1218,54868-5773-02 ",.01)
 ;;54868-5773-02
 ;;9002226.02101,"1218,54868-5773-02 ",.02)
 ;;54868-5773-02
 ;;9002226.02101,"1218,54868-5773-03 ",.01)
 ;;54868-5773-03
 ;;9002226.02101,"1218,54868-5773-03 ",.02)
 ;;54868-5773-03
 ;;9002226.02101,"1218,54868-5817-00 ",.01)
 ;;54868-5817-00
 ;;9002226.02101,"1218,54868-5817-00 ",.02)
 ;;54868-5817-00
 ;;9002226.02101,"1218,54868-5817-01 ",.01)
 ;;54868-5817-01
 ;;9002226.02101,"1218,54868-5817-01 ",.02)
 ;;54868-5817-01
 ;;9002226.02101,"1218,54868-5817-02 ",.01)
 ;;54868-5817-02
 ;;9002226.02101,"1218,54868-5817-02 ",.02)
 ;;54868-5817-02
 ;;9002226.02101,"1218,54868-5817-03 ",.01)
 ;;54868-5817-03
 ;;9002226.02101,"1218,54868-5817-03 ",.02)
 ;;54868-5817-03
 ;;9002226.02101,"1218,54868-5869-00 ",.01)
 ;;54868-5869-00
 ;;9002226.02101,"1218,54868-5869-00 ",.02)
 ;;54868-5869-00
 ;;9002226.02101,"1218,54868-5869-01 ",.01)
 ;;54868-5869-01
 ;;9002226.02101,"1218,54868-5869-01 ",.02)
 ;;54868-5869-01
 ;;9002226.02101,"1218,54868-5944-00 ",.01)
 ;;54868-5944-00
 ;;9002226.02101,"1218,54868-5944-00 ",.02)
 ;;54868-5944-00
 ;;9002226.02101,"1218,54868-5944-01 ",.01)
 ;;54868-5944-01
 ;;9002226.02101,"1218,54868-5944-01 ",.02)
 ;;54868-5944-01
 ;;9002226.02101,"1218,54868-6018-00 ",.01)
 ;;54868-6018-00
 ;;9002226.02101,"1218,54868-6018-00 ",.02)
 ;;54868-6018-00
 ;;9002226.02101,"1218,54868-6018-01 ",.01)
 ;;54868-6018-01
 ;;9002226.02101,"1218,54868-6018-01 ",.02)
 ;;54868-6018-01
 ;;9002226.02101,"1218,54868-6019-00 ",.01)
 ;;54868-6019-00
 ;;9002226.02101,"1218,54868-6019-00 ",.02)
 ;;54868-6019-00
 ;;9002226.02101,"1218,54868-6019-01 ",.01)
 ;;54868-6019-01
 ;;9002226.02101,"1218,54868-6019-01 ",.02)
 ;;54868-6019-01
 ;;9002226.02101,"1218,55048-0028-30 ",.01)
 ;;55048-0028-30
 ;;9002226.02101,"1218,55048-0028-30 ",.02)
 ;;55048-0028-30
 ;;9002226.02101,"1218,55048-0029-30 ",.01)
 ;;55048-0029-30
 ;;9002226.02101,"1218,55048-0029-30 ",.02)
 ;;55048-0029-30
 ;;9002226.02101,"1218,55048-0029-90 ",.01)
 ;;55048-0029-90
 ;;9002226.02101,"1218,55048-0029-90 ",.02)
 ;;55048-0029-90
 ;;9002226.02101,"1218,55048-0030-30 ",.01)
 ;;55048-0030-30
 ;;9002226.02101,"1218,55048-0030-30 ",.02)
 ;;55048-0030-30
 ;;9002226.02101,"1218,55048-0056-30 ",.01)
 ;;55048-0056-30
 ;;9002226.02101,"1218,55048-0056-30 ",.02)
 ;;55048-0056-30
 ;;9002226.02101,"1218,55048-0056-60 ",.01)
 ;;55048-0056-60
 ;;9002226.02101,"1218,55048-0056-60 ",.02)
 ;;55048-0056-60
 ;;9002226.02101,"1218,55048-0057-30 ",.01)
 ;;55048-0057-30
 ;;9002226.02101,"1218,55048-0057-30 ",.02)
 ;;55048-0057-30
 ;;9002226.02101,"1218,55048-0057-60 ",.01)
 ;;55048-0057-60
 ;;9002226.02101,"1218,55048-0057-60 ",.02)
 ;;55048-0057-60
 ;;9002226.02101,"1218,55048-0058-30 ",.01)
 ;;55048-0058-30
 ;;9002226.02101,"1218,55048-0058-30 ",.02)
 ;;55048-0058-30
 ;;9002226.02101,"1218,55048-0058-60 ",.01)
 ;;55048-0058-60
 ;;9002226.02101,"1218,55048-0058-60 ",.02)
 ;;55048-0058-60
 ;;9002226.02101,"1218,55048-0059-30 ",.01)
 ;;55048-0059-30
 ;;9002226.02101,"1218,55048-0059-30 ",.02)
 ;;55048-0059-30
 ;;9002226.02101,"1218,55048-0059-60 ",.01)
 ;;55048-0059-60
 ;;9002226.02101,"1218,55048-0059-60 ",.02)
 ;;55048-0059-60
 ;;9002226.02101,"1218,55048-0127-30 ",.01)
 ;;55048-0127-30
 ;;9002226.02101,"1218,55048-0127-30 ",.02)
 ;;55048-0127-30
 ;;9002226.02101,"1218,55048-0128-30 ",.01)
 ;;55048-0128-30
 ;;9002226.02101,"1218,55048-0128-30 ",.02)
 ;;55048-0128-30
 ;;9002226.02101,"1218,55048-0134-60 ",.01)
 ;;55048-0134-60
 ;;9002226.02101,"1218,55048-0134-60 ",.02)
 ;;55048-0134-60
 ;;9002226.02101,"1218,55048-0135-60 ",.01)
 ;;55048-0135-60
 ;;9002226.02101,"1218,55048-0135-60 ",.02)
 ;;55048-0135-60
 ;;9002226.02101,"1218,55048-0137-60 ",.01)
 ;;55048-0137-60
 ;;9002226.02101,"1218,55048-0137-60 ",.02)
 ;;55048-0137-60
 ;;9002226.02101,"1218,55048-0138-60 ",.01)
 ;;55048-0138-60
 ;;9002226.02101,"1218,55048-0138-60 ",.02)
 ;;55048-0138-60
 ;;9002226.02101,"1218,55048-0144-60 ",.01)
 ;;55048-0144-60
 ;;9002226.02101,"1218,55048-0144-60 ",.02)
 ;;55048-0144-60
 ;;9002226.02101,"1218,55048-0519-30 ",.01)
 ;;55048-0519-30
 ;;9002226.02101,"1218,55048-0519-30 ",.02)
 ;;55048-0519-30
 ;;9002226.02101,"1218,55048-0519-60 ",.01)
 ;;55048-0519-60
 ;;9002226.02101,"1218,55048-0519-60 ",.02)
 ;;55048-0519-60
 ;;9002226.02101,"1218,55048-0520-30 ",.01)
 ;;55048-0520-30
 ;;9002226.02101,"1218,55048-0520-30 ",.02)
 ;;55048-0520-30
 ;;9002226.02101,"1218,55048-0521-30 ",.01)
 ;;55048-0521-30
 ;;9002226.02101,"1218,55048-0521-30 ",.02)
 ;;55048-0521-30
 ;;9002226.02101,"1218,55048-0522-30 ",.01)
 ;;55048-0522-30
 ;;9002226.02101,"1218,55048-0522-30 ",.02)
 ;;55048-0522-30
 ;;9002226.02101,"1218,55048-0523-30 ",.01)
 ;;55048-0523-30
 ;;9002226.02101,"1218,55048-0523-30 ",.02)
 ;;55048-0523-30
 ;;9002226.02101,"1218,55048-0524-30 ",.01)
 ;;55048-0524-30
 ;;9002226.02101,"1218,55048-0524-30 ",.02)
 ;;55048-0524-30
 ;;9002226.02101,"1218,55048-0524-60 ",.01)
 ;;55048-0524-60
 ;;9002226.02101,"1218,55048-0524-60 ",.02)
 ;;55048-0524-60
 ;;9002226.02101,"1218,55048-0524-74 ",.01)
 ;;55048-0524-74
 ;;9002226.02101,"1218,55048-0524-74 ",.02)
 ;;55048-0524-74
 ;;9002226.02101,"1218,55111-0252-01 ",.01)
 ;;55111-0252-01
 ;;9002226.02101,"1218,55111-0252-01 ",.02)
 ;;55111-0252-01
 ;;9002226.02101,"1218,55111-0252-05 ",.01)
 ;;55111-0252-05
 ;;9002226.02101,"1218,55111-0252-05 ",.02)
 ;;55111-0252-05
 ;;9002226.02101,"1218,55111-0253-01 ",.01)
 ;;55111-0253-01
 ;;9002226.02101,"1218,55111-0253-01 ",.02)
 ;;55111-0253-01
 ;;9002226.02101,"1218,55111-0253-05 ",.01)
 ;;55111-0253-05
 ;;9002226.02101,"1218,55111-0253-05 ",.02)
 ;;55111-0253-05
 ;;9002226.02101,"1218,55111-0254-01 ",.01)
 ;;55111-0254-01
 ;;9002226.02101,"1218,55111-0254-01 ",.02)
 ;;55111-0254-01
 ;;9002226.02101,"1218,55111-0254-05 ",.01)
 ;;55111-0254-05
 ;;9002226.02101,"1218,55111-0254-05 ",.02)
 ;;55111-0254-05
 ;;9002226.02101,"1218,55111-0255-01 ",.01)
 ;;55111-0255-01
 ;;9002226.02101,"1218,55111-0255-01 ",.02)
 ;;55111-0255-01
 ;;9002226.02101,"1218,55111-0255-05 ",.01)
 ;;55111-0255-05
 ;;9002226.02101,"1218,55111-0255-05 ",.02)
 ;;55111-0255-05
 ;;9002226.02101,"1218,55111-0466-01 ",.01)
 ;;55111-0466-01
 ;;9002226.02101,"1218,55111-0466-01 ",.02)
 ;;55111-0466-01
 ;;9002226.02101,"1218,55111-0466-05 ",.01)
 ;;55111-0466-05
 ;;9002226.02101,"1218,55111-0466-05 ",.02)
 ;;55111-0466-05
 ;;9002226.02101,"1218,55111-0467-01 ",.01)
 ;;55111-0467-01
 ;;9002226.02101,"1218,55111-0467-01 ",.02)
 ;;55111-0467-01
 ;;9002226.02101,"1218,55111-0467-05 ",.01)
 ;;55111-0467-05