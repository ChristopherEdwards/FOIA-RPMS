BSDB0 ; IHS/ANMC/LJF - SCHEDULING TEMPLATES ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
ASK ;EP; ask user for template when setting up clinic
 ; Called by ^SDB0
 S Y=$$READ^BDGF("FO^1:30","TIME","","^D HELP^BSDB0")
 Q:Y=U  Q:Y=""
 I Y="[?" D HELP2,ASK Q
 I $E(Y)="[" D GETTIMES($P(Y,"[",2)),ASK Q
 I Y'?4N1"-"4N D MSG^BDGF("Enter time like 0800-1200",1,0),ASK Q
 S BSDTIME=$G(BSDTIME)_Y_U D SLOTS,ASK Q
 Q
 ;
GETTIMES(TNAMES)  ; find times and slots based on sched template TNAMES
 NEW ONE,IEN,IEN1
 ; separate template names by ;
 F  S ONE=$P(TNAMES,";"),TNAMES=$P(TNAMES,";",2,99) Q:ONE=""  D
 . ;
 . ; find template in file 9009017.3
 . S IEN=$O(^BSDST("B",ONE,0)) I 'IEN W $C(7),"??" Q
 . ;
 . ; loop thru time multiples to set times and slots
 . S IEN1=0 F  S IEN1=$O(^BSDST(IEN,1,IEN1)) Q:'IEN1  D
 .. S BSDTIME=$G(BSDTIME)_$P(^BSDST(IEN,1,IEN1,0),U)_U
 .. S BSDSLOT=$G(BSDSLOT)_$P(^BSDST(IEN,1,IEN1,0),U,2)_U
 Q
 ;
SLOTS ; ask user for # of slots
 ;PROG NOTE: using Read command to mimic VA user interface where
 ;   this question is on same line as TIME prompt
 R "   NO. SLOTS: 1//  ",Y:DTIME S:Y="" Y=1
 I Y>0 S BSDSLOT=$G(BSDSLOT)_Y_U
 Q
 ;
HELP ;EP; user help on TIME question
 D MSG^BDGF($$SP(5)_"Enter times using this example: 0800-1200 or enter a",2,0)
 D MSG^BDGF($$SP(5)_"scheduling template name(s): [FMS C1 or [PEDS B3AM;PEDS D1PM.",1,0)
 D MSG^BDGF($$SP(5)_"A template name must be preceeded by a bracket [.  If you need",1,0)
 D MSG^BDGF($$SP(5)_"to enter more than one template per day (am and pm), separate",1,0)
 D MSG^BDGF($$SP(5)_"them by a semicolon.",1,0)
 D MSG^BDGF($$SP(5)_"To see a list of current templates, type [? at TIME prompt.",1,0)
 Q
 ;
HELP2 ; list scheduling templates in file
 NEW DIC,D,DZ,X,Y
 S DIC="^BSDST(",DIC(0)="AMQE",D="B",DZ="??" D DQ^DICQ
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
