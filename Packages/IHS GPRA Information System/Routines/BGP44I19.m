BGP44I19 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON SEP 06, 2013;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1788,54868-5217-01 ",.02)
 ;;54868-5217-01
 ;;9002226.02101,"1788,54868-5217-02 ",.01)
 ;;54868-5217-02
 ;;9002226.02101,"1788,54868-5217-02 ",.02)
 ;;54868-5217-02
 ;;9002226.02101,"1788,54868-5217-03 ",.01)
 ;;54868-5217-03
 ;;9002226.02101,"1788,54868-5217-03 ",.02)
 ;;54868-5217-03
 ;;9002226.02101,"1788,54868-5217-04 ",.01)
 ;;54868-5217-04
 ;;9002226.02101,"1788,54868-5217-04 ",.02)
 ;;54868-5217-04
 ;;9002226.02101,"1788,54868-5217-05 ",.01)
 ;;54868-5217-05
 ;;9002226.02101,"1788,54868-5217-05 ",.02)
 ;;54868-5217-05
 ;;9002226.02101,"1788,54868-5243-00 ",.01)
 ;;54868-5243-00
 ;;9002226.02101,"1788,54868-5243-00 ",.02)
 ;;54868-5243-00
 ;;9002226.02101,"1788,54868-5243-01 ",.01)
 ;;54868-5243-01
 ;;9002226.02101,"1788,54868-5243-01 ",.02)
 ;;54868-5243-01
 ;;9002226.02101,"1788,54868-5243-02 ",.01)
 ;;54868-5243-02
 ;;9002226.02101,"1788,54868-5243-02 ",.02)
 ;;54868-5243-02
 ;;9002226.02101,"1788,54868-5243-03 ",.01)
 ;;54868-5243-03
 ;;9002226.02101,"1788,54868-5243-03 ",.02)
 ;;54868-5243-03
 ;;9002226.02101,"1788,54868-5243-04 ",.01)
 ;;54868-5243-04
 ;;9002226.02101,"1788,54868-5243-04 ",.02)
 ;;54868-5243-04
 ;;9002226.02101,"1788,54868-5249-00 ",.01)
 ;;54868-5249-00
 ;;9002226.02101,"1788,54868-5249-00 ",.02)
 ;;54868-5249-00
 ;;9002226.02101,"1788,54868-5249-01 ",.01)
 ;;54868-5249-01
 ;;9002226.02101,"1788,54868-5249-01 ",.02)
 ;;54868-5249-01
 ;;9002226.02101,"1788,54868-5262-00 ",.01)
 ;;54868-5262-00
 ;;9002226.02101,"1788,54868-5262-00 ",.02)
 ;;54868-5262-00
 ;;9002226.02101,"1788,54868-5262-01 ",.01)
 ;;54868-5262-01
 ;;9002226.02101,"1788,54868-5262-01 ",.02)
 ;;54868-5262-01
 ;;9002226.02101,"1788,54868-5364-00 ",.01)
 ;;54868-5364-00
 ;;9002226.02101,"1788,54868-5364-00 ",.02)
 ;;54868-5364-00
 ;;9002226.02101,"1788,54868-5364-01 ",.01)
 ;;54868-5364-01
 ;;9002226.02101,"1788,54868-5364-01 ",.02)
 ;;54868-5364-01
 ;;9002226.02101,"1788,54868-5364-02 ",.01)
 ;;54868-5364-02
 ;;9002226.02101,"1788,54868-5364-02 ",.02)
 ;;54868-5364-02
 ;;9002226.02101,"1788,54868-5376-00 ",.01)
 ;;54868-5376-00
 ;;9002226.02101,"1788,54868-5376-00 ",.02)
 ;;54868-5376-00
 ;;9002226.02101,"1788,54868-5380-00 ",.01)
 ;;54868-5380-00
 ;;9002226.02101,"1788,54868-5380-00 ",.02)
 ;;54868-5380-00
 ;;9002226.02101,"1788,54868-5380-01 ",.01)
 ;;54868-5380-01
 ;;9002226.02101,"1788,54868-5380-01 ",.02)
 ;;54868-5380-01
 ;;9002226.02101,"1788,54868-5381-00 ",.01)
 ;;54868-5381-00
 ;;9002226.02101,"1788,54868-5381-00 ",.02)
 ;;54868-5381-00
 ;;9002226.02101,"1788,54868-5381-01 ",.01)
 ;;54868-5381-01
 ;;9002226.02101,"1788,54868-5381-01 ",.02)
 ;;54868-5381-01
 ;;9002226.02101,"1788,54868-5381-02 ",.01)
 ;;54868-5381-02
 ;;9002226.02101,"1788,54868-5381-02 ",.02)
 ;;54868-5381-02
 ;;9002226.02101,"1788,54868-5384-00 ",.01)
 ;;54868-5384-00
 ;;9002226.02101,"1788,54868-5384-00 ",.02)
 ;;54868-5384-00
 ;;9002226.02101,"1788,54868-5384-01 ",.01)
 ;;54868-5384-01
 ;;9002226.02101,"1788,54868-5384-01 ",.02)
 ;;54868-5384-01
 ;;9002226.02101,"1788,54868-5457-00 ",.01)
 ;;54868-5457-00
 ;;9002226.02101,"1788,54868-5457-00 ",.02)
 ;;54868-5457-00
 ;;9002226.02101,"1788,54868-5457-01 ",.01)
 ;;54868-5457-01
 ;;9002226.02101,"1788,54868-5457-01 ",.02)
 ;;54868-5457-01
 ;;9002226.02101,"1788,54868-5457-02 ",.01)
 ;;54868-5457-02
 ;;9002226.02101,"1788,54868-5457-02 ",.02)
 ;;54868-5457-02
 ;;9002226.02101,"1788,54868-5467-00 ",.01)
 ;;54868-5467-00
 ;;9002226.02101,"1788,54868-5467-00 ",.02)
 ;;54868-5467-00
 ;;9002226.02101,"1788,54868-5467-01 ",.01)
 ;;54868-5467-01
 ;;9002226.02101,"1788,54868-5467-01 ",.02)
 ;;54868-5467-01
 ;;9002226.02101,"1788,54868-5467-02 ",.01)
 ;;54868-5467-02
 ;;9002226.02101,"1788,54868-5467-02 ",.02)
 ;;54868-5467-02
 ;;9002226.02101,"1788,54868-5500-00 ",.01)
 ;;54868-5500-00
 ;;9002226.02101,"1788,54868-5500-00 ",.02)
 ;;54868-5500-00
 ;;9002226.02101,"1788,54868-5500-01 ",.01)
 ;;54868-5500-01
 ;;9002226.02101,"1788,54868-5500-01 ",.02)
 ;;54868-5500-01
 ;;9002226.02101,"1788,54868-5500-02 ",.01)
 ;;54868-5500-02
 ;;9002226.02101,"1788,54868-5500-02 ",.02)
 ;;54868-5500-02
 ;;9002226.02101,"1788,54868-5505-00 ",.01)
 ;;54868-5505-00
 ;;9002226.02101,"1788,54868-5505-00 ",.02)
 ;;54868-5505-00
 ;;9002226.02101,"1788,54868-5505-01 ",.01)
 ;;54868-5505-01
 ;;9002226.02101,"1788,54868-5505-01 ",.02)
 ;;54868-5505-01
 ;;9002226.02101,"1788,54868-5505-02 ",.01)
 ;;54868-5505-02
 ;;9002226.02101,"1788,54868-5505-02 ",.02)
 ;;54868-5505-02
 ;;9002226.02101,"1788,54868-5553-00 ",.01)
 ;;54868-5553-00
 ;;9002226.02101,"1788,54868-5553-00 ",.02)
 ;;54868-5553-00
 ;;9002226.02101,"1788,54868-5553-01 ",.01)
 ;;54868-5553-01
 ;;9002226.02101,"1788,54868-5553-01 ",.02)
 ;;54868-5553-01
 ;;9002226.02101,"1788,54868-5553-02 ",.01)
 ;;54868-5553-02
 ;;9002226.02101,"1788,54868-5553-02 ",.02)
 ;;54868-5553-02
 ;;9002226.02101,"1788,54868-5558-00 ",.01)
 ;;54868-5558-00
 ;;9002226.02101,"1788,54868-5558-00 ",.02)
 ;;54868-5558-00
 ;;9002226.02101,"1788,54868-5558-01 ",.01)
 ;;54868-5558-01
 ;;9002226.02101,"1788,54868-5558-01 ",.02)
 ;;54868-5558-01
 ;;9002226.02101,"1788,54868-5712-00 ",.01)
 ;;54868-5712-00
 ;;9002226.02101,"1788,54868-5712-00 ",.02)
 ;;54868-5712-00
 ;;9002226.02101,"1788,54868-5739-00 ",.01)
 ;;54868-5739-00
 ;;9002226.02101,"1788,54868-5739-00 ",.02)
 ;;54868-5739-00
 ;;9002226.02101,"1788,54868-5840-00 ",.01)
 ;;54868-5840-00
 ;;9002226.02101,"1788,54868-5840-00 ",.02)
 ;;54868-5840-00
 ;;9002226.02101,"1788,54868-5840-01 ",.01)
 ;;54868-5840-01
 ;;9002226.02101,"1788,54868-5840-01 ",.02)
 ;;54868-5840-01
 ;;9002226.02101,"1788,54868-5973-00 ",.01)
 ;;54868-5973-00
 ;;9002226.02101,"1788,54868-5973-00 ",.02)
 ;;54868-5973-00
 ;;9002226.02101,"1788,54868-6031-00 ",.01)
 ;;54868-6031-00
 ;;9002226.02101,"1788,54868-6031-00 ",.02)
 ;;54868-6031-00
 ;;9002226.02101,"1788,54868-6031-01 ",.01)
 ;;54868-6031-01
 ;;9002226.02101,"1788,54868-6031-01 ",.02)
 ;;54868-6031-01
 ;;9002226.02101,"1788,54868-6309-00 ",.01)
 ;;54868-6309-00
 ;;9002226.02101,"1788,54868-6309-00 ",.02)
 ;;54868-6309-00
 ;;9002226.02101,"1788,55045-2138-01 ",.01)
 ;;55045-2138-01
 ;;9002226.02101,"1788,55045-2138-01 ",.02)
 ;;55045-2138-01
 ;;9002226.02101,"1788,55045-2138-08 ",.01)
 ;;55045-2138-08
 ;;9002226.02101,"1788,55045-2138-08 ",.02)
 ;;55045-2138-08
 ;;9002226.02101,"1788,55045-2265-01 ",.01)
 ;;55045-2265-01
 ;;9002226.02101,"1788,55045-2265-01 ",.02)
 ;;55045-2265-01
 ;;9002226.02101,"1788,55045-2265-08 ",.01)
 ;;55045-2265-08
 ;;9002226.02101,"1788,55045-2265-08 ",.02)
 ;;55045-2265-08
 ;;9002226.02101,"1788,55045-2266-01 ",.01)
 ;;55045-2266-01
 ;;9002226.02101,"1788,55045-2266-01 ",.02)
 ;;55045-2266-01
 ;;9002226.02101,"1788,55045-2322-01 ",.01)
 ;;55045-2322-01
 ;;9002226.02101,"1788,55045-2322-01 ",.02)
 ;;55045-2322-01
 ;;9002226.02101,"1788,55045-2504-01 ",.01)
 ;;55045-2504-01
 ;;9002226.02101,"1788,55045-2504-01 ",.02)
 ;;55045-2504-01
 ;;9002226.02101,"1788,55045-2904-00 ",.01)
 ;;55045-2904-00
 ;;9002226.02101,"1788,55045-2904-00 ",.02)
 ;;55045-2904-00
 ;;9002226.02101,"1788,55045-2904-02 ",.01)
 ;;55045-2904-02
 ;;9002226.02101,"1788,55045-2904-02 ",.02)
 ;;55045-2904-02
 ;;9002226.02101,"1788,55045-2904-06 ",.01)
 ;;55045-2904-06
 ;;9002226.02101,"1788,55045-2904-06 ",.02)
 ;;55045-2904-06
 ;;9002226.02101,"1788,55045-2905-00 ",.01)
 ;;55045-2905-00
 ;;9002226.02101,"1788,55045-2905-00 ",.02)
 ;;55045-2905-00
 ;;9002226.02101,"1788,55045-2905-08 ",.01)
 ;;55045-2905-08
 ;;9002226.02101,"1788,55045-2905-08 ",.02)
 ;;55045-2905-08
 ;;9002226.02101,"1788,55045-2906-00 ",.01)
 ;;55045-2906-00
 ;;9002226.02101,"1788,55045-2906-00 ",.02)
 ;;55045-2906-00
 ;;9002226.02101,"1788,55045-2906-01 ",.01)
 ;;55045-2906-01
 ;;9002226.02101,"1788,55045-2906-01 ",.02)
 ;;55045-2906-01
 ;;9002226.02101,"1788,55045-2906-02 ",.01)
 ;;55045-2906-02
 ;;9002226.02101,"1788,55045-2906-02 ",.02)
 ;;55045-2906-02
 ;;9002226.02101,"1788,55045-2906-06 ",.01)
 ;;55045-2906-06
 ;;9002226.02101,"1788,55045-2906-06 ",.02)
 ;;55045-2906-06
 ;;9002226.02101,"1788,55045-2906-08 ",.01)
 ;;55045-2906-08
 ;;9002226.02101,"1788,55045-2906-08 ",.02)
 ;;55045-2906-08
 ;;9002226.02101,"1788,55045-2906-09 ",.01)
 ;;55045-2906-09
 ;;9002226.02101,"1788,55045-2906-09 ",.02)
 ;;55045-2906-09
 ;;9002226.02101,"1788,55045-3045-01 ",.01)
 ;;55045-3045-01
 ;;9002226.02101,"1788,55045-3045-01 ",.02)
 ;;55045-3045-01
 ;;9002226.02101,"1788,55045-3045-06 ",.01)
 ;;55045-3045-06
 ;;9002226.02101,"1788,55045-3045-06 ",.02)
 ;;55045-3045-06
 ;;9002226.02101,"1788,55045-3045-08 ",.01)
 ;;55045-3045-08
 ;;9002226.02101,"1788,55045-3045-08 ",.02)
 ;;55045-3045-08
 ;;9002226.02101,"1788,55045-3300-01 ",.01)
 ;;55045-3300-01
 ;;9002226.02101,"1788,55045-3300-01 ",.02)
 ;;55045-3300-01
 ;;9002226.02101,"1788,55045-3434-08 ",.01)
 ;;55045-3434-08
 ;;9002226.02101,"1788,55045-3434-08 ",.02)
 ;;55045-3434-08
 ;;9002226.02101,"1788,55045-3761-08 ",.01)
 ;;55045-3761-08
 ;;9002226.02101,"1788,55045-3761-08 ",.02)
 ;;55045-3761-08
 ;;9002226.02101,"1788,55048-0241-30 ",.01)
 ;;55048-0241-30
 ;;9002226.02101,"1788,55048-0241-30 ",.02)
 ;;55048-0241-30
 ;;9002226.02101,"1788,55048-0242-30 ",.01)
 ;;55048-0242-30
 ;;9002226.02101,"1788,55048-0242-30 ",.02)
 ;;55048-0242-30
 ;;9002226.02101,"1788,55048-0243-30 ",.01)
 ;;55048-0243-30
 ;;9002226.02101,"1788,55048-0243-30 ",.02)
 ;;55048-0243-30
 ;;9002226.02101,"1788,55048-0243-60 ",.01)
 ;;55048-0243-60
 ;;9002226.02101,"1788,55048-0243-60 ",.02)
 ;;55048-0243-60
 ;;9002226.02101,"1788,55048-0244-30 ",.01)
 ;;55048-0244-30
 ;;9002226.02101,"1788,55048-0244-30 ",.02)
 ;;55048-0244-30
 ;;9002226.02101,"1788,55048-0245-30 ",.01)
 ;;55048-0245-30
 ;;9002226.02101,"1788,55048-0245-30 ",.02)
 ;;55048-0245-30
 ;;9002226.02101,"1788,55048-0245-60 ",.01)
 ;;55048-0245-60
 ;;9002226.02101,"1788,55048-0245-60 ",.02)
 ;;55048-0245-60
 ;;9002226.02101,"1788,55048-0246-30 ",.01)
 ;;55048-0246-30
 ;;9002226.02101,"1788,55048-0246-30 ",.02)
 ;;55048-0246-30
 ;;9002226.02101,"1788,55048-0247-30 ",.01)
 ;;55048-0247-30
 ;;9002226.02101,"1788,55048-0247-30 ",.02)
 ;;55048-0247-30
 ;;9002226.02101,"1788,55048-0248-30 ",.01)
 ;;55048-0248-30
 ;;9002226.02101,"1788,55048-0248-30 ",.02)
 ;;55048-0248-30
 ;;9002226.02101,"1788,55048-0248-90 ",.01)
 ;;55048-0248-90
 ;;9002226.02101,"1788,55048-0248-90 ",.02)
 ;;55048-0248-90
 ;;9002226.02101,"1788,55048-0269-30 ",.01)
 ;;55048-0269-30
 ;;9002226.02101,"1788,55048-0269-30 ",.02)
 ;;55048-0269-30
 ;;9002226.02101,"1788,55048-0270-30 ",.01)
 ;;55048-0270-30
 ;;9002226.02101,"1788,55048-0270-30 ",.02)
 ;;55048-0270-30
 ;;9002226.02101,"1788,55048-0273-60 ",.01)
 ;;55048-0273-60
 ;;9002226.02101,"1788,55048-0273-60 ",.02)
 ;;55048-0273-60
 ;;9002226.02101,"1788,55048-0273-71 ",.01)
 ;;55048-0273-71
 ;;9002226.02101,"1788,55048-0273-71 ",.02)
 ;;55048-0273-71
 ;;9002226.02101,"1788,55048-0288-60 ",.01)
 ;;55048-0288-60
 ;;9002226.02101,"1788,55048-0288-60 ",.02)
 ;;55048-0288-60
 ;;9002226.02101,"1788,55048-0289-60 ",.01)
 ;;55048-0289-60
 ;;9002226.02101,"1788,55048-0289-60 ",.02)
 ;;55048-0289-60
 ;;9002226.02101,"1788,55048-0434-60 ",.01)
 ;;55048-0434-60
 ;;9002226.02101,"1788,55048-0434-60 ",.02)
 ;;55048-0434-60
 ;;9002226.02101,"1788,55048-0437-60 ",.01)
 ;;55048-0437-60
 ;;9002226.02101,"1788,55048-0437-60 ",.02)
 ;;55048-0437-60
 ;;9002226.02101,"1788,55048-0508-30 ",.01)
 ;;55048-0508-30
 ;;9002226.02101,"1788,55048-0508-30 ",.02)
 ;;55048-0508-30
 ;;9002226.02101,"1788,55048-0508-60 ",.01)
 ;;55048-0508-60
 ;;9002226.02101,"1788,55048-0508-60 ",.02)
 ;;55048-0508-60
 ;;9002226.02101,"1788,55048-0509-30 ",.01)
 ;;55048-0509-30
 ;;9002226.02101,"1788,55048-0509-30 ",.02)
 ;;55048-0509-30
 ;;9002226.02101,"1788,55048-0509-60 ",.01)
 ;;55048-0509-60
 ;;9002226.02101,"1788,55048-0509-60 ",.02)
 ;;55048-0509-60
 ;;9002226.02101,"1788,55048-0509-71 ",.01)
 ;;55048-0509-71
 ;;9002226.02101,"1788,55048-0509-71 ",.02)
 ;;55048-0509-71
 ;;9002226.02101,"1788,55048-0509-74 ",.01)
 ;;55048-0509-74
 ;;9002226.02101,"1788,55048-0509-74 ",.02)
 ;;55048-0509-74
 ;;9002226.02101,"1788,55048-0509-90 ",.01)
 ;;55048-0509-90
 ;;9002226.02101,"1788,55048-0509-90 ",.02)
 ;;55048-0509-90
 ;;9002226.02101,"1788,55048-0510-30 ",.01)
 ;;55048-0510-30
 ;;9002226.02101,"1788,55048-0510-30 ",.02)
 ;;55048-0510-30
 ;;9002226.02101,"1788,55048-0510-60 ",.01)
 ;;55048-0510-60
 ;;9002226.02101,"1788,55048-0510-60 ",.02)
 ;;55048-0510-60
 ;;9002226.02101,"1788,55048-0510-71 ",.01)
 ;;55048-0510-71
 ;;9002226.02101,"1788,55048-0510-71 ",.02)
 ;;55048-0510-71
 ;;9002226.02101,"1788,55048-0510-74 ",.01)
 ;;55048-0510-74
 ;;9002226.02101,"1788,55048-0510-74 ",.02)
 ;;55048-0510-74
 ;;9002226.02101,"1788,55048-0510-90 ",.01)
 ;;55048-0510-90
 ;;9002226.02101,"1788,55048-0510-90 ",.02)
 ;;55048-0510-90
 ;;9002226.02101,"1788,55048-0583-30 ",.01)
 ;;55048-0583-30
 ;;9002226.02101,"1788,55048-0583-30 ",.02)
 ;;55048-0583-30
 ;;9002226.02101,"1788,55048-0584-30 ",.01)
 ;;55048-0584-30
 ;;9002226.02101,"1788,55048-0584-30 ",.02)
 ;;55048-0584-30
 ;;9002226.02101,"1788,55048-0585-30 ",.01)
 ;;55048-0585-30
 ;;9002226.02101,"1788,55048-0585-30 ",.02)
 ;;55048-0585-30
 ;;9002226.02101,"1788,55048-0611-60 ",.01)
 ;;55048-0611-60
 ;;9002226.02101,"1788,55048-0611-60 ",.02)
 ;;55048-0611-60
 ;;9002226.02101,"1788,55048-0611-74 ",.01)
 ;;55048-0611-74
 ;;9002226.02101,"1788,55048-0611-74 ",.02)
 ;;55048-0611-74