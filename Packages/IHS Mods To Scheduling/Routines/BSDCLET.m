BSDCLET ;cmi/anch/maw - BSD Print Letters by Patient 2/20/2007 1:06:40 PM
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.14
 ;
 ;
MAIN ;-- main driver
 D LTR
 I '$G(BSDLET) D XIT Q
 D PAT
 I $O(VAUTN(""))="" D  Q  ;cmi/anch/maw 8/14/2007 changed from $D to stop if no patient selected
 . W !,"You must select a patient, quitting" H 3
 . D XIT
 D PRT
 D XIT
 Q
 ;
LTR ;-- select the letter
 K DIC,X,Y
 S DIC=407.5
 S DIC(0)="AEQMZ"
 D ^DIC
 Q:'$G(Y)
 S BSDLET=+Y
 Q
 ;
PAT ;-- select the patients
 S VAUTNI=1
 S VAUTNALL=1
 D PATIENT^VAUTOMA
 Q
 ;
PRT ;-- print the letter
 D ZIS^DGUTQ
 Q:POP
 U IO
 S SDLET=BSDLET
 S SDFORM=0
 N BSDDA
 S BSDDA=0 F  S BSDDA=$O(VAUTN(BSDDA)) Q:BSDDA=""  D
 . S A=$G(VAUTN(BSDDA))
 . D PRT^BSDLT
 . D REST^BSDLT
 D CLOSE^DGUTQ
 Q
 ;
XIT ;-- clean up the variables
 K VAUTNI,VAUTNALL,SDLET,BSDLET,SDFORM,VAUTN
 D KVA^VADPT,KILL^AUPNPAT
 Q
 ;
