BGP2TA16 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1064,24658-0243-18 ",.02)
 ;;24658-0243-18
 ;;9002226.02101,"1064,24658-0243-30 ",.01)
 ;;24658-0243-30
 ;;9002226.02101,"1064,24658-0243-30 ",.02)
 ;;24658-0243-30
 ;;9002226.02101,"1064,24658-0243-45 ",.01)
 ;;24658-0243-45
 ;;9002226.02101,"1064,24658-0243-45 ",.02)
 ;;24658-0243-45
 ;;9002226.02101,"1064,24658-0243-90 ",.01)
 ;;24658-0243-90
 ;;9002226.02101,"1064,24658-0243-90 ",.02)
 ;;24658-0243-90
 ;;9002226.02101,"1064,24658-0244-01 ",.01)
 ;;24658-0244-01
 ;;9002226.02101,"1064,24658-0244-01 ",.02)
 ;;24658-0244-01
 ;;9002226.02101,"1064,24658-0244-10 ",.01)
 ;;24658-0244-10
 ;;9002226.02101,"1064,24658-0244-10 ",.02)
 ;;24658-0244-10
 ;;9002226.02101,"1064,24658-0245-10 ",.01)
 ;;24658-0245-10
 ;;9002226.02101,"1064,24658-0245-10 ",.02)
 ;;24658-0245-10
 ;;9002226.02101,"1064,24658-0245-15 ",.01)
 ;;24658-0245-15
 ;;9002226.02101,"1064,24658-0245-15 ",.02)
 ;;24658-0245-15
 ;;9002226.02101,"1064,24658-0245-18 ",.01)
 ;;24658-0245-18
 ;;9002226.02101,"1064,24658-0245-18 ",.02)
 ;;24658-0245-18
 ;;9002226.02101,"1064,24658-0245-30 ",.01)
 ;;24658-0245-30
 ;;9002226.02101,"1064,24658-0245-30 ",.02)
 ;;24658-0245-30
 ;;9002226.02101,"1064,24658-0245-45 ",.01)
 ;;24658-0245-45
 ;;9002226.02101,"1064,24658-0245-45 ",.02)
 ;;24658-0245-45
 ;;9002226.02101,"1064,24658-0245-60 ",.01)
 ;;24658-0245-60
 ;;9002226.02101,"1064,24658-0245-60 ",.02)
 ;;24658-0245-60
 ;;9002226.02101,"1064,24658-0245-90 ",.01)
 ;;24658-0245-90
 ;;9002226.02101,"1064,24658-0245-90 ",.02)
 ;;24658-0245-90
 ;;9002226.02101,"1064,31722-0200-90 ",.01)
 ;;31722-0200-90
 ;;9002226.02101,"1064,31722-0200-90 ",.02)
 ;;31722-0200-90
 ;;9002226.02101,"1064,31722-0201-90 ",.01)
 ;;31722-0201-90
 ;;9002226.02101,"1064,31722-0201-90 ",.02)
 ;;31722-0201-90
 ;;9002226.02101,"1064,31722-0202-90 ",.01)
 ;;31722-0202-90
 ;;9002226.02101,"1064,31722-0202-90 ",.02)
 ;;31722-0202-90
 ;;9002226.02101,"1064,31722-0271-01 ",.01)
 ;;31722-0271-01
 ;;9002226.02101,"1064,31722-0271-01 ",.02)
 ;;31722-0271-01
 ;;9002226.02101,"1064,31722-0272-01 ",.01)
 ;;31722-0272-01
 ;;9002226.02101,"1064,31722-0272-01 ",.02)
 ;;31722-0272-01
 ;;9002226.02101,"1064,31722-0272-10 ",.01)
 ;;31722-0272-10
 ;;9002226.02101,"1064,31722-0272-10 ",.02)
 ;;31722-0272-10
 ;;9002226.02101,"1064,31722-0273-01 ",.01)
 ;;31722-0273-01
 ;;9002226.02101,"1064,31722-0273-01 ",.02)
 ;;31722-0273-01
 ;;9002226.02101,"1064,31722-0273-10 ",.01)
 ;;31722-0273-10
 ;;9002226.02101,"1064,31722-0273-10 ",.02)
 ;;31722-0273-10
 ;;9002226.02101,"1064,31722-0274-01 ",.01)
 ;;31722-0274-01
 ;;9002226.02101,"1064,31722-0274-01 ",.02)
 ;;31722-0274-01
 ;;9002226.02101,"1064,31722-0274-10 ",.01)
 ;;31722-0274-10
 ;;9002226.02101,"1064,31722-0274-10 ",.02)
 ;;31722-0274-10
 ;;9002226.02101,"1064,33358-0047-30 ",.01)
 ;;33358-0047-30
 ;;9002226.02101,"1064,33358-0047-30 ",.02)
 ;;33358-0047-30
 ;;9002226.02101,"1064,33358-0048-30 ",.01)
 ;;33358-0048-30
 ;;9002226.02101,"1064,33358-0048-30 ",.02)
 ;;33358-0048-30
 ;;9002226.02101,"1064,33358-0049-30 ",.01)
 ;;33358-0049-30
 ;;9002226.02101,"1064,33358-0049-30 ",.02)
 ;;33358-0049-30
 ;;9002226.02101,"1064,33358-0050-30 ",.01)
 ;;33358-0050-30
 ;;9002226.02101,"1064,33358-0050-30 ",.02)
 ;;33358-0050-30
 ;;9002226.02101,"1064,33358-0127-30 ",.01)
 ;;33358-0127-30
 ;;9002226.02101,"1064,33358-0127-30 ",.02)
 ;;33358-0127-30
 ;;9002226.02101,"1064,33358-0211-30 ",.01)
 ;;33358-0211-30
 ;;9002226.02101,"1064,33358-0211-30 ",.02)
 ;;33358-0211-30
 ;;9002226.02101,"1064,33358-0212-30 ",.01)
 ;;33358-0212-30
 ;;9002226.02101,"1064,33358-0212-30 ",.02)
 ;;33358-0212-30
 ;;9002226.02101,"1064,33358-0213-30 ",.01)
 ;;33358-0213-30
 ;;9002226.02101,"1064,33358-0213-30 ",.02)
 ;;33358-0213-30
 ;;9002226.02101,"1064,33358-0214-30 ",.01)
 ;;33358-0214-30
 ;;9002226.02101,"1064,33358-0214-30 ",.02)
 ;;33358-0214-30
 ;;9002226.02101,"1064,33358-0214-60 ",.01)
 ;;33358-0214-60
 ;;9002226.02101,"1064,33358-0214-60 ",.02)
 ;;33358-0214-60
 ;;9002226.02101,"1064,33358-0222-00 ",.01)
 ;;33358-0222-00
 ;;9002226.02101,"1064,33358-0222-00 ",.02)
 ;;33358-0222-00
 ;;9002226.02101,"1064,33458-0211-30 ",.01)
 ;;33458-0211-30
 ;;9002226.02101,"1064,33458-0211-30 ",.02)
 ;;33458-0211-30
 ;;9002226.02101,"1064,35356-0541-30 ",.01)
 ;;35356-0541-30
 ;;9002226.02101,"1064,35356-0541-30 ",.02)
 ;;35356-0541-30
 ;;9002226.02101,"1064,43063-0007-01 ",.01)
 ;;43063-0007-01
 ;;9002226.02101,"1064,43063-0007-01 ",.02)
 ;;43063-0007-01
 ;;9002226.02101,"1064,43063-0032-01 ",.01)
 ;;43063-0032-01
 ;;9002226.02101,"1064,43063-0032-01 ",.02)
 ;;43063-0032-01
 ;;9002226.02101,"1064,43063-0065-30 ",.01)
 ;;43063-0065-30
 ;;9002226.02101,"1064,43063-0065-30 ",.02)
 ;;43063-0065-30
 ;;9002226.02101,"1064,43063-0065-90 ",.01)
 ;;43063-0065-90
 ;;9002226.02101,"1064,43063-0065-90 ",.02)
 ;;43063-0065-90
 ;;9002226.02101,"1064,43063-0118-30 ",.01)
 ;;43063-0118-30
 ;;9002226.02101,"1064,43063-0118-30 ",.02)
 ;;43063-0118-30
 ;;9002226.02101,"1064,43063-0118-90 ",.01)
 ;;43063-0118-90
 ;;9002226.02101,"1064,43063-0118-90 ",.02)
 ;;43063-0118-90
 ;;9002226.02101,"1064,43063-0130-90 ",.01)
 ;;43063-0130-90
 ;;9002226.02101,"1064,43063-0130-90 ",.02)
 ;;43063-0130-90
 ;;9002226.02101,"1064,43063-0131-30 ",.01)
 ;;43063-0131-30
 ;;9002226.02101,"1064,43063-0131-30 ",.02)
 ;;43063-0131-30
 ;;9002226.02101,"1064,43063-0132-30 ",.01)
 ;;43063-0132-30
 ;;9002226.02101,"1064,43063-0132-30 ",.02)
 ;;43063-0132-30
 ;;9002226.02101,"1064,43063-0138-90 ",.01)
 ;;43063-0138-90
 ;;9002226.02101,"1064,43063-0138-90 ",.02)
 ;;43063-0138-90
 ;;9002226.02101,"1064,43063-0146-30 ",.01)
 ;;43063-0146-30
 ;;9002226.02101,"1064,43063-0146-30 ",.02)
 ;;43063-0146-30
 ;;9002226.02101,"1064,43063-0171-14 ",.01)
 ;;43063-0171-14
 ;;9002226.02101,"1064,43063-0171-14 ",.02)
 ;;43063-0171-14
 ;;9002226.02101,"1064,43063-0232-30 ",.01)
 ;;43063-0232-30
 ;;9002226.02101,"1064,43063-0232-30 ",.02)
 ;;43063-0232-30
 ;;9002226.02101,"1064,43063-0232-60 ",.01)
 ;;43063-0232-60
 ;;9002226.02101,"1064,43063-0232-60 ",.02)
 ;;43063-0232-60
 ;;9002226.02101,"1064,43063-0233-60 ",.01)
 ;;43063-0233-60
 ;;9002226.02101,"1064,43063-0233-60 ",.02)
 ;;43063-0233-60
 ;;9002226.02101,"1064,43063-0234-60 ",.01)
 ;;43063-0234-60
 ;;9002226.02101,"1064,43063-0234-60 ",.02)
 ;;43063-0234-60
 ;;9002226.02101,"1064,43063-0288-30 ",.01)
 ;;43063-0288-30
 ;;9002226.02101,"1064,43063-0288-30 ",.02)
 ;;43063-0288-30
 ;;9002226.02101,"1064,43063-0303-30 ",.01)
 ;;43063-0303-30
 ;;9002226.02101,"1064,43063-0303-30 ",.02)
 ;;43063-0303-30
 ;;9002226.02101,"1064,43353-0350-30 ",.01)
 ;;43353-0350-30
 ;;9002226.02101,"1064,43353-0350-30 ",.02)
 ;;43353-0350-30
 ;;9002226.02101,"1064,43353-0365-15 ",.01)
 ;;43353-0365-15
 ;;9002226.02101,"1064,43353-0365-15 ",.02)
 ;;43353-0365-15
 ;;9002226.02101,"1064,43353-0411-60 ",.01)
 ;;43353-0411-60
 ;;9002226.02101,"1064,43353-0411-60 ",.02)
 ;;43353-0411-60
 ;;9002226.02101,"1064,43353-0488-45 ",.01)
 ;;43353-0488-45
 ;;9002226.02101,"1064,43353-0488-45 ",.02)
 ;;43353-0488-45
 ;;9002226.02101,"1064,49158-0501-01 ",.01)
 ;;49158-0501-01
 ;;9002226.02101,"1064,49158-0501-01 ",.02)
 ;;49158-0501-01
 ;;9002226.02101,"1064,49158-0502-01 ",.01)
 ;;49158-0502-01
 ;;9002226.02101,"1064,49158-0502-01 ",.02)
 ;;49158-0502-01
 ;;9002226.02101,"1064,49158-0502-10 ",.01)
 ;;49158-0502-10
 ;;9002226.02101,"1064,49158-0502-10 ",.02)
 ;;49158-0502-10
 ;;9002226.02101,"1064,49158-0503-01 ",.01)
 ;;49158-0503-01
 ;;9002226.02101,"1064,49158-0503-01 ",.02)
 ;;49158-0503-01
 ;;9002226.02101,"1064,49884-0556-01 ",.01)
 ;;49884-0556-01
 ;;9002226.02101,"1064,49884-0556-01 ",.02)
 ;;49884-0556-01
 ;;9002226.02101,"1064,49884-0556-10 ",.01)
 ;;49884-0556-10
 ;;9002226.02101,"1064,49884-0556-10 ",.02)
 ;;49884-0556-10
 ;;9002226.02101,"1064,49884-0557-01 ",.01)
 ;;49884-0557-01
 ;;9002226.02101,"1064,49884-0557-01 ",.02)
 ;;49884-0557-01
 ;;9002226.02101,"1064,49884-0557-10 ",.01)
 ;;49884-0557-10
 ;;9002226.02101,"1064,49884-0557-10 ",.02)
 ;;49884-0557-10
 ;;9002226.02101,"1064,49884-0558-01 ",.01)
 ;;49884-0558-01
 ;;9002226.02101,"1064,49884-0558-01 ",.02)
 ;;49884-0558-01
 ;;9002226.02101,"1064,49884-0558-10 ",.01)
 ;;49884-0558-10
 ;;9002226.02101,"1064,49884-0558-10 ",.02)
 ;;49884-0558-10
 ;;9002226.02101,"1064,49884-0559-01 ",.01)
 ;;49884-0559-01
 ;;9002226.02101,"1064,49884-0559-01 ",.02)
 ;;49884-0559-01
 ;;9002226.02101,"1064,49884-0559-10 ",.01)
 ;;49884-0559-10
 ;;9002226.02101,"1064,49884-0559-10 ",.02)
 ;;49884-0559-10
 ;;9002226.02101,"1064,49884-0560-01 ",.01)
 ;;49884-0560-01
 ;;9002226.02101,"1064,49884-0560-01 ",.02)
 ;;49884-0560-01
 ;;9002226.02101,"1064,49884-0560-10 ",.01)
 ;;49884-0560-10
 ;;9002226.02101,"1064,49884-0560-10 ",.02)
 ;;49884-0560-10
 ;;9002226.02101,"1064,49884-0591-01 ",.01)
 ;;49884-0591-01
 ;;9002226.02101,"1064,49884-0591-01 ",.02)
 ;;49884-0591-01
 ;;9002226.02101,"1064,49884-0591-10 ",.01)
 ;;49884-0591-10
 ;;9002226.02101,"1064,49884-0591-10 ",.02)
 ;;49884-0591-10
 ;;9002226.02101,"1064,49884-0592-01 ",.01)
 ;;49884-0592-01
 ;;9002226.02101,"1064,49884-0592-01 ",.02)
 ;;49884-0592-01
 ;;9002226.02101,"1064,49884-0592-10 ",.01)
 ;;49884-0592-10
 ;;9002226.02101,"1064,49884-0592-10 ",.02)
 ;;49884-0592-10
 ;;9002226.02101,"1064,49884-0593-01 ",.01)
 ;;49884-0593-01
 ;;9002226.02101,"1064,49884-0593-01 ",.02)
 ;;49884-0593-01
 ;;9002226.02101,"1064,49884-0593-10 ",.01)
 ;;49884-0593-10
 ;;9002226.02101,"1064,49884-0593-10 ",.02)
 ;;49884-0593-10
 ;;9002226.02101,"1064,49884-0594-01 ",.01)
 ;;49884-0594-01
 ;;9002226.02101,"1064,49884-0594-01 ",.02)
 ;;49884-0594-01
 ;;9002226.02101,"1064,49884-0594-10 ",.01)
 ;;49884-0594-10
 ;;9002226.02101,"1064,49884-0594-10 ",.02)
 ;;49884-0594-10
 ;;9002226.02101,"1064,49884-0619-01 ",.01)
 ;;49884-0619-01
 ;;9002226.02101,"1064,49884-0619-01 ",.02)
 ;;49884-0619-01
 ;;9002226.02101,"1064,49884-0620-01 ",.01)
 ;;49884-0620-01
 ;;9002226.02101,"1064,49884-0620-01 ",.02)
 ;;49884-0620-01
 ;;9002226.02101,"1064,49884-0620-10 ",.01)
 ;;49884-0620-10
 ;;9002226.02101,"1064,49884-0620-10 ",.02)
 ;;49884-0620-10
 ;;9002226.02101,"1064,49884-0622-01 ",.01)
 ;;49884-0622-01
 ;;9002226.02101,"1064,49884-0622-01 ",.02)
 ;;49884-0622-01
 ;;9002226.02101,"1064,49884-0635-01 ",.01)
 ;;49884-0635-01
 ;;9002226.02101,"1064,49884-0635-01 ",.02)
 ;;49884-0635-01
 ;;9002226.02101,"1064,49884-0635-10 ",.01)
 ;;49884-0635-10
 ;;9002226.02101,"1064,49884-0635-10 ",.02)
 ;;49884-0635-10
 ;;9002226.02101,"1064,49884-0686-01 ",.01)
 ;;49884-0686-01
 ;;9002226.02101,"1064,49884-0686-01 ",.02)
 ;;49884-0686-01
 ;;9002226.02101,"1064,49884-0687-01 ",.01)
 ;;49884-0687-01
 ;;9002226.02101,"1064,49884-0687-01 ",.02)
 ;;49884-0687-01
 ;;9002226.02101,"1064,49884-0793-01 ",.01)
 ;;49884-0793-01
 ;;9002226.02101,"1064,49884-0793-01 ",.02)
 ;;49884-0793-01
 ;;9002226.02101,"1064,49884-0793-74 ",.01)
 ;;49884-0793-74
 ;;9002226.02101,"1064,49884-0793-74 ",.02)
 ;;49884-0793-74
 ;;9002226.02101,"1064,49884-0794-01 ",.01)
 ;;49884-0794-01
 ;;9002226.02101,"1064,49884-0794-01 ",.02)
 ;;49884-0794-01
 ;;9002226.02101,"1064,49884-0794-10 ",.01)
 ;;49884-0794-10
 ;;9002226.02101,"1064,49884-0794-10 ",.02)
 ;;49884-0794-10
 ;;9002226.02101,"1064,49884-0794-74 ",.01)
 ;;49884-0794-74
 ;;9002226.02101,"1064,49884-0794-74 ",.02)
 ;;49884-0794-74
 ;;9002226.02101,"1064,49884-0795-01 ",.01)
 ;;49884-0795-01
 ;;9002226.02101,"1064,49884-0795-01 ",.02)
 ;;49884-0795-01
 ;;9002226.02101,"1064,49884-0795-10 ",.01)
 ;;49884-0795-10
 ;;9002226.02101,"1064,49884-0795-10 ",.02)
 ;;49884-0795-10
 ;;9002226.02101,"1064,49884-0795-74 ",.01)
 ;;49884-0795-74
 ;;9002226.02101,"1064,49884-0795-74 ",.02)
 ;;49884-0795-74
 ;;9002226.02101,"1064,49884-0796-01 ",.01)
 ;;49884-0796-01
 ;;9002226.02101,"1064,49884-0796-01 ",.02)
 ;;49884-0796-01
 ;;9002226.02101,"1064,49884-0815-01 ",.01)
 ;;49884-0815-01
 ;;9002226.02101,"1064,49884-0815-01 ",.02)
 ;;49884-0815-01
 ;;9002226.02101,"1064,49884-0816-01 ",.01)
 ;;49884-0816-01
 ;;9002226.02101,"1064,49884-0816-01 ",.02)
 ;;49884-0816-01
 ;;9002226.02101,"1064,49884-0817-01 ",.01)
 ;;49884-0817-01
 ;;9002226.02101,"1064,49884-0817-01 ",.02)
 ;;49884-0817-01
 ;;9002226.02101,"1064,49884-0818-01 ",.01)
 ;;49884-0818-01
 ;;9002226.02101,"1064,49884-0818-01 ",.02)
 ;;49884-0818-01
 ;;9002226.02101,"1064,49884-0929-01 ",.01)
 ;;49884-0929-01
 ;;9002226.02101,"1064,49884-0929-01 ",.02)
 ;;49884-0929-01
 ;;9002226.02101,"1064,49884-0930-01 ",.01)
 ;;49884-0930-01
 ;;9002226.02101,"1064,49884-0930-01 ",.02)
 ;;49884-0930-01
 ;;9002226.02101,"1064,49884-0931-01 ",.01)
 ;;49884-0931-01
 ;;9002226.02101,"1064,49884-0931-01 ",.02)
 ;;49884-0931-01
 ;;9002226.02101,"1064,49884-0932-01 ",.01)
 ;;49884-0932-01
 ;;9002226.02101,"1064,49884-0932-01 ",.02)
 ;;49884-0932-01
 ;;9002226.02101,"1064,49884-0952-01 ",.01)
 ;;49884-0952-01
 ;;9002226.02101,"1064,49884-0952-01 ",.02)
 ;;49884-0952-01
 ;;9002226.02101,"1064,49884-0953-01 ",.01)
 ;;49884-0953-01
 ;;9002226.02101,"1064,49884-0953-01 ",.02)
 ;;49884-0953-01
 ;;9002226.02101,"1064,49884-0990-09 ",.01)
 ;;49884-0990-09
 ;;9002226.02101,"1064,49884-0990-09 ",.02)
 ;;49884-0990-09
 ;;9002226.02101,"1064,49884-0991-09 ",.01)
 ;;49884-0991-09
 ;;9002226.02101,"1064,49884-0991-09 ",.02)
 ;;49884-0991-09
 ;;9002226.02101,"1064,49884-0992-09 ",.01)
 ;;49884-0992-09
 ;;9002226.02101,"1064,49884-0992-09 ",.02)
 ;;49884-0992-09