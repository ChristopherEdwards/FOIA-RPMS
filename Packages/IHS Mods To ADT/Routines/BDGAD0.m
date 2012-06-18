BDGAD0 ; IHS/ANMC/LJF - A&D UTILITY CALLS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
FORMAT ;EP; -- ask user which format to print
 ; called by DGPMGL1
 I $G(BDGREC) S BDGFRM="" Q     ;recalculate only; no printing
 S BDGFRM=$$READ^BDGF("SB^D:Detailed Format;S:Summary Format","Select Report Format - DETAILED or SUMMARY","","^D FRMHLP^BDGAD0")
 I (BDGFRM="")!(BDGFRM=U) S BDGQUIT=1 Q
 I BDGFRM="D" W !!?20,"Paper margin must be at least 110."
 Q
 ;
FRMHLP ;EP; help for format question
 D MSG^BDGF("Enter 'D' for DETAILED or 'S' for SUMMARY",1,1)
 D MSG^BDGF("DETAILED FORMAT uses a right margin of 110.",1,0)
 D MSG^BDGF("It lists each patient name along with provider, age,",1,0)
 D MSG^BDGF("ward, service, community, and chart number. Newborn",1,0)
 D MSG^BDGF("admissions and discharges are listed separately.",1,1)
 D MSG^BDGF("SUMMARY FORMAT uses a right margin of 80.",1,0)
 D MSG^BDGF("It gives a summary of movements by service. Then",1,0)
 D MSG^BDGF("lists each patient with chart number, service,",1,0)
 D MSG^BDGF("and ward.",1,0)
 Q
 ;
MAN ;EP; -- manual purge
 N Y,X1,X2,PD
 ; -- date selection
 S PD=$$READ^BDGF("DO^::EPX","Purge from what date")
 I PD<1 Q
 ;
 ; -- procede?
 S Y=$$READ^BDGF("Y","Do you want to purge census files from "_$$FMTE^XLFDT(PD),"NO") Q:'Y
 ;
 ; -- call purge subroutine
 S X1=PD,X2=-1 D C^%DTC S PD=X  ;set to date before
 D PURG(PD)
 Q
 ;
PURG(PD) ;EP; -- purge called from recalc and manual purge options
 ; PD= day before purge date
 NEW WD,TS,DATE
 ; for each ward
 S WD=0 F  S WD=$O(^BDGCWD(WD)) Q:'WD  D
 . ;
 . ; set zero node of multiple if not there
 . S:$P($G(^BDGCWD(WD,1,0)),U,2)="" $P(^(0),U,2)="9009016.21D"
 . ;
 . ; loop thru dates from purge date to present
 . S DATE=PD F  S DATE=$O(^BDGCWD(WD,1,DATE)) Q:'DATE  D
 .. ;
 .. ; call DIK to delete multiple entry for date
 .. S DA(1)=WD,DA=DATE,DIK="^BDGCWD("_DA(1)_",1,"
 .. NEW WD,DATE D ^DIK K DA,DIK
 ;
 ;
 ; for each treating specialty
 S TS=0 F  S TS=$O(^BDGCTX(TS)) Q:'TS  D
 . ;
 . ; set zero node for multiple if not there
 . S:$P($G(^BDGCTX(TS,1,0)),U,2)="" $P(^(0),U,2)="9009016.61D"
 . ;
 . ; loop thru dates from purge date to present
 . S DATE=PD F  S DATE=$O(^BDGCTX(TS,1,DATE)) Q:'DATE  D
 .. ;
 .. ; call DIK to delete multiple entry for date
 .. S DA(1)=TS,DA=DATE,DIK="^BDGCTX("_DA(1)_",1,"
 .. NEW TS,DATE D ^DIK K DA,DIK
 Q
