BGP1XTV ; IHS/CMI/LAB - DISPLAY IND LISTS 15 Dec 2010 9:42 AM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("BGP")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BGP 11 TAXONOMY VIEW")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="VIEW CRS TAXONOMIES"
 Q
 ;
INIT ;EP -- init variables and list array
 K BGPTAX S BGPHIGH="",C=0,J=0
 S BGPT=""
 F  S BGPT=$O(^BGPTAXB("B",BGPT)) Q:BGPT=""  D
 .S BGPY=$O(^BGPTAXB("B",BGPT,0))
 .Q:'$O(^BGPTAXB(BGPY,12,0))
 .S BGPTYPE=$P(^BGPTAXB(BGPY,0),U,2),BGPDESC=$G(^BGPTAXB(BGPY,11,1,0)),BGPEDIT=$P(^BGPTAXB(BGPY,0),U,4),J=J+1
 .I BGPTYPE'="L" D  Q:'I
 ..S I=$O(^ATXAX("B",BGPT,0))
 .I BGPTYPE="L" D  Q:'I
 ..S I=$O(^ATXLAB("B",BGPT,0))
 .S BGPTAX(J,0)=J_")  "_BGPT
 .S $E(BGPTAX(J,0),38)=$$VAL^XBDIQ1(90377.08,BGPY,.02)
 .S $E(BGPTAX(J,0),55)=BGPDESC
 .S BGPTAX("IDX",J,J)=I_U_$S(BGPTYPE'="L":"T",1:"L")_U_BGPY
 .S C=C+1
 .Q
 S (VALMCNT,BGPHIGH)=C
 Q
 ;
 ;
 K BGPTAX S BGPHIGH="",C=0
 S T="",J=0,C=0 F  S T=$O(^BGPTAXB("B",T)) Q:T=""  D
 .S Y=0 F  S Y=$O(^BGPTAXB("B",T,Y)) Q:Y'=+Y  D
 ..S N=^BGPTAXB(Y,0)
 ..S Z=$P(N,U,2)  ;TYPE
 ..I Z="L" S BGPT=$O(^ATXLAB("B",T,0))
 ..I Z'="L" S BGPT=$O(^ATXAX("B",T,0))
 ..I Z="" Q
 ..S J=J+1
 ..S BGPTAX(J,0)=J_")  "_T,$E(BGPTAX(J,0),39)=$$VAL^XBDIQ1(90377.08,Y,.02) D
 ...S A="",B=0 F  S B=$O(^BGPTAXB(Y,12,B)) Q:B'=+B  S R=$P(^BGPTAXB(Y,12,B,0),U) S:A]"" A=A_";" S A=A_$S(R=1:"National GPRA",R=2:"Local CRS",R=3:"HEDIS",R=4:"ELDER",R=5:"CMS",1:"")
 ...S $E(BGPTAX(J,0),60)=A
 ..S BGPTAX("IDX",J,J)=BGPT_U_Z_U_Y
 ..S C=C+1
 .Q
 S (VALMCNT,BGPHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_BGPHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G DISPX
 I $D(DIRUT) W !,"No taxonomy selected." G DISPX
 S BGPFIEN=$P(BGPTAX("IDX",Y,Y),U,3)
 S BGPSEL=Y
 S BGPTIEN=$P(BGPTAX("IDX",Y,Y),U,1)
 S BGPTYPE=$P(BGPTAX("IDX",Y,Y),U,2)
 ;D FULL^VALM1 W:$D(IOF) @IOF
 D EP^BGP1XTV1(BGPTIEN,BGPTYPE,BGPFIEN)
DISPX ;
 D BACK
 Q
