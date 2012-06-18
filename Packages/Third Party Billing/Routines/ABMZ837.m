ABMZ837 ; Local mods routine for 837 billing
 ;
REF03 ; Kidscare - change REF for provider to 1D and Medicaid number
 ;REF03^ABMZ837 IS REFERENCED BY THE KIDSCARE ENTRIES IN THE
 ;3P EXP LOCAL MOD FILE
 I $G(ABMR("REF",20))="OB"  D
 .S ABMR("REF",20)="1D"
 .S ABMR("REF",30)=$$MCD^ABMEEPRV(ABMIEN)
 Q
