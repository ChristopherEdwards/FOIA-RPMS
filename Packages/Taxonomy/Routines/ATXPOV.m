ATXPOV ; IHS/OHPRD/TMJ -  IF ICD CODE HAS A TAXON, ENTER PAT IN PT TAX FILE ; 07 Feb 2016  5:51 PM
 ;;5.1;TAXONOMY;**11,14,15**;FEB 04, 1997;Build 20
 ;IHS/TUCSON/LAB - because of the check for the variable
 ;IHS/CMI/LAB - patch 1 to version 5.1 allows the autoupdating
 ;of complications in a CMS register triggered from PCC Data Entry
 ;6/20/2000
 ;APCDDATE at the top of this routine, bulletins were not being
 ;sent if the user was not using PCC Data Entry.  This has been
 ;changed so that bulletins will be fired even if the POV is
 ;created by a link from another package.
 ;Q:'$D(APCDDATE)!('$D(DA))!('$D(X))
 Q:'$D(DA)!('$D(X))  ;DA IS DA OF aupnvpov, X is internal of ICD code
 NEW ATXPOVDA,ATXDI,ATXICD
 ;ATXVISI visit ien
 ;ATXVIS visit date
 ;ATXDFN patient dfn
 ;ATXPOVDA V POV ien
 ;kill side of xref, .03 exists
 S ATXPOVDA=DA
 S ATXDI=X   ;ien of icd code
 ;I $P(^AUPNVPOV(ATXPOVDA,0),U,3) S ATXVISI=$P(^AUPNVPOV(ATXPOVDA,0),U,3),ATXVIS=$$VD^APCLV(ATXVISI),ATXDFN=$P(^AUPNVPOV(ATXPOVDA,0),U,2)
 ;I '$D(ATXAD),$P(^AUPNVPOV(DA,0),U,3) S ATXVIS=+^AUPNVSIT($P(^AUPNVPOV(DA,0),U,3),0) S:'$D(APCDVSIT) APCDVSIT=$P(^AUPNVPOV(DA,0),U,3) S:'$D(AUPNPAT) AUPNPAT=$P(^AUPNVPOV(DA,0),U,2)
 ;E  S ATXVIS=$P(APCDDATE,".")
 ;Set ATXVIS with visit Date
 ;E  S ATXVIS=$S($G(APCDDATE):$P(APCDDATE,"."),$G(APCDVSIT):$P($P(^AUPNVSIT(APCDVSIT,0),U),"."),1:"")
 ;Q:ATXVIS=""
 ;
 ;I '$O(^ICD9(ATXDI,9999999.41,0)) D CMSCMPL,EOJ Q  ;IHS/CMI/LAB
 ;NEW FOR AICD 4.0
 ;loop "ABLT" and call ICD^ATXCHK with X
 NEW T,B,G,F
 S (B,G)=0 F  S B=$O(^ATXAX("ABLT",B)) Q:B'=+B!(G)  D
 .S T=0 F  S T=$O(^ATXAX("ABLT",B,T)) Q:T'=+T!(G)  D
 ..Q:'$D(^ATXAX(T,0))
 ..I $P(^ATXAX(T,0),U,15)'=80 Q
 ..I $$ICD^ATXCHK(ATXDI,T,9) S G=1
 .Q
 I 'G D CMSCMPL Q
 I '$D(ATXAD) D CMSCMPL Q  ;IF NOT IN SET SIDE THEN JUST DO COMPLICATIONS  ***LORI
 ;
 D START
 D EOJ
 Q
 ;
 ;
CALL ;SEE IF PT TAX FILE TO BE UPDATED
 Q:'$D(^ATXPAT(ATXDT,0))#2
 I ATXVIS<$P(^ATXAX(ATXDT,0),U,6) Q
 I $D(ATXAD) D DIEADD^ATXPAT Q
 I '$D(ATXAD) D DIEDEL^ATXPAT Q
 Q
 ;
START ;
 ;
 NEW ZTRTN,ZTSAVE,ZTDESC,ZTIO,ZTDTH,ZTSK,%
 S ATXICD=ATXDI
 F %="ATXPOVDA","ATXICD","ATXDI" S ZTSAVE(%)=""
 S ZTRTN="START1^ATXPOV"
 S ZTDESC="BULLETIN/COMPL TRIGGER FROM PCC DATA ENTRY"
 S ZTIO=""
 S ZTDTH=$H,$P(ZTDTH,",",2)=$P(ZTDTH,",",2)+300  ;CHANGE TO 300
 D ^%ZTLOAD
 K ZTSK
X Q
 ;
START1 ;EP = called from taskman
 ;call bulletin for any taxonomies that have this code
 S ATXDT=""
 S ATXB=0 F  S ATXB=$O(^ATXAX("ABLT",ATXB)) Q:ATXB'=+ATXB  D
 .S ATXT=0 F  S ATXT=$O(^ATXAX("ABLT",ATXB,ATXT)) Q:ATXT'=+ATXT  D
 ..S ATXDT="" I $$ICD^ATXCHK(ATXDI,ATXT,9) S ATXDT=ATXT D EN^ATXBULL
 .Q
 D CMSCMPL0
 I $D(ZTQUEUED) S ZTREQ="@"
EOJ ;
 K ATXDT,ATXL,ATXPD,ATXDI,ATXAD,ATXVIS,ATXDOLH,ATXPOVDA,ATXVISDA,ATXC,ATXR,ATXRCMS,ATXR1
 Q
 ;
CMSCMPL ;
 ;if this ICD code is in ^ACM(42.1,"DX", xref
 ;then get registers associated with it
 ;if this patient is on any of those registers, then update
 ;their complication list if this isn't already on their list
 ;S ATXDT=0,ATXPD=AUPNPAT
 ;maybe this should be tasked to the background ??
 Q:ATXDI=""
 Q:'$D(^ACM(42.1,"DX",ATXDI))  ;IHS/CMI/LAB - not in any complication list so don't bother
 ;task off to taskman
 ;G CMSCMPL0  ;LORI REMOVE
 NEW ZTRTN,ZTDESC,ZTIO,ZTDTH,ZTSK,%
 F %="ATXDI","ATXPOVDA" S ZTSAVE(%)=""
 S ZTRTN="CMSCMPL0^ATXPOV"
 S ZTDESC="CMS COMPL TRIGGER FROM PCC DATA ENTRY"
 S ZTIO=""
 S ZTDTH=$H,$P(ZTDTH,",",2)=$P(ZTDTH,",",2)+300
 D ^%ZTLOAD
 K ZTSK
 Q
CMSCMPL0 ;EP - called from taskman
 ;SET UP VARS
 Q:ATXDI=""
 Q:'$D(^ACM(42.1,"DX",ATXDI))  ;IHS/CMI/LAB - not in any complication list so don't bother
 NEW ATXC,ATXR,ATXRA,ATXPD
 S ATXPD=$P($G(^AUPNVPOV(ATXPOVDA,0)),U,2)  ;patient
 Q:'ATXPD  ;v pov must have been deleted
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
 ..S DIADD=1,DLAYGO=9002242,X=ATXC,DIC="^ACM(42,",DIC("DR")=".02////"_ATXPD_";.03////"_ATXRCMS_";.04////"_ATXR,DIC(0)="L" K DD,D0,DO D FILE^DICN
 ..K DIC,DIADD,DLAYGO
 Q
