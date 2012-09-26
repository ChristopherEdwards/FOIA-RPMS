BGP2TD14 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1729,00078-0314-05 ",.02)
 ;;00078-0314-05
 ;;9002226.02101,"1729,00078-0314-06 ",.01)
 ;;00078-0314-06
 ;;9002226.02101,"1729,00078-0314-06 ",.02)
 ;;00078-0314-06
 ;;9002226.02101,"1729,00078-0314-33 ",.01)
 ;;00078-0314-33
 ;;9002226.02101,"1729,00078-0314-33 ",.02)
 ;;00078-0314-33
 ;;9002226.02101,"1729,00078-0314-34 ",.01)
 ;;00078-0314-34
 ;;9002226.02101,"1729,00078-0314-34 ",.02)
 ;;00078-0314-34
 ;;9002226.02101,"1729,00078-0314-61 ",.01)
 ;;00078-0314-61
 ;;9002226.02101,"1729,00078-0314-61 ",.02)
 ;;00078-0314-61
 ;;9002226.02101,"1729,00078-0315-05 ",.01)
 ;;00078-0315-05
 ;;9002226.02101,"1729,00078-0315-05 ",.02)
 ;;00078-0315-05
 ;;9002226.02101,"1729,00078-0315-06 ",.01)
 ;;00078-0315-06
 ;;9002226.02101,"1729,00078-0315-06 ",.02)
 ;;00078-0315-06
 ;;9002226.02101,"1729,00078-0315-15 ",.01)
 ;;00078-0315-15
 ;;9002226.02101,"1729,00078-0315-15 ",.02)
 ;;00078-0315-15
 ;;9002226.02101,"1729,00078-0315-17 ",.01)
 ;;00078-0315-17
 ;;9002226.02101,"1729,00078-0315-17 ",.02)
 ;;00078-0315-17
 ;;9002226.02101,"1729,00078-0315-34 ",.01)
 ;;00078-0315-34
 ;;9002226.02101,"1729,00078-0315-34 ",.02)
 ;;00078-0315-34
 ;;9002226.02101,"1729,00078-0315-61 ",.01)
 ;;00078-0315-61
 ;;9002226.02101,"1729,00078-0315-61 ",.02)
 ;;00078-0315-61
 ;;9002226.02101,"1729,00078-0315-67 ",.01)
 ;;00078-0315-67
 ;;9002226.02101,"1729,00078-0315-67 ",.02)
 ;;00078-0315-67
 ;;9002226.02101,"1729,00078-0358-05 ",.01)
 ;;00078-0358-05
 ;;9002226.02101,"1729,00078-0358-05 ",.02)
 ;;00078-0358-05
 ;;9002226.02101,"1729,00078-0358-06 ",.01)
 ;;00078-0358-06
 ;;9002226.02101,"1729,00078-0358-06 ",.02)
 ;;00078-0358-06
 ;;9002226.02101,"1729,00078-0358-33 ",.01)
 ;;00078-0358-33
 ;;9002226.02101,"1729,00078-0358-33 ",.02)
 ;;00078-0358-33
 ;;9002226.02101,"1729,00078-0358-34 ",.01)
 ;;00078-0358-34
 ;;9002226.02101,"1729,00078-0358-34 ",.02)
 ;;00078-0358-34
 ;;9002226.02101,"1729,00078-0358-61 ",.01)
 ;;00078-0358-61
 ;;9002226.02101,"1729,00078-0358-61 ",.02)
 ;;00078-0358-61
 ;;9002226.02101,"1729,00078-0359-05 ",.01)
 ;;00078-0359-05
 ;;9002226.02101,"1729,00078-0359-05 ",.02)
 ;;00078-0359-05
 ;;9002226.02101,"1729,00078-0359-06 ",.01)
 ;;00078-0359-06
 ;;9002226.02101,"1729,00078-0359-06 ",.02)
 ;;00078-0359-06
 ;;9002226.02101,"1729,00078-0359-17 ",.01)
 ;;00078-0359-17
 ;;9002226.02101,"1729,00078-0359-17 ",.02)
 ;;00078-0359-17
 ;;9002226.02101,"1729,00078-0359-34 ",.01)
 ;;00078-0359-34
 ;;9002226.02101,"1729,00078-0359-34 ",.02)
 ;;00078-0359-34
 ;;9002226.02101,"1729,00078-0359-61 ",.01)
 ;;00078-0359-61
 ;;9002226.02101,"1729,00078-0359-61 ",.02)
 ;;00078-0359-61
 ;;9002226.02101,"1729,00078-0360-05 ",.01)
 ;;00078-0360-05
 ;;9002226.02101,"1729,00078-0360-05 ",.02)
 ;;00078-0360-05
 ;;9002226.02101,"1729,00078-0360-06 ",.01)
 ;;00078-0360-06
 ;;9002226.02101,"1729,00078-0360-06 ",.02)
 ;;00078-0360-06
 ;;9002226.02101,"1729,00078-0360-11 ",.01)
 ;;00078-0360-11
 ;;9002226.02101,"1729,00078-0360-11 ",.02)
 ;;00078-0360-11
 ;;9002226.02101,"1729,00078-0360-34 ",.01)
 ;;00078-0360-34
 ;;9002226.02101,"1729,00078-0360-34 ",.02)
 ;;00078-0360-34
 ;;9002226.02101,"1729,00078-0364-05 ",.01)
 ;;00078-0364-05
 ;;9002226.02101,"1729,00078-0364-05 ",.02)
 ;;00078-0364-05
 ;;9002226.02101,"1729,00078-0376-06 ",.01)
 ;;00078-0376-06
 ;;9002226.02101,"1729,00078-0376-06 ",.02)
 ;;00078-0376-06
 ;;9002226.02101,"1729,00078-0376-15 ",.01)
 ;;00078-0376-15
 ;;9002226.02101,"1729,00078-0376-15 ",.02)
 ;;00078-0376-15
 ;;9002226.02101,"1729,00078-0379-05 ",.01)
 ;;00078-0379-05
 ;;9002226.02101,"1729,00078-0379-05 ",.02)
 ;;00078-0379-05
 ;;9002226.02101,"1729,00078-0383-05 ",.01)
 ;;00078-0383-05
 ;;9002226.02101,"1729,00078-0383-05 ",.02)
 ;;00078-0383-05
 ;;9002226.02101,"1729,00078-0383-06 ",.01)
 ;;00078-0383-06
 ;;9002226.02101,"1729,00078-0383-06 ",.02)
 ;;00078-0383-06
 ;;9002226.02101,"1729,00078-0383-15 ",.01)
 ;;00078-0383-15
 ;;9002226.02101,"1729,00078-0383-15 ",.02)
 ;;00078-0383-15
 ;;9002226.02101,"1729,00078-0383-17 ",.01)
 ;;00078-0383-17
 ;;9002226.02101,"1729,00078-0383-17 ",.02)
 ;;00078-0383-17
 ;;9002226.02101,"1729,00078-0383-34 ",.01)
 ;;00078-0383-34
 ;;9002226.02101,"1729,00078-0383-34 ",.02)
 ;;00078-0383-34
 ;;9002226.02101,"1729,00078-0383-61 ",.01)
 ;;00078-0383-61
 ;;9002226.02101,"1729,00078-0383-61 ",.02)
 ;;00078-0383-61
 ;;9002226.02101,"1729,00078-0383-67 ",.01)
 ;;00078-0383-67
 ;;9002226.02101,"1729,00078-0383-67 ",.02)
 ;;00078-0383-67
 ;;9002226.02101,"1729,00078-0384-05 ",.01)
 ;;00078-0384-05
 ;;9002226.02101,"1729,00078-0384-05 ",.02)
 ;;00078-0384-05
 ;;9002226.02101,"1729,00078-0404-05 ",.01)
 ;;00078-0404-05
 ;;9002226.02101,"1729,00078-0404-05 ",.02)
 ;;00078-0404-05
 ;;9002226.02101,"1729,00078-0405-05 ",.01)
 ;;00078-0405-05
 ;;9002226.02101,"1729,00078-0405-05 ",.02)
 ;;00078-0405-05
 ;;9002226.02101,"1729,00078-0406-05 ",.01)
 ;;00078-0406-05
 ;;9002226.02101,"1729,00078-0406-05 ",.02)
 ;;00078-0406-05
 ;;9002226.02101,"1729,00078-0423-06 ",.01)
 ;;00078-0423-06
 ;;9002226.02101,"1729,00078-0423-06 ",.02)
 ;;00078-0423-06
 ;;9002226.02101,"1729,00078-0423-15 ",.01)
 ;;00078-0423-15
 ;;9002226.02101,"1729,00078-0423-15 ",.02)
 ;;00078-0423-15
 ;;9002226.02101,"1729,00078-0423-61 ",.01)
 ;;00078-0423-61
 ;;9002226.02101,"1729,00078-0423-61 ",.02)
 ;;00078-0423-61
 ;;9002226.02101,"1729,00078-0447-05 ",.01)
 ;;00078-0447-05
 ;;9002226.02101,"1729,00078-0447-05 ",.02)
 ;;00078-0447-05
 ;;9002226.02101,"1729,00078-0448-05 ",.01)
 ;;00078-0448-05
 ;;9002226.02101,"1729,00078-0448-05 ",.02)
 ;;00078-0448-05
 ;;9002226.02101,"1729,00078-0449-05 ",.01)
 ;;00078-0449-05
 ;;9002226.02101,"1729,00078-0449-05 ",.02)
 ;;00078-0449-05
 ;;9002226.02101,"1729,00078-0450-05 ",.01)
 ;;00078-0450-05
 ;;9002226.02101,"1729,00078-0450-05 ",.02)
 ;;00078-0450-05
 ;;9002226.02101,"1729,00078-0451-05 ",.01)
 ;;00078-0451-05
 ;;9002226.02101,"1729,00078-0451-05 ",.02)
 ;;00078-0451-05
 ;;9002226.02101,"1729,00078-0452-05 ",.01)
 ;;00078-0452-05
 ;;9002226.02101,"1729,00078-0452-05 ",.02)
 ;;00078-0452-05
 ;;9002226.02101,"1729,00078-0453-05 ",.01)
 ;;00078-0453-05
 ;;9002226.02101,"1729,00078-0453-05 ",.02)
 ;;00078-0453-05
 ;;9002226.02101,"1729,00078-0454-05 ",.01)
 ;;00078-0454-05
 ;;9002226.02101,"1729,00078-0454-05 ",.02)
 ;;00078-0454-05
 ;;9002226.02101,"1729,00078-0471-11 ",.01)
 ;;00078-0471-11
 ;;9002226.02101,"1729,00078-0471-11 ",.02)
 ;;00078-0471-11
 ;;9002226.02101,"1729,00078-0471-15 ",.01)
 ;;00078-0471-15
 ;;9002226.02101,"1729,00078-0471-15 ",.02)
 ;;00078-0471-15
 ;;9002226.02101,"1729,00078-0471-34 ",.01)
 ;;00078-0471-34
 ;;9002226.02101,"1729,00078-0471-34 ",.02)
 ;;00078-0471-34
 ;;9002226.02101,"1729,00078-0471-67 ",.01)
 ;;00078-0471-67
 ;;9002226.02101,"1729,00078-0471-67 ",.02)
 ;;00078-0471-67
 ;;9002226.02101,"1729,00078-0472-11 ",.01)
 ;;00078-0472-11
 ;;9002226.02101,"1729,00078-0472-11 ",.02)
 ;;00078-0472-11
 ;;9002226.02101,"1729,00078-0472-15 ",.01)
 ;;00078-0472-15
 ;;9002226.02101,"1729,00078-0472-15 ",.02)
 ;;00078-0472-15
 ;;9002226.02101,"1729,00078-0472-34 ",.01)
 ;;00078-0472-34
 ;;9002226.02101,"1729,00078-0472-34 ",.02)
 ;;00078-0472-34
 ;;9002226.02101,"1729,00078-0472-67 ",.01)
 ;;00078-0472-67
 ;;9002226.02101,"1729,00078-0472-67 ",.02)
 ;;00078-0472-67
 ;;9002226.02101,"1729,00078-0485-15 ",.01)
 ;;00078-0485-15
 ;;9002226.02101,"1729,00078-0485-15 ",.02)
 ;;00078-0485-15
 ;;9002226.02101,"1729,00078-0485-35 ",.01)
 ;;00078-0485-35
 ;;9002226.02101,"1729,00078-0485-35 ",.02)
 ;;00078-0485-35
 ;;9002226.02101,"1729,00078-0485-61 ",.01)
 ;;00078-0485-61
 ;;9002226.02101,"1729,00078-0485-61 ",.02)
 ;;00078-0485-61
 ;;9002226.02101,"1729,00078-0486-15 ",.01)
 ;;00078-0486-15
 ;;9002226.02101,"1729,00078-0486-15 ",.02)
 ;;00078-0486-15
 ;;9002226.02101,"1729,00078-0486-35 ",.01)
 ;;00078-0486-35
 ;;9002226.02101,"1729,00078-0486-35 ",.02)
 ;;00078-0486-35
 ;;9002226.02101,"1729,00078-0486-61 ",.01)
 ;;00078-0486-61
 ;;9002226.02101,"1729,00078-0486-61 ",.02)
 ;;00078-0486-61
 ;;9002226.02101,"1729,00078-0488-15 ",.01)
 ;;00078-0488-15
 ;;9002226.02101,"1729,00078-0488-15 ",.02)
 ;;00078-0488-15
 ;;9002226.02101,"1729,00078-0489-15 ",.01)
 ;;00078-0489-15
 ;;9002226.02101,"1729,00078-0489-15 ",.02)
 ;;00078-0489-15
 ;;9002226.02101,"1729,00078-0490-15 ",.01)
 ;;00078-0490-15
 ;;9002226.02101,"1729,00078-0490-15 ",.02)
 ;;00078-0490-15
 ;;9002226.02101,"1729,00078-0491-15 ",.01)
 ;;00078-0491-15
 ;;9002226.02101,"1729,00078-0491-15 ",.02)
 ;;00078-0491-15
 ;;9002226.02101,"1729,00078-0521-15 ",.01)
 ;;00078-0521-15
 ;;9002226.02101,"1729,00078-0521-15 ",.02)
 ;;00078-0521-15
 ;;9002226.02101,"1729,00078-0522-15 ",.01)
 ;;00078-0522-15
 ;;9002226.02101,"1729,00078-0522-15 ",.02)
 ;;00078-0522-15
 ;;9002226.02101,"1729,00078-0523-15 ",.01)
 ;;00078-0523-15
 ;;9002226.02101,"1729,00078-0523-15 ",.02)
 ;;00078-0523-15
 ;;9002226.02101,"1729,00078-0524-15 ",.01)
 ;;00078-0524-15
 ;;9002226.02101,"1729,00078-0524-15 ",.02)
 ;;00078-0524-15
 ;;9002226.02101,"1729,00078-0559-15 ",.01)
 ;;00078-0559-15
 ;;9002226.02101,"1729,00078-0559-15 ",.02)
 ;;00078-0559-15
 ;;9002226.02101,"1729,00078-0560-15 ",.01)
 ;;00078-0560-15
 ;;9002226.02101,"1729,00078-0560-15 ",.02)
 ;;00078-0560-15
 ;;9002226.02101,"1729,00078-0561-15 ",.01)
 ;;00078-0561-15
 ;;9002226.02101,"1729,00078-0561-15 ",.02)
 ;;00078-0561-15
 ;;9002226.02101,"1729,00078-0562-15 ",.01)
 ;;00078-0562-15
 ;;9002226.02101,"1729,00078-0562-15 ",.02)
 ;;00078-0562-15
 ;;9002226.02101,"1729,00078-0563-15 ",.01)
 ;;00078-0563-15
 ;;9002226.02101,"1729,00078-0563-15 ",.02)
 ;;00078-0563-15
 ;;9002226.02101,"1729,00078-0572-15 ",.01)
 ;;00078-0572-15
 ;;9002226.02101,"1729,00078-0572-15 ",.02)
 ;;00078-0572-15
 ;;9002226.02101,"1729,00078-0574-15 ",.01)
 ;;00078-0574-15
 ;;9002226.02101,"1729,00078-0574-15 ",.02)
 ;;00078-0574-15
 ;;9002226.02101,"1729,00078-0603-15 ",.01)
 ;;00078-0603-15
 ;;9002226.02101,"1729,00078-0603-15 ",.02)
 ;;00078-0603-15
 ;;9002226.02101,"1729,00078-0604-15 ",.01)
 ;;00078-0604-15
 ;;9002226.02101,"1729,00078-0604-15 ",.02)
 ;;00078-0604-15
 ;;9002226.02101,"1729,00078-0605-15 ",.01)
 ;;00078-0605-15
 ;;9002226.02101,"1729,00078-0605-15 ",.02)
 ;;00078-0605-15
 ;;9002226.02101,"1729,00078-0606-15 ",.01)
 ;;00078-0606-15
 ;;9002226.02101,"1729,00078-0606-15 ",.02)
 ;;00078-0606-15
 ;;9002226.02101,"1729,00078-0610-15 ",.01)
 ;;00078-0610-15
 ;;9002226.02101,"1729,00078-0610-15 ",.02)
 ;;00078-0610-15
 ;;9002226.02101,"1729,00078-0611-15 ",.01)
 ;;00078-0611-15
 ;;9002226.02101,"1729,00078-0611-15 ",.02)
 ;;00078-0611-15
 ;;9002226.02101,"1729,00078-0612-15 ",.01)
 ;;00078-0612-15
 ;;9002226.02101,"1729,00078-0612-15 ",.02)
 ;;00078-0612-15
 ;;9002226.02101,"1729,00078-0613-15 ",.01)
 ;;00078-0613-15
 ;;9002226.02101,"1729,00078-0613-15 ",.02)
 ;;00078-0613-15
 ;;9002226.02101,"1729,00078-0614-15 ",.01)
 ;;00078-0614-15
 ;;9002226.02101,"1729,00078-0614-15 ",.02)
 ;;00078-0614-15
 ;;9002226.02101,"1729,00083-0057-30 ",.01)
 ;;00083-0057-30
 ;;9002226.02101,"1729,00083-0057-30 ",.02)
 ;;00083-0057-30
 ;;9002226.02101,"1729,00083-0059-30 ",.01)
 ;;00083-0059-30
 ;;9002226.02101,"1729,00083-0059-30 ",.02)
 ;;00083-0059-30
 ;;9002226.02101,"1729,00083-0059-32 ",.01)
 ;;00083-0059-32
 ;;9002226.02101,"1729,00083-0059-32 ",.02)
 ;;00083-0059-32
 ;;9002226.02101,"1729,00083-0059-90 ",.01)
 ;;00083-0059-90
 ;;9002226.02101,"1729,00083-0059-90 ",.02)
 ;;00083-0059-90
 ;;9002226.02101,"1729,00083-0063-30 ",.01)
 ;;00083-0063-30
 ;;9002226.02101,"1729,00083-0063-30 ",.02)
 ;;00083-0063-30
 ;;9002226.02101,"1729,00083-0063-32 ",.01)
 ;;00083-0063-32
 ;;9002226.02101,"1729,00083-0063-32 ",.02)
 ;;00083-0063-32
 ;;9002226.02101,"1729,00083-0063-90 ",.01)
 ;;00083-0063-90
 ;;9002226.02101,"1729,00083-0063-90 ",.02)
 ;;00083-0063-90
 ;;9002226.02101,"1729,00083-0072-30 ",.01)
 ;;00083-0072-30
 ;;9002226.02101,"1729,00083-0072-30 ",.02)
 ;;00083-0072-30
 ;;9002226.02101,"1729,00083-0074-30 ",.01)
 ;;00083-0074-30
 ;;9002226.02101,"1729,00083-0074-30 ",.02)
 ;;00083-0074-30
 ;;9002226.02101,"1729,00083-0075-30 ",.01)
 ;;00083-0075-30
 ;;9002226.02101,"1729,00083-0075-30 ",.02)
 ;;00083-0075-30
 ;;9002226.02101,"1729,00083-0079-30 ",.01)
 ;;00083-0079-30
 ;;9002226.02101,"1729,00083-0079-30 ",.02)
 ;;00083-0079-30
 ;;9002226.02101,"1729,00083-0079-32 ",.01)
 ;;00083-0079-32
 ;;9002226.02101,"1729,00083-0079-32 ",.02)
 ;;00083-0079-32
 ;;9002226.02101,"1729,00083-0079-90 ",.01)
 ;;00083-0079-90
 ;;9002226.02101,"1729,00083-0079-90 ",.02)
 ;;00083-0079-90
 ;;9002226.02101,"1729,00083-0094-30 ",.01)
 ;;00083-0094-30
 ;;9002226.02101,"1729,00083-0094-30 ",.02)
 ;;00083-0094-30
 ;;9002226.02101,"1729,00083-0094-32 ",.01)
 ;;00083-0094-32
 ;;9002226.02101,"1729,00083-0094-32 ",.02)
 ;;00083-0094-32
 ;;9002226.02101,"1729,00083-0094-90 ",.01)
 ;;00083-0094-90
 ;;9002226.02101,"1729,00083-0094-90 ",.02)
 ;;00083-0094-90
 ;;9002226.02101,"1729,00083-2255-30 ",.01)
 ;;00083-2255-30
 ;;9002226.02101,"1729,00083-2255-30 ",.02)
 ;;00083-2255-30
 ;;9002226.02101,"1729,00083-2260-30 ",.01)
 ;;00083-2260-30
 ;;9002226.02101,"1729,00083-2260-30 ",.02)
 ;;00083-2260-30
 ;;9002226.02101,"1729,00083-2265-30 ",.01)
 ;;00083-2265-30
 ;;9002226.02101,"1729,00083-2265-30 ",.02)
 ;;00083-2265-30
 ;;9002226.02101,"1729,00087-0158-46 ",.01)
 ;;00087-0158-46
 ;;9002226.02101,"1729,00087-0158-46 ",.02)
 ;;00087-0158-46
