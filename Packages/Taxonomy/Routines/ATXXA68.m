ATXXA68 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"873,S52.189C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.201A ",.01)
 ;;S52.201A
 ;;9002226.02101,"873,S52.201A ",.02)
 ;;S52.201A
 ;;9002226.02101,"873,S52.201A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.201B ",.01)
 ;;S52.201B
 ;;9002226.02101,"873,S52.201B ",.02)
 ;;S52.201B
 ;;9002226.02101,"873,S52.201B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.201C ",.01)
 ;;S52.201C
 ;;9002226.02101,"873,S52.201C ",.02)
 ;;S52.201C
 ;;9002226.02101,"873,S52.201C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.202A ",.01)
 ;;S52.202A
 ;;9002226.02101,"873,S52.202A ",.02)
 ;;S52.202A
 ;;9002226.02101,"873,S52.202A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.202B ",.01)
 ;;S52.202B
 ;;9002226.02101,"873,S52.202B ",.02)
 ;;S52.202B
 ;;9002226.02101,"873,S52.202B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.202C ",.01)
 ;;S52.202C
 ;;9002226.02101,"873,S52.202C ",.02)
 ;;S52.202C
 ;;9002226.02101,"873,S52.202C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.209A ",.01)
 ;;S52.209A
 ;;9002226.02101,"873,S52.209A ",.02)
 ;;S52.209A
 ;;9002226.02101,"873,S52.209A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.209B ",.01)
 ;;S52.209B
 ;;9002226.02101,"873,S52.209B ",.02)
 ;;S52.209B
 ;;9002226.02101,"873,S52.209B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.209C ",.01)
 ;;S52.209C
 ;;9002226.02101,"873,S52.209C ",.02)
 ;;S52.209C
 ;;9002226.02101,"873,S52.209C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.211A ",.01)
 ;;S52.211A
 ;;9002226.02101,"873,S52.211A ",.02)
 ;;S52.211A
 ;;9002226.02101,"873,S52.211A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.212A ",.01)
 ;;S52.212A
 ;;9002226.02101,"873,S52.212A ",.02)
 ;;S52.212A
 ;;9002226.02101,"873,S52.212A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.219A ",.01)
 ;;S52.219A
 ;;9002226.02101,"873,S52.219A ",.02)
 ;;S52.219A
 ;;9002226.02101,"873,S52.219A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.221A ",.01)
 ;;S52.221A
 ;;9002226.02101,"873,S52.221A ",.02)
 ;;S52.221A
 ;;9002226.02101,"873,S52.221A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.221B ",.01)
 ;;S52.221B
 ;;9002226.02101,"873,S52.221B ",.02)
 ;;S52.221B
 ;;9002226.02101,"873,S52.221B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.221C ",.01)
 ;;S52.221C
 ;;9002226.02101,"873,S52.221C ",.02)
 ;;S52.221C
 ;;9002226.02101,"873,S52.221C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.222A ",.01)
 ;;S52.222A
 ;;9002226.02101,"873,S52.222A ",.02)
 ;;S52.222A
 ;;9002226.02101,"873,S52.222A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.222B ",.01)
 ;;S52.222B
 ;;9002226.02101,"873,S52.222B ",.02)
 ;;S52.222B
 ;;9002226.02101,"873,S52.222B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.222C ",.01)
 ;;S52.222C
 ;;9002226.02101,"873,S52.222C ",.02)
 ;;S52.222C
 ;;9002226.02101,"873,S52.222C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.223A ",.01)
 ;;S52.223A
 ;;9002226.02101,"873,S52.223A ",.02)
 ;;S52.223A
 ;;9002226.02101,"873,S52.223A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.223B ",.01)
 ;;S52.223B
 ;;9002226.02101,"873,S52.223B ",.02)
 ;;S52.223B
 ;;9002226.02101,"873,S52.223B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.223C ",.01)
 ;;S52.223C
 ;;9002226.02101,"873,S52.223C ",.02)
 ;;S52.223C
 ;;9002226.02101,"873,S52.223C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.224A ",.01)
 ;;S52.224A
 ;;9002226.02101,"873,S52.224A ",.02)
 ;;S52.224A
 ;;9002226.02101,"873,S52.224A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.224B ",.01)
 ;;S52.224B
 ;;9002226.02101,"873,S52.224B ",.02)
 ;;S52.224B
 ;;9002226.02101,"873,S52.224B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.224C ",.01)
 ;;S52.224C
 ;;9002226.02101,"873,S52.224C ",.02)
 ;;S52.224C
 ;;9002226.02101,"873,S52.224C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.225A ",.01)
 ;;S52.225A
 ;;9002226.02101,"873,S52.225A ",.02)
 ;;S52.225A
 ;;9002226.02101,"873,S52.225A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.225B ",.01)
 ;;S52.225B
 ;;9002226.02101,"873,S52.225B ",.02)
 ;;S52.225B
 ;;9002226.02101,"873,S52.225B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.225C ",.01)
 ;;S52.225C
 ;;9002226.02101,"873,S52.225C ",.02)
 ;;S52.225C
 ;;9002226.02101,"873,S52.225C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.226A ",.01)
 ;;S52.226A
 ;;9002226.02101,"873,S52.226A ",.02)
 ;;S52.226A
 ;;9002226.02101,"873,S52.226A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.226B ",.01)
 ;;S52.226B
 ;;9002226.02101,"873,S52.226B ",.02)
 ;;S52.226B
 ;;9002226.02101,"873,S52.226B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.226C ",.01)
 ;;S52.226C
 ;;9002226.02101,"873,S52.226C ",.02)
 ;;S52.226C
 ;;9002226.02101,"873,S52.226C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.231A ",.01)
 ;;S52.231A
 ;;9002226.02101,"873,S52.231A ",.02)
 ;;S52.231A
 ;;9002226.02101,"873,S52.231A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.231B ",.01)
 ;;S52.231B
 ;;9002226.02101,"873,S52.231B ",.02)
 ;;S52.231B
 ;;9002226.02101,"873,S52.231B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.231C ",.01)
 ;;S52.231C
 ;;9002226.02101,"873,S52.231C ",.02)
 ;;S52.231C
 ;;9002226.02101,"873,S52.231C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.232A ",.01)
 ;;S52.232A
 ;;9002226.02101,"873,S52.232A ",.02)
 ;;S52.232A
 ;;9002226.02101,"873,S52.232A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.232B ",.01)
 ;;S52.232B
 ;;9002226.02101,"873,S52.232B ",.02)
 ;;S52.232B
 ;;9002226.02101,"873,S52.232B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.232C ",.01)
 ;;S52.232C
 ;;9002226.02101,"873,S52.232C ",.02)
 ;;S52.232C
 ;;9002226.02101,"873,S52.232C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.233A ",.01)
 ;;S52.233A
 ;;9002226.02101,"873,S52.233A ",.02)
 ;;S52.233A
 ;;9002226.02101,"873,S52.233A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.233B ",.01)
 ;;S52.233B
 ;;9002226.02101,"873,S52.233B ",.02)
 ;;S52.233B
 ;;9002226.02101,"873,S52.233B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.233C ",.01)
 ;;S52.233C
 ;;9002226.02101,"873,S52.233C ",.02)
 ;;S52.233C
 ;;9002226.02101,"873,S52.233C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.234A ",.01)
 ;;S52.234A
 ;;9002226.02101,"873,S52.234A ",.02)
 ;;S52.234A
 ;;9002226.02101,"873,S52.234A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.234B ",.01)
 ;;S52.234B
 ;;9002226.02101,"873,S52.234B ",.02)
 ;;S52.234B
 ;;9002226.02101,"873,S52.234B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.234C ",.01)
 ;;S52.234C
 ;;9002226.02101,"873,S52.234C ",.02)
 ;;S52.234C
 ;;9002226.02101,"873,S52.234C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.235A ",.01)
 ;;S52.235A
 ;;9002226.02101,"873,S52.235A ",.02)
 ;;S52.235A
 ;;9002226.02101,"873,S52.235A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.235B ",.01)
 ;;S52.235B
 ;;9002226.02101,"873,S52.235B ",.02)
 ;;S52.235B
 ;;9002226.02101,"873,S52.235B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.235C ",.01)
 ;;S52.235C
 ;;9002226.02101,"873,S52.235C ",.02)
 ;;S52.235C
 ;;9002226.02101,"873,S52.235C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.236A ",.01)
 ;;S52.236A
 ;;9002226.02101,"873,S52.236A ",.02)
 ;;S52.236A
 ;;9002226.02101,"873,S52.236A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.236B ",.01)
 ;;S52.236B
 ;;9002226.02101,"873,S52.236B ",.02)
 ;;S52.236B
 ;;9002226.02101,"873,S52.236B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.236C ",.01)
 ;;S52.236C
 ;;9002226.02101,"873,S52.236C ",.02)
 ;;S52.236C
 ;;9002226.02101,"873,S52.236C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.241A ",.01)
 ;;S52.241A
 ;;9002226.02101,"873,S52.241A ",.02)
 ;;S52.241A
 ;;9002226.02101,"873,S52.241A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.241B ",.01)
 ;;S52.241B
 ;;9002226.02101,"873,S52.241B ",.02)
 ;;S52.241B
 ;;9002226.02101,"873,S52.241B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.241C ",.01)
 ;;S52.241C
 ;;9002226.02101,"873,S52.241C ",.02)
 ;;S52.241C
 ;;9002226.02101,"873,S52.241C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.242A ",.01)
 ;;S52.242A
 ;;9002226.02101,"873,S52.242A ",.02)
 ;;S52.242A
 ;;9002226.02101,"873,S52.242A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.242B ",.01)
 ;;S52.242B
 ;;9002226.02101,"873,S52.242B ",.02)
 ;;S52.242B
 ;;9002226.02101,"873,S52.242B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.242C ",.01)
 ;;S52.242C
 ;;9002226.02101,"873,S52.242C ",.02)
 ;;S52.242C
 ;;9002226.02101,"873,S52.242C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.243A ",.01)
 ;;S52.243A
 ;;9002226.02101,"873,S52.243A ",.02)
 ;;S52.243A
 ;;9002226.02101,"873,S52.243A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.243B ",.01)
 ;;S52.243B
 ;;9002226.02101,"873,S52.243B ",.02)
 ;;S52.243B
 ;;9002226.02101,"873,S52.243B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.243C ",.01)
 ;;S52.243C
 ;;9002226.02101,"873,S52.243C ",.02)
 ;;S52.243C
 ;;9002226.02101,"873,S52.243C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.244A ",.01)
 ;;S52.244A
 ;;9002226.02101,"873,S52.244A ",.02)
 ;;S52.244A
 ;;9002226.02101,"873,S52.244A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.244B ",.01)
 ;;S52.244B
 ;;9002226.02101,"873,S52.244B ",.02)
 ;;S52.244B
 ;;9002226.02101,"873,S52.244B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.244C ",.01)
 ;;S52.244C
 ;;9002226.02101,"873,S52.244C ",.02)
 ;;S52.244C
 ;;9002226.02101,"873,S52.244C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.245A ",.01)
 ;;S52.245A
 ;;9002226.02101,"873,S52.245A ",.02)
 ;;S52.245A
 ;;9002226.02101,"873,S52.245A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.245B ",.01)
 ;;S52.245B
 ;;9002226.02101,"873,S52.245B ",.02)
 ;;S52.245B
 ;;9002226.02101,"873,S52.245B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.245C ",.01)
 ;;S52.245C
 ;;9002226.02101,"873,S52.245C ",.02)
 ;;S52.245C
 ;;9002226.02101,"873,S52.245C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.246A ",.01)
 ;;S52.246A
 ;;9002226.02101,"873,S52.246A ",.02)
 ;;S52.246A
 ;;9002226.02101,"873,S52.246A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.246B ",.01)
 ;;S52.246B
 ;;9002226.02101,"873,S52.246B ",.02)
 ;;S52.246B
 ;;9002226.02101,"873,S52.246B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.246C ",.01)
 ;;S52.246C
 ;;9002226.02101,"873,S52.246C ",.02)
 ;;S52.246C
 ;;9002226.02101,"873,S52.246C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.251A ",.01)
 ;;S52.251A
 ;;9002226.02101,"873,S52.251A ",.02)
 ;;S52.251A
 ;;9002226.02101,"873,S52.251A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.251B ",.01)
 ;;S52.251B
 ;;9002226.02101,"873,S52.251B ",.02)
 ;;S52.251B
 ;;9002226.02101,"873,S52.251B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.251C ",.01)
 ;;S52.251C
 ;;9002226.02101,"873,S52.251C ",.02)
 ;;S52.251C
 ;;9002226.02101,"873,S52.251C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.252A ",.01)
 ;;S52.252A
 ;;9002226.02101,"873,S52.252A ",.02)
 ;;S52.252A
 ;;9002226.02101,"873,S52.252A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.252B ",.01)
 ;;S52.252B
 ;;9002226.02101,"873,S52.252B ",.02)
 ;;S52.252B
 ;;9002226.02101,"873,S52.252B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.252C ",.01)
 ;;S52.252C
 ;;9002226.02101,"873,S52.252C ",.02)
 ;;S52.252C
 ;;9002226.02101,"873,S52.252C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.253A ",.01)
 ;;S52.253A
 ;;9002226.02101,"873,S52.253A ",.02)
 ;;S52.253A
 ;;9002226.02101,"873,S52.253A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.253B ",.01)
 ;;S52.253B
 ;;9002226.02101,"873,S52.253B ",.02)
 ;;S52.253B
 ;;9002226.02101,"873,S52.253B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.253C ",.01)
 ;;S52.253C
 ;;9002226.02101,"873,S52.253C ",.02)
 ;;S52.253C
 ;;9002226.02101,"873,S52.253C ",.03)
 ;;30
 ;;9002226.02101,"873,S52.254A ",.01)
 ;;S52.254A
 ;;9002226.02101,"873,S52.254A ",.02)
 ;;S52.254A
 ;;9002226.02101,"873,S52.254A ",.03)
 ;;30
 ;;9002226.02101,"873,S52.254B ",.01)
 ;;S52.254B
 ;;9002226.02101,"873,S52.254B ",.02)
 ;;S52.254B
 ;;9002226.02101,"873,S52.254B ",.03)
 ;;30
 ;;9002226.02101,"873,S52.254C ",.01)
 ;;S52.254C
 ;;9002226.02101,"873,S52.254C ",.02)
 ;;S52.254C
 ;;9002226.02101,"873,S52.254C ",.03)
 ;;30