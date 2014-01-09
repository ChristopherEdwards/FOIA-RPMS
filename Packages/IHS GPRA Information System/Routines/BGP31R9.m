BGP31R9 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 29, 2012;
 ;;13.0;IHS CLINICAL REPORTING;;NOV 20, 2012;Build 81
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"806,00781-5171-05 ",.02)
 ;;00781-5171-05
 ;;9002226.02101,"806,00781-5172-01 ",.01)
 ;;00781-5172-01
 ;;9002226.02101,"806,00781-5172-01 ",.02)
 ;;00781-5172-01
 ;;9002226.02101,"806,00781-5172-05 ",.01)
 ;;00781-5172-05
 ;;9002226.02101,"806,00781-5172-05 ",.02)
 ;;00781-5172-05
 ;;9002226.02101,"806,00904-0225-60 ",.01)
 ;;00904-0225-60
 ;;9002226.02101,"806,00904-0225-60 ",.02)
 ;;00904-0225-60
 ;;9002226.02101,"806,00904-0226-60 ",.01)
 ;;00904-0226-60
 ;;9002226.02101,"806,00904-0226-60 ",.02)
 ;;00904-0226-60
 ;;9002226.02101,"806,00904-0761-60 ",.01)
 ;;00904-0761-60
 ;;9002226.02101,"806,00904-0761-60 ",.02)
 ;;00904-0761-60
 ;;9002226.02101,"806,00904-0761-80 ",.01)
 ;;00904-0761-80
 ;;9002226.02101,"806,00904-0761-80 ",.02)
 ;;00904-0761-80
 ;;9002226.02101,"806,00904-0762-60 ",.01)
 ;;00904-0762-60
 ;;9002226.02101,"806,00904-0762-60 ",.02)
 ;;00904-0762-60
 ;;9002226.02101,"806,00904-0762-80 ",.01)
 ;;00904-0762-80
 ;;9002226.02101,"806,00904-0762-80 ",.02)
 ;;00904-0762-80
 ;;9002226.02101,"806,00904-0763-60 ",.01)
 ;;00904-0763-60
 ;;9002226.02101,"806,00904-0763-60 ",.02)
 ;;00904-0763-60
 ;;9002226.02101,"806,00904-0763-80 ",.01)
 ;;00904-0763-80
 ;;9002226.02101,"806,00904-0763-80 ",.02)
 ;;00904-0763-80
 ;;9002226.02101,"806,00904-3570-60 ",.01)
 ;;00904-3570-60
 ;;9002226.02101,"806,00904-3570-60 ",.02)
 ;;00904-3570-60
 ;;9002226.02101,"806,00904-3571-60 ",.01)
 ;;00904-3571-60
 ;;9002226.02101,"806,00904-3571-60 ",.02)
 ;;00904-3571-60
 ;;9002226.02101,"806,00904-3571-61 ",.01)
 ;;00904-3571-61
 ;;9002226.02101,"806,00904-3571-61 ",.02)
 ;;00904-3571-61
 ;;9002226.02101,"806,00904-5177-60 ",.01)
 ;;00904-5177-60
 ;;9002226.02101,"806,00904-5177-60 ",.02)
 ;;00904-5177-60
 ;;9002226.02101,"806,00904-5178-60 ",.01)
 ;;00904-5178-60
 ;;9002226.02101,"806,00904-5178-60 ",.02)
 ;;00904-5178-60
 ;;9002226.02101,"806,00904-6137-60 ",.01)
 ;;00904-6137-60
 ;;9002226.02101,"806,00904-6137-60 ",.02)
 ;;00904-6137-60
 ;;9002226.02101,"806,00904-6138-40 ",.01)
 ;;00904-6138-40
 ;;9002226.02101,"806,00904-6138-40 ",.02)
 ;;00904-6138-40
 ;;9002226.02101,"806,00904-6138-60 ",.01)
 ;;00904-6138-60
 ;;9002226.02101,"806,00904-6138-60 ",.02)
 ;;00904-6138-60
 ;;9002226.02101,"806,00904-6139-60 ",.01)
 ;;00904-6139-60
 ;;9002226.02101,"806,00904-6139-60 ",.02)
 ;;00904-6139-60
 ;;9002226.02101,"806,00904-6139-80 ",.01)
 ;;00904-6139-80
 ;;9002226.02101,"806,00904-6139-80 ",.02)
 ;;00904-6139-80
 ;;9002226.02101,"806,00904-7865-60 ",.01)
 ;;00904-7865-60
 ;;9002226.02101,"806,00904-7865-60 ",.02)
 ;;00904-7865-60
 ;;9002226.02101,"806,00904-7865-80 ",.01)
 ;;00904-7865-80
 ;;9002226.02101,"806,00904-7865-80 ",.02)
 ;;00904-7865-80
 ;;9002226.02101,"806,10135-0204-01 ",.01)
 ;;10135-0204-01
 ;;9002226.02101,"806,10135-0204-01 ",.02)
 ;;10135-0204-01
 ;;9002226.02101,"806,10135-0204-10 ",.01)
 ;;10135-0204-10
 ;;9002226.02101,"806,10135-0204-10 ",.02)
 ;;10135-0204-10
 ;;9002226.02101,"806,10135-0205-01 ",.01)
 ;;10135-0205-01
 ;;9002226.02101,"806,10135-0205-01 ",.02)
 ;;10135-0205-01
 ;;9002226.02101,"806,10135-0205-10 ",.01)
 ;;10135-0205-10
 ;;9002226.02101,"806,10135-0205-10 ",.02)
 ;;10135-0205-10
 ;;9002226.02101,"806,10135-0206-01 ",.01)
 ;;10135-0206-01
 ;;9002226.02101,"806,10135-0206-01 ",.02)
 ;;10135-0206-01
 ;;9002226.02101,"806,10135-0206-10 ",.01)
 ;;10135-0206-10
 ;;9002226.02101,"806,10135-0206-10 ",.02)
 ;;10135-0206-10
 ;;9002226.02101,"806,10135-0469-01 ",.01)
 ;;10135-0469-01
 ;;9002226.02101,"806,10135-0469-01 ",.02)
 ;;10135-0469-01
 ;;9002226.02101,"806,10135-0470-01 ",.01)
 ;;10135-0470-01
 ;;9002226.02101,"806,10135-0470-01 ",.02)
 ;;10135-0470-01
 ;;9002226.02101,"806,11528-0010-01 ",.01)
 ;;11528-0010-01
 ;;9002226.02101,"806,11528-0010-01 ",.02)
 ;;11528-0010-01
 ;;9002226.02101,"806,11528-0020-01 ",.01)
 ;;11528-0020-01
 ;;9002226.02101,"806,11528-0020-01 ",.02)
 ;;11528-0020-01
 ;;9002226.02101,"806,12280-0026-00 ",.01)
 ;;12280-0026-00
 ;;9002226.02101,"806,12280-0026-00 ",.02)
 ;;12280-0026-00
 ;;9002226.02101,"806,12280-0027-00 ",.01)
 ;;12280-0027-00
 ;;9002226.02101,"806,12280-0027-00 ",.02)
 ;;12280-0027-00
 ;;9002226.02101,"806,12280-0028-00 ",.01)
 ;;12280-0028-00
 ;;9002226.02101,"806,12280-0028-00 ",.02)
 ;;12280-0028-00
 ;;9002226.02101,"806,12280-0039-00 ",.01)
 ;;12280-0039-00
 ;;9002226.02101,"806,12280-0039-00 ",.02)
 ;;12280-0039-00
 ;;9002226.02101,"806,12280-0110-00 ",.01)
 ;;12280-0110-00
 ;;9002226.02101,"806,12280-0110-00 ",.02)
 ;;12280-0110-00
 ;;9002226.02101,"806,12280-0130-00 ",.01)
 ;;12280-0130-00
 ;;9002226.02101,"806,12280-0130-00 ",.02)
 ;;12280-0130-00
 ;;9002226.02101,"806,12280-0131-00 ",.01)
 ;;12280-0131-00
 ;;9002226.02101,"806,12280-0131-00 ",.02)
 ;;12280-0131-00
 ;;9002226.02101,"806,12280-0131-30 ",.01)
 ;;12280-0131-30
 ;;9002226.02101,"806,12280-0131-30 ",.02)
 ;;12280-0131-30
 ;;9002226.02101,"806,12280-0204-00 ",.01)
 ;;12280-0204-00
 ;;9002226.02101,"806,12280-0204-00 ",.02)
 ;;12280-0204-00
 ;;9002226.02101,"806,15310-0010-01 ",.01)
 ;;15310-0010-01
 ;;9002226.02101,"806,15310-0010-01 ",.02)
 ;;15310-0010-01
 ;;9002226.02101,"806,15310-0020-01 ",.01)
 ;;15310-0020-01
 ;;9002226.02101,"806,15310-0020-01 ",.02)
 ;;15310-0020-01
 ;;9002226.02101,"806,15456-0325-56 ",.01)
 ;;15456-0325-56
 ;;9002226.02101,"806,15456-0325-56 ",.02)
 ;;15456-0325-56
 ;;9002226.02101,"806,16590-0254-33 ",.01)
 ;;16590-0254-33
 ;;9002226.02101,"806,16590-0254-33 ",.02)
 ;;16590-0254-33
 ;;9002226.02101,"806,16590-0898-08 ",.01)
 ;;16590-0898-08
 ;;9002226.02101,"806,16590-0898-08 ",.02)
 ;;16590-0898-08
 ;;9002226.02101,"806,16590-0898-16 ",.01)
 ;;16590-0898-16
 ;;9002226.02101,"806,16590-0898-16 ",.02)
 ;;16590-0898-16
 ;;9002226.02101,"806,16590-0940-60 ",.01)
 ;;16590-0940-60
 ;;9002226.02101,"806,16590-0940-60 ",.02)
 ;;16590-0940-60
 ;;9002226.02101,"806,16590-0972-30 ",.01)
 ;;16590-0972-30
 ;;9002226.02101,"806,16590-0972-30 ",.02)
 ;;16590-0972-30
 ;;9002226.02101,"806,17139-0617-40 ",.01)
 ;;17139-0617-40
 ;;9002226.02101,"806,17139-0617-40 ",.02)
 ;;17139-0617-40
 ;;9002226.02101,"806,17236-0495-01 ",.01)
 ;;17236-0495-01
 ;;9002226.02101,"806,17236-0495-01 ",.02)
 ;;17236-0495-01
 ;;9002226.02101,"806,17856-0907-30 ",.01)
 ;;17856-0907-30
 ;;9002226.02101,"806,17856-0907-30 ",.02)
 ;;17856-0907-30
 ;;9002226.02101,"806,17856-0907-31 ",.01)
 ;;17856-0907-31
 ;;9002226.02101,"806,17856-0907-31 ",.02)
 ;;17856-0907-31
 ;;9002226.02101,"806,18860-0480-01 ",.01)
 ;;18860-0480-01
 ;;9002226.02101,"806,18860-0480-01 ",.02)
 ;;18860-0480-01
 ;;9002226.02101,"806,18860-0480-60 ",.01)
 ;;18860-0480-60
 ;;9002226.02101,"806,18860-0480-60 ",.02)
 ;;18860-0480-60
 ;;9002226.02101,"806,18860-0490-02 ",.01)
 ;;18860-0490-02
 ;;9002226.02101,"806,18860-0490-02 ",.02)
 ;;18860-0490-02
 ;;9002226.02101,"806,21695-0467-30 ",.01)
 ;;21695-0467-30
 ;;9002226.02101,"806,21695-0467-30 ",.02)
 ;;21695-0467-30
 ;;9002226.02101,"806,21695-0467-60 ",.01)
 ;;21695-0467-60
 ;;9002226.02101,"806,21695-0467-60 ",.02)
 ;;21695-0467-60
 ;;9002226.02101,"806,21695-0468-30 ",.01)
 ;;21695-0468-30
 ;;9002226.02101,"806,21695-0468-30 ",.02)
 ;;21695-0468-30
 ;;9002226.02101,"806,21695-0468-60 ",.01)
 ;;21695-0468-60
 ;;9002226.02101,"806,21695-0468-60 ",.02)
 ;;21695-0468-60
 ;;9002226.02101,"806,21695-0468-72 ",.01)
 ;;21695-0468-72
 ;;9002226.02101,"806,21695-0468-72 ",.02)
 ;;21695-0468-72
 ;;9002226.02101,"806,21695-0468-78 ",.01)
 ;;21695-0468-78
 ;;9002226.02101,"806,21695-0468-78 ",.02)
 ;;21695-0468-78
 ;;9002226.02101,"806,21695-0568-30 ",.01)
 ;;21695-0568-30
 ;;9002226.02101,"806,21695-0568-30 ",.02)
 ;;21695-0568-30
 ;;9002226.02101,"806,21695-0613-00 ",.01)
 ;;21695-0613-00
 ;;9002226.02101,"806,21695-0613-00 ",.02)
 ;;21695-0613-00
 ;;9002226.02101,"806,21695-0613-30 ",.01)
 ;;21695-0613-30
 ;;9002226.02101,"806,21695-0613-30 ",.02)
 ;;21695-0613-30
 ;;9002226.02101,"806,21695-0623-00 ",.01)
 ;;21695-0623-00
 ;;9002226.02101,"806,21695-0623-00 ",.02)
 ;;21695-0623-00
 ;;9002226.02101,"806,21695-0623-15 ",.01)
 ;;21695-0623-15
 ;;9002226.02101,"806,21695-0623-15 ",.02)
 ;;21695-0623-15
 ;;9002226.02101,"806,21695-0623-30 ",.01)
 ;;21695-0623-30
 ;;9002226.02101,"806,21695-0623-30 ",.02)
 ;;21695-0623-30
 ;;9002226.02101,"806,21695-0696-45 ",.01)
 ;;21695-0696-45
 ;;9002226.02101,"806,21695-0696-45 ",.02)
 ;;21695-0696-45
 ;;9002226.02101,"806,21695-0981-30 ",.01)
 ;;21695-0981-30
 ;;9002226.02101,"806,21695-0981-30 ",.02)
 ;;21695-0981-30
 ;;9002226.02101,"806,23155-0056-01 ",.01)
 ;;23155-0056-01
 ;;9002226.02101,"806,23155-0056-01 ",.02)
 ;;23155-0056-01
 ;;9002226.02101,"806,23155-0057-01 ",.01)
 ;;23155-0057-01
 ;;9002226.02101,"806,23155-0057-01 ",.02)
 ;;23155-0057-01
 ;;9002226.02101,"806,23155-0058-01 ",.01)
 ;;23155-0058-01
 ;;9002226.02101,"806,23155-0058-01 ",.02)
 ;;23155-0058-01
 ;;9002226.02101,"806,23155-0058-10 ",.01)
 ;;23155-0058-10
 ;;9002226.02101,"806,23155-0058-10 ",.02)
 ;;23155-0058-10
 ;;9002226.02101,"806,23490-0138-10 ",.01)
 ;;23490-0138-10
 ;;9002226.02101,"806,23490-0138-10 ",.02)
 ;;23490-0138-10
 ;;9002226.02101,"806,23490-0139-03 ",.01)
 ;;23490-0139-03
 ;;9002226.02101,"806,23490-0139-03 ",.02)
 ;;23490-0139-03
 ;;9002226.02101,"806,23490-5528-01 ",.01)
 ;;23490-5528-01
 ;;9002226.02101,"806,23490-5528-01 ",.02)
 ;;23490-5528-01
 ;;9002226.02101,"806,23490-5528-02 ",.01)
 ;;23490-5528-02
 ;;9002226.02101,"806,23490-5528-02 ",.02)
 ;;23490-5528-02
 ;;9002226.02101,"806,23490-5528-03 ",.01)
 ;;23490-5528-03
 ;;9002226.02101,"806,23490-5528-03 ",.02)
 ;;23490-5528-03
 ;;9002226.02101,"806,23490-5529-01 ",.01)
 ;;23490-5529-01
 ;;9002226.02101,"806,23490-5529-01 ",.02)
 ;;23490-5529-01
 ;;9002226.02101,"806,23490-5529-02 ",.01)
 ;;23490-5529-02
 ;;9002226.02101,"806,23490-5529-02 ",.02)
 ;;23490-5529-02
 ;;9002226.02101,"806,23490-5529-03 ",.01)
 ;;23490-5529-03
 ;;9002226.02101,"806,23490-5529-03 ",.02)
 ;;23490-5529-03
 ;;9002226.02101,"806,23490-5530-03 ",.01)
 ;;23490-5530-03
 ;;9002226.02101,"806,23490-5530-03 ",.02)
 ;;23490-5530-03
 ;;9002226.02101,"806,23490-5531-03 ",.01)
 ;;23490-5531-03
 ;;9002226.02101,"806,23490-5531-03 ",.02)
 ;;23490-5531-03
 ;;9002226.02101,"806,23490-5532-07 ",.01)
 ;;23490-5532-07
 ;;9002226.02101,"806,23490-5532-07 ",.02)
 ;;23490-5532-07
 ;;9002226.02101,"806,23490-5638-01 ",.01)
 ;;23490-5638-01
 ;;9002226.02101,"806,23490-5638-01 ",.02)
 ;;23490-5638-01
 ;;9002226.02101,"806,23490-5638-02 ",.01)
 ;;23490-5638-02
 ;;9002226.02101,"806,23490-5638-02 ",.02)
 ;;23490-5638-02
 ;;9002226.02101,"806,23490-5638-04 ",.01)
 ;;23490-5638-04
 ;;9002226.02101,"806,23490-5638-04 ",.02)
 ;;23490-5638-04
 ;;9002226.02101,"806,23490-5639-01 ",.01)
 ;;23490-5639-01
 ;;9002226.02101,"806,23490-5639-01 ",.02)
 ;;23490-5639-01
 ;;9002226.02101,"806,23490-5639-02 ",.01)
 ;;23490-5639-02
 ;;9002226.02101,"806,23490-5639-02 ",.02)
 ;;23490-5639-02
 ;;9002226.02101,"806,23490-6374-01 ",.01)
 ;;23490-6374-01
 ;;9002226.02101,"806,23490-6374-01 ",.02)
 ;;23490-6374-01
 ;;9002226.02101,"806,23490-6377-01 ",.01)
 ;;23490-6377-01
 ;;9002226.02101,"806,23490-6377-01 ",.02)
 ;;23490-6377-01
 ;;9002226.02101,"806,23490-6377-02 ",.01)
 ;;23490-6377-02
 ;;9002226.02101,"806,23490-6377-02 ",.02)
 ;;23490-6377-02
 ;;9002226.02101,"806,23490-6906-01 ",.01)
 ;;23490-6906-01
 ;;9002226.02101,"806,23490-6906-01 ",.02)
 ;;23490-6906-01
 ;;9002226.02101,"806,23490-7448-03 ",.01)
 ;;23490-7448-03
 ;;9002226.02101,"806,23490-7448-03 ",.02)
 ;;23490-7448-03
 ;;9002226.02101,"806,23490-7448-06 ",.01)
 ;;23490-7448-06
 ;;9002226.02101,"806,23490-7448-06 ",.02)
 ;;23490-7448-06
 ;;9002226.02101,"806,23490-7449-01 ",.01)
 ;;23490-7449-01
 ;;9002226.02101,"806,23490-7449-01 ",.02)
 ;;23490-7449-01
 ;;9002226.02101,"806,23490-7449-06 ",.01)
 ;;23490-7449-06
 ;;9002226.02101,"806,23490-7449-06 ",.02)
 ;;23490-7449-06
 ;;9002226.02101,"806,23490-7449-09 ",.01)
 ;;23490-7449-09
 ;;9002226.02101,"806,23490-7449-09 ",.02)
 ;;23490-7449-09
 ;;9002226.02101,"806,23490-7794-01 ",.01)
 ;;23490-7794-01
 ;;9002226.02101,"806,23490-7794-01 ",.02)
 ;;23490-7794-01
 ;;9002226.02101,"806,23629-0018-10 ",.01)
 ;;23629-0018-10
 ;;9002226.02101,"806,23629-0018-10 ",.02)
 ;;23629-0018-10
 ;;9002226.02101,"806,23629-0023-10 ",.01)
 ;;23629-0023-10
 ;;9002226.02101,"806,23629-0023-10 ",.02)
 ;;23629-0023-10
 ;;9002226.02101,"806,29336-0325-56 ",.01)
 ;;29336-0325-56
 ;;9002226.02101,"806,29336-0325-56 ",.02)
 ;;29336-0325-56
 ;;9002226.02101,"806,33261-0209-30 ",.01)
 ;;33261-0209-30
 ;;9002226.02101,"806,33261-0209-30 ",.02)
 ;;33261-0209-30
 ;;9002226.02101,"806,33261-0209-60 ",.01)
 ;;33261-0209-60
 ;;9002226.02101,"806,33261-0209-60 ",.02)
 ;;33261-0209-60
 ;;9002226.02101,"806,33261-0209-90 ",.01)
 ;;33261-0209-90
 ;;9002226.02101,"806,33261-0209-90 ",.02)
 ;;33261-0209-90
 ;;9002226.02101,"806,33261-0751-30 ",.01)
 ;;33261-0751-30
 ;;9002226.02101,"806,33261-0751-30 ",.02)
 ;;33261-0751-30
 ;;9002226.02101,"806,33261-0751-60 ",.01)
 ;;33261-0751-60
 ;;9002226.02101,"806,33261-0751-60 ",.02)
 ;;33261-0751-60
 ;;9002226.02101,"806,33261-0751-90 ",.01)
 ;;33261-0751-90
 ;;9002226.02101,"806,33261-0751-90 ",.02)
 ;;33261-0751-90
 ;;9002226.02101,"806,33261-0763-01 ",.01)
 ;;33261-0763-01
 ;;9002226.02101,"806,33261-0763-01 ",.02)
 ;;33261-0763-01
 ;;9002226.02101,"806,33261-0821-30 ",.01)
 ;;33261-0821-30