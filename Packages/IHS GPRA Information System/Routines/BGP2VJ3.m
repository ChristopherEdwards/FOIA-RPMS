BGP2VJ3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 27, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"747,00182-1589-89 ",.02)
 ;;00182-1589-89
 ;;9002226.02101,"747,00182-1590-89 ",.01)
 ;;00182-1590-89
 ;;9002226.02101,"747,00182-1590-89 ",.02)
 ;;00182-1590-89
 ;;9002226.02101,"747,00186-0370-20 ",.01)
 ;;00186-0370-20
 ;;9002226.02101,"747,00186-0370-20 ",.02)
 ;;00186-0370-20
 ;;9002226.02101,"747,00186-0370-28 ",.01)
 ;;00186-0370-28
 ;;9002226.02101,"747,00186-0370-28 ",.02)
 ;;00186-0370-28
 ;;9002226.02101,"747,00186-0372-20 ",.01)
 ;;00186-0372-20
 ;;9002226.02101,"747,00186-0372-20 ",.02)
 ;;00186-0372-20
 ;;9002226.02101,"747,00186-0372-28 ",.01)
 ;;00186-0372-28
 ;;9002226.02101,"747,00186-0372-28 ",.02)
 ;;00186-0372-28
 ;;9002226.02101,"747,00186-0426-04 ",.01)
 ;;00186-0426-04
 ;;9002226.02101,"747,00186-0426-04 ",.02)
 ;;00186-0426-04
 ;;9002226.02101,"747,00186-0915-42 ",.01)
 ;;00186-0915-42
 ;;9002226.02101,"747,00186-0915-42 ",.02)
 ;;00186-0915-42
 ;;9002226.02101,"747,00186-0916-12 ",.01)
 ;;00186-0916-12
 ;;9002226.02101,"747,00186-0916-12 ",.02)
 ;;00186-0916-12
 ;;9002226.02101,"747,00186-0917-06 ",.01)
 ;;00186-0917-06
 ;;9002226.02101,"747,00186-0917-06 ",.02)
 ;;00186-0917-06
 ;;9002226.02101,"747,00186-1988-04 ",.01)
 ;;00186-1988-04
 ;;9002226.02101,"747,00186-1988-04 ",.02)
 ;;00186-1988-04
 ;;9002226.02101,"747,00186-1989-04 ",.01)
 ;;00186-1989-04
 ;;9002226.02101,"747,00186-1989-04 ",.02)
 ;;00186-1989-04
 ;;9002226.02101,"747,00186-1990-04 ",.01)
 ;;00186-1990-04
 ;;9002226.02101,"747,00186-1990-04 ",.02)
 ;;00186-1990-04
 ;;9002226.02101,"747,00223-6623-01 ",.01)
 ;;00223-6623-01
 ;;9002226.02101,"747,00223-6623-01 ",.02)
 ;;00223-6623-01
 ;;9002226.02101,"747,00247-0190-20 ",.01)
 ;;00247-0190-20
 ;;9002226.02101,"747,00247-0190-20 ",.02)
 ;;00247-0190-20
 ;;9002226.02101,"747,00247-0656-02 ",.01)
 ;;00247-0656-02
 ;;9002226.02101,"747,00247-0656-02 ",.02)
 ;;00247-0656-02
 ;;9002226.02101,"747,00247-0656-04 ",.01)
 ;;00247-0656-04
 ;;9002226.02101,"747,00247-0656-04 ",.02)
 ;;00247-0656-04
 ;;9002226.02101,"747,00247-0656-10 ",.01)
 ;;00247-0656-10
 ;;9002226.02101,"747,00247-0656-10 ",.02)
 ;;00247-0656-10
 ;;9002226.02101,"747,00247-0656-14 ",.01)
 ;;00247-0656-14
 ;;9002226.02101,"747,00247-0656-14 ",.02)
 ;;00247-0656-14
 ;;9002226.02101,"747,00247-0656-20 ",.01)
 ;;00247-0656-20
 ;;9002226.02101,"747,00247-0656-20 ",.02)
 ;;00247-0656-20
 ;;9002226.02101,"747,00247-0656-28 ",.01)
 ;;00247-0656-28
 ;;9002226.02101,"747,00247-0656-28 ",.02)
 ;;00247-0656-28
 ;;9002226.02101,"747,00247-0656-30 ",.01)
 ;;00247-0656-30
 ;;9002226.02101,"747,00247-0656-30 ",.02)
 ;;00247-0656-30
 ;;9002226.02101,"747,00247-0656-60 ",.01)
 ;;00247-0656-60
 ;;9002226.02101,"747,00247-0656-60 ",.02)
 ;;00247-0656-60
 ;;9002226.02101,"747,00247-0659-07 ",.01)
 ;;00247-0659-07
 ;;9002226.02101,"747,00247-0659-07 ",.02)
 ;;00247-0659-07
 ;;9002226.02101,"747,00247-0667-08 ",.01)
 ;;00247-0667-08
 ;;9002226.02101,"747,00247-0667-08 ",.02)
 ;;00247-0667-08
 ;;9002226.02101,"747,00247-0674-41 ",.01)
 ;;00247-0674-41
 ;;9002226.02101,"747,00247-0674-41 ",.02)
 ;;00247-0674-41
 ;;9002226.02101,"747,00247-0703-07 ",.01)
 ;;00247-0703-07
 ;;9002226.02101,"747,00247-0703-07 ",.02)
 ;;00247-0703-07
 ;;9002226.02101,"747,00247-0824-06 ",.01)
 ;;00247-0824-06
 ;;9002226.02101,"747,00247-0824-06 ",.02)
 ;;00247-0824-06
 ;;9002226.02101,"747,00247-0824-10 ",.01)
 ;;00247-0824-10
 ;;9002226.02101,"747,00247-0824-10 ",.02)
 ;;00247-0824-10
 ;;9002226.02101,"747,00247-0824-30 ",.01)
 ;;00247-0824-30
 ;;9002226.02101,"747,00247-0824-30 ",.02)
 ;;00247-0824-30
 ;;9002226.02101,"747,00247-0824-60 ",.01)
 ;;00247-0824-60
 ;;9002226.02101,"747,00247-0824-60 ",.02)
 ;;00247-0824-60
 ;;9002226.02101,"747,00247-0824-90 ",.01)
 ;;00247-0824-90
 ;;9002226.02101,"747,00247-0824-90 ",.02)
 ;;00247-0824-90
 ;;9002226.02101,"747,00247-0873-02 ",.01)
 ;;00247-0873-02
 ;;9002226.02101,"747,00247-0873-02 ",.02)
 ;;00247-0873-02
 ;;9002226.02101,"747,00247-0873-52 ",.01)
 ;;00247-0873-52
 ;;9002226.02101,"747,00247-0873-52 ",.02)
 ;;00247-0873-52
 ;;9002226.02101,"747,00247-0873-60 ",.01)
 ;;00247-0873-60
 ;;9002226.02101,"747,00247-0873-60 ",.02)
 ;;00247-0873-60
 ;;9002226.02101,"747,00247-1696-93 ",.01)
 ;;00247-1696-93
 ;;9002226.02101,"747,00247-1696-93 ",.02)
 ;;00247-1696-93
 ;;9002226.02101,"747,00247-1897-00 ",.01)
 ;;00247-1897-00
 ;;9002226.02101,"747,00247-1897-00 ",.02)
 ;;00247-1897-00
 ;;9002226.02101,"747,00247-1897-30 ",.01)
 ;;00247-1897-30
 ;;9002226.02101,"747,00247-1897-30 ",.02)
 ;;00247-1897-30
 ;;9002226.02101,"747,00247-1897-60 ",.01)
 ;;00247-1897-60
 ;;9002226.02101,"747,00247-1897-60 ",.02)
 ;;00247-1897-60
 ;;9002226.02101,"747,00247-1897-77 ",.01)
 ;;00247-1897-77
 ;;9002226.02101,"747,00247-1897-77 ",.02)
 ;;00247-1897-77
 ;;9002226.02101,"747,00247-1897-90 ",.01)
 ;;00247-1897-90
 ;;9002226.02101,"747,00247-1897-90 ",.02)
 ;;00247-1897-90
 ;;9002226.02101,"747,00247-1898-00 ",.01)
 ;;00247-1898-00
 ;;9002226.02101,"747,00247-1898-00 ",.02)
 ;;00247-1898-00
 ;;9002226.02101,"747,00247-1898-14 ",.01)
 ;;00247-1898-14
 ;;9002226.02101,"747,00247-1898-14 ",.02)
 ;;00247-1898-14
 ;;9002226.02101,"747,00247-1898-30 ",.01)
 ;;00247-1898-30
 ;;9002226.02101,"747,00247-1898-30 ",.02)
 ;;00247-1898-30
 ;;9002226.02101,"747,00247-1898-60 ",.01)
 ;;00247-1898-60
 ;;9002226.02101,"747,00247-1898-60 ",.02)
 ;;00247-1898-60
 ;;9002226.02101,"747,00247-1898-77 ",.01)
 ;;00247-1898-77
 ;;9002226.02101,"747,00247-1898-77 ",.02)
 ;;00247-1898-77
 ;;9002226.02101,"747,00247-1898-90 ",.01)
 ;;00247-1898-90
 ;;9002226.02101,"747,00247-1898-90 ",.02)
 ;;00247-1898-90
 ;;9002226.02101,"747,00247-1973-60 ",.01)
 ;;00247-1973-60
 ;;9002226.02101,"747,00247-1973-60 ",.02)
 ;;00247-1973-60
 ;;9002226.02101,"747,00247-1983-60 ",.01)
 ;;00247-1983-60
 ;;9002226.02101,"747,00247-1983-60 ",.02)
 ;;00247-1983-60
 ;;9002226.02101,"747,00247-1988-30 ",.01)
 ;;00247-1988-30
 ;;9002226.02101,"747,00247-1988-30 ",.02)
 ;;00247-1988-30
 ;;9002226.02101,"747,00247-2215-60 ",.01)
 ;;00247-2215-60
 ;;9002226.02101,"747,00247-2215-60 ",.02)
 ;;00247-2215-60
 ;;9002226.02101,"747,00258-3581-01 ",.01)
 ;;00258-3581-01
 ;;9002226.02101,"747,00258-3581-01 ",.02)
 ;;00258-3581-01
 ;;9002226.02101,"747,00258-3581-05 ",.01)
 ;;00258-3581-05
 ;;9002226.02101,"747,00258-3581-05 ",.02)
 ;;00258-3581-05
 ;;9002226.02101,"747,00258-3581-10 ",.01)
 ;;00258-3581-10
 ;;9002226.02101,"747,00258-3581-10 ",.02)
 ;;00258-3581-10
 ;;9002226.02101,"747,00258-3583-01 ",.01)
 ;;00258-3583-01
 ;;9002226.02101,"747,00258-3583-01 ",.02)
 ;;00258-3583-01
 ;;9002226.02101,"747,00258-3583-05 ",.01)
 ;;00258-3583-05
 ;;9002226.02101,"747,00258-3583-05 ",.02)
 ;;00258-3583-05
 ;;9002226.02101,"747,00258-3583-10 ",.01)
 ;;00258-3583-10
 ;;9002226.02101,"747,00258-3583-10 ",.02)
 ;;00258-3583-10
 ;;9002226.02101,"747,00258-3584-01 ",.01)
 ;;00258-3584-01
 ;;9002226.02101,"747,00258-3584-01 ",.02)
 ;;00258-3584-01
 ;;9002226.02101,"747,00258-3584-05 ",.01)
 ;;00258-3584-05
 ;;9002226.02101,"747,00258-3584-05 ",.02)
 ;;00258-3584-05
 ;;9002226.02101,"747,00258-3614-01 ",.01)
 ;;00258-3614-01
 ;;9002226.02101,"747,00258-3614-01 ",.02)
 ;;00258-3614-01
 ;;9002226.02101,"747,00258-3625-01 ",.01)
 ;;00258-3625-01
 ;;9002226.02101,"747,00258-3625-01 ",.02)
 ;;00258-3625-01
 ;;9002226.02101,"747,00258-3634-01 ",.01)
 ;;00258-3634-01
 ;;9002226.02101,"747,00258-3634-01 ",.02)
 ;;00258-3634-01
 ;;9002226.02101,"747,00258-3638-01 ",.01)
 ;;00258-3638-01
 ;;9002226.02101,"747,00258-3638-01 ",.02)
 ;;00258-3638-01
 ;;9002226.02101,"747,00281-1115-57 ",.01)
 ;;00281-1115-57
 ;;9002226.02101,"747,00281-1115-57 ",.02)
 ;;00281-1115-57
 ;;9002226.02101,"747,00281-1127-74 ",.01)
 ;;00281-1127-74
 ;;9002226.02101,"747,00281-1127-74 ",.02)
 ;;00281-1127-74
 ;;9002226.02101,"747,00310-0401-60 ",.01)
 ;;00310-0401-60
 ;;9002226.02101,"747,00310-0401-60 ",.02)
 ;;00310-0401-60
 ;;9002226.02101,"747,00310-0402-39 ",.01)
 ;;00310-0402-39
 ;;9002226.02101,"747,00310-0402-39 ",.02)
 ;;00310-0402-39
 ;;9002226.02101,"747,00310-0402-60 ",.01)
 ;;00310-0402-60
 ;;9002226.02101,"747,00310-0402-60 ",.02)
 ;;00310-0402-60
 ;;9002226.02101,"747,00310-0411-60 ",.01)
 ;;00310-0411-60
 ;;9002226.02101,"747,00310-0411-60 ",.02)
 ;;00310-0411-60
 ;;9002226.02101,"747,00310-0412-60 ",.01)
 ;;00310-0412-60
 ;;9002226.02101,"747,00310-0412-60 ",.02)
 ;;00310-0412-60
 ;;9002226.02101,"747,00430-0214-24 ",.01)
 ;;00430-0214-24
 ;;9002226.02101,"747,00430-0214-24 ",.02)
 ;;00430-0214-24
 ;;9002226.02101,"747,00430-0221-24 ",.01)
 ;;00430-0221-24
 ;;9002226.02101,"747,00430-0221-24 ",.02)
 ;;00430-0221-24
 ;;9002226.02101,"747,00456-0644-16 ",.01)
 ;;00456-0644-16
 ;;9002226.02101,"747,00456-0644-16 ",.02)
 ;;00456-0644-16
 ;;9002226.02101,"747,00456-0645-08 ",.01)
 ;;00456-0645-08
 ;;9002226.02101,"747,00456-0645-08 ",.02)
 ;;00456-0645-08
 ;;9002226.02101,"747,00456-0648-08 ",.01)
 ;;00456-0648-08
 ;;9002226.02101,"747,00456-0648-08 ",.02)
 ;;00456-0648-08
 ;;9002226.02101,"747,00456-0648-16 ",.01)
 ;;00456-0648-16
 ;;9002226.02101,"747,00456-0648-16 ",.02)
 ;;00456-0648-16
 ;;9002226.02101,"747,00456-0670-99 ",.01)
 ;;00456-0670-99
 ;;9002226.02101,"747,00456-0670-99 ",.02)
 ;;00456-0670-99
 ;;9002226.02101,"747,00456-0672-99 ",.01)
 ;;00456-0672-99
 ;;9002226.02101,"747,00456-0672-99 ",.02)
 ;;00456-0672-99
 ;;9002226.02101,"747,00456-3581-01 ",.01)
 ;;00456-3581-01
 ;;9002226.02101,"747,00456-3581-01 ",.02)
 ;;00456-3581-01
 ;;9002226.02101,"747,00456-3581-05 ",.01)
 ;;00456-3581-05
 ;;9002226.02101,"747,00456-3581-05 ",.02)
 ;;00456-3581-05
 ;;9002226.02101,"747,00456-3581-10 ",.01)
 ;;00456-3581-10
 ;;9002226.02101,"747,00456-3581-10 ",.02)
 ;;00456-3581-10
 ;;9002226.02101,"747,00456-4301-01 ",.01)
 ;;00456-4301-01
 ;;9002226.02101,"747,00456-4301-01 ",.02)
 ;;00456-4301-01
 ;;9002226.02101,"747,00456-4302-01 ",.01)
 ;;00456-4302-01
 ;;9002226.02101,"747,00456-4302-01 ",.02)
 ;;00456-4302-01
 ;;9002226.02101,"747,00456-4303-01 ",.01)
 ;;00456-4303-01
 ;;9002226.02101,"747,00456-4303-01 ",.02)
 ;;00456-4303-01
 ;;9002226.02101,"747,00456-4310-01 ",.01)
 ;;00456-4310-01
 ;;9002226.02101,"747,00456-4310-01 ",.02)
 ;;00456-4310-01
 ;;9002226.02101,"747,00456-4320-00 ",.01)
 ;;00456-4320-00
 ;;9002226.02101,"747,00456-4320-00 ",.02)
 ;;00456-4320-00
 ;;9002226.02101,"747,00456-4320-01 ",.01)
 ;;00456-4320-01
 ;;9002226.02101,"747,00456-4320-01 ",.02)
 ;;00456-4320-01
 ;;9002226.02101,"747,00456-4320-02 ",.01)
 ;;00456-4320-02
 ;;9002226.02101,"747,00456-4320-02 ",.02)
 ;;00456-4320-02
 ;;9002226.02101,"747,00456-4330-00 ",.01)
 ;;00456-4330-00
 ;;9002226.02101,"747,00456-4330-00 ",.02)
 ;;00456-4330-00
 ;;9002226.02101,"747,00456-4330-01 ",.01)
 ;;00456-4330-01
 ;;9002226.02101,"747,00456-4330-01 ",.02)
 ;;00456-4330-01
 ;;9002226.02101,"747,00456-4330-02 ",.01)
 ;;00456-4330-02
 ;;9002226.02101,"747,00456-4330-02 ",.02)
 ;;00456-4330-02
 ;;9002226.02101,"747,00456-4345-01 ",.01)
 ;;00456-4345-01
 ;;9002226.02101,"747,00456-4345-01 ",.02)
 ;;00456-4345-01
 ;;9002226.02101,"747,00463-9031-16 ",.01)
 ;;00463-9031-16
 ;;9002226.02101,"747,00463-9031-16 ",.02)
 ;;00463-9031-16
 ;;9002226.02101,"747,00472-0750-21 ",.01)
 ;;00472-0750-21
 ;;9002226.02101,"747,00472-0750-21 ",.02)
 ;;00472-0750-21
 ;;9002226.02101,"747,00472-0750-60 ",.01)
 ;;00472-0750-60
 ;;9002226.02101,"747,00472-0750-60 ",.02)
 ;;00472-0750-60
 ;;9002226.02101,"747,00472-0752-21 ",.01)
 ;;00472-0752-21
 ;;9002226.02101,"747,00472-0752-21 ",.02)
 ;;00472-0752-21
 ;;9002226.02101,"747,00472-0752-60 ",.01)
 ;;00472-0752-60
 ;;9002226.02101,"747,00472-0752-60 ",.02)
 ;;00472-0752-60
 ;;9002226.02101,"747,00472-1238-16 ",.01)
 ;;00472-1238-16
 ;;9002226.02101,"747,00472-1238-16 ",.02)
 ;;00472-1238-16
 ;;9002226.02101,"747,00485-0059-16 ",.01)
 ;;00485-0059-16
 ;;9002226.02101,"747,00485-0059-16 ",.02)
 ;;00485-0059-16
 ;;9002226.02101,"747,00490-0080-00 ",.01)
 ;;00490-0080-00
 ;;9002226.02101,"747,00490-0080-00 ",.02)
 ;;00490-0080-00
 ;;9002226.02101,"747,00490-0080-30 ",.01)
 ;;00490-0080-30
 ;;9002226.02101,"747,00490-0080-30 ",.02)
 ;;00490-0080-30
 ;;9002226.02101,"747,00490-0080-60 ",.01)
 ;;00490-0080-60
 ;;9002226.02101,"747,00490-0080-60 ",.02)
 ;;00490-0080-60
 ;;9002226.02101,"747,00490-0080-90 ",.01)
 ;;00490-0080-90
 ;;9002226.02101,"747,00490-0080-90 ",.02)
 ;;00490-0080-90
 ;;9002226.02101,"747,00525-0376-16 ",.01)
 ;;00525-0376-16
 ;;9002226.02101,"747,00525-0376-16 ",.02)
 ;;00525-0376-16
 ;;9002226.02101,"747,00551-0205-01 ",.01)
 ;;00551-0205-01
 ;;9002226.02101,"747,00551-0205-01 ",.02)
 ;;00551-0205-01
 ;;9002226.02101,"747,00585-0673-02 ",.01)
 ;;00585-0673-02
 ;;9002226.02101,"747,00585-0673-02 ",.02)
 ;;00585-0673-02
 ;;9002226.02101,"747,00585-0673-03 ",.01)
 ;;00585-0673-03
 ;;9002226.02101,"747,00585-0673-03 ",.02)
 ;;00585-0673-03
 ;;9002226.02101,"747,00603-1190-58 ",.01)
 ;;00603-1190-58
 ;;9002226.02101,"747,00603-1190-58 ",.02)
 ;;00603-1190-58
 ;;9002226.02101,"747,00603-5944-21 ",.01)
 ;;00603-5944-21
 ;;9002226.02101,"747,00603-5944-21 ",.02)
 ;;00603-5944-21
 ;;9002226.02101,"747,00603-5944-28 ",.01)
 ;;00603-5944-28
 ;;9002226.02101,"747,00603-5944-28 ",.02)
 ;;00603-5944-28
 ;;9002226.02101,"747,00603-5945-21 ",.01)
 ;;00603-5945-21
 ;;9002226.02101,"747,00603-5945-21 ",.02)
 ;;00603-5945-21
 ;;9002226.02101,"747,00603-5945-28 ",.01)
 ;;00603-5945-28
