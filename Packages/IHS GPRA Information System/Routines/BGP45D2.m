BGP45D2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON SEP 11, 2013;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"314,35452-2 ",.01)
 ;;35452-2
 ;;9002226.02101,"314,35452-2 ",.02)
 ;;35452-2
 ;;9002226.02101,"314,35564-4 ",.01)
 ;;35564-4
 ;;9002226.02101,"314,35564-4 ",.02)
 ;;35564-4
 ;;9002226.02101,"314,35565-1 ",.01)
 ;;35565-1
 ;;9002226.02101,"314,35565-1 ",.02)
 ;;35565-1
 ;;9002226.02101,"314,38998-1 ",.01)
 ;;38998-1
 ;;9002226.02101,"314,38998-1 ",.02)
 ;;38998-1
 ;;9002226.02101,"314,40437-6 ",.01)
 ;;40437-6
 ;;9002226.02101,"314,40437-6 ",.02)
 ;;40437-6
 ;;9002226.02101,"314,40438-4 ",.01)
 ;;40438-4
 ;;9002226.02101,"314,40438-4 ",.02)
 ;;40438-4
 ;;9002226.02101,"314,40439-2 ",.01)
 ;;40439-2
 ;;9002226.02101,"314,40439-2 ",.02)
 ;;40439-2
 ;;9002226.02101,"314,40732-0 ",.01)
 ;;40732-0
 ;;9002226.02101,"314,40732-0 ",.02)
 ;;40732-0
 ;;9002226.02101,"314,40733-8 ",.01)
 ;;40733-8
 ;;9002226.02101,"314,40733-8 ",.02)
 ;;40733-8
 ;;9002226.02101,"314,41143-9 ",.01)
 ;;41143-9
 ;;9002226.02101,"314,41143-9 ",.02)
 ;;41143-9
 ;;9002226.02101,"314,41144-7 ",.01)
 ;;41144-7
 ;;9002226.02101,"314,41144-7 ",.02)
 ;;41144-7
 ;;9002226.02101,"314,41145-4 ",.01)
 ;;41145-4
 ;;9002226.02101,"314,41145-4 ",.02)
 ;;41145-4
 ;;9002226.02101,"314,41290-8 ",.01)
 ;;41290-8
 ;;9002226.02101,"314,41290-8 ",.02)
 ;;41290-8
 ;;9002226.02101,"314,42339-2 ",.01)
 ;;42339-2
 ;;9002226.02101,"314,42339-2 ",.02)
 ;;42339-2
 ;;9002226.02101,"314,42600-7 ",.01)
 ;;42600-7
 ;;9002226.02101,"314,42600-7 ",.02)
 ;;42600-7
 ;;9002226.02101,"314,42627-0 ",.01)
 ;;42627-0
 ;;9002226.02101,"314,42627-0 ",.02)
 ;;42627-0
 ;;9002226.02101,"314,42768-2 ",.01)
 ;;42768-2
 ;;9002226.02101,"314,42768-2 ",.02)
 ;;42768-2
 ;;9002226.02101,"314,43008-2 ",.01)
 ;;43008-2
 ;;9002226.02101,"314,43008-2 ",.02)
 ;;43008-2
 ;;9002226.02101,"314,43009-0 ",.01)
 ;;43009-0
 ;;9002226.02101,"314,43009-0 ",.02)
 ;;43009-0
 ;;9002226.02101,"314,43010-8 ",.01)
 ;;43010-8
 ;;9002226.02101,"314,43010-8 ",.02)
 ;;43010-8
 ;;9002226.02101,"314,43011-6 ",.01)
 ;;43011-6
 ;;9002226.02101,"314,43011-6 ",.02)
 ;;43011-6
 ;;9002226.02101,"314,43012-4 ",.01)
 ;;43012-4
 ;;9002226.02101,"314,43012-4 ",.02)
 ;;43012-4
 ;;9002226.02101,"314,43013-2 ",.01)
 ;;43013-2
 ;;9002226.02101,"314,43013-2 ",.02)
 ;;43013-2
 ;;9002226.02101,"314,43185-8 ",.01)
 ;;43185-8
 ;;9002226.02101,"314,43185-8 ",.02)
 ;;43185-8
 ;;9002226.02101,"314,43599-0 ",.01)
 ;;43599-0
 ;;9002226.02101,"314,43599-0 ",.02)
 ;;43599-0
 ;;9002226.02101,"314,44531-2 ",.01)
 ;;44531-2
 ;;9002226.02101,"314,44531-2 ",.02)
 ;;44531-2
 ;;9002226.02101,"314,44532-0 ",.01)
 ;;44532-0
 ;;9002226.02101,"314,44532-0 ",.02)
 ;;44532-0
 ;;9002226.02101,"314,44533-8 ",.01)
 ;;44533-8
 ;;9002226.02101,"314,44533-8 ",.02)
 ;;44533-8
 ;;9002226.02101,"314,44607-0 ",.01)
 ;;44607-0
 ;;9002226.02101,"314,44607-0 ",.02)
 ;;44607-0
 ;;9002226.02101,"314,44871-2 ",.01)
 ;;44871-2
 ;;9002226.02101,"314,44871-2 ",.02)
 ;;44871-2
 ;;9002226.02101,"314,44872-0 ",.01)
 ;;44872-0
 ;;9002226.02101,"314,44872-0 ",.02)
 ;;44872-0
 ;;9002226.02101,"314,44873-8 ",.01)
 ;;44873-8
 ;;9002226.02101,"314,44873-8 ",.02)
 ;;44873-8
 ;;9002226.02101,"314,45212-8 ",.01)
 ;;45212-8
 ;;9002226.02101,"314,45212-8 ",.02)
 ;;45212-8
 ;;9002226.02101,"314,47029-4 ",.01)
 ;;47029-4
 ;;9002226.02101,"314,47029-4 ",.02)
 ;;47029-4
 ;;9002226.02101,"314,48023-6 ",.01)
 ;;48023-6
 ;;9002226.02101,"314,48023-6 ",.02)
 ;;48023-6
 ;;9002226.02101,"314,48345-3 ",.01)
 ;;48345-3
 ;;9002226.02101,"314,48345-3 ",.02)
 ;;48345-3
 ;;9002226.02101,"314,48346-1 ",.01)
 ;;48346-1
 ;;9002226.02101,"314,48346-1 ",.02)
 ;;48346-1
 ;;9002226.02101,"314,49483-1 ",.01)
 ;;49483-1
 ;;9002226.02101,"314,49483-1 ",.02)
 ;;49483-1
 ;;9002226.02101,"314,49580-4 ",.01)
 ;;49580-4
 ;;9002226.02101,"314,49580-4 ",.02)
 ;;49580-4
 ;;9002226.02101,"314,49718-0 ",.01)
 ;;49718-0
 ;;9002226.02101,"314,49718-0 ",.02)
 ;;49718-0
 ;;9002226.02101,"314,49905-3 ",.01)
 ;;49905-3
 ;;9002226.02101,"314,49905-3 ",.02)
 ;;49905-3
 ;;9002226.02101,"314,49965-7 ",.01)
 ;;49965-7
 ;;9002226.02101,"314,49965-7 ",.02)
 ;;49965-7
 ;;9002226.02101,"314,51786-2 ",.01)
 ;;51786-2
 ;;9002226.02101,"314,51786-2 ",.02)
 ;;51786-2
 ;;9002226.02101,"314,51866-2 ",.01)
 ;;51866-2
 ;;9002226.02101,"314,51866-2 ",.02)
 ;;51866-2
 ;;9002226.02101,"314,5220-9 ",.01)
 ;;5220-9
 ;;9002226.02101,"314,5220-9 ",.02)
 ;;5220-9
 ;;9002226.02101,"314,5221-7 ",.01)
 ;;5221-7
 ;;9002226.02101,"314,5221-7 ",.02)
 ;;5221-7
 ;;9002226.02101,"314,5222-5 ",.01)
 ;;5222-5
 ;;9002226.02101,"314,5222-5 ",.02)
 ;;5222-5
 ;;9002226.02101,"314,5223-3 ",.01)
 ;;5223-3
 ;;9002226.02101,"314,5223-3 ",.02)
 ;;5223-3
 ;;9002226.02101,"314,5224-1 ",.01)
 ;;5224-1
 ;;9002226.02101,"314,5224-1 ",.02)
 ;;5224-1
 ;;9002226.02101,"314,5225-8 ",.01)
 ;;5225-8
 ;;9002226.02101,"314,5225-8 ",.02)
 ;;5225-8
 ;;9002226.02101,"314,53379-4 ",.01)
 ;;53379-4
 ;;9002226.02101,"314,53379-4 ",.02)
 ;;53379-4
 ;;9002226.02101,"314,53601-1 ",.01)
 ;;53601-1
 ;;9002226.02101,"314,53601-1 ",.02)
 ;;53601-1
 ;;9002226.02101,"314,53825-6 ",.01)
 ;;53825-6
 ;;9002226.02101,"314,53825-6 ",.02)
 ;;53825-6
 ;;9002226.02101,"314,54086-4 ",.01)
 ;;54086-4
 ;;9002226.02101,"314,54086-4 ",.02)
 ;;54086-4
 ;;9002226.02101,"314,56888-1 ",.01)
 ;;56888-1
 ;;9002226.02101,"314,56888-1 ",.02)
 ;;56888-1
 ;;9002226.02101,"314,57974-8 ",.01)
 ;;57974-8
 ;;9002226.02101,"314,57974-8 ",.02)
 ;;57974-8
 ;;9002226.02101,"314,57975-5 ",.01)
 ;;57975-5
 ;;9002226.02101,"314,57975-5 ",.02)
 ;;57975-5
 ;;9002226.02101,"314,57976-3 ",.01)
 ;;57976-3
 ;;9002226.02101,"314,57976-3 ",.02)
 ;;57976-3
 ;;9002226.02101,"314,57977-1 ",.01)
 ;;57977-1
 ;;9002226.02101,"314,57977-1 ",.02)
 ;;57977-1
 ;;9002226.02101,"314,57978-9 ",.01)
 ;;57978-9
 ;;9002226.02101,"314,57978-9 ",.02)
 ;;57978-9
 ;;9002226.02101,"314,58900-2 ",.01)
 ;;58900-2
 ;;9002226.02101,"314,58900-2 ",.02)
 ;;58900-2
 ;;9002226.02101,"314,59052-1 ",.01)
 ;;59052-1
 ;;9002226.02101,"314,59052-1 ",.02)
 ;;59052-1
 ;;9002226.02101,"314,59419-2 ",.01)
 ;;59419-2
 ;;9002226.02101,"314,59419-2 ",.02)
 ;;59419-2
 ;;9002226.02101,"314,62456-9 ",.01)
 ;;62456-9
 ;;9002226.02101,"314,62456-9 ",.02)
 ;;62456-9
 ;;9002226.02101,"314,6429-5 ",.01)
 ;;6429-5
 ;;9002226.02101,"314,6429-5 ",.02)
 ;;6429-5
 ;;9002226.02101,"314,6430-3 ",.01)
 ;;6430-3
 ;;9002226.02101,"314,6430-3 ",.02)
 ;;6430-3
 ;;9002226.02101,"314,6431-1 ",.01)
 ;;6431-1
 ;;9002226.02101,"314,6431-1 ",.02)
 ;;6431-1
 ;;9002226.02101,"314,68961-2 ",.01)
 ;;68961-2
 ;;9002226.02101,"314,68961-2 ",.02)
 ;;68961-2
 ;;9002226.02101,"314,69668-2 ",.01)
 ;;69668-2
 ;;9002226.02101,"314,69668-2 ",.02)
 ;;69668-2
 ;;9002226.02101,"314,73905-2 ",.01)
 ;;73905-2
 ;;9002226.02101,"314,73905-2 ",.02)
 ;;73905-2
 ;;9002226.02101,"314,73906-0 ",.01)
 ;;73906-0
 ;;9002226.02101,"314,73906-0 ",.02)
 ;;73906-0
 ;;9002226.02101,"314,7917-8 ",.01)
 ;;7917-8
 ;;9002226.02101,"314,7917-8 ",.02)
 ;;7917-8
 ;;9002226.02101,"314,7918-6 ",.01)
 ;;7918-6
 ;;9002226.02101,"314,7918-6 ",.02)
 ;;7918-6
 ;;9002226.02101,"314,7919-4 ",.01)
 ;;7919-4
 ;;9002226.02101,"314,7919-4 ",.02)
 ;;7919-4
 ;;9002226.02101,"314,9660-2 ",.01)
 ;;9660-2
 ;;9002226.02101,"314,9660-2 ",.02)
 ;;9660-2
 ;;9002226.02101,"314,9661-0 ",.01)
 ;;9661-0
 ;;9002226.02101,"314,9661-0 ",.02)
 ;;9661-0
 ;;9002226.02101,"314,9662-8 ",.01)
 ;;9662-8
 ;;9002226.02101,"314,9662-8 ",.02)
 ;;9662-8
 ;;9002226.02101,"314,9663-6 ",.01)
 ;;9663-6
 ;;9002226.02101,"314,9663-6 ",.02)
 ;;9663-6
 ;;9002226.02101,"314,9664-4 ",.01)
 ;;9664-4
 ;;9002226.02101,"314,9664-4 ",.02)
 ;;9664-4
 ;;9002226.02101,"314,9665-1 ",.01)
 ;;9665-1
 ;;9002226.02101,"314,9665-1 ",.02)
 ;;9665-1
 ;;9002226.02101,"314,9666-9 ",.01)
 ;;9666-9
 ;;9002226.02101,"314,9666-9 ",.02)
 ;;9666-9
 ;;9002226.02101,"314,9667-7 ",.01)
 ;;9667-7
 ;;9002226.02101,"314,9667-7 ",.02)
 ;;9667-7
 ;;9002226.02101,"314,9668-5 ",.01)
 ;;9668-5
 ;;9002226.02101,"314,9668-5 ",.02)
 ;;9668-5
 ;;9002226.02101,"314,9669-3 ",.01)
 ;;9669-3
 ;;9002226.02101,"314,9669-3 ",.02)
 ;;9669-3
 ;;9002226.02101,"314,9821-0 ",.01)
 ;;9821-0
 ;;9002226.02101,"314,9821-0 ",.02)
 ;;9821-0
 ;;9002226.02101,"314,9836-8 ",.01)
 ;;9836-8
 ;;9002226.02101,"314,9836-8 ",.02)
 ;;9836-8
 ;;9002226.02101,"314,9837-6 ",.01)
 ;;9837-6
 ;;9002226.02101,"314,9837-6 ",.02)
 ;;9837-6