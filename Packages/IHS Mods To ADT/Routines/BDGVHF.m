BDGVHF ; IHS/ANMC/LJF - CREATE VHOSP IF MISSING ;  [ 05/31/2002  4:22 PM ]
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 04/26/2006 PATCH 1005 fixed date calls
 ;
 ;
 NEW BDGBD,BDGED
 ;IHS/OIT/LJF 04/26/2006 PATCH 1005
 ;S BDGBD=$$READ^BDGF("DO^::EQ","Beginning Discharge Date") Q:BDGBD<1
 ;S BDGED=$$READ^BDGF("DO^"_BDGBD_":"_DT_":EQ","Ending Discharge Date")
 S BDGBD=$$READ^BDGF("DO^::E","Beginning Discharge Date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^"_BDGBD_":"_DT_":E","Ending Discharge Date")
 ;
 Q:BDGED<1
 ;
 D ZIS^BDGF("PQ","LOOP^BDGVHF","FIX MISSING VHOSP","BDGBD;BDGED")
 Q
 ;
 ;
LOOP ;EP; loop thru discharges to check for missing vhosps
 NEW DATE,DGEND,DSC,ADM,VST
 U IO D INIT,HED
 ;
 S DATE=BDGBD-.0001,DGEND=BDGED+.2400
 F  S DATE=$O(^DGPM("ATT3",DATE)) Q:DATE=""!(DATE>DGEND)  D
 . S DSC=0
 . F  S DSC=$O(^DGPM("ATT3",DATE,DSC)) Q:DSC=""  D
 .. S ADM=$$GET1^DIQ(405,DSC,.14,"I") Q:'ADM   ;corresponding admission
 .. Q:'$G(^DGPM(ADM,0))                        ;bad pointer
 .. ;
 .. ;IHS/ANMC/LJF 5/29/2002 fixed setting of VST and added check for
 .. ;           deleted visit (per LJF3) 
 .. ;S VST=$P($G(^DGPM(ADM,"IHS")),U)
 .. ;I $O(^AUPNVINP("AD",+VST,0)) Q              ;entry okay
 .. S VST=$P($G(^DGPM(ADM,0)),U,27)
 .. I $O(^AUPNVINP("AD",+VST,0)),$P($G(^AUPNVSIT(+VST,0)),U,11)'=1 Q
 .. ;IHS/ANMC/LJF 5/29/2002 end of mods
 .. NEW DFN,DGPMA,DGPMCA
 .. S DFN=$$GET1^DIQ(405,DSC,.03,"I")     ;patient ien
 .. S DGPMA=$G(^DGPM(DSC,0))              ;discharge node
 .. S DGPMCA=ADM
 .. W !,$$GET1^DIQ(405,DSC,.01),?20,$$GET1^DIQ(2,DFN,.01)
 .. D ADDVH^BDGPCCL
 ;
 I $E(IOST,1,2)="C-" D PAUSE^BDGF
 D ^%ZISC
 Q
 ;
 ;
INIT ; initialize variables
 S DGPG=0,DGDUZ=$P(^VA(200,DUZ,0),U,2),DGSITE=$P(^DIC(4,DUZ(2),0),U)
 S DGLIN=$$REPEAT^XLFSTR("=",80),DGLIN2=$$REPEAT^XLFSTR("-",80)
 S DGQ=""
 Q
 ;
HED ; -- heading
 I (DGPG>0)!(IOST["C-") W @IOF
 W !,DGLIN S DGPG=DGPG+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGSITE)/2,DGSITE S DGTY="FIX MISSING V HOSP ENTRIES"
 W !,$$TIME^BDGF($$NOW^XLFDT),?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPG
 S Y=DT X ^DD("DD") W !,Y
 W !,DGLIN2,!
 Q
 ;
