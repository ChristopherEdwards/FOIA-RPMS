APCLCV1 ; IHS/CMI/LAB - Indian Beneficiary Calendar Year Visit Summary ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;APCL1 = New Patients 1st Visit (Indian)
 ;APCL2 = Est Patients 1st Visit (Indian)
 ;APCL3 = Total 1st Visits (Indian)
 ;APCL4 = Additional Visits (2nd,3rd, etc.) (Indian)
 ;APCLG = Total Vistis (Indian)
 ;
 ;APCL5 = Grand Total (All Visits)
 ;
 ;APCL1O = New Patients 1st Visit (Non-Indian)
 ;APCL2O = Est Patients 1st Visit (Non-Indian)
 ;APCL3O = Total 1st Visits (Non-Indian)
 ;APCL4O = Additional Visits (Non-Indian)
 ;APCLGO = Total Visits (Non-Indian)
 ;
 ;IHS/CMI/LAB - added comment lines below
 ;APCL1N = New Patients 1st Visit (tribe 970)
 ;APCL2N = Est Patients 1st Visit (tribe 970)
 ;APCL3N = Total 1st Visits (tribe 970)
 ;APCL4N = Additional Visits (tribe 970)
 ;APCLGN = Total Visits (tribe 970)
 ;
START ;
 S APCLBT=$H,APCLJOB=$J,APCL1=0,APCL2=0,APCL3=0,APCL4=0,APCL5=0,APCL1O=0,APCL2O=0,APCL3O=0,APCL4O=0,APCLG=0,APCLGO=0,(APCL1N,APCL2N,APCL3N,APCL4N,APCLGN)=0 ;IHS/CMI/LAB - added new vars to list
 S APCLSDD=$$FMADD^XLFDT(APCLBD,-1),APCLBDD=$$FMTE^XLFDT($E(APCLBD,1,3)_"0101")
 K ^XTMP("APCLCV",APCLJOB,APCLBT)
 D XTMP^APCLOSUT("APCLCV","PCC CALENDAR YR 1ST VISIT RPT")
V ; Run by visit date
 S APCLSD=APCLSD_".9999" F  S APCLSD=$O(^AUPNVSIT("B",APCLSD)) Q:APCLSD=""!((APCLSD\1)>APCLED)  D V1
 ;
XIT ;
 D EOJ
 S APCLET=$H
 Q
V1 ;
 S APCLVIEN="" F  S APCLVIEN=$O(^AUPNVSIT("B",APCLSD,APCLVIEN)) Q:APCLVIEN'=+APCLVIEN  I $D(^AUPNVSIT(APCLVIEN,0)) S APCLVREC=^(0) D PROC
 Q
PROC ;
 Q:'$P(APCLVREC,U,9)
 Q:$P(APCLVREC,U,11)
 Q:"ETC"[$P(APCLVREC,U,7)
 Q:$D(^APCLCNTL(4,11,"B",$P(APCLVREC,U,3)))
 I APCLLOC]"",APCLLOC'=$P(APCLVREC,U,6) Q
 S APCLCLIN=$P(APCLVREC,U,8)
 I APCLCLIN]"",$D(APCLCLNT),'$D(APCLCLNT(APCLCLIN)) Q
 I $D(APCLCLNT),APCLCLIN="" Q
 ;I APCLCL]"",APCLCL'=$P(APCLVREC,U,8) Q
 S DFN=$P(APCLVREC,U,5)
 Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 Q:'$D(^AUPNVPOV("AD",APCLVIEN))
 Q:'$D(^AUPNVPRV("AD",APCLVIEN))
 ;
GETCLASS ;
 S APCLTRIB=$$TRIBE^AUPNPAT(DFN,"C") ;IHS/CMI/LAB - get tribe code
 S APCLCLAS=$$BEN^AUPNPAT(DFN,"C")
 Q:APCLCLAS=""
 ;
 S APCL5=APCL5+1 ; Grand Total
 ;
 I $D(^XTMP("APCLCV",APCLJOB,APCLBT,"PATIENTS",DFN)) D SECONDV Q
 ;
FIRST ;First Visit Count No patient DFN in TMP Global
 ;
 S ^XTMP("APCLCV",APCLJOB,APCLBT,"PATIENTS",DFN)=""
 ;New Patients 1st Visit
 S APCLDTE=$P(^AUPNPAT(DFN,0),U,2) ; Date Patient Established
 I APCLDTE'<APCLBD,APCLDTE'>APCLED D  Q
 .I APCLTRIB=970 S APCL1N=APCL1N+1,APCL3N=APCL3N+1 Q  ;tribe 970 - 1st visit IHS/CMI/LAB
 .S:APCLCLAS="01" APCL1=APCL1+1 ;Indian - 1st Visit
 .S:APCLCLAS'="01" APCL1O=APCL1O+1 ;Non-Indian-1st Visit
 .S:APCLCLAS="01" APCL3=APCL3+1 ;Indian - Total 1st Visit
 .S:APCLCLAS'="01" APCL3O=APCL3O+1 ;Non-Indian - Total 1st Visit
 .Q
 ;Established Patients 1st Visit
 I '$$VST(DFN,APCLBDD,APCLSDD,APCLLOC,.APCLCLNT) D SECONDV Q
 I APCLTRIB=970 S APCL2N=APCL2N+1,APCL3N=APCL3N+1 Q  ;tribe 970 - 1st visit IHS/CMI/LAB
 S:APCLCLAS="01" APCL2=APCL2+1 ;Indian - Established Pt 1st Visit
 S:APCLCLAS'="01" APCL2O=APCL2O+1 ;Non-Indian - Est Pt 1st Visit
 S:APCLCLAS="01" APCL3=APCL3+1 ;Indian - Total Est 1st Visit
 S:APCLCLAS'="01" APCL3O=APCL3O+1 ;Non-Indian - Total Est 1st Visit
 Q
 ;
SECONDV ;Counts for Established Patients Additional Visits for Year
 ;
 I APCLTRIB=970 S APCL4N=APCL4N+1 Q  ;IHS/CMI/LAB - tribe 970 additional visits
 S:APCLCLAS="01" APCL4=APCL4+1 ;Indian-Est Pts Additional Visits
 S:APCLCLAS'="01" APCL4O=APCL4O+1 ;Non-Indian-Est Pts Additional Visits
 Q
EOJ K APCLVLOC,APCLVREC,APCLSKIP,APCLAP,APCLDISC,APCLDPTR,APCLLOCC,APCLCLN
 K X,X1,X2
 Q
 ;
 ;
VST(APCLCVP,APCLCVFD,APCLCVLD,APCLCVL,APCLCVC) ;return 1 if patient had a visit between APCLCVFD AND APCDCVLD, otherwise return 0
 I 'APCLCVP Q 0
 I $G(APCLCVFD)="" Q 0
 I $G(APCLCVLD)="" Q 0
 I $G(APCLCVL)="" S APCLCVL=""
 NEW X,APCL
 K APCL
 S X=APCLCVP_"^ALL VISITS;DURING "_APCLCVFD_"-"_$$FMTE^XLFDT(APCLCVLD) S E=$$START1^APCLDF(X,"APCL(")
 I '$D(APCL) Q 1
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X  D
 .S V=$P(APCL(X),U,5)
 .I '$P(^AUPNVSIT(V,0),U,9) K APCL(X)
 .I $P(^AUPNVSIT(V,0),U,11) K APCL(X)
 .Q:'$D(^AUPNVPOV("AD",V))
 .Q:'$D(^AUPNVPRV("AD",V))
 .I APCLCVL]"",$P(^AUPNVSIT(V,0),U,6)'=APCLCVL K APCL(X)
 .I "ETC"[$P(^AUPNVSIT(V,0),U,7) K APCL(X)
 .I $D(^APCLCNTL(4,11,"B",$P(^AUPNVSIT(V,0),U,3))) K APCL(X)
 .S C=$P(^AUPNVSIT(V,0),U,8) I C]"",$O(APCLCVC(0)),'$D(APCLCVC(C)) K APCL(X)
 .I $O(APCLCVC(0)),C="" K APCL(X)
 I $O(APCL(0)) Q 0
 Q 1
