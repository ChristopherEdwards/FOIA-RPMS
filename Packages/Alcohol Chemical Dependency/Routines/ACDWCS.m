ACDWCS ;IHS/ADC/EDE/KML - SET LOC VARS FROM ACDCS FILE;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;**********************************************************************
 ;//^ACDWCD3, ^ACDWDRV3, ^ACDWDRV4
 ;Needs ACDDA as internal DA to file entry
 ;**********************************************************************
 K ACDN0,ACDDAY,ACDSVAC,ACDLOTY,ACDHOUR
 S ACDN0=^ACDCS(ACDDA,0)
 S ACDDAY=$P(ACDN0,U)
 S ACDSVAC=$P(ACDN0,U,2) S:'ACDSVAC ACDSVAC="NONE" S ACDSVAC=$S($D(^ACDSERV(ACDSVAC,0)):$P(^(0),U),1:"NONE")
 S ACDLOTY=$P(ACDN0,U,3) S:'ACDLOTY ACDLOTY="NONE" S ACDLOTY=$S($D(^ACDLOT(ACDLOTY,0)):$P(^(0),U),1:"NONE")
 S ACDHOUR=$P(ACDN0,U,4) S:'ACDHOUR ACDHOUR=.0001
