BGP2TI15 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,54868-5672-00 ",.02)
 ;;54868-5672-00
 ;;9002226.02101,"1201,54868-5699-00 ",.01)
 ;;54868-5699-00
 ;;9002226.02101,"1201,54868-5699-00 ",.02)
 ;;54868-5699-00
 ;;9002226.02101,"1201,54868-5886-00 ",.01)
 ;;54868-5886-00
 ;;9002226.02101,"1201,54868-5886-00 ",.02)
 ;;54868-5886-00
 ;;9002226.02101,"1201,54868-5886-01 ",.01)
 ;;54868-5886-01
 ;;9002226.02101,"1201,54868-5886-01 ",.02)
 ;;54868-5886-01
 ;;9002226.02101,"1201,54868-5904-00 ",.01)
 ;;54868-5904-00
 ;;9002226.02101,"1201,54868-5904-00 ",.02)
 ;;54868-5904-00
 ;;9002226.02101,"1201,54868-5904-01 ",.01)
 ;;54868-5904-01
 ;;9002226.02101,"1201,54868-5904-01 ",.02)
 ;;54868-5904-01
 ;;9002226.02101,"1201,54868-5907-00 ",.01)
 ;;54868-5907-00
 ;;9002226.02101,"1201,54868-5907-00 ",.02)
 ;;54868-5907-00
 ;;9002226.02101,"1201,54868-5907-01 ",.01)
 ;;54868-5907-01
 ;;9002226.02101,"1201,54868-5907-01 ",.02)
 ;;54868-5907-01
 ;;9002226.02101,"1201,54868-6066-00 ",.01)
 ;;54868-6066-00
 ;;9002226.02101,"1201,54868-6066-00 ",.02)
 ;;54868-6066-00
 ;;9002226.02101,"1201,54868-6169-00 ",.01)
 ;;54868-6169-00
 ;;9002226.02101,"1201,54868-6169-00 ",.02)
 ;;54868-6169-00
 ;;9002226.02101,"1201,55045-3014-08 ",.01)
 ;;55045-3014-08
 ;;9002226.02101,"1201,55045-3014-08 ",.02)
 ;;55045-3014-08
 ;;9002226.02101,"1201,55045-3015-08 ",.01)
 ;;55045-3015-08
 ;;9002226.02101,"1201,55045-3015-08 ",.02)
 ;;55045-3015-08
 ;;9002226.02101,"1201,55045-3655-08 ",.01)
 ;;55045-3655-08
 ;;9002226.02101,"1201,55045-3655-08 ",.02)
 ;;55045-3655-08
 ;;9002226.02101,"1201,55048-0031-30 ",.01)
 ;;55048-0031-30
 ;;9002226.02101,"1201,55048-0031-30 ",.02)
 ;;55048-0031-30
 ;;9002226.02101,"1201,55048-0032-30 ",.01)
 ;;55048-0032-30
 ;;9002226.02101,"1201,55048-0032-30 ",.02)
 ;;55048-0032-30
 ;;9002226.02101,"1201,55048-0033-30 ",.01)
 ;;55048-0033-30
 ;;9002226.02101,"1201,55048-0033-30 ",.02)
 ;;55048-0033-30
 ;;9002226.02101,"1201,55048-0033-90 ",.01)
 ;;55048-0033-90
 ;;9002226.02101,"1201,55048-0033-90 ",.02)
 ;;55048-0033-90
 ;;9002226.02101,"1201,55048-0034-30 ",.01)
 ;;55048-0034-30
 ;;9002226.02101,"1201,55048-0034-30 ",.02)
 ;;55048-0034-30
 ;;9002226.02101,"1201,55111-0197-05 ",.01)
 ;;55111-0197-05
 ;;9002226.02101,"1201,55111-0197-05 ",.02)
 ;;55111-0197-05
 ;;9002226.02101,"1201,55111-0197-30 ",.01)
 ;;55111-0197-30
 ;;9002226.02101,"1201,55111-0197-30 ",.02)
 ;;55111-0197-30
 ;;9002226.02101,"1201,55111-0197-90 ",.01)
 ;;55111-0197-90
 ;;9002226.02101,"1201,55111-0197-90 ",.02)
 ;;55111-0197-90
 ;;9002226.02101,"1201,55111-0198-05 ",.01)
 ;;55111-0198-05
 ;;9002226.02101,"1201,55111-0198-05 ",.02)
 ;;55111-0198-05
 ;;9002226.02101,"1201,55111-0198-30 ",.01)
 ;;55111-0198-30
 ;;9002226.02101,"1201,55111-0198-30 ",.02)
 ;;55111-0198-30
 ;;9002226.02101,"1201,55111-0198-90 ",.01)
 ;;55111-0198-90
 ;;9002226.02101,"1201,55111-0198-90 ",.02)
 ;;55111-0198-90
 ;;9002226.02101,"1201,55111-0199-05 ",.01)
 ;;55111-0199-05
 ;;9002226.02101,"1201,55111-0199-05 ",.02)
 ;;55111-0199-05
 ;;9002226.02101,"1201,55111-0199-10 ",.01)
 ;;55111-0199-10
 ;;9002226.02101,"1201,55111-0199-10 ",.02)
 ;;55111-0199-10
 ;;9002226.02101,"1201,55111-0199-30 ",.01)
 ;;55111-0199-30
 ;;9002226.02101,"1201,55111-0199-30 ",.02)
 ;;55111-0199-30
 ;;9002226.02101,"1201,55111-0199-90 ",.01)
 ;;55111-0199-90
 ;;9002226.02101,"1201,55111-0199-90 ",.02)
 ;;55111-0199-90
 ;;9002226.02101,"1201,55111-0200-05 ",.01)
 ;;55111-0200-05
 ;;9002226.02101,"1201,55111-0200-05 ",.02)
 ;;55111-0200-05
 ;;9002226.02101,"1201,55111-0200-10 ",.01)
 ;;55111-0200-10
 ;;9002226.02101,"1201,55111-0200-10 ",.02)
 ;;55111-0200-10
 ;;9002226.02101,"1201,55111-0200-30 ",.01)
 ;;55111-0200-30
 ;;9002226.02101,"1201,55111-0200-30 ",.02)
 ;;55111-0200-30
 ;;9002226.02101,"1201,55111-0200-90 ",.01)
 ;;55111-0200-90
 ;;9002226.02101,"1201,55111-0200-90 ",.02)
 ;;55111-0200-90
 ;;9002226.02101,"1201,55111-0229-05 ",.01)
 ;;55111-0229-05
 ;;9002226.02101,"1201,55111-0229-05 ",.02)
 ;;55111-0229-05
 ;;9002226.02101,"1201,55111-0229-90 ",.01)
 ;;55111-0229-90
 ;;9002226.02101,"1201,55111-0229-90 ",.02)
 ;;55111-0229-90
 ;;9002226.02101,"1201,55111-0230-05 ",.01)
 ;;55111-0230-05
 ;;9002226.02101,"1201,55111-0230-05 ",.02)
 ;;55111-0230-05
 ;;9002226.02101,"1201,55111-0230-90 ",.01)
 ;;55111-0230-90
 ;;9002226.02101,"1201,55111-0230-90 ",.02)
 ;;55111-0230-90
 ;;9002226.02101,"1201,55111-0231-05 ",.01)
 ;;55111-0231-05
 ;;9002226.02101,"1201,55111-0231-05 ",.02)
 ;;55111-0231-05
 ;;9002226.02101,"1201,55111-0231-90 ",.01)
 ;;55111-0231-90
 ;;9002226.02101,"1201,55111-0231-90 ",.02)
 ;;55111-0231-90
 ;;9002226.02101,"1201,55111-0268-05 ",.01)
 ;;55111-0268-05
 ;;9002226.02101,"1201,55111-0268-05 ",.02)
 ;;55111-0268-05
 ;;9002226.02101,"1201,55111-0268-30 ",.01)
 ;;55111-0268-30
 ;;9002226.02101,"1201,55111-0268-30 ",.02)
 ;;55111-0268-30
 ;;9002226.02101,"1201,55111-0268-90 ",.01)
 ;;55111-0268-90
 ;;9002226.02101,"1201,55111-0268-90 ",.02)
 ;;55111-0268-90
 ;;9002226.02101,"1201,55111-0274-05 ",.01)
 ;;55111-0274-05
 ;;9002226.02101,"1201,55111-0274-05 ",.02)
 ;;55111-0274-05
 ;;9002226.02101,"1201,55111-0274-90 ",.01)
 ;;55111-0274-90
 ;;9002226.02101,"1201,55111-0274-90 ",.02)
 ;;55111-0274-90
 ;;9002226.02101,"1201,55111-0726-10 ",.01)
 ;;55111-0726-10
 ;;9002226.02101,"1201,55111-0726-10 ",.02)
 ;;55111-0726-10
 ;;9002226.02101,"1201,55111-0726-30 ",.01)
 ;;55111-0726-30
 ;;9002226.02101,"1201,55111-0726-30 ",.02)
 ;;55111-0726-30
 ;;9002226.02101,"1201,55111-0726-90 ",.01)
 ;;55111-0726-90
 ;;9002226.02101,"1201,55111-0726-90 ",.02)
 ;;55111-0726-90
 ;;9002226.02101,"1201,55111-0735-10 ",.01)
 ;;55111-0735-10
 ;;9002226.02101,"1201,55111-0735-10 ",.02)
 ;;55111-0735-10
 ;;9002226.02101,"1201,55111-0735-30 ",.01)
 ;;55111-0735-30
 ;;9002226.02101,"1201,55111-0735-30 ",.02)
 ;;55111-0735-30
 ;;9002226.02101,"1201,55111-0735-90 ",.01)
 ;;55111-0735-90
 ;;9002226.02101,"1201,55111-0735-90 ",.02)
 ;;55111-0735-90
 ;;9002226.02101,"1201,55111-0740-10 ",.01)
 ;;55111-0740-10
 ;;9002226.02101,"1201,55111-0740-10 ",.02)
 ;;55111-0740-10
 ;;9002226.02101,"1201,55111-0740-30 ",.01)
 ;;55111-0740-30
 ;;9002226.02101,"1201,55111-0740-30 ",.02)
 ;;55111-0740-30
 ;;9002226.02101,"1201,55111-0740-90 ",.01)
 ;;55111-0740-90
 ;;9002226.02101,"1201,55111-0740-90 ",.02)
 ;;55111-0740-90
 ;;9002226.02101,"1201,55111-0749-10 ",.01)
 ;;55111-0749-10
 ;;9002226.02101,"1201,55111-0749-10 ",.02)
 ;;55111-0749-10
 ;;9002226.02101,"1201,55111-0749-30 ",.01)
 ;;55111-0749-30
 ;;9002226.02101,"1201,55111-0749-30 ",.02)
 ;;55111-0749-30
 ;;9002226.02101,"1201,55111-0749-90 ",.01)
 ;;55111-0749-90
 ;;9002226.02101,"1201,55111-0749-90 ",.02)
 ;;55111-0749-90
 ;;9002226.02101,"1201,55111-0750-10 ",.01)
 ;;55111-0750-10
 ;;9002226.02101,"1201,55111-0750-10 ",.02)
 ;;55111-0750-10
 ;;9002226.02101,"1201,55111-0750-30 ",.01)
 ;;55111-0750-30
 ;;9002226.02101,"1201,55111-0750-30 ",.02)
 ;;55111-0750-30
 ;;9002226.02101,"1201,55111-0750-90 ",.01)
 ;;55111-0750-90
 ;;9002226.02101,"1201,55111-0750-90 ",.02)
 ;;55111-0750-90
 ;;9002226.02101,"1201,55289-0104-30 ",.01)
 ;;55289-0104-30
 ;;9002226.02101,"1201,55289-0104-30 ",.02)
 ;;55289-0104-30
 ;;9002226.02101,"1201,55289-0280-30 ",.01)
 ;;55289-0280-30
 ;;9002226.02101,"1201,55289-0280-30 ",.02)
 ;;55289-0280-30
 ;;9002226.02101,"1201,55289-0293-14 ",.01)
 ;;55289-0293-14
 ;;9002226.02101,"1201,55289-0293-14 ",.02)
 ;;55289-0293-14
 ;;9002226.02101,"1201,55289-0293-30 ",.01)
 ;;55289-0293-30
 ;;9002226.02101,"1201,55289-0293-30 ",.02)
 ;;55289-0293-30
 ;;9002226.02101,"1201,55289-0293-90 ",.01)
 ;;55289-0293-90
 ;;9002226.02101,"1201,55289-0293-90 ",.02)
 ;;55289-0293-90
 ;;9002226.02101,"1201,55289-0338-14 ",.01)
 ;;55289-0338-14
 ;;9002226.02101,"1201,55289-0338-14 ",.02)
 ;;55289-0338-14
 ;;9002226.02101,"1201,55289-0338-30 ",.01)
 ;;55289-0338-30
 ;;9002226.02101,"1201,55289-0338-30 ",.02)
 ;;55289-0338-30
 ;;9002226.02101,"1201,55289-0338-90 ",.01)
 ;;55289-0338-90
 ;;9002226.02101,"1201,55289-0338-90 ",.02)
 ;;55289-0338-90
 ;;9002226.02101,"1201,55289-0395-30 ",.01)
 ;;55289-0395-30
 ;;9002226.02101,"1201,55289-0395-30 ",.02)
 ;;55289-0395-30
 ;;9002226.02101,"1201,55289-0395-90 ",.01)
 ;;55289-0395-90
 ;;9002226.02101,"1201,55289-0395-90 ",.02)
 ;;55289-0395-90
 ;;9002226.02101,"1201,55289-0400-30 ",.01)
 ;;55289-0400-30
 ;;9002226.02101,"1201,55289-0400-30 ",.02)
 ;;55289-0400-30
 ;;9002226.02101,"1201,55289-0476-30 ",.01)
 ;;55289-0476-30
 ;;9002226.02101,"1201,55289-0476-30 ",.02)
 ;;55289-0476-30
 ;;9002226.02101,"1201,55289-0520-30 ",.01)
 ;;55289-0520-30
 ;;9002226.02101,"1201,55289-0520-30 ",.02)
 ;;55289-0520-30
 ;;9002226.02101,"1201,55289-0548-30 ",.01)
 ;;55289-0548-30
 ;;9002226.02101,"1201,55289-0548-30 ",.02)
 ;;55289-0548-30
 ;;9002226.02101,"1201,55289-0692-14 ",.01)
 ;;55289-0692-14
 ;;9002226.02101,"1201,55289-0692-14 ",.02)
 ;;55289-0692-14
 ;;9002226.02101,"1201,55289-0692-30 ",.01)
 ;;55289-0692-30
 ;;9002226.02101,"1201,55289-0692-30 ",.02)
 ;;55289-0692-30
 ;;9002226.02101,"1201,55289-0740-60 ",.01)
 ;;55289-0740-60
 ;;9002226.02101,"1201,55289-0740-60 ",.02)
 ;;55289-0740-60
 ;;9002226.02101,"1201,55289-0800-30 ",.01)
 ;;55289-0800-30
 ;;9002226.02101,"1201,55289-0800-30 ",.02)
 ;;55289-0800-30
 ;;9002226.02101,"1201,55289-0861-30 ",.01)
 ;;55289-0861-30
 ;;9002226.02101,"1201,55289-0861-30 ",.02)
 ;;55289-0861-30
 ;;9002226.02101,"1201,55289-0870-30 ",.01)
 ;;55289-0870-30
 ;;9002226.02101,"1201,55289-0870-30 ",.02)
 ;;55289-0870-30
 ;;9002226.02101,"1201,55289-0871-30 ",.01)
 ;;55289-0871-30
 ;;9002226.02101,"1201,55289-0871-30 ",.02)
 ;;55289-0871-30
 ;;9002226.02101,"1201,55289-0873-30 ",.01)
 ;;55289-0873-30
 ;;9002226.02101,"1201,55289-0873-30 ",.02)
 ;;55289-0873-30
 ;;9002226.02101,"1201,55289-0874-30 ",.01)
 ;;55289-0874-30
 ;;9002226.02101,"1201,55289-0874-30 ",.02)
 ;;55289-0874-30
 ;;9002226.02101,"1201,55289-0881-30 ",.01)
 ;;55289-0881-30
 ;;9002226.02101,"1201,55289-0881-30 ",.02)
 ;;55289-0881-30
 ;;9002226.02101,"1201,55289-0932-30 ",.01)
 ;;55289-0932-30
 ;;9002226.02101,"1201,55289-0932-30 ",.02)
 ;;55289-0932-30
 ;;9002226.02101,"1201,55289-0935-30 ",.01)
 ;;55289-0935-30
 ;;9002226.02101,"1201,55289-0935-30 ",.02)
 ;;55289-0935-30
 ;;9002226.02101,"1201,55289-0980-21 ",.01)
 ;;55289-0980-21
 ;;9002226.02101,"1201,55289-0980-21 ",.02)
 ;;55289-0980-21
 ;;9002226.02101,"1201,55887-0192-90 ",.01)
 ;;55887-0192-90
 ;;9002226.02101,"1201,55887-0192-90 ",.02)
 ;;55887-0192-90
 ;;9002226.02101,"1201,55887-0203-30 ",.01)
 ;;55887-0203-30
 ;;9002226.02101,"1201,55887-0203-30 ",.02)
 ;;55887-0203-30
 ;;9002226.02101,"1201,55887-0203-90 ",.01)
 ;;55887-0203-90
 ;;9002226.02101,"1201,55887-0203-90 ",.02)
 ;;55887-0203-90
 ;;9002226.02101,"1201,55887-0350-30 ",.01)
 ;;55887-0350-30
 ;;9002226.02101,"1201,55887-0350-30 ",.02)
 ;;55887-0350-30
 ;;9002226.02101,"1201,55887-0350-60 ",.01)
 ;;55887-0350-60
 ;;9002226.02101,"1201,55887-0350-60 ",.02)
 ;;55887-0350-60
 ;;9002226.02101,"1201,55887-0350-90 ",.01)
 ;;55887-0350-90
 ;;9002226.02101,"1201,55887-0350-90 ",.02)
 ;;55887-0350-90
 ;;9002226.02101,"1201,55887-0369-30 ",.01)
 ;;55887-0369-30
 ;;9002226.02101,"1201,55887-0369-30 ",.02)
 ;;55887-0369-30
 ;;9002226.02101,"1201,55887-0369-60 ",.01)
 ;;55887-0369-60
 ;;9002226.02101,"1201,55887-0369-60 ",.02)
 ;;55887-0369-60
 ;;9002226.02101,"1201,55887-0369-90 ",.01)
 ;;55887-0369-90
 ;;9002226.02101,"1201,55887-0369-90 ",.02)
 ;;55887-0369-90
 ;;9002226.02101,"1201,55887-0624-20 ",.01)
 ;;55887-0624-20
 ;;9002226.02101,"1201,55887-0624-20 ",.02)
 ;;55887-0624-20
 ;;9002226.02101,"1201,55887-0624-30 ",.01)
 ;;55887-0624-30
 ;;9002226.02101,"1201,55887-0624-30 ",.02)
 ;;55887-0624-30
 ;;9002226.02101,"1201,55887-0624-40 ",.01)
 ;;55887-0624-40
 ;;9002226.02101,"1201,55887-0624-40 ",.02)
 ;;55887-0624-40
 ;;9002226.02101,"1201,55887-0624-60 ",.01)
 ;;55887-0624-60
 ;;9002226.02101,"1201,55887-0624-60 ",.02)
 ;;55887-0624-60
 ;;9002226.02101,"1201,55887-0624-82 ",.01)
 ;;55887-0624-82
 ;;9002226.02101,"1201,55887-0624-82 ",.02)
 ;;55887-0624-82
 ;;9002226.02101,"1201,55887-0624-90 ",.01)
 ;;55887-0624-90
 ;;9002226.02101,"1201,55887-0624-90 ",.02)
 ;;55887-0624-90
 ;;9002226.02101,"1201,55887-0858-10 ",.01)
 ;;55887-0858-10
 ;;9002226.02101,"1201,55887-0858-10 ",.02)
 ;;55887-0858-10
 ;;9002226.02101,"1201,55887-0858-30 ",.01)
 ;;55887-0858-30
 ;;9002226.02101,"1201,55887-0858-30 ",.02)
 ;;55887-0858-30
 ;;9002226.02101,"1201,55887-0858-60 ",.01)
 ;;55887-0858-60
 ;;9002226.02101,"1201,55887-0858-60 ",.02)
 ;;55887-0858-60
 ;;9002226.02101,"1201,55887-0858-90 ",.01)
 ;;55887-0858-90
 ;;9002226.02101,"1201,55887-0858-90 ",.02)
 ;;55887-0858-90
 ;;9002226.02101,"1201,55887-0929-90 ",.01)
 ;;55887-0929-90
 ;;9002226.02101,"1201,55887-0929-90 ",.02)
 ;;55887-0929-90
 ;;9002226.02101,"1201,55887-0974-30 ",.01)
 ;;55887-0974-30
 ;;9002226.02101,"1201,55887-0974-30 ",.02)
 ;;55887-0974-30
 ;;9002226.02101,"1201,57866-3932-01 ",.01)
 ;;57866-3932-01
 ;;9002226.02101,"1201,57866-3932-01 ",.02)
 ;;57866-3932-01
 ;;9002226.02101,"1201,57866-6400-01 ",.01)
 ;;57866-6400-01
 ;;9002226.02101,"1201,57866-6400-01 ",.02)
 ;;57866-6400-01
 ;;9002226.02101,"1201,57866-6500-01 ",.01)
 ;;57866-6500-01
 ;;9002226.02101,"1201,57866-6500-01 ",.02)
 ;;57866-6500-01
 ;;9002226.02101,"1201,57866-6601-01 ",.01)
 ;;57866-6601-01
 ;;9002226.02101,"1201,57866-6601-01 ",.02)
 ;;57866-6601-01
