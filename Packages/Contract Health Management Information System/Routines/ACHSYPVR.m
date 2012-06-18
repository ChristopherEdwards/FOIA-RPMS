ACHSYPVR ; IHS/ITSC/PMF - RESET CHS TX DATE IN IHS PATIENT & VENDOR FILE ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; This utility resets export-control fields in the PATIENT and
 ; VENDOR file.  Those fields are checked during CHS export to
 ; determine if a VENDOR or PATIENT has been edited since the last
 ; CHS export.  If they have been edited, VENDOR and PATIENT info is
 ; exported to the Fiscal Intermediary.
 ;
 ; Reset CHS TX DATE in Patient & Vendor files.
 ;
 ; This will flag EVERY patient and vendor for export in the next
 ; CHS export.  You could get some very big export files.
 ;
 ; Kernel variables need to be defined.
 ;
START ;EP
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 I '$G(DUZ(2)) W !,"DUZ(2) UNDEFINED OR 0." Q
 I '$D(^XUSEC("XUMGR",DUZ)) W !,"You're not a manager." Q
 D HOME^%ZIS,DT^DICRW
 W @IOF,$$REPEAT^XLFSTR("*",70)
 W !,$$C^XBFUNC("RESET CHS TX DATE IN PATIENT & VENDOR FILES",80),!
 W $$REPEAT^XLFSTR("*",70),!!
A1 ;
 Q:'$$DIR^XBDIR("Y","Are You SURE you want to RESET the CHS TX DATE ","N")
 Q:$D(DUOUT)!$D(DTOUT)
 W !!,"Please be PATIENT -- This process could take a while",!!
 N C,N,R,I
 S N=$P(^AUPNPAT(0),U,4)
A2 ;
 W "Resetting Patient CHS TX DATE in ",N," NODES",!
 S (R,C)=0,DX=$X,DY=$Y
A3 ;
 F  S R=$O(^AUPNPAT(R)) Q:'R  I $D(^AUPNPAT(R,0)) S $P(^(0),U,15)="",C=C+1 X IOXY W $J(C,8)," of ",$J(N,8)
 ;
 W !!,"Number of Patient Nodes Reset = ",C,!!
VEND ;
 S N=$P(^AUTTVNDR(0),U,4)
 W "Resetting Vendor CHS TX DATE in ",N," NODES",!
 S (R,C)=0,DX=$X,DY=$Y
 ;
 F  S R=$O(^AUTTVNDR(R)) Q:'R  I $D(^AUTTVNDR(R,11)) S $P(^(11),U,12)="",C=C+1 X IOXY W $J(C,8)," of ",$J(N,8)
 ;
 W !!,"Number of Vendor Nodes Reset = ",C,!!!,"JOB COMPLETED"
 ;
 Q
