BHSFLOA ;IHS/CIA/MGH - Health Summary for Flowsheets ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;==================================================================
 ;Updated to use VA health summary
 ;Taken from APCHS12A
 ; IHS/TUCSON/LAB - PART 12A OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;2.0;IHS RPMS/PCC Health Summary;;JUN 24, 1997
 ;====================================================================
 ; ********** FLOWSHEET PRODUCTION **********
FLOWD ;ENTRY POINT
 N X
 S X=-BHSIVD\1+9999999 D REGDT4^GMTSU S BHSDAT=X
 S BHSP="",$P(BHSP,"-",BHSMXL+9)="" D CKP^GMTSUP Q:$D(GMTSQIT)  W:'GMTSNPG ?2,BHSP,! D:GMTSNPG FLOWHD^BHSFLOW
 D FLOWCKP^BHSFLOW Q:$D(GMTSQIT)
 W ?2,BHSDAT
 F BHSI=0:0 S BHSI=$O(BHSDB(BHSI)) Q:'BHSI  D FLOWCKP^BHSFLOW Q:$D(GMTSQIT)  D FLOWD2 W !
 Q
FLOWD2 F BHSJ=0:0 S BHSJ=$O(BHSTB(BHSJ)) Q:'BHSJ  W ?12+BHSTB(BHSJ),":",$G(BHSDB(BHSI,BHSJ))
 Q
