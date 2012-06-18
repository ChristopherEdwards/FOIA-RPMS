ATXPOV ; IHS/OHPRD/TMJ -  IF ICD CODE HAS A TAXON, ENTER PAT IN PT TAX FILE ;  
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/TUCSON/LAB - because of the check for the variable
 ;IHS/CMI/LAB - patch 1 to version 5.1 allows the autoupdating
 ;of complications in a CMS register triggered from PCC Data Entry
 ;6/20/2000
 ;APCDDATE at the top of this routine, bulletins were not being
 ;sent if the user was not using PCC Data Entry.  This has been
 ;changed so that bulletins will be fired even if the POV is
 ;created by a link from another package.
 ;Q:'$D(APCDDATE)!('$D(DA))!('$D(X))
 Q:'$D(DA)!('$D(X))
 I '$D(ATXAD),$P(^AUPNVPOV(DA,0),U,3) NEW AUPNPAT,APCDVSIT S ATXVIS=+^AUPNVSIT($P(^AUPNVPOV(DA,0),U,3),0) S:'$D(APCDVSIT) APCDVSIT=$P(^AUPNVPOV(DA,0),U,3) S:'$D(AUPNPAT) AUPNPAT=$P(^AUPNVPOV(DA,0),U,2)
 ;E  S ATXVIS=$P(APCDDATE,".")
 ;Set ATXVIS with visit Date
 E  S ATXVIS=$S($G(APCDDATE):$P(APCDDATE,"."),$G(APCDVSIT):$P($P(^AUPNVSIT(APCDVSIT,0),U),"."),1:"")
 Q:ATXVIS=""
 ;
 S ATXDI=X
 I '$O(^ICD9(ATXDI,9999999.41,0)) D CMSCMPL,EOJ Q  ;IHS/CMI/LAB
 ;
 D START
 D EOJ
 Q
 ;
START ;
 S ATXDT=0,ATXPD=AUPNPAT,ATXPOVDA=DA,ATXVISDA=APCDVSIT
 F ATXL=0:0 S ATXDT=$O(^ICD9(ATXDI,9999999.41,ATXDT)) Q:ATXDT'=+ATXDT  I $D(^ATXAX(ATXDT,0)) D CALL,BULLT
 D CMSCMPL ;IHS/CMI/LAB - cms complications
 Q
 ;
CALL ;SEE IF PT TAX FILE TO BE UPDATED
 Q:'$D(^ATXPAT(ATXDT,0))#2
 I ATXVIS<$P(^ATXAX(ATXDT,0),U,6) Q
 I $D(ATXAD) D DIEADD^ATXPAT Q
 I '$D(ATXAD) D DIEDEL^ATXPAT Q
 Q
 ;
BULLT ;CALL ROUTINE TO CREATE BULLETIN FOR THIS ICD CODE
 Q:'$D(ATXAD)
 Q:$P(^ATXAX(ATXDT,0),U,7)=""
 Q:'$D(^XMB(3.6,$P(^ATXAX(ATXDT,0),U,7),0))  ;quit if no bulletin
 I $P(^ATXAX(ATXDT,0),U,11)]"",$P(^AUPNVSIT(ATXVISDA,0),U,7)_"B"[$P(^ATXAX(ATXDT,0),U,11),($P(^AUPNVSIT(ATXVISDA,0),U,6)=$P(^ATXAX(ATXDT,0),U,3)!('$P(^ATXAX(ATXDT,0),U,3)))
 E  G X
 S ATXDOLH=$H_$R(1000)
 ;S ^TMP("ATXBUL",ATXDOLH,"ICD",ATXDI)=""
 ;S ^TMP("ATXBUL",ATXDOLH,"TAX",ATXDT)=""
 ;S ^TMP("ATXBUL",ATXDOLH,"POV",ATXPOVDA)=""
 ;FOR DEBUGGING ONLY - ********
 ;D EN^ATXBULL Q
 S ATXICD=ATXDI
 F %="ATXDI","ATXICD","ATXPOVDA","ATXDT","APCDPAT" S ZTSAVE(%)=""
 S ZTRTN="EN^ATXBULL"
 S ZTDESC="BULLETIN TRIGGER FROM PCC DATA ENTRY"
 S ZTIO=""
 S ZTDTH=$H,$P(ZTDTH,",",2)=$P(ZTDTH,",",2)+300
 D ^%ZTLOAD
 K ZTSK
X Q
 ;
EOJ ;
 K ATXDT,ATXL,ATXPD,ATXDI,ATXAD,ATXVIS,ATXDOLH,ATXPOVDA,ATXVISDA,ATXC,ATXR,ATXRCMS,ATXR1
 Q
 ;
CMSCMPL ;
 ;if this ICD code is in ^ACM(42.1,"DX", xref
 ;then get registers associated with it
 ;if this patient is on any of those registers, then update
 ;their complication list if this isn't already on their list
 S ATXDT=0,ATXPD=AUPNPAT
 ;maybe this should be tasked to the background ??
 Q:'$D(^ACM(42.1,"DX",ATXDI))  ;IHS/CMI/LAB - is it in DX xref
 NEW ATXC,ATXR,ATXR1
 S ATXC=0 F  S ATXC=$O(^ACM(42.1,"DX",ATXDI,ATXC)) Q:ATXC'=+ATXC  D
 .;process each complication
 .S ATXR1=0 F  S ATXR1=$O(^ACM(42.1,ATXC,"RG",ATXR1)) Q:ATXR1'=+ATXR1  D
 ..;process each register
 ..S ATXR=$P(^ACM(42.1,ATXC,"RG",ATXR1,0),U,1)
 ..Q:'$D(^ACM(41,"AC",ATXPD,ATXR))  ;patient not on this register
 ..S ATXRCMS=^ACM(41,"AC",ATXPD,ATXR)
 ..;update complication for this patient
 ..Q:$D(^ACM(42,"AC",ATXR,ATXPD,ATXC))  ;pt already has this complication
 ..;add complication to file
 ..;call xbnew
 ..D EN^XBNEW("CMSCMPL1^ATXPOV","ATX*")
 ..Q
 .Q
 Q
 ;
CMSCMPL1 ;EP called from XBNEW
 ;add complication to register for patient in ATXPD
 S DIADD=1,DLAYGO=9002242,X=ATXC,DIC="^ACM(42,",DIC("DR")=".02////"_ATXPD_";.03////"_ATXRCMS_";.04////"_ATXR,DIC(0)="L" K DD,D0,DO D FILE^DICN
 K DIC,DIADD,DLAYGO
 Q
