BCHGDEL ; IHS/TUCSON/LAB - KILL ALL STND GLOBALS ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;Kill of unsubscripted globals is approved here because this
 ;routine is only used when installing a new version of this
 ;package.
 Q  ;can't enter from top of routine
GDEL ;EP
 K ^BCHDTER,^BCHERR,^BCHSORT,^BCHTPROG,^BCHTPROB,^BCHTFPM,^BCHTREF,^BCHTSERV,^BCHRCNT,^BCHTACTL,^BCHTHAC,^BCHTMT
 Q
