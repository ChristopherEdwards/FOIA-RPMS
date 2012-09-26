BGP2TD23 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1729,12280-0066-30 ",.01)
 ;;12280-0066-30
 ;;9002226.02101,"1729,12280-0066-30 ",.02)
 ;;12280-0066-30
 ;;9002226.02101,"1729,12280-0067-15 ",.01)
 ;;12280-0067-15
 ;;9002226.02101,"1729,12280-0067-15 ",.02)
 ;;12280-0067-15
 ;;9002226.02101,"1729,12280-0067-30 ",.01)
 ;;12280-0067-30
 ;;9002226.02101,"1729,12280-0067-30 ",.02)
 ;;12280-0067-30
 ;;9002226.02101,"1729,12280-0067-90 ",.01)
 ;;12280-0067-90
 ;;9002226.02101,"1729,12280-0067-90 ",.02)
 ;;12280-0067-90
 ;;9002226.02101,"1729,12280-0120-30 ",.01)
 ;;12280-0120-30
 ;;9002226.02101,"1729,12280-0120-30 ",.02)
 ;;12280-0120-30
 ;;9002226.02101,"1729,12280-0121-30 ",.01)
 ;;12280-0121-30
 ;;9002226.02101,"1729,12280-0121-30 ",.02)
 ;;12280-0121-30
 ;;9002226.02101,"1729,12280-0123-30 ",.01)
 ;;12280-0123-30
 ;;9002226.02101,"1729,12280-0123-30 ",.02)
 ;;12280-0123-30
 ;;9002226.02101,"1729,12280-0124-30 ",.01)
 ;;12280-0124-30
 ;;9002226.02101,"1729,12280-0124-30 ",.02)
 ;;12280-0124-30
 ;;9002226.02101,"1729,12280-0126-30 ",.01)
 ;;12280-0126-30
 ;;9002226.02101,"1729,12280-0126-30 ",.02)
 ;;12280-0126-30
 ;;9002226.02101,"1729,12280-0126-60 ",.01)
 ;;12280-0126-60
 ;;9002226.02101,"1729,12280-0126-60 ",.02)
 ;;12280-0126-60
 ;;9002226.02101,"1729,12280-0127-30 ",.01)
 ;;12280-0127-30
 ;;9002226.02101,"1729,12280-0127-30 ",.02)
 ;;12280-0127-30
 ;;9002226.02101,"1729,12280-0129-60 ",.01)
 ;;12280-0129-60
 ;;9002226.02101,"1729,12280-0129-60 ",.02)
 ;;12280-0129-60
 ;;9002226.02101,"1729,12280-0144-00 ",.01)
 ;;12280-0144-00
 ;;9002226.02101,"1729,12280-0144-00 ",.02)
 ;;12280-0144-00
 ;;9002226.02101,"1729,12280-0168-30 ",.01)
 ;;12280-0168-30
 ;;9002226.02101,"1729,12280-0168-30 ",.02)
 ;;12280-0168-30
 ;;9002226.02101,"1729,12280-0168-90 ",.01)
 ;;12280-0168-90
 ;;9002226.02101,"1729,12280-0168-90 ",.02)
 ;;12280-0168-90
 ;;9002226.02101,"1729,12280-0183-30 ",.01)
 ;;12280-0183-30
 ;;9002226.02101,"1729,12280-0183-30 ",.02)
 ;;12280-0183-30
 ;;9002226.02101,"1729,12280-0220-00 ",.01)
 ;;12280-0220-00
 ;;9002226.02101,"1729,12280-0220-00 ",.02)
 ;;12280-0220-00
 ;;9002226.02101,"1729,12280-0228-90 ",.01)
 ;;12280-0228-90
 ;;9002226.02101,"1729,12280-0228-90 ",.02)
 ;;12280-0228-90
 ;;9002226.02101,"1729,12280-0340-30 ",.01)
 ;;12280-0340-30
 ;;9002226.02101,"1729,12280-0340-30 ",.02)
 ;;12280-0340-30
 ;;9002226.02101,"1729,12280-0369-30 ",.01)
 ;;12280-0369-30
 ;;9002226.02101,"1729,12280-0369-30 ",.02)
 ;;12280-0369-30
 ;;9002226.02101,"1729,12280-0369-90 ",.01)
 ;;12280-0369-90
 ;;9002226.02101,"1729,12280-0369-90 ",.02)
 ;;12280-0369-90
 ;;9002226.02101,"1729,12280-0370-30 ",.01)
 ;;12280-0370-30
 ;;9002226.02101,"1729,12280-0370-30 ",.02)
 ;;12280-0370-30
 ;;9002226.02101,"1729,12280-0370-90 ",.01)
 ;;12280-0370-90
 ;;9002226.02101,"1729,12280-0370-90 ",.02)
 ;;12280-0370-90
 ;;9002226.02101,"1729,12280-0371-30 ",.01)
 ;;12280-0371-30
 ;;9002226.02101,"1729,12280-0371-30 ",.02)
 ;;12280-0371-30
 ;;9002226.02101,"1729,12280-0371-90 ",.01)
 ;;12280-0371-90
 ;;9002226.02101,"1729,12280-0371-90 ",.02)
 ;;12280-0371-90
 ;;9002226.02101,"1729,12280-0375-30 ",.01)
 ;;12280-0375-30
 ;;9002226.02101,"1729,12280-0375-30 ",.02)
 ;;12280-0375-30
 ;;9002226.02101,"1729,12280-0375-90 ",.01)
 ;;12280-0375-90
 ;;9002226.02101,"1729,12280-0375-90 ",.02)
 ;;12280-0375-90
 ;;9002226.02101,"1729,12280-0378-90 ",.01)
 ;;12280-0378-90
 ;;9002226.02101,"1729,12280-0378-90 ",.02)
 ;;12280-0378-90
 ;;9002226.02101,"1729,12280-0379-90 ",.01)
 ;;12280-0379-90
 ;;9002226.02101,"1729,12280-0379-90 ",.02)
 ;;12280-0379-90
 ;;9002226.02101,"1729,12280-0380-30 ",.01)
 ;;12280-0380-30
 ;;9002226.02101,"1729,12280-0380-30 ",.02)
 ;;12280-0380-30
 ;;9002226.02101,"1729,12280-0380-90 ",.01)
 ;;12280-0380-90
 ;;9002226.02101,"1729,12280-0380-90 ",.02)
 ;;12280-0380-90
 ;;9002226.02101,"1729,12280-0382-30 ",.01)
 ;;12280-0382-30
 ;;9002226.02101,"1729,12280-0382-30 ",.02)
 ;;12280-0382-30
 ;;9002226.02101,"1729,12280-0383-30 ",.01)
 ;;12280-0383-30
 ;;9002226.02101,"1729,12280-0383-30 ",.02)
 ;;12280-0383-30
 ;;9002226.02101,"1729,12280-0400-30 ",.01)
 ;;12280-0400-30
 ;;9002226.02101,"1729,12280-0400-30 ",.02)
 ;;12280-0400-30
 ;;9002226.02101,"1729,13411-0106-01 ",.01)
 ;;13411-0106-01
 ;;9002226.02101,"1729,13411-0106-01 ",.02)
 ;;13411-0106-01
 ;;9002226.02101,"1729,13411-0106-03 ",.01)
 ;;13411-0106-03
 ;;9002226.02101,"1729,13411-0106-03 ",.02)
 ;;13411-0106-03
 ;;9002226.02101,"1729,13411-0106-06 ",.01)
 ;;13411-0106-06
 ;;9002226.02101,"1729,13411-0106-06 ",.02)
 ;;13411-0106-06
 ;;9002226.02101,"1729,13411-0106-09 ",.01)
 ;;13411-0106-09
 ;;9002226.02101,"1729,13411-0106-09 ",.02)
 ;;13411-0106-09
 ;;9002226.02101,"1729,13411-0106-15 ",.01)
 ;;13411-0106-15
 ;;9002226.02101,"1729,13411-0106-15 ",.02)
 ;;13411-0106-15
 ;;9002226.02101,"1729,13411-0107-01 ",.01)
 ;;13411-0107-01
 ;;9002226.02101,"1729,13411-0107-01 ",.02)
 ;;13411-0107-01
 ;;9002226.02101,"1729,13411-0107-03 ",.01)
 ;;13411-0107-03
 ;;9002226.02101,"1729,13411-0107-03 ",.02)
 ;;13411-0107-03
 ;;9002226.02101,"1729,13411-0107-06 ",.01)
 ;;13411-0107-06
 ;;9002226.02101,"1729,13411-0107-06 ",.02)
 ;;13411-0107-06
 ;;9002226.02101,"1729,13411-0107-09 ",.01)
 ;;13411-0107-09
 ;;9002226.02101,"1729,13411-0107-09 ",.02)
 ;;13411-0107-09
 ;;9002226.02101,"1729,13411-0107-15 ",.01)
 ;;13411-0107-15
 ;;9002226.02101,"1729,13411-0107-15 ",.02)
 ;;13411-0107-15
 ;;9002226.02101,"1729,13411-0142-01 ",.01)
 ;;13411-0142-01
 ;;9002226.02101,"1729,13411-0142-01 ",.02)
 ;;13411-0142-01
 ;;9002226.02101,"1729,13411-0142-02 ",.01)
 ;;13411-0142-02
 ;;9002226.02101,"1729,13411-0142-02 ",.02)
 ;;13411-0142-02
 ;;9002226.02101,"1729,13411-0142-03 ",.01)
 ;;13411-0142-03
 ;;9002226.02101,"1729,13411-0142-03 ",.02)
 ;;13411-0142-03
 ;;9002226.02101,"1729,13411-0142-06 ",.01)
 ;;13411-0142-06
 ;;9002226.02101,"1729,13411-0142-06 ",.02)
 ;;13411-0142-06
 ;;9002226.02101,"1729,13411-0142-09 ",.01)
 ;;13411-0142-09
 ;;9002226.02101,"1729,13411-0142-09 ",.02)
 ;;13411-0142-09
 ;;9002226.02101,"1729,13411-0143-01 ",.01)
 ;;13411-0143-01
 ;;9002226.02101,"1729,13411-0143-01 ",.02)
 ;;13411-0143-01
 ;;9002226.02101,"1729,13411-0143-02 ",.01)
 ;;13411-0143-02
 ;;9002226.02101,"1729,13411-0143-02 ",.02)
 ;;13411-0143-02
 ;;9002226.02101,"1729,13411-0143-03 ",.01)
 ;;13411-0143-03
 ;;9002226.02101,"1729,13411-0143-03 ",.02)
 ;;13411-0143-03
 ;;9002226.02101,"1729,13411-0143-06 ",.01)
 ;;13411-0143-06
 ;;9002226.02101,"1729,13411-0143-06 ",.02)
 ;;13411-0143-06
 ;;9002226.02101,"1729,13411-0143-09 ",.01)
 ;;13411-0143-09
 ;;9002226.02101,"1729,13411-0143-09 ",.02)
 ;;13411-0143-09
 ;;9002226.02101,"1729,13411-0144-01 ",.01)
 ;;13411-0144-01
 ;;9002226.02101,"1729,13411-0144-01 ",.02)
 ;;13411-0144-01
 ;;9002226.02101,"1729,13411-0144-02 ",.01)
 ;;13411-0144-02
 ;;9002226.02101,"1729,13411-0144-02 ",.02)
 ;;13411-0144-02
 ;;9002226.02101,"1729,13411-0144-03 ",.01)
 ;;13411-0144-03
 ;;9002226.02101,"1729,13411-0144-03 ",.02)
 ;;13411-0144-03
 ;;9002226.02101,"1729,13411-0144-06 ",.01)
 ;;13411-0144-06
 ;;9002226.02101,"1729,13411-0144-06 ",.02)
 ;;13411-0144-06
 ;;9002226.02101,"1729,13411-0144-09 ",.01)
 ;;13411-0144-09
 ;;9002226.02101,"1729,13411-0144-09 ",.02)
 ;;13411-0144-09
 ;;9002226.02101,"1729,13411-0145-01 ",.01)
 ;;13411-0145-01
 ;;9002226.02101,"1729,13411-0145-01 ",.02)
 ;;13411-0145-01
 ;;9002226.02101,"1729,13411-0145-02 ",.01)
 ;;13411-0145-02
 ;;9002226.02101,"1729,13411-0145-02 ",.02)
 ;;13411-0145-02
 ;;9002226.02101,"1729,13411-0145-03 ",.01)
 ;;13411-0145-03
 ;;9002226.02101,"1729,13411-0145-03 ",.02)
 ;;13411-0145-03
 ;;9002226.02101,"1729,13411-0145-06 ",.01)
 ;;13411-0145-06
 ;;9002226.02101,"1729,13411-0145-06 ",.02)
 ;;13411-0145-06
 ;;9002226.02101,"1729,13411-0145-09 ",.01)
 ;;13411-0145-09
 ;;9002226.02101,"1729,13411-0145-09 ",.02)
 ;;13411-0145-09
 ;;9002226.02101,"1729,13411-0156-01 ",.01)
 ;;13411-0156-01
 ;;9002226.02101,"1729,13411-0156-01 ",.02)
 ;;13411-0156-01
 ;;9002226.02101,"1729,13411-0156-02 ",.01)
 ;;13411-0156-02
 ;;9002226.02101,"1729,13411-0156-02 ",.02)
 ;;13411-0156-02
 ;;9002226.02101,"1729,13411-0156-03 ",.01)
 ;;13411-0156-03
 ;;9002226.02101,"1729,13411-0156-03 ",.02)
 ;;13411-0156-03
 ;;9002226.02101,"1729,13411-0156-06 ",.01)
 ;;13411-0156-06
 ;;9002226.02101,"1729,13411-0156-06 ",.02)
 ;;13411-0156-06
 ;;9002226.02101,"1729,13411-0156-09 ",.01)
 ;;13411-0156-09
 ;;9002226.02101,"1729,13411-0156-09 ",.02)
 ;;13411-0156-09
 ;;9002226.02101,"1729,13411-0184-02 ",.01)
 ;;13411-0184-02
 ;;9002226.02101,"1729,13411-0184-02 ",.02)
 ;;13411-0184-02
 ;;9002226.02101,"1729,13411-0184-03 ",.01)
 ;;13411-0184-03
 ;;9002226.02101,"1729,13411-0184-03 ",.02)
 ;;13411-0184-03
 ;;9002226.02101,"1729,13411-0184-06 ",.01)
 ;;13411-0184-06
 ;;9002226.02101,"1729,13411-0184-06 ",.02)
 ;;13411-0184-06
 ;;9002226.02101,"1729,13411-0184-09 ",.01)
 ;;13411-0184-09
 ;;9002226.02101,"1729,13411-0184-09 ",.02)
 ;;13411-0184-09
 ;;9002226.02101,"1729,13411-0184-10 ",.01)
 ;;13411-0184-10
 ;;9002226.02101,"1729,13411-0184-10 ",.02)
 ;;13411-0184-10
 ;;9002226.02101,"1729,13668-0113-10 ",.01)
 ;;13668-0113-10
 ;;9002226.02101,"1729,13668-0113-10 ",.02)
 ;;13668-0113-10
 ;;9002226.02101,"1729,13668-0113-90 ",.01)
 ;;13668-0113-90
 ;;9002226.02101,"1729,13668-0113-90 ",.02)
 ;;13668-0113-90
 ;;9002226.02101,"1729,13668-0114-10 ",.01)
 ;;13668-0114-10
 ;;9002226.02101,"1729,13668-0114-10 ",.02)
 ;;13668-0114-10
 ;;9002226.02101,"1729,13668-0114-30 ",.01)
 ;;13668-0114-30
 ;;9002226.02101,"1729,13668-0114-30 ",.02)
 ;;13668-0114-30
 ;;9002226.02101,"1729,13668-0114-90 ",.01)
 ;;13668-0114-90
 ;;9002226.02101,"1729,13668-0114-90 ",.02)
 ;;13668-0114-90
 ;;9002226.02101,"1729,13668-0115-10 ",.01)
 ;;13668-0115-10
 ;;9002226.02101,"1729,13668-0115-10 ",.02)
 ;;13668-0115-10
 ;;9002226.02101,"1729,13668-0115-30 ",.01)
 ;;13668-0115-30
 ;;9002226.02101,"1729,13668-0115-30 ",.02)
 ;;13668-0115-30
 ;;9002226.02101,"1729,13668-0115-90 ",.01)
 ;;13668-0115-90
 ;;9002226.02101,"1729,13668-0115-90 ",.02)
 ;;13668-0115-90
 ;;9002226.02101,"1729,13668-0116-10 ",.01)
 ;;13668-0116-10
 ;;9002226.02101,"1729,13668-0116-10 ",.02)
 ;;13668-0116-10
 ;;9002226.02101,"1729,13668-0116-30 ",.01)
 ;;13668-0116-30
 ;;9002226.02101,"1729,13668-0116-30 ",.02)
 ;;13668-0116-30
 ;;9002226.02101,"1729,13668-0116-90 ",.01)
 ;;13668-0116-90
 ;;9002226.02101,"1729,13668-0116-90 ",.02)
 ;;13668-0116-90
 ;;9002226.02101,"1729,13668-0117-10 ",.01)
 ;;13668-0117-10
 ;;9002226.02101,"1729,13668-0117-10 ",.02)
 ;;13668-0117-10
 ;;9002226.02101,"1729,13668-0117-30 ",.01)
 ;;13668-0117-30
 ;;9002226.02101,"1729,13668-0117-30 ",.02)
 ;;13668-0117-30
 ;;9002226.02101,"1729,13668-0117-90 ",.01)
 ;;13668-0117-90
 ;;9002226.02101,"1729,13668-0117-90 ",.02)
 ;;13668-0117-90
 ;;9002226.02101,"1729,13668-0118-10 ",.01)
 ;;13668-0118-10
 ;;9002226.02101,"1729,13668-0118-10 ",.02)
 ;;13668-0118-10
 ;;9002226.02101,"1729,13668-0118-30 ",.01)
 ;;13668-0118-30
 ;;9002226.02101,"1729,13668-0118-30 ",.02)
 ;;13668-0118-30
 ;;9002226.02101,"1729,13668-0118-90 ",.01)
 ;;13668-0118-90
 ;;9002226.02101,"1729,13668-0118-90 ",.02)
 ;;13668-0118-90
 ;;9002226.02101,"1729,13668-0409-10 ",.01)
 ;;13668-0409-10
 ;;9002226.02101,"1729,13668-0409-10 ",.02)
 ;;13668-0409-10
 ;;9002226.02101,"1729,13668-0409-30 ",.01)
 ;;13668-0409-30
 ;;9002226.02101,"1729,13668-0409-30 ",.02)
 ;;13668-0409-30
 ;;9002226.02101,"1729,13668-0409-90 ",.01)
 ;;13668-0409-90
 ;;9002226.02101,"1729,13668-0409-90 ",.02)
 ;;13668-0409-90
 ;;9002226.02101,"1729,15338-0200-30 ",.01)
 ;;15338-0200-30
 ;;9002226.02101,"1729,15338-0200-30 ",.02)
 ;;15338-0200-30
 ;;9002226.02101,"1729,15338-0211-30 ",.01)
 ;;15338-0211-30
 ;;9002226.02101,"1729,15338-0211-30 ",.02)
 ;;15338-0211-30
 ;;9002226.02101,"1729,15338-0220-30 ",.01)
 ;;15338-0220-30
 ;;9002226.02101,"1729,15338-0220-30 ",.02)
 ;;15338-0220-30
 ;;9002226.02101,"1729,15338-0222-30 ",.01)
 ;;15338-0222-30
 ;;9002226.02101,"1729,15338-0222-30 ",.02)
 ;;15338-0222-30
 ;;9002226.02101,"1729,15338-0233-30 ",.01)
 ;;15338-0233-30
 ;;9002226.02101,"1729,15338-0233-30 ",.02)
 ;;15338-0233-30
 ;;9002226.02101,"1729,16252-0541-30 ",.01)
 ;;16252-0541-30
 ;;9002226.02101,"1729,16252-0541-30 ",.02)
 ;;16252-0541-30
 ;;9002226.02101,"1729,16252-0542-90 ",.01)
 ;;16252-0542-90
 ;;9002226.02101,"1729,16252-0542-90 ",.02)
 ;;16252-0542-90
 ;;9002226.02101,"1729,16252-0543-90 ",.01)
 ;;16252-0543-90
 ;;9002226.02101,"1729,16252-0543-90 ",.02)
 ;;16252-0543-90
 ;;9002226.02101,"1729,16252-0570-30 ",.01)
 ;;16252-0570-30
 ;;9002226.02101,"1729,16252-0570-30 ",.02)
 ;;16252-0570-30
 ;;9002226.02101,"1729,16252-0571-01 ",.01)
 ;;16252-0571-01
 ;;9002226.02101,"1729,16252-0571-01 ",.02)
 ;;16252-0571-01
 ;;9002226.02101,"1729,16252-0571-50 ",.01)
 ;;16252-0571-50
 ;;9002226.02101,"1729,16252-0571-50 ",.02)
 ;;16252-0571-50
 ;;9002226.02101,"1729,16252-0572-01 ",.01)
 ;;16252-0572-01
 ;;9002226.02101,"1729,16252-0572-01 ",.02)
 ;;16252-0572-01
 ;;9002226.02101,"1729,16252-0572-50 ",.01)
 ;;16252-0572-50
 ;;9002226.02101,"1729,16252-0572-50 ",.02)
 ;;16252-0572-50
 ;;9002226.02101,"1729,16252-0573-01 ",.01)
 ;;16252-0573-01
 ;;9002226.02101,"1729,16252-0573-01 ",.02)
 ;;16252-0573-01
 ;;9002226.02101,"1729,16252-0573-50 ",.01)
 ;;16252-0573-50
 ;;9002226.02101,"1729,16252-0573-50 ",.02)
 ;;16252-0573-50
 ;;9002226.02101,"1729,16252-0610-01 ",.01)
 ;;16252-0610-01
