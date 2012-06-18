AZXAPTRG ; IHS/PHXAO/TMJ - PATIENT REGISTRATION - TOTAL RE-EXPORT 4/3/01 ; 
 ;;2.0;RELEASE OF INFORMATION;;FEB 21, 2002
 ;;IHS/PHXAO/TMJ Phoenix Area - Toni Jarland
 ;This Routine populates the ^AGPATCH  Global in preparation
 ;for the next regular Monthly Patient Registration Export
 ;
START ;Sytem Variable Setup's for Variable N - Date
 ;Returns N in cyymmdd.time Format
 D SETUP^AUMXPORT
 ;Minus 2 Day Delay Factor for Patient Registration Export Requirements
 S N=N-2
 ;
 W !,"The Export Date/Time Value of N is: "_N
 W !,"Record this value - should a restart be necessary",!
 ;
 ;
 S DFN=0,L=$P(^AUPNPAT(0),U,3)
 W:'$D(ZTQUEUED) ! ; IHS/ASDST/GTH AUM*99.1*10
 S DX=$X,DY=$Y
 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D  I '(DFN#100),'$D(ZTQUEUED) X IOXY W "On IEN ",DFN," of ",L," in ^AUPNPAT(..." ; IHS/ASDST/GTH AUM*99.1*10
 . Q:'$D(^DPT(DFN))
 . S D=0
 . F  S D=$O(^AUPNPAT(DFN,41,D)) Q:'D  I '$$INAC(DFN,D) S ^AGPATCH(N,D,DFN)=""
 .Q
 ;
 W:'$D(ZTQUEUED) !!,"If you change your mind, you need to KILL ^AGPATCH(",N,").",!! ; IHS/ASDST/GTH AUM*99.1*10
 S DX=$X,DY=$Y,W=$S('$D(ZTQUEUED):"X IOXY W ""Counting..."",T",1:"") ; IHS/ASDST/GTH AUM*99.1*10
 G COUNT
 ;
 Q
 ;
COUNT ;
 W #
 S (D,T)=0
 F  S D=$O(^AGPATCH(N,D)) Q:'D  X W S DFN=0 F  S DFN=$O(^AGPATCH(N,D,DFN)) Q:'DFN  X W S T=T+1
 ;Q T
 ;
 W !!,"DONE WITH COUNT - PROCESSED:  "_T_" HEALTH RECORD ENTRIES",!
 K DFN,N,T,W,D
 Q
INAC(DFN,D) ; Pt is inactive -inactive date, or status is Deleted/Inactive/Merged ; 
 ;
 I $P($G(^AUPNPAT(DFN,41,D,0)),U,3) Q 1 ; Inactive Date
 I '$L($P($G(^AUPNPAT(DFN,41,D,0)),U,5)) Q 0
 I "DI"[$P($G(^AUPNPAT(DFN,41,D,0)),U,5) Q 1 ; Deleted or Inactive
 I "M"[$P($G(^AUPNPAT(DFN,41,D,0)),U,5) Q 1
